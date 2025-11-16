import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firebase_auth_service.dart';
import 'firebase_auth_provider.dart';

// Firebase Auth Service Provider
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

// Firebase Auth Provider
final firebaseAuthProvider = StateNotifierProvider<FirebaseAuthNotifier, FirebaseAuthState>((ref) {
  final authService = ref.watch(firebaseAuthServiceProvider);
  return FirebaseAuthNotifier(authService);
});

// Kullanıcı giriş yapmış mı?
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(firebaseAuthProvider);
  return authState.isAuthenticated;
});

// Mevcut kullanıcı
final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(firebaseAuthProvider);
  return authState.user;
});

// Kullanıcının analiz kredileri
final userCreditsProvider = Provider<int>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.analysisCredits ?? 0;
});

// Premium kullanıcı mı?
final isPremiumProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;
  
  if (user.premiumExpiry != null) {
    return DateTime.now().isBefore(user.premiumExpiry!);
  }
  
  return user.isPremium;
});

// Auth loading state
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(firebaseAuthProvider);
  return authState.isLoading;
});

// Auth error
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(firebaseAuthProvider);
  return authState.error;
});