import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/analysis_models.dart';
import '../models/product_model.dart';
import '../models/tracking_models.dart';
import 'firebase_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get user document reference
  DocumentReference<Map<String, dynamic>> userDoc(String userId) {
    return _firestore.collection(FirebaseService.usersCollection).doc(userId);
  }

  /// Get analyses collection reference
  CollectionReference<Map<String, dynamic>> analysesCollection(String userId) {
    return userDoc(userId).collection(FirebaseService.analysesCollection);
  }

  /// Get products collection reference
  CollectionReference<Map<String, dynamic>> productsCollection(String userId) {
    return userDoc(userId).collection(FirebaseService.productsCollection);
  }

  /// Get routines collection reference
  CollectionReference<Map<String, dynamic>> routinesCollection(String userId) {
    return userDoc(userId).collection(FirebaseService.routinesCollection);
  }

  /// Get water tracking collection reference
  CollectionReference<Map<String, dynamic>> waterTrackingCollection(String userId) {
    return userDoc(userId).collection(FirebaseService.waterTrackingCollection);
  }

  /// Save analysis result
  Future<String> saveAnalysis(String userId, SkinAnalysisResult analysis) async {
    try {
      final docRef = await analysesCollection(userId).add({
        'userId': userId,
        'imageUrl': analysis.imageUrl,
        'skinTypes': analysis.skinTypes,
        'primaryConcerns': analysis.primaryConcerns,
        'secondaryConcerns': analysis.secondaryConcerns,
        'sensitivityLevel': analysis.sensitivityLevel,
        'recommendations': analysis.recommendations,
        'productRecommendations': analysis.productRecommendations,
        'routineRecommendations': analysis.routineRecommendations,
        'lifestyleTips': analysis.lifestyleTips,
        'confidenceLevel': analysis.confidenceLevel,
        'symptoms': analysis.symptoms,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await FirebaseService.instance.logEvent('analysis_saved', {
        'user_id': userId,
        'analysis_id': docRef.id,
        'skin_types': analysis.skinTypes,
        'concerns': [...analysis.primaryConcerns, ...analysis.secondaryConcerns],
      });

      return docRef.id;
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Get user's analysis history
  Future<List<SkinAnalysisResult>> getAnalysisHistory(String userId) async {
    try {
      final querySnapshot = await analysesCollection(userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return SkinAnalysisResult(
          id: doc.id,
          userId: userId,
          imageUrl: data['imageUrl'] ?? '',
          skinTypes: List<String>.from(data['skinTypes'] ?? []),
          primaryConcerns: List<String>.from(data['primaryConcerns'] ?? []),
          secondaryConcerns: List<String>.from(data['secondaryConcerns'] ?? []),
          sensitivityLevel: data['sensitivityLevel']?.toDouble() ?? 0.0,
          recommendations: List<String>.from(data['recommendations'] ?? []),
          productRecommendations: List<String>.from(data['productRecommendations'] ?? []),
          routineRecommendations: List<String>.from(data['routineRecommendations'] ?? []),
          lifestyleTips: List<String>.from(data['lifestyleTips'] ?? []),
          confidenceLevel: data['confidenceLevel']?.toDouble() ?? 0.0,
          symptoms: List<String>.from(data['symptoms'] ?? []),
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Get specific analysis
  Future<SkinAnalysisResult?> getAnalysis(String userId, String analysisId) async {
    try {
      final doc = await analysesCollection(userId).doc(analysisId).get();
      
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return SkinAnalysisResult(
          id: doc.id,
          userId: userId,
          imageUrl: data['imageUrl'] ?? '',
          skinTypes: List<String>.from(data['skinTypes'] ?? []),
          primaryConcerns: List<String>.from(data['primaryConcerns'] ?? []),
          secondaryConcerns: List<String>.from(data['secondaryConcerns'] ?? []),
          sensitivityLevel: data['sensitivityLevel']?.toDouble() ?? 0.0,
          recommendations: List<String>.from(data['recommendations'] ?? []),
          productRecommendations: List<String>.from(data['productRecommendations'] ?? []),
          routineRecommendations: List<String>.from(data['routineRecommendations'] ?? []),
          lifestyleTips: List<String>.from(data['lifestyleTips'] ?? []),
          confidenceLevel: data['confidenceLevel']?.toDouble() ?? 0.0,
          symptoms: List<String>.from(data['symptoms'] ?? []),
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Delete analysis
  Future<void> deleteAnalysis(String userId, String analysisId) async {
    try {
      await analysesCollection(userId).doc(analysisId).delete();
      
      await FirebaseService.instance.logEvent('analysis_deleted', {
        'user_id': userId,
        'analysis_id': analysisId,
      });
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Save water intake record
  Future<void> saveWaterIntake(String userId, WaterIntakeRecord record) async {
    try {
      await waterTrackingCollection(userId).add({
        'userId': userId,
        'amount': record.amount,
        'unit': record.unit,
        'timestamp': Timestamp.fromDate(record.timestamp),
        'date': DateTime(record.timestamp.year, record.timestamp.month, record.timestamp.day).toIso8601String(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseService.instance.logEvent('water_intake_saved', {
        'user_id': userId,
        'amount': record.amount,
        'unit': record.unit,
      });
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Get water intake for a specific date
  Future<List<WaterIntakeRecord>> getWaterIntakeForDate(String userId, DateTime date) async {
    try {
      final dateString = DateTime(date.year, date.month, date.day).toIso8601String();
      
      final querySnapshot = await waterTrackingCollection(userId)
          .where('date', isEqualTo: dateString)
          .orderBy('timestamp')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return WaterIntakeRecord(
          id: doc.id,
          amount: data['amount'] ?? 0,
          unit: data['unit'] ?? 'ml',
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Get water intake for a date range
  Future<Map<String, List<WaterIntakeRecord>>> getWaterIntakeForDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final querySnapshot = await waterTrackingCollection(userId)
          .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('timestamp')
          .get();

      final Map<String, List<WaterIntakeRecord>> result = {};
      
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final date = data['date'] as String;
        
        result.putIfAbsent(date, () => []);
        result[date]!.add(WaterIntakeRecord(
          id: doc.id,
          amount: data['amount'] ?? 0,
          unit: data['unit'] ?? 'ml',
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        ));
      }
      
      return result;
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Save skincare routine
  Future<String> saveSkincareRoutine(String userId, SkincareRoutine routine) async {
    try {
      final docRef = await routinesCollection(userId).add({
        'userId': userId,
        'name': routine.name,
        'description': routine.description,
        'type': routine.type,
        'steps': routine.steps.map((step) => {
          'name': step.name,
          'description': step.description,
          'duration': step.duration,
          'productId': step.productId,
          'order': step.order,
        }).toList(),
        'isActive': routine.isActive,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await FirebaseService.instance.logEvent('routine_saved', {
        'user_id': userId,
        'routine_id': docRef.id,
        'routine_type': routine.type,
        'step_count': routine.steps.length,
      });

      return docRef.id;
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Get user's skincare routines
  Future<List<SkincareRoutine>> getSkincareRoutines(String userId) async {
    try {
      final querySnapshot = await routinesCollection(userId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return SkincareRoutine(
          id: doc.id,
          userId: userId,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          type: data['type'] ?? 'morning',
          steps: (data['steps'] as List<dynamic>?)
              ?.map((step) => SkincareStep(
                    name: step['name'] ?? '',
                    description: step['description'] ?? '',
                    duration: step['duration'] ?? 0,
                    productId: step['productId'],
                    order: step['order'] ?? 0,
                  ))
              .toList() ?? [],
          isActive: data['isActive'] ?? true,
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Update user premium status
  Future<void> updateUserPremiumStatus(String userId, bool isPremium) async {
    try {
      await userDoc(userId).update({
        'isPremium': isPremium,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await FirebaseService.instance.logEvent('premium_status_updated', {
        'user_id': userId,
        'is_premium': isPremium,
      });
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }
}