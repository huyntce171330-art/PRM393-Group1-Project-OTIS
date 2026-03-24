import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class GetCurrentUserIdUseCase {
  final AuthRepository repository;

  GetCurrentUserIdUseCase(this.repository);

  Future<Either<Failure, int?>> call() {
    return repository.getCurrentUserId();
  }
}
