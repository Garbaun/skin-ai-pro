import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_ai_clean/core/services/vlm_service.dart';
import 'package:skin_ai_clean/core/services/notification_service.dart';
import 'package:skin_ai_clean/domain/models/analysis_models.dart';

// Events
abstract class AnalysisEvent {}

class TakePhotoEvent extends AnalysisEvent {}
class PickImageEvent extends AnalysisEvent {}
class AnalyzeImageEvent extends AnalysisEvent {
  final String imagePath;
  AnalyzeImageEvent(this.imagePath);
}

// States
abstract class AnalysisState {}

class AnalysisInitial extends AnalysisState {}
class AnalysisLoading extends AnalysisState {}
class AnalysisImageSelected extends AnalysisState {
  final String imagePath;
  AnalysisImageSelected(this.imagePath);
}
class AnalysisSuccess extends AnalysisState {
  final SkinAnalysisResult result;
  AnalysisSuccess(this.result);
}
class AnalysisError extends AnalysisState {
  final String message;
  AnalysisError(this.message);
}

// Bloc
class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final VLMService _vlmService;

  AnalysisBloc() : _vlmService = VLMService(), super(AnalysisInitial()) {
    on<TakePhotoEvent>(_onTakePhoto);
    on<PickImageEvent>(_onPickImage);
    on<AnalyzeImageEvent>(_onAnalyzeImage);
  }

  Future<void> _onTakePhoto(TakePhotoEvent event, Emitter<AnalysisState> emit) async {
    try {
      emit(AnalysisLoading());
      final imageFile = await _vlmService.takePhoto();
      if (imageFile != null) {
        emit(AnalysisImageSelected(imageFile.path));
      } else {
        emit(AnalysisError('No photo taken'));
      }
    } catch (e) {
      emit(AnalysisError('Failed to take photo: $e'));
    }
  }

  Future<void> _onPickImage(PickImageEvent event, Emitter<AnalysisState> emit) async {
    try {
      emit(AnalysisLoading());
      final imageFile = await _vlmService.pickImage();
      if (imageFile != null) {
        emit(AnalysisImageSelected(imageFile.path));
      } else {
        emit(AnalysisError('No image selected'));
      }
    } catch (e) {
      emit(AnalysisError('Failed to pick image: $e'));
    }
  }

  Future<void> _onAnalyzeImage(AnalyzeImageEvent event, Emitter<AnalysisState> emit) async {
    try {
      emit(AnalysisLoading());
      final result = await _vlmService.analyzeImage(File(event.imagePath));
      emit(AnalysisSuccess(result));
      
      // Schedule water reminders if analysis is successful
      await NotificationService.scheduleWaterReminders(
        dailyGoal: 8,
        intervalHours: 2,
        startTime: '09:00',
        endTime: '21:00',
      );
    } catch (e) {
      emit(AnalysisError('Analysis failed: $e'));
    }
  }
}