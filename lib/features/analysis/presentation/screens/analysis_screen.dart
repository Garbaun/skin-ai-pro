import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../../core/providers/analysis_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/widgets/app_button.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  bool _isAnalyzing = false;

  Future<void> _startAnalysis() async {
    final user = ref.read(authProvider).currentUser;
    if (user == null) return;

    // Kredi kontrolü
    if (user.analysisCredits <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Analiz krediniz bitmiş. Lütfen premium üyelik satın alın.')),
        );
      }
      return;
    }

    // TODO: Kamera veya galeriden fotoğraf seçme
    // Şimdilik örnek bir analiz başlat
    setState(() => _isAnalyzing = true);

    try {
      await ref.read(analysisProvider.notifier).startAnalysis(
        userId: user.id,
        imageFile: File(''), // Örnek dosya
        symptoms: ['kuru cilt', 'gözenekler'],
      );

      if (mounted) {
        // Analiz kredisini kullan
        await ref.read(authProvider.notifier).useAnalysisCredit();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Analiz başlatıldı!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analiz hatası: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final analysisStatus = ref.watch(analysisStatusProvider);
    final currentResult = ref.watch(currentAnalysisProvider);
    final user = ref.watch(authProvider).currentUser;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Başlık
              const Text(
                'Cilt Analizi',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Yapay zeka ile cilt sağlığınızı analiz edin',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // Kalan kredi göstergesi
              if (user != null) ...[
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.purple[700],
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kalan Analiz Krediniz',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${user.analysisCredits} analiz hakkı',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (user.analysisCredits == 0)
                          ElevatedButton(
                            onPressed: () {
                              // Premium satın alma ekranına git
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Yükselt'),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Analiz durumu
              if (analysisStatus == AnalysisStatus.uploading || 
                  analysisStatus == AnalysisStatus.analyzing) ...[
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          analysisStatus == AnalysisStatus.uploading
                              ? 'Fotoğraf yükleniyor...'
                              : 'Analiz yapılıyor...',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (analysisStatus == AnalysisStatus.uploading)
                          Consumer(builder: (context, ref, child) {
                            final progress = ref.watch(analysisProvider.select(
                              (state) => state.uploadProgress
                            ));
                            return LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[200],
                            );
                          }),
                      ],
                    ),
                  ),
                ),
              ] else if (currentResult != null) ...[
                // Son analiz sonucu
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.science,
                                color: Colors.green[700],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Son Analiz Sonucunuz',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Güven skoru: %${(currentResult.confidenceScore * 100).toInt()}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Cilt Tipi: ${currentResult.skinType.toString().split('.').last}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        if (currentResult.concerns.isNotEmpty) ...[
                          const Text(
                            'Tespit Edilen Sorunlar:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...currentResult.concerns.map((concern) => Padding(
                            padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
                            child: Text(
                              '• ${concern.name} (${concern.severity})',
                              style: const TextStyle(fontSize: 13),
                            ),
                          )),
                        ],
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // Detaylara git
                            },
                            child: const Text('Detayları Gör'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Analiz başlat butonu
              AppButton(
                text: _isAnalyzing ? 'Analiz Yapılıyor...' : 'Yeni Analiz Başlat',
                onPressed: (_isAnalyzing || user?.analysisCredits == 0) 
                    ? null 
                    : _startAnalysis,
                isLoading: _isAnalyzing,
                icon: const Icon(Icons.camera_alt),
              ),
              
              const SizedBox(height: 16),
              
              // İpuçları
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.amber[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Analiz İpuçları',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• Temiz, makyajsız cildinizle çekin\n'
                        '• Doğal ışıkta, net bir fotoğraf çekin\n'
                        '• Yüzünüzü doğrudan karşıdan çekin\n'
                        '• Farklı açılardan birkaç fotoğraf çekin',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}