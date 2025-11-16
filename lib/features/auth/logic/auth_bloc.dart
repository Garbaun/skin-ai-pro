import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../core/models/analysis_models.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Dio _dio = Dio();

  AuthBloc() : super(const AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<UpdateProfile>(_onUpdateProfile);

    // Check auth status on initialization
    add(const CheckAuthStatus());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userData = prefs.getString('user_data');

      if (token != null && userData != null) {
        final user = User.fromJson(userData);
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Simulate API call - replace with actual endpoint
      await Future.delayed(const Duration(seconds: 2));

      // Mock user data - replace with actual API response
      final user = User(
        id: '1',
        name: event.email.split('@')[0],
        email: event.email,
        subscriptionType: SubscriptionType.basic,
        analysisCount: 5,
        maxAnalyses: 10,
        createdAt: DateTime.now(),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'mock_token_${event.email}');
      await prefs.setString('user_data', user.toJson());

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(const AuthError('Giriş yapılırken bir hata oluştu'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Simulate API call - replace with actual endpoint
      await Future.delayed(const Duration(seconds: 2));

      // Mock user data - replace with actual API response
      final user = User(
        id: '1',
        name: event.name,
        email: event.email,
        subscriptionType: SubscriptionType.basic,
        analysisCount: 0,
        maxAnalyses: 10,
        createdAt: DateTime.now(),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'mock_token_${event.email}');
      await prefs.setString('user_data', user.toJson());

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(const AuthError('Kayıt olunurken bir hata oluştu'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');

      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(const AuthError('Çıkış yapılırken bir hata oluştu'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      final currentUser = (state as AuthAuthenticated).user;
      final updatedUser = currentUser.copyWith(
        name: event.name ?? currentUser.name,
        email: event.email ?? currentUser.email,
      );

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', updatedUser.toJson());

        emit(AuthAuthenticated(updatedUser));
      } catch (e) {
        emit(const AuthError('Profil güncellenirken bir hata oluştu'));
      }
    }
  }
}
