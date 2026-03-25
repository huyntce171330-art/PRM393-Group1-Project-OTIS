import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class SaveCurrentUserUseCase {
  final AuthRepository repository;

  SaveCurrentUserUseCase(this.repository);

  Future<Either<Failure, void>> call(int userId) {
    return repository.saveCurrentUser(userId);
  }
}
