import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, int>> updateUserProfile({
    required int userId,
    required String fullName,
    required String address,
    required String phone,
  });

  Future<Either<Failure, User?>> getUserById(int userId);

  Future<Either<Failure, int>> countCustomers();

  Future<Either<Failure, int>> updateUserStatus({
    required int userId,
    required String status,
  });

  Future<Either<Failure, List<User>>> getUsers({
    String? query,
    String? status,
    String? sortBy,
  });
}
