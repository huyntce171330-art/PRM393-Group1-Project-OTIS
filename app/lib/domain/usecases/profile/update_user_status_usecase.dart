import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/profile_repository.dart';

class UpdateUserStatusUseCase {
  final ProfileRepository repository;

  UpdateUserStatusUseCase(this.repository);

  Future<Either<Failure, int>> call({
    required int userId,
    required String status,
  }) {
    return repository.updateUserStatus(userId: userId, status: status);
  }
}
