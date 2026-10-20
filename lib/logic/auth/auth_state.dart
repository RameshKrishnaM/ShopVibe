import 'package:equatable/equatable.dart';
import 'package:appcart/data/models/user_model.dart';

/// Base state for application authentication
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial uninitialized state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during login attempt
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Successfully authenticated state with active user details
class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state (logged out / pristine)
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Authentication failed state with message
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
