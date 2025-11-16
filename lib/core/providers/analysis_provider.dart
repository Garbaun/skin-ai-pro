import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Analiz durumları
enum AnalysisStatus {
  idle,
  uploading,
  analyzing,
  completed,
  error,
}

// Cilt tipi analiz sonuçları
enum SkinType {
  normal,
  dry,
  oily,
  combination,
  sensitive,
}

// Cilt sorunları
class SkinConcern {
  final String id;
  final String name;
  final String description;
  final String severity;

  SkinConcern({
    required this.id,
    required this.name,
    required this.description,
    required this.severity,
  });
}

// Analiz sonucu modeli
class AnalysisResult {
  final String id;
  final String userId;
  final File? imageFile;
  final String? imageUrl;
  final SkinType skinType;
  final List<SkinConcern> concerns;
  final Map<String, dynamic> analysisData;
  final List<String> recommendations;
  final DateTime timestamp;
  final double confidenceScore;

  AnalysisResult({
    required this.id,
    required this.userId,
    this.imageFile,
    this.imageUrl,
    required this.skinType,
    required this.concerns,
    required this.analysisData,
    required this.recommendations,
    required this.timestamp,
    required this.confidenceScore,
  });
}

// Analiz state modeli
class AnalysisState {
  final AnalysisStatus status;
  final AnalysisResult? currentResult;
  final List<AnalysisResult> history;
  final String? errorMessage;
  final bool isUploading;
  final double uploadProgress;

  AnalysisState({
    this.status = AnalysisStatus.idle,
    this.currentResult,
    this.history = const [],
    this.errorMessage,
    this.isUploading = false,
    this.uploadProgress = 0.0,
  });

  AnalysisState copyWith({
    AnalysisStatus? status,
    AnalysisResult? currentResult,
    List<AnalysisResult>? history,
    String? errorMessage,
    bool? isUploading,
    double? uploadProgress,
  }) {
    return AnalysisState(
      status: status ?? this.status,
      currentResult: currentResult ?? this.currentResult,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}

// Analiz provider'ı
class AnalysisNotifier extends StateNotifier<AnalysisState> {
  AnalysisNotifier() : super(AnalysisState());

  // Yeni analiz başlat
  Future<void> startAnalysis({
    required String userId,
    required File imageFile,
    List<String>? symptoms,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      state = state.copyWith(
        status: AnalysisStatus.uploading,
        isUploading: true,
        uploadProgress: 0.0,
        errorMessage: null,
      );

      // Upload progress simülasyonu
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        state = state.copyWith(uploadProgress: i / 100);
      }

      state = state.copyWith(
        status: AnalysisStatus.analyzing,
        uploadProgress: 1.0,
      );

      // Analiz simülasyonu
      await Future.delayed(const Duration(seconds: 3));

      // Örnek analiz sonucu oluştur
      final result = AnalysisResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        imageFile: imageFile,
        skinType: SkinType.combination,
        concerns: [
          SkinConcern(
            id: '1',
            name: 'Kuruluk',
            description: 'Cildinizde hafif kuruluk tespit edildi',
            severity: 'hafif',
          ),
          SkinConcern(
            id: '2',
            name: 'Gözenekler',
            description: 'T bölgesinde gözenek görünümü',
            severity: 'orta',
          ),
        ],
        analysisData: {
          'hydration_level': 65,
          'oil_level': 45,
          'sensitivity_score': 20,
          'aging_signs': 15,
          'acne_risk': 25,
        },
        recommendations: [
          'Nemlendirici kullanmayı ihmal etmeyin',
          'Haftada 1-2 kez nem maskesi uygulayın',
          'Güneş koruması kullanın',
        ],
        timestamp: DateTime.now(),
        confidenceScore: 0.85,
      );

      state = state.copyWith(
        status: AnalysisStatus.completed,
        currentResult: result,
        history: [result, ...state.history],
        isUploading: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: AnalysisStatus.error,
        errorMessage: 'Analiz sırasında hata oluştu: $e',
        isUploading: false,
      );
    }
  }

  // Analiz geçmişini yükle
  Future<void> loadAnalysisHistory(String userId) async {
    try {
      // Burada Firestore'dan geçmiş verileri yükleyeceğiz
      // Şimdilik boş liste döndürüyoruz
      state = state.copyWith(history: []);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Geçmiş yüklenirken hata oluştu: $e',
      );
    }
  }

  // Analiz sonucunu kaydet
  Future<void> saveAnalysisResult(AnalysisResult result) async {
    try {
      // Firestore'a kaydetme işlemi yapılacak
      state = state.copyWith(
        history: [result, ...state.history],
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Sonuç kaydedilirken hata oluştu: $e',
      );
    }
  }

  // Analiz durumunu sıfırla
  void resetAnalysis() {
    state = AnalysisState(
      history: state.history, // Geçmişi koru
    );
  }

  // Hata mesajını temizle
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  // Analiz sonucunu sil
  Future<void> deleteAnalysis(String analysisId) async {
    try {
      final updatedHistory =
          state.history.where((analysis) => analysis.id != analysisId).toList();

      state = state.copyWith(history: updatedHistory);

      // Firestore'dan da silinecek
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Analiz silinirken hata oluştu: $e',
      );
    }
  }
}

// Provider tanımlamaları
final analysisProvider =
    StateNotifierProvider<AnalysisNotifier, AnalysisState>((ref) {
  return AnalysisNotifier();
});

// Mevcut analiz durumu provider'ı
final currentAnalysisProvider = Provider<AnalysisResult?>((ref) {
  return ref.watch(analysisProvider).currentResult;
});

// Analiz geçmişi provider'ı
final analysisHistoryProvider = Provider<List<AnalysisResult>>((ref) {
  return ref.watch(analysisProvider).history;
});

// Analiz durumu provider'ı
final analysisStatusProvider = Provider<AnalysisStatus>((ref) {
  return ref.watch(analysisProvider).status;
});
