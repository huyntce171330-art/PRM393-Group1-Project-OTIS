// This file defines the states for AuthBloc.
//
// Steps to implement:
// 1. Define abstract class `AuthState`.
// 2. Create `AuthInitial`.
// 3. Create `AuthLoading`.
// 4. Create `Authenticated`:
//    - `final User user;`
// 5. Create `Unauthenticated`.
// 6. Create `AuthError`:
//    - `final String message;`

import 'package:frontend_otis/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

/// Base class for authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when nothing has happened yet
class AuthInitial extends AuthState {}

/// Loading state during API call
class AuthLoading extends AuthState {}

/// User successfully authenticated
class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// User is not authenticated
class Unauthenticated extends AuthState {}

/// Error state
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// OTP has been sent successfully
class OtpSent extends AuthState {}

/// OTP has been verified successfully
class OtpVerified extends AuthState {}

/// Password was changed or reset successfully
class PasswordChanged extends AuthState {}

