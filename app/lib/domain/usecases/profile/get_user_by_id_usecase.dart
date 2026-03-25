import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/profile_repository.dart';

class GetUserByIdUseCase {
  final ProfileRepository repository;

  GetUserByIdUseCase(this.repository);

  Future<Either<Failure, User?>> call(int userId) {
    return repository.getUserById(userId);
  }
}
