import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/analysis_models.dart';
import '../../../core/api/vlm_service.dart';

part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final VLMService _vlmService = VLMService();
  
  AnalysisBloc() : super(const AnalysisInitial()) {
    on<StartAnalysis>(_onStartAnalysis);
    on<CaptureImage>(_onCaptureImage);
    on<SelectFromGallery>(_onSelectFromGallery);
    on<AnalyzeImage>(_onAnalyzeImage);
    on<SaveAnalysis>(_onSaveAnalysis);
  }

  Future<void> _onStartAnalysis(
    StartAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(const AnalysisReady());
  }

  Future<void> _onCaptureImage(
    CaptureImage event,
    Emitter<AnalysisState> emit,
  ) async {
    try {
      emit(const AnalysisLoading());
      
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 90,
      );
      
      if (photo != null) {
        emit(AnalysisImageSelected(photo.path));
      } else {
        emit(const AnalysisReady());
      }
    } catch (e) {
      emit(const AnalysisError('Kamera açılırken bir hata oluştu'));
    }
  }

  Future<void> _onSelectFromGallery(
    SelectFromGallery event,
    Emitter<AnalysisState> emit,
  ) async {
    try {
      emit(const AnalysisLoading());
      
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      
      if (image != null) {
        emit(AnalysisImageSelected(image.path));
      } else {
        emit(const AnalysisReady());
      }
    } catch (e) {
      emit(const AnalysisError('Galeriden resim seçilirken bir hata oluştu'));
    }
  }

  Future<void> _onAnalyzeImage(
    AnalyzeImage event,
    Emitter<AnalysisState> emit,
  ) async {
    try {
      emit(const AnalysisProcessing());
      
      // Call VLM API for analysis
      final analysisResult = await _vlmService.analyzeImage(event.imagePath);
      
      emit(AnalysisCompleted(analysisResult));
    } catch (e) {
      emit(AnalysisError('Analiz yapılırken bir hata oluştu: $e'));
    }
  }

  Future<void> _onSaveAnalysis(
    SaveAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final analyses = prefs.getStringList('analyses') ?? [];
      
      analyses.add(event.analysis.toJson());
      await prefs.setStringList('analyses', analyses);
      
      emit(const AnalysisSaved());
    } catch (e) {
      emit(const AnalysisError('Analiz kaydedilirken bir hata oluştu'));
    }
  }
}