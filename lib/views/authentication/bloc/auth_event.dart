part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthInitialEvent extends AuthEvent {}
class AuthStartEvent extends AuthEvent {}

class AuthCodeFoundEvent extends AuthEvent {
  final String? authCode;

  AuthCodeFoundEvent(
    this.authCode,
  );
}
