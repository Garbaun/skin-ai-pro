import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();
  
  FirebaseService._();

  // Firebase instances
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;
  late final FirebaseAnalytics analytics;
  late final FirebaseCrashlytics crashlytics;

  // Collection names
  static const String usersCollection = 'users';
  static const String analysesCollection = 'analyses';
  static const String productsCollection = 'products';
  static const String routinesCollection = 'routines';
  static const String waterTrackingCollection = 'water_tracking';

  /// Initialize Firebase services
  Future<void> initialize() async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp();
      
      // Initialize services
      auth = FirebaseAuth.instance;
      firestore = FirebaseFirestore.instance;
      storage = FirebaseStorage.instance;
      analytics = FirebaseAnalytics.instance;
      crashlytics = FirebaseCrashlytics.instance;

      // Enable crashlytics in release mode
      if (bool.fromEnvironment('dart.vm.product')) {
        await crashlytics.setCrashlyticsCollectionEnabled(true);
      }

      // Configure Firestore settings
      firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization failed: $e');
      rethrow;
    }
  }

  /// Get current user
  User? get currentUser => auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Get user document reference
  DocumentReference<Map<String, dynamic>>? get userDoc {
    final user = currentUser;
    return user != null ? firestore.collection(usersCollection).doc(user.uid) : null;
  }

  /// Enable/disable analytics
  Future<void> setAnalyticsEnabled(bool enabled) async {
    await analytics.setAnalyticsCollectionEnabled(enabled);
  }

  /// Log custom event
  Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    await analytics.logEvent(name: name, parameters: parameters);
  }

  /// Set user properties
  Future<void> setUserProperty(String name, String value) async {
    await analytics.setUserProperty(name: name, value: value);
  }

  /// Record error
  Future<void> recordError(dynamic error, StackTrace? stackTrace) async {
    await crashlytics.recordError(error, stackTrace);
  }

  /// Set user ID for crashlytics
  Future<void> setUserId(String userId) async {
    await crashlytics.setUserIdentifier(userId);
  }
}