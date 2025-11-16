part of 'analysis_bloc.dart';

abstract class AnalysisState {
  const AnalysisState();
}

class AnalysisInitial extends AnalysisState {
  const AnalysisInitial();
}

class AnalysisReady extends AnalysisState {
  const AnalysisReady();
}

class AnalysisLoading extends AnalysisState {
  const AnalysisLoading();
}

class AnalysisImageSelected extends AnalysisState {
  final String imagePath;

  const AnalysisImageSelected(this.imagePath);
}

class AnalysisProcessing extends AnalysisState {
  const AnalysisProcessing();
}

class AnalysisCompleted extends AnalysisState {
  final AnalysisResult result;

  const AnalysisCompleted(this.result);
}

class AnalysisSaved extends AnalysisState {
  const AnalysisSaved();
}

class AnalysisError extends AnalysisState {
  final String message;

  const AnalysisError(this.message);
}