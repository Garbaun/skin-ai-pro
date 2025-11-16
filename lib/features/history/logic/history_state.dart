part of 'history_bloc.dart';

abstract class HistoryState {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<AnalysisResult> analyses;

  const HistoryLoaded(this.analyses);
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);
}