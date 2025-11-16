import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_ai_clean/presentation/blocs/analysis/analysis_bloc.dart';
import 'package:skin_ai_clean/domain/models/analysis_models.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cilt Analizi'),
      ),
      body: BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          if (state is AnalysisInitial) {
            return _buildInitialContent(context);
          } else if (state is AnalysisLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AnalysisImageSelected) {
            return _buildImagePreview(context, state.imagePath);
          } else if (state is AnalysisSuccess) {
            return _buildResults(context, state.result);
          } else if (state is AnalysisError) {
            return _buildError(context, state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInitialContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 64, color: Colors.blue),
          const SizedBox(height: 16),
          const Text(
            'Cilt Analizi Başlat',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Yüzünüzün fotoğrafını çekin veya galeriden seçin',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.read<AnalysisBloc>().add(TakePhotoEvent()),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Fotoğraf Çek'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => context.read<AnalysisBloc>().add(PickImageEvent()),
            icon: const Icon(Icons.photo_library),
            label: const Text('Galeriden Seç'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, String imagePath) {
    return Column(
      children: [
        Expanded(
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.read<AnalysisBloc>().add(
                        AnalyzeImageEvent(imagePath),
                      ),
                  child: const Text('Analiz Et'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResults(BuildContext context, SkinAnalysisResult result) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analiz Sonucu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(result.summary),
                  const SizedBox(height: 8),
                  Text(
                    'Güven Skoru: ${(result.confidenceScore * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tespit Edilen Durumlar:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...result.concerns.map((concern) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(concern.name),
                  subtitle: Text(concern.description),
                  trailing: Chip(
                    label: Text(concern.severity),
                    backgroundColor: _getSeverityColor(concern.severity),
                  ),
                ),
              )),
          const SizedBox(height: 16),
          const Text(
            'Ürün Önerileri:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...result.recommendations.map((product) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: product.imageUrl.isNotEmpty
                      ? Image.network(product.imageUrl,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.shopping_bag),
                  title: Text(product.name),
                  subtitle: Text('${product.brand} • ${product.category}'),
                  trailing: Text('${product.price.toStringAsFixed(0)} TL'),
                ),
              )),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Hata',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.read<AnalysisBloc>().add(TakePhotoEvent()),
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
      case 'düşük':
        return Colors.green;
      case 'medium':
      case 'orta':
        return Colors.orange;
      case 'high':
      case 'yüksek':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
