import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:skin_ai_clean/domain/models/analysis_models.dart';

class VLMService {
  static const String _baseUrl = 'https://api.example.com'; // VLM API URL
  static const String _apiKey = 'your-vlm-api-key'; // VLM API Key

  final Dio _dio = Dio();
  final ImagePicker _picker = ImagePicker();

  VLMService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers['Authorization'] = 'Bearer $_apiKey';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  // Take photo with camera
  Future<File?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo != null) {
        return File(photo.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to take photo: $e');
    }
  }

  // Pick image from gallery
  Future<File?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  // Analyze image with VLM API
  Future<SkinAnalysisResult> analyzeImage(File imageFile) async {
    try {
      // Save image to app directory
      final savedImage = await _saveImageToAppDirectory(imageFile);

      // Create form data
      final formData = FormData();
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(savedImage.path,
              filename: 'skin_analysis.jpg'),
        ),
      );

      // Add analysis parameters
      formData.fields.addAll([
        const MapEntry('analysis_type', 'skin_health'),
        const MapEntry('detailed_analysis', 'true'),
        const MapEntry('language', 'tr'),
      ]);

      // Send to VLM API
      final response = await _dio.post(
        '/analyze',
        data: formData,
      );

      if (response.statusCode == 200) {
        return SkinAnalysisResult.fromJson(response.data);
      } else {
        throw Exception('Analysis failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to analyze image: $e');
    }
  }

  // Save image to app directory
  Future<File> _saveImageToAppDirectory(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'skin_analysis_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await imageFile.copy('${directory.path}/$fileName');
      return savedImage;
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  // Get analysis history
  Future<List<SkinAnalysisResult>> getAnalysisHistory(String userId) async {
    try {
      final response = await _dio.get(
        '/history',
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['analyses'];
        return data.map((json) => SkinAnalysisResult.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get history: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get analysis history: $e');
    }
  }
}
