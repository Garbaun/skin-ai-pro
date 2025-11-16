part of 'history_bloc.dart';

abstract class HistoryEvent {
  const HistoryEvent();
}

class LoadHistory extends HistoryEvent {
  const LoadHistory();
}

class DeleteAnalysis extends HistoryEvent {
  final String analysisId;

  const DeleteAnalysis(this.analysisId);
}

class ClearHistory extends HistoryEvent {
  const ClearHistory();
}