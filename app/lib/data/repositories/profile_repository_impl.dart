import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource profileRemoteDatasource;

  ProfileRepositoryImpl({required this.profileRemoteDatasource});

  @override
  Future<Either<Failure, int>> updateUserProfile({
    required int userId,
    required String fullName,
    required String address,
    required String phone,
  }) async {
    try {
      final result = await profileRemoteDatasource.updateUserProfile(
        userId: userId,
        fullName: fullName,
        address: address,
        phone: phone,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getUserById(int userId) async {
    try {
      final result = await profileRemoteDatasource.getUserById(userId);
      return Right(result?.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> countCustomers() async {
    try {
      final result = await profileRemoteDatasource.countCustomers();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> updateUserStatus({
    required int userId,
    required String status,
  }) async {
    try {
      final result = await profileRemoteDatasource.updateUserStatus(
        userId: userId,
        status: status,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers({
    String? query,
    String? status,
    String? sortBy,
  }) async {
    try {
      final results = await profileRemoteDatasource.getUsers(
        query: query,
        status: status,
        sortBy: sortBy,
      );
      return Right(results.map((m) => m.toDomain()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
