// This file defines the events for AuthBloc.
//
// Steps to implement:
// 1. Define abstract class `AuthEvent`.
// 2. Create `LoginEvent`:
//    - `final String email;`
//    - `final String password;`
// 3. Create `RegisterEvent`:
//    - `final String name;`
//    - `final String email;`
//    - `final String password;`
//    - `final String phone;`
// 4. Create `LogoutEvent`.
// 5. Create `CheckAuthStatusEvent` (optional, to check if already logged in on app start).

import 'package:equatable/equatable.dart';

/// Base class for authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to log in user
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event to register a new user
class RegisterEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String phone;

  const RegisterEvent({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
  });

  @override
  List<Object?> get props => [fullName, email, password, phone];
}

/// Event to log out the current user
class LogoutEvent extends AuthEvent {}

/// Optional: Event to check auth status on app start
class CheckAuthStatusEvent extends AuthEvent {}
