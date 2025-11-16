import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'firebase_service.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload user profile image
  Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref('users/$userId/profile/$fileName');
      
      final uploadTask = ref.putFile(imageFile, SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'userId': userId,
        },
      ));

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseService.instance.logEvent('profile_image_uploaded', {
        'user_id': userId,
        'file_name': fileName,
        'size_bytes': snapshot.totalBytes,
      });

      return downloadUrl;
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Upload analysis image
  Future<String> uploadAnalysisImage(String userId, File imageFile) async {
    try {
      final fileName = 'analysis_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref('users/$userId/analyses/$fileName');
      
      final uploadTask = ref.putFile(imageFile, SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'userId': userId,
          'type': 'analysis',
        },
      ));

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseService.instance.logEvent('analysis_image_uploaded', {
        'user_id': userId,
        'file_name': fileName,
        'size_bytes': snapshot.totalBytes,
      });

      return downloadUrl;
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Upload image from bytes (for camera captures)
  Future<String> uploadImageFromBytes(String userId, Uint8List imageBytes, String folder) async {
    try {
      final fileName = '${folder}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref('users/$userId/$folder/$fileName');
      
      final uploadTask = ref.putData(imageBytes, SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'userId': userId,
          'type': folder,
        },
      ));

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseService.instance.logEvent('image_uploaded_from_bytes', {
        'user_id': userId,
        'folder': folder,
        'file_name': fileName,
        'size_bytes': snapshot.totalBytes,
      });

      return downloadUrl;
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Delete image by URL
  Future<void> deleteImageByUrl(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();

      await FirebaseService.instance.logEvent('image_deleted', {
        'image_url': imageUrl,
      });
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Get download URL for a storage path
  Future<String> getDownloadUrl(String storagePath) async {
    try {
      final ref = _storage.ref(storagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Upload multiple images
  Future<List<String>> uploadMultipleImages(
    String userId,
    List<File> imageFiles,
    String folder,
  ) async {
    try {
      final uploadTasks = <Future<String>>[];
      
      for (final imageFile in imageFiles) {
        uploadTasks.add(_uploadSingleImage(userId, imageFile, folder));
      }

      final results = await Future.wait(uploadTasks);
      
      await FirebaseService.instance.logEvent('multiple_images_uploaded', {
        'user_id': userId,
        'folder': folder,
        'image_count': imageFiles.length,
      });

      return results;
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Helper method to upload a single image
  Future<String> _uploadSingleImage(String userId, File imageFile, String folder) async {
    final fileName = '${folder}_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
    final ref = _storage.ref('users/$userId/$folder/$fileName');
    
    final uploadTask = ref.putFile(imageFile, SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {
        'uploadedAt': DateTime.now().toIso8601String(),
        'userId': userId,
        'type': folder,
      },
    ));

    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  /// Get image metadata
  Future<Map<String, dynamic>?> getImageMetadata(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      final metadata = await ref.getMetadata();
      
      return {
        'name': metadata.name,
        'size': metadata.size,
        'contentType': metadata.contentType,
        'customMetadata': metadata.customMetadata,
        'updated': metadata.updated,
      };
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      return null;
    }
  }

  /// Compress and upload image (for large files)
  Future<String> uploadCompressedImage(
    String userId,
    File imageFile,
    String folder, {
    int maxWidth = 1024,
    int maxHeight = 1024,
    int quality = 85,
  }) async {
    try {
      // For Flutter, we'll use the image package for compression
      // This is a placeholder - you might want to use flutter_image_compress package
      final fileName = 'compressed_${folder}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref('users/$userId/$folder/$fileName');
      
      final uploadTask = ref.putFile(imageFile, SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'userId': userId,
          'type': folder,
          'compressed': 'true',
          'maxWidth': maxWidth.toString(),
          'maxHeight': maxHeight.toString(),
          'quality': quality.toString(),
        },
      ));

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseService.instance.logEvent('compressed_image_uploaded', {
        'user_id': userId,
        'folder': folder,
        'file_name': fileName,
        'size_bytes': snapshot.totalBytes,
        'compressed': true,
      });

      return downloadUrl;
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }
}