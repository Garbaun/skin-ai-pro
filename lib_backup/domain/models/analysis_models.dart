// Simple data models for the clean app
class SkinAnalysisResult {
  final String id;
  final String userId;
  final String imageUrl;
  final DateTime timestamp;
  final String summary;
  final List<SkinConcern> concerns;
  final List<ProductRecommendation> recommendations;
  final double confidenceScore;

  SkinAnalysisResult({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.timestamp,
    required this.summary,
    required this.concerns,
    required this.recommendations,
    required this.confidenceScore,
  });

  factory SkinAnalysisResult.fromJson(Map<String, dynamic> json) {
    return SkinAnalysisResult(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      imageUrl: json['image_url'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      summary: json['summary'] ?? '',
      concerns: (json['concerns'] as List<dynamic>?)
          ?.map((c) => SkinConcern.fromJson(c))
          .toList() ?? [],
      recommendations: (json['recommendations'] as List<dynamic>?)
          ?.map((r) => ProductRecommendation.fromJson(r))
          .toList() ?? [],
      confidenceScore: (json['confidence_score'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SkinConcern {
  final String name;
  final String severity;
  final String description;
  final List<String> recommendations;

  SkinConcern({
    required this.name,
    required this.severity,
    required this.description,
    required this.recommendations,
  });

  factory SkinConcern.fromJson(Map<String, dynamic> json) {
    return SkinConcern(
      name: json['name'] ?? '',
      severity: json['severity'] ?? '',
      description: json['description'] ?? '',
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }
}

class ProductRecommendation {
  final String name;
  final String category;
  final String brand;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;

  ProductRecommendation({
    required this.name,
    required this.category,
    required this.brand,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });

  factory ProductRecommendation.fromJson(Map<String, dynamic> json) {
    return ProductRecommendation(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}