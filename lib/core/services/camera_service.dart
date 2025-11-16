import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> initialize() async {
    _cameras = await availableCameras();
  }

  List<CameraDescription> get cameras => _cameras;

  CameraController? get controller => _controller;

  Future<CameraController?> initializeCamera({
    CameraDescription? camera,
    ResolutionPreset resolutionPreset = ResolutionPreset.high,
  }) async {
    if (_cameras.isEmpty) {
      await initialize();
    }

    final cameraToUse = camera ?? _cameras.firstOrNull;
    if (cameraToUse == null) return null;

    _controller = CameraController(
      cameraToUse,
      resolutionPreset,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      return _controller;
    } catch (e) {
      print('Kamera başlatma hatası: $e');
      return null;
    }
  }

  Future<void> disposeCamera() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
    }
  }

  Future<File?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return null;
    }

    try {
      final XFile photo = await _controller!.takePicture();
      return File(photo.path);
    } catch (e) {
      print('Fotoğraf çekme hatası: $e');
      return null;
    }
  }

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      print('Galeriden resim seçme hatası: $e');
      return null;
    }
  }

  Future<File?> captureImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      print('Kameradan resim çekme hatası: $e');
      return null;
    }
  }

  Future<String> saveImageToAppDirectory(File image) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'skin_analysis_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await image.copy('${directory.path}/$fileName');
      return savedImage.path;
    } catch (e) {
      print('Resim kaydetme hatası: $e');
      return image.path;
    }
  }

  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Resim silme hatası: $e');
    }
  }

  bool get isCameraAvailable => _cameras.isNotEmpty;
  bool get isControllerInitialized => _controller?.value.isInitialized ?? false;
}

extension on List<CameraDescription> {
  CameraDescription? get firstOrNull => isEmpty ? null : first;
}
