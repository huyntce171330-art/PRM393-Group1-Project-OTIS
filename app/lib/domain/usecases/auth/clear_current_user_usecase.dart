import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class ClearCurrentUserUseCase {
  final AuthRepository repository;

  ClearCurrentUserUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.clearCurrentUser();
  }
}
