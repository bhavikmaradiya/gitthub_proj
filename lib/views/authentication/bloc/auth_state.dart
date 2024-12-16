part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthFailedState extends AuthState {}

class AuthLoadingState extends AuthState {
  final bool isLoading;

  AuthLoadingState({
    this.isLoading = true,
  });
}
