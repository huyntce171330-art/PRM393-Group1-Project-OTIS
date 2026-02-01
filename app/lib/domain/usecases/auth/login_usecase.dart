// This use case encapsulates the business logic for logging in a user.
//
// Steps to implement:
// 1. Create a class `LoginUsecase`.
// 2. Inject `AuthRepository` via constructor.
// 3. Define a `call` method taking `LoginParams` (containing email, password) and returning `Future<Either<Failure, User>>`.
// 4. In `call`, invoke `repository.login(params.email, params.password)`.

import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) {
    return repository.login(
      email: email,
      password: password,
    );
  }
}
