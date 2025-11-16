part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const RegisterRequested(this.name, this.email, this.password);
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class UpdateProfile extends AuthEvent {
  final String? name;
  final String? email;

  const UpdateProfile({this.name, this.email});
}