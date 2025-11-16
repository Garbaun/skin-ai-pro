import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';
import '../services/firebase_auth_service.dart';

// Auth state
class FirebaseAuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const FirebaseAuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null;
  UserModel? get currentUser => user;

  FirebaseAuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return FirebaseAuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Firebase Auth notifier
class FirebaseAuthNotifier extends StateNotifier<FirebaseAuthState> {
  final FirebaseAuthService _authService;

  FirebaseAuthNotifier(this._authService) : super(const FirebaseAuthState()) {
    _init();
  }

  void _init() async {
    // Listen to auth state changes
    _authService.authStateChanges.listen((userModel) {
      if (userModel != null) {
        state = FirebaseAuthState(user: userModel);
      } else {
        state = const FirebaseAuthState();
      }
    });

    // Check for cached user
    await _loadCachedUser();
  }

  Future<void> _loadCachedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedUserId = prefs.getString('cached_user_id');
      final cachedUserEmail = prefs.getString('cached_user_email');
      final cachedUserName = prefs.getString('cached_user_name');

      if (cachedUserId != null && cachedUserEmail != null) {
        final user = UserModel(
          id: cachedUserId,
          email: cachedUserEmail,
          name: cachedUserName,
          isPremium: prefs.getBool('cached_user_premium') ?? false,
          analysisCredits: prefs.getInt('cached_user_credits') ?? 0,
        );

        // Check if still authenticated with Firebase
        if (_authService.currentUser != null &&
            _authService.currentUser!.uid == cachedUserId) {
          state = FirebaseAuthState(user: user);
        }
      }
    } catch (e) {
      print('Error loading cached user: $e');
    }
  }

  Future<void> _cacheUser(UserModel? user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (user != null) {
        await prefs.setString('cached_user_id', user.id);
        await prefs.setString('cached_user_email', user.email);
        if (user.name != null) {
          await prefs.setString('cached_user_name', user.name!);
        }
        await prefs.setBool('cached_user_premium', user.isPremium);
        await prefs.setInt('cached_user_credits', user.analysisCredits);
      } else {
        await prefs.remove('cached_user_id');
        await prefs.remove('cached_user_email');
        await prefs.remove('cached_user_name');
        await prefs.remove('cached_user_premium');
        await prefs.remove('cached_user_credits');
      }
    } catch (e) {
      print('Error caching user: $e');
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.signInWithEmail(email, password);

      if (user != null) {
        await _cacheUser(user);
        state = FirebaseAuthState(user: user);

        await FirebaseService.instance.logEvent('email_sign_in_success', {
          'user_id': user.id,
          'email': user.email,
        });
      } else {
        throw Exception('Giriş yapılırken bir hata oluştu');
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Giriş yapılırken bir hata oluştu: ${e.toString()}',
        isLoading: false,
      );

      await FirebaseService.instance.recordError(e, StackTrace.current);
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        await _cacheUser(user);
        state = FirebaseAuthState(user: user);

        await FirebaseService.instance.logEvent('google_sign_in_success', {
          'user_id': user.id,
          'email': user.email,
        });
      } else {
        throw Exception('Google ile giriş yapılırken bir hata oluştu');
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Google ile giriş yapılırken bir hata oluştu: ${e.toString()}',
        isLoading: false,
      );

      await FirebaseService.instance.recordError(e, StackTrace.current);
    }
  }

  /// Register with email
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.registerWithEmail(
        email: email,
        password: password,
        name: name,
      );

      if (user != null) {
        await _cacheUser(user);
        state = FirebaseAuthState(user: user);

        await FirebaseService.instance.logEvent('email_registration_success', {
          'user_id': user.id,
          'email': user.email,
        });
      } else {
        throw Exception('Kayıt olunurken bir hata oluştu');
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Kayıt olunurken bir hata oluştu: ${e.toString()}',
        isLoading: false,
      );

      await FirebaseService.instance.recordError(e, StackTrace.current);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authService.signOut();
      await _cacheUser(null);
      state = const FirebaseAuthState();

      await FirebaseService.instance.logEvent('user_sign_out', {});
    } catch (e) {
      state = state.copyWith(
        error: 'Çıkış yapılırken bir hata oluştu: ${e.toString()}',
        isLoading: false,
      );

      await FirebaseService.instance.recordError(e, StackTrace.current);
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? photoUrl,
  }) async {
    try {
      final currentUser = state.user;
      if (currentUser == null) return;

      await _authService.updateUserProfile(name: name, photoUrl: photoUrl);

      // Refresh user data
      final updatedUser = await _authService.getCurrentUser();
      if (updatedUser != null) {
        await _cacheUser(updatedUser);
        state = FirebaseAuthState(user: updatedUser);
      }

      await FirebaseService.instance.logEvent('user_profile_updated', {
        'user_id': currentUser.id,
      });
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Use analysis credit
  Future<bool> useAnalysisCredit() async {
    final currentUser = state.user;
    if (currentUser == null) return false;

    if (currentUser.analysisCredits > 0) {
      try {
        await _authService
            .updateAnalysisCredits(currentUser.analysisCredits - 1);

        final updatedUser = currentUser.copyWith(
          analysisCredits: currentUser.analysisCredits - 1,
        );

        await _cacheUser(updatedUser);
        state = FirebaseAuthState(user: updatedUser);

        await FirebaseService.instance.logEvent('analysis_credit_used', {
          'user_id': currentUser.id,
          'remaining_credits': updatedUser.analysisCredits,
        });

        return true;
      } catch (e) {
        await FirebaseService.instance.recordError(e, StackTrace.current);
        return false;
      }
    }

    return false;
  }

  /// Add analysis credits
  Future<void> addAnalysisCredits(int credits) async {
    final currentUser = state.user;
    if (currentUser == null) return;

    try {
      await _authService
          .updateAnalysisCredits(currentUser.analysisCredits + credits);

      final updatedUser = currentUser.copyWith(
        analysisCredits: currentUser.analysisCredits + credits,
      );

      await _cacheUser(updatedUser);
      state = FirebaseAuthState(user: updatedUser);

      await FirebaseService.instance.logEvent('analysis_credits_added', {
        'user_id': currentUser.id,
        'added_credits': credits,
        'total_credits': updatedUser.analysisCredits,
      });
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
    }
  }

  /// Update premium status
  Future<void> updatePremiumStatus(bool isPremium,
      {DateTime? expiryDate}) async {
    final currentUser = state.user;
    if (currentUser == null) return;

    try {
      await _authService.updatePremiumStatus(isPremium, expiryDate: expiryDate);

      final updatedUser = currentUser.copyWith(
        isPremium: isPremium,
        premiumExpiry: expiryDate,
      );

      await _cacheUser(updatedUser);
      state = FirebaseAuthState(user: updatedUser);

      await FirebaseService.instance.logEvent('premium_status_updated', {
        'user_id': currentUser.id,
        'is_premium': isPremium,
      });
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}
