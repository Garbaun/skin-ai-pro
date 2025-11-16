import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Kullanıcı modeli
class User {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final bool isPremium;
  final DateTime? premiumExpiry;
  final int analysisCredits;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.isPremium = false,
    this.premiumExpiry,
    this.analysisCredits = 0,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    bool? isPremium,
    DateTime? premiumExpiry,
    int? analysisCredits,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiry: premiumExpiry ?? this.premiumExpiry,
      analysisCredits: analysisCredits ?? this.analysisCredits,
    );
  }
}

// Auth state
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  // Yardımcı getter'lar
  bool get isAuthenticated => user != null;
  User? get currentUser => user;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  // Giriş yap
  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // TODO: Firebase authentication implemente et
      await Future.delayed(const Duration(seconds: 2)); // Simülasyon
      
      final user = User(
        id: 'user_123',
        email: email,
        name: 'Test Kullanıcı',
        analysisCredits: 5,
      );
      
      state = state.copyWith(user: user, isLoading: false);
      
      // Kullanıcı bilgilerini local storage'a kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.id);
      await prefs.setString('user_email', user.email);
      if (user.name != null) {
        await prefs.setString('user_name', user.name!);
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Giriş yapılırken bir hata oluştu: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  // Google ile giriş yap
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // TODO: Google Sign-In implemente et
      await Future.delayed(const Duration(seconds: 2)); // Simülasyon
      
      final user = User(
        id: 'google_user_456',
        email: 'user@gmail.com',
        name: 'Google Kullanıcı',
        photoUrl: 'https://example.com/photo.jpg',
        analysisCredits: 3,
      );
      
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Google ile giriş yapılırken bir hata oluştu: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  // Kayıt ol
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // TODO: Firebase registration implemente et
      await Future.delayed(const Duration(seconds: 2)); // Simülasyon
      
      final user = User(
        id: 'new_user_789',
        email: email,
        name: name,
        analysisCredits: 1, // Yeni kullanıcıya 1 analiz hakkı
      );
      
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Kayıt olunurken bir hata oluştu: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  // Çıkış yap
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // TODO: Firebase sign out implemente et
      await Future.delayed(const Duration(seconds: 1)); // Simülasyon
      
      state = const AuthState(); // State'i temizle
      
      // Local storage'ı temizle
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      state = state.copyWith(
        error: 'Çıkış yapılırken bir hata oluştu: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  // Kullanıcı bilgilerini güncelle
  Future<void> updateUser(User updatedUser) async {
    state = state.copyWith(user: updatedUser);
    
    // Local storage'ı güncelle
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', updatedUser.id);
    await prefs.setString('user_email', updatedUser.email);
    if (updatedUser.name != null) {
      await prefs.setString('user_name', updatedUser.name!);
    }
  }

  // Kredi kullan
  Future<bool> useAnalysisCredit() async {
    final currentUser = state.user;
    if (currentUser == null) return false;
    
    if (currentUser.analysisCredits > 0) {
      final updatedUser = currentUser.copyWith(
        analysisCredits: currentUser.analysisCredits - 1,
      );
      await updateUser(updatedUser);
      return true;
    }
    
    return false;
  }

  // Kredi ekle
  Future<void> addAnalysisCredits(int credits) async {
    final currentUser = state.user;
    if (currentUser == null) return;
    
    final updatedUser = currentUser.copyWith(
      analysisCredits: currentUser.analysisCredits + credits,
    );
    await updateUser(updatedUser);
  }

  // Hataları temizle
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Kullanıcı stream provider (Firebase auth state changes için)
final authStateChangesProvider = StreamProvider<User?>((ref) {
  // TODO: Firebase auth state changes implemente et
  return Stream.value(null); // Şimdilik boş stream
});

// Kullanıcı giriş yapmış mı?
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user != null;
});

// Mevcut kullanıcı
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authProvider);
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