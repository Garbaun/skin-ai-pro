part of 'analysis_bloc.dart';

abstract class AnalysisEvent {
  const AnalysisEvent();
}

class StartAnalysis extends AnalysisEvent {
  const StartAnalysis();
}

class CaptureImage extends AnalysisEvent {
  const CaptureImage();
}

class SelectFromGallery extends AnalysisEvent {
  const SelectFromGallery();
}

class AnalyzeImage extends AnalysisEvent {
  final String imagePath;

  const AnalyzeImage(this.imagePath);
}

class SaveAnalysis extends AnalysisEvent {
  final AnalysisResult analysis;

  const SaveAnalysis(this.analysis);
}