import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analiz Geçmişi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHistoryItem(
            date: '15 Kasım 2024',
            summary: 'Cilt genel olarak sağlıklı görünüyor',
            concerns: ['Hafif kuruluk', 'Güneş lekeleri'],
            confidence: 85,
          ),
          const SizedBox(height: 12),
          _buildHistoryItem(
            date: '8 Kasım 2024',
            summary: 'Nem dengesi iyileşmiş',
            concerns: ['Güneş lekeleri'],
            confidence: 92,
          ),
          const SizedBox(height: 12),
          _buildHistoryItem(
            date: '1 Kasım 2024',
            summary: 'Kuruluk belirgin, nem takviyesi önerilir',
            concerns: ['Kuruluk', 'Güneş lekeleri', 'İnce çizgiler'],
            confidence: 78,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String date,
    required String summary,
    required List<String> concerns,
    required int confidence,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to detailed analysis
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getConfidenceColor(confidence),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '%$confidence',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                summary,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              if (concerns.isNotEmpty) ...[
                const Text(
                  'Tespitler:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: concerns.map((concern) => Chip(
                    label: Text(
                      concern,
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: Colors.orange.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getConfidenceColor(int confidence) {
    if (confidence >= 90) return Colors.green;
    if (confidence >= 80) return Colors.orange;
    return Colors.red;
  }
}