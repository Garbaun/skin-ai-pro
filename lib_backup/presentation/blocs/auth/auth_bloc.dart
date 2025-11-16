import 'package:flutter_bloc/flutter_bloc.dart';

// Auth Events
abstract class AuthEvent {}
class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  
  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  
  RegisterEvent({required this.email, required this.password, required this.name});
}

class LogoutEvent extends AuthEvent {}

// Auth States
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  
  AuthAuthenticated({required this.userId, required this.email});
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  
  AuthError({required this.message});
}

// Auth Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    await Future.delayed(const Duration(seconds: 1));
    
    if (event.email.isNotEmpty && event.password.isNotEmpty) {
      emit(AuthAuthenticated(userId: 'user_123', email: event.email));
    } else {
      emit(AuthError(message: 'Invalid credentials'));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    await Future.delayed(const Duration(seconds: 1));
    
    if (event.email.isNotEmpty && event.password.isNotEmpty && event.name.isNotEmpty) {
      emit(AuthAuthenticated(userId: 'user_123', email: event.email));
    } else {
      emit(AuthError(message: 'Registration failed'));
    }
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }
}