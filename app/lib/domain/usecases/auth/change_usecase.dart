import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  /// Change password (Profile flow)
  Future<Either<Failure, void>> changePassword({
    required String phone,
    required String newPassword,
  }) async {
    return repository.changePassword(
      phone: phone,
      newPassword: newPassword,
    );
  }
}
