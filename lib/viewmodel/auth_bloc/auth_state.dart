part of 'auth_bloc.dart';


sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthFailed extends AuthState {
  final String msg;

  AuthFailed(this.msg);
}

final class AuthGranted extends AuthState {
  final UserModel model;

  AuthGranted(this.model);
}
