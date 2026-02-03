// This file connects the Domain and Data layers for Authentication.
//
// Steps to implement:
// 1. Create `AuthRepositoryImpl` implementing `AuthRepository`.
// 2. Inject `AuthRemoteDatasource` (and `NetworkInfo`).
// 3. Implement `login`:
//    - Call `remoteDatasource.login`.
//    - Return `Right(user)` on success.
//    - Catch exceptions and return `Left(Failure)`.
// 4. Implement `register`:
//    - Call `remoteDatasource.register`.
//    - Return `Right(user)` on success.
// 5. Implement `logout`:
//    - Call `remoteDatasource.logout`.
//    - Return `Right(null)`.

import 'package:fpdart/fpdart.dart';
import 'package:frontend_otis/domain/entities/user.dart';
import 'package:frontend_otis/domain/repositories/auth_repository.dart';
import 'package:frontend_otis/data/datasources/auth/auth_remote_datasource.dart';
import 'package:frontend_otis/core/error/failures.dart';

/// Repository implementation connecting Domain and Data layers
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  /// Login user
  @override
  Future<Either<Failure, User>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final userModel = await remoteDatasource.login(phone, password);
      return Right(userModel.toDomain());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return Left(ServerFailure('Login failed'));
    }
  }

  /// Register user
  @override
  Future<Either<Failure, User>> register({
    required String phone,
    required String password,
    required String fullName,
  }) async {
    try {
      final userModel = await remoteDatasource.register(
        fullName,
        password,
        phone,
      );
      return Right(userModel.toDomain());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return Left(ServerFailure('Register failed'));
    }
  }

  /// Logout user
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDatasource.logout();
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return Left(ServerFailure('Logout failed'));
    }
  }

  // ─────────────────────────────────────────────
  // 🔐 OTP
  // ─────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> requestOtp({
    required String phone,
  }) async {
    try {
      await remoteDatasource.requestOtp(phone);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return Left(ServerFailure('Request OTP failed'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      await remoteDatasource.verifyOtp(phone, otp);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return Left(ServerFailure('Verify OTP failed'));
    }
  }

  // ─────────────────────────────────────────────
  // 🔑 Password
  // ─────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> resetPassword({
    required String phone,
    required String newPassword,
  }) async {
    try {
      await remoteDatasource.resetPassword(phone, newPassword);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return Left(ServerFailure('Reset password failed'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String phone,
    required String newPassword,
  }) async {
    try {
      await remoteDatasource.changePassword(phone, newPassword);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return Left(ServerFailure('Change password failed'));
    }
  }
}
