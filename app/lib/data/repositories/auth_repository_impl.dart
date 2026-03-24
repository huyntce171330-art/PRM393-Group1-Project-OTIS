import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, User>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final userModel = await remoteDatasource.login(phone, password);
      return Right(userModel.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Login failed'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

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
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Register failed'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDatasource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Logout failed'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestOtp({required String phone}) async {
    try {
      await remoteDatasource.requestOtp(phone);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Request OTP failed'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
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
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Verify OTP failed'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String phone,
    required String newPassword,
  }) async {
    try {
      await remoteDatasource.resetPassword(phone, newPassword);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Reset password failed'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
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
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Change password failed'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(int userId) async {
    try {
      final userModel = await remoteDatasource.getUserById(userId);
      return Right(userModel.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveCurrentUser(int userId) async {
    try {
      await remoteDatasource.saveCurrentUser(userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'DB Error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int?>> getCurrentUserId() async {
    try {
      final result = await remoteDatasource.getCurrentUserId();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'DB Error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCurrentUser() async {
    try {
      await remoteDatasource.clearCurrentUser();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'DB Error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
