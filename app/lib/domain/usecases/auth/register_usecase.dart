// This use case encapsulates the business logic for registering a new user.
//
// Steps to implement:
// 1. Create a class `RegisterUsecase`.
// 2. Inject `AuthRepository` via constructor.
// 3. Define a `call` method taking `RegisterParams` (name, email, password, phone, etc.) and returning `Future<Either<Failure, User>>`.
// 4. In `call`, invoke `repository.register(...)`.

import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<Either<Failure, User>> call({
    required String fullName,
    required String phone,
    required String password,
  }) {
    return repository.register(
      fullName: fullName,
      phone: phone,
      password: password,
    );
  }
}
