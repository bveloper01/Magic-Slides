import 'package:equatable/equatable.dart';

abstract class BlocAuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends BlocAuthState {}

class AuthLoading extends BlocAuthState {}

class AuthAuthenticated extends BlocAuthState {
  final String userId;

  AuthAuthenticated(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AuthUnauthenticated extends BlocAuthState {}

class AuthError extends BlocAuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}