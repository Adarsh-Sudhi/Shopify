part of 'auth_bloc.dart';

sealed class AuthEvent {}

class SignUpUser extends AuthEvent {
  final UserModel userModel;

  SignUpUser({required this.userModel});
}

class LogInUser extends AuthEvent {
  final UserModel userModel;

  LogInUser({required this.userModel});
}
