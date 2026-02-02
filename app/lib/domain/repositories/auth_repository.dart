// This file defines the contract for Authentication Repository in the Domain layer.
//
// Steps to implement:
// 1. Import `dartz` (Either), `failure`, and `User` entity.
// 2. Define an abstract class `AuthRepository`.
// 3. Define `Future<Either<Failure, User>> login(String email, String password);`
// 4. Define `Future<Either<Failure, User>> register(String name, String email, String password, String phone);`
//    - Adjust parameters based on your User model and API requirements.
// 5. Define `Future<Either<Failure, void>> logout();`
//    - This might clear local tokens.

import 'package:fpdart/fpdart.dart';

import '../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Authenticate user using phone number and password.
  /// Returns authenticated [User] on success.
  Future<Either<Failure, User>> login({
    required String phone,
    required String password,
  });

  /// Register a new user.
  ///
  /// Domain-level fields only.
  /// API-specific fields (email, otp, etc.) are handled in data layer.
  ///
  /// Returns [User] if registration also authenticates the user.
  Future<Either<Failure, User>> register({
    required String phone,
    required String password,
    required String fullName,
  });

  /// Logout current user.
  /// Clears authentication state (tokens, sessions, etc.).
  Future<Either<Failure, void>> logout();
}

