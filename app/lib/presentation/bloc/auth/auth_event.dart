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
import 'package:frontend_otis/domain/entities/user.dart';

/// Base class for authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to log in user
class LoginEvent extends AuthEvent {
  final String phone;
  final String password;

  const LoginEvent({
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [phone, password];
}

/// Event to register a new user
class RegisterEvent extends AuthEvent {
  final String fullName;
  final String phone;
  final String password;

  const RegisterEvent({
    required this.fullName,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, phone, password];
}

/// Event to log out the current user
class LogoutEvent extends AuthEvent {}

/// Optional: Event to check auth status on app start
class CheckAuthStatusEvent extends AuthEvent {}

/// Event to request OTP (used for both forgot & change password)
class RequestOtpEvent extends AuthEvent {
  final String phone;

  const RequestOtpEvent({required this.phone});

  @override
  List<Object?> get props => [phone];
}

/// Event to verify OTP
class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;

  const VerifyOtpEvent({
    required this.phone,
    required this.otp,
  });

  @override
  List<Object?> get props => [phone, otp];
}

/// Event to reset password (forgot password flow)
class ResetPasswordEvent extends AuthEvent {
  final String phone;
  final String newPassword;

  const ResetPasswordEvent({
    required this.phone,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [phone, newPassword];
}

/// Event to change password (user is logged in)
class ChangePasswordEvent extends AuthEvent {
  final String phone;
  final String newPassword;

  const ChangePasswordEvent({
    required this.phone,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [phone, newPassword];
}
class AuthUserUpdated extends AuthEvent {
  final User updatedUser;
  const AuthUserUpdated(this.updatedUser);

  @override
  List<Object?> get props => [updatedUser];
}

