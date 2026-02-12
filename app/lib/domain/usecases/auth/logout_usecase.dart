// This use case encapsulates the business logic for logging out.
//
// Steps to implement:
// 1. Create a class `LogoutUsecase`.
// 2. Inject `AuthRepository` via constructor.
// 3. Define a `call` method returning `Future<Either<Failure, void>>`.
// 4. In `call`, invoke `repository.logout()`.

import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
