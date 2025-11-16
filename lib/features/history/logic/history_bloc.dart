import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/analysis_models.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(const HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<DeleteAnalysis>(_onDeleteAnalysis);
    on<ClearHistory>(_onClearHistory);
    
    // Load history on initialization
    add(const LoadHistory());
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      emit(const HistoryLoading());
      
      final prefs = await SharedPreferences.getInstance();
      final analysesJson = prefs.getStringList('analyses') ?? [];
      
      final analyses = analysesJson
          .map((json) => AnalysisResult.fromJson(json))
          .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      emit(HistoryLoaded(analyses));
    } catch (e) {
      emit(const HistoryError('Geçmiş yüklenirken bir hata oluştu'));
    }
  }

  Future<void> _onDeleteAnalysis(
    DeleteAnalysis event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      if (state is HistoryLoaded) {
        final currentAnalyses = (state as HistoryLoaded).analyses;
        final updatedAnalyses = currentAnalyses
            .where((analysis) => analysis.id != event.analysisId)
            .toList();
        
        final prefs = await SharedPreferences.getInstance();
        final analysesJson = updatedAnalyses.map((a) => a.toJson()).toList();
        await prefs.setStringList('analyses', analysesJson);
        
        emit(HistoryLoaded(updatedAnalyses));
      }
    } catch (e) {
      emit(const HistoryError('Analiz silinirken bir hata oluştu'));
    }
  }

  Future<void> _onClearHistory(
    ClearHistory event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('analyses');
      
      emit(const HistoryLoaded([]));
    } catch (e) {
      emit(const HistoryError('Geçmiş temizlenirken bir hata oluştu'));
    }
  }
}