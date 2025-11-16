// User model
class User {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final UserSubscription subscription;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
    this.lastLoginAt,
    required this.subscription,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photo_url'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      lastLoginAt: json['last_login_at'] != null 
          ? DateTime.parse(json['last_login_at']) 
          : null,
      subscription: UserSubscription.fromJson(json['subscription'] ?? {}),
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'subscription': subscription.toJson(),
      'preferences': preferences.toJson(),
    };
  }
}

class UserSubscription {
  final String type; // 'free', 'premium', 'professional'
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final int creditsRemaining;
  final int analysisLimit;
  final int analysisUsed;

  UserSubscription({
    required this.type,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.creditsRemaining,
    required this.analysisLimit,
    required this.analysisUsed,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      type: json['type'] ?? 'free',
      startDate: DateTime.parse(json['start_date'] ?? DateTime.now().toIso8601String()),
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date']) 
          : null,
      isActive: json['is_active'] ?? true,
      creditsRemaining: json['credits_remaining'] ?? 0,
      analysisLimit: json['analysis_limit'] ?? 3,
      analysisUsed: json['analysis_used'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
      'credits_remaining': creditsRemaining,
      'analysis_limit': analysisLimit,
      'analysis_used': analysisUsed,
    };
  }
}

class UserPreferences {
  final String language; // 'tr', 'en'
  final String theme; // 'light', 'dark', 'system'
  final bool notificationsEnabled;
  final bool waterReminderEnabled;
  final int dailyWaterGoal; // in ml
  final List<String> skinConcerns;
  final List<String> preferredBrands;

  UserPreferences({
    required this.language,
    required this.theme,
    required this.notificationsEnabled,
    required this.waterReminderEnabled,
    required this.dailyWaterGoal,
    required this.skinConcerns,
    required this.preferredBrands,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] ?? 'tr',
      theme: json['theme'] ?? 'system',
      notificationsEnabled: json['notifications_enabled'] ?? true,
      waterReminderEnabled: json['water_reminder_enabled'] ?? true,
      dailyWaterGoal: json['daily_water_goal'] ?? 2000,
      skinConcerns: List<String>.from(json['skin_concerns'] ?? []),
      preferredBrands: List<String>.from(json['preferred_brands'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'theme': theme,
      'notifications_enabled': notificationsEnabled,
      'water_reminder_enabled': waterReminderEnabled,
      'daily_water_goal': dailyWaterGoal,
      'skin_concerns': skinConcerns,
      'preferred_brands': preferredBrands,
    };
  }
}

// Analysis models
class SkinAnalysisResult {
  final String id;
  final String userId;
  final String imageUrl;
  final DateTime timestamp;
  final String summary;
  final List<SkinConcern> concerns;
  final List<ProductRecommendation> recommendations;
  final double confidenceScore;
  final AnalysisMetadata metadata;

  SkinAnalysisResult({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.timestamp,
    required this.summary,
    required this.concerns,
    required this.recommendations,
    required this.confidenceScore,
    required this.metadata,
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
      metadata: AnalysisMetadata.fromJson(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'image_url': imageUrl,
      'timestamp': timestamp.toIso8601String(),
      'summary': summary,
      'concerns': concerns.map((c) => c.toJson()).toList(),
      'recommendations': recommendations.map((r) => r.toJson()).toList(),
      'confidence_score': confidenceScore,
      'metadata': metadata.toJson(),
    };
  }
}

class SkinConcern {
  final String name;
  final String severity; // 'low', 'medium', 'high'
  final String description;
  final double confidence;
  final List<String> recommendations;
  final Map<String, dynamic> details;

  SkinConcern({
    required this.name,
    required this.severity,
    required this.description,
    required this.confidence,
    required this.recommendations,
    required this.details,
  });

  factory SkinConcern.fromJson(Map<String, dynamic> json) {
    return SkinConcern(
      name: json['name'] ?? '',
      severity: json['severity'] ?? 'medium',
      description: json['description'] ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      recommendations: List<String>.from(json['recommendations'] ?? []),
      details: Map<String, dynamic>.from(json['details'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'severity': severity,
      'description': description,
      'confidence': confidence,
      'recommendations': recommendations,
      'details': details,
    };
  }
}

class ProductRecommendation {
  final String id;
  final String name;
  final String category;
  final String brand;
  final String description;
  final double price;
  final String currency; // 'USD', 'EUR', 'TRY'
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String purchaseUrl;
  final bool isAvailable;
  final List<String> skinTypes; // 'dry', 'oily', 'combination', 'sensitive'
  final List<String> concerns; // Concerns this product addresses

  ProductRecommendation({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.description,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.purchaseUrl,
    required this.isAvailable,
    required this.skinTypes,
    required this.concerns,
  });

  factory ProductRecommendation.fromJson(Map<String, dynamic> json) {
    return ProductRecommendation(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      imageUrl: json['image_url'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      purchaseUrl: json['purchase_url'] ?? '',
      isAvailable: json['is_available'] ?? true,
      skinTypes: List<String>.from(json['skin_types'] ?? []),
      concerns: List<String>.from(json['concerns'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'brand': brand,
      'description': description,
      'price': price,
      'currency': currency,
      'image_url': imageUrl,
      'rating': rating,
      'review_count': reviewCount,
      'purchase_url': purchaseUrl,
      'is_available': isAvailable,
      'skin_types': skinTypes,
      'concerns': concerns,
    };
  }
}

class AnalysisMetadata {
  final String deviceInfo;
  final String appVersion;
  final Map<String, dynamic> imageMetadata;
  final Map<String, dynamic> analysisParameters;
  final DateTime processingTime;

  AnalysisMetadata({
    required this.deviceInfo,
    required this.appVersion,
    required this.imageMetadata,
    required this.analysisParameters,
    required this.processingTime,
  });

  factory AnalysisMetadata.fromJson(Map<String, dynamic> json) {
    return AnalysisMetadata(
      deviceInfo: json['device_info'] ?? '',
      appVersion: json['app_version'] ?? '',
      imageMetadata: Map<String, dynamic>.from(json['image_metadata'] ?? {}),
      analysisParameters: Map<String, dynamic>.from(json['analysis_parameters'] ?? {}),
      processingTime: DateTime.parse(json['processing_time'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_info': deviceInfo,
      'app_version': appVersion,
      'image_metadata': imageMetadata,
      'analysis_parameters': analysisParameters,
      'processing_time': processingTime.toIso8601String(),
    };
  }
}

// Comparison model
class ComparisonResult {
  final String id;
  final String analysisId1;
  final String analysisId2;
  final DateTime timestamp;
  final String summary;
  final List<ConcernComparison> concernComparisons;
  final double overallImprovement;
  final List<String> recommendations;

  ComparisonResult({
    required this.id,
    required this.analysisId1,
    required this.analysisId2,
    required this.timestamp,
    required this.summary,
    required this.concernComparisons,
    required this.overallImprovement,
    required this.recommendations,
  });

  factory ComparisonResult.fromJson(Map<String, dynamic> json) {
    return ComparisonResult(
      id: json['id'] ?? '',
      analysisId1: json['analysis_id_1'] ?? '',
      analysisId2: json['analysis_id_2'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      summary: json['summary'] ?? '',
      concernComparisons: (json['concern_comparisons'] as List<dynamic>?)
          ?.map((c) => ConcernComparison.fromJson(c))
          .toList() ?? [],
      overallImprovement: (json['overall_improvement'] as num?)?.toDouble() ?? 0.0,
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'analysis_id_1': analysisId1,
      'analysis_id_2': analysisId2,
      'timestamp': timestamp.toIso8601String(),
      'summary': summary,
      'concern_comparisons': concernComparisons.map((c) => c.toJson()).toList(),
      'overall_improvement': overallImprovement,
      'recommendations': recommendations,
    };
  }
}

class ConcernComparison {
  final String concernName;
  final ConcernStatus previousStatus;
  final ConcernStatus currentStatus;
  final double improvement;
  final String trend; // 'improved', 'worsened', 'stable'

  ConcernComparison({
    required this.concernName,
    required this.previousStatus,
    required this.currentStatus,
    required this.improvement,
    required this.trend,
  });

  factory ConcernComparison.fromJson(Map<String, dynamic> json) {
    return ConcernComparison(
      concernName: json['concern_name'] ?? '',
      previousStatus: ConcernStatus.fromJson(json['previous_status'] ?? {}),
      currentStatus: ConcernStatus.fromJson(json['current_status'] ?? {}),
      improvement: (json['improvement'] as num?)?.toDouble() ?? 0.0,
      trend: json['trend'] ?? 'stable',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'concern_name': concernName,
      'previous_status': previousStatus.toJson(),
      'current_status': currentStatus.toJson(),
      'improvement': improvement,
      'trend': trend,
    };
  }
}

class ConcernStatus {
  final String severity;
  final double confidence;
  final String description;

  ConcernStatus({
    required this.severity,
    required this.confidence,
    required this.description,
  });

  factory ConcernStatus.fromJson(Map<String, dynamic> json) {
    return ConcernStatus(
      severity: json['severity'] ?? 'medium',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'severity': severity,
      'confidence': confidence,
      'description': description,
    };
  }
}