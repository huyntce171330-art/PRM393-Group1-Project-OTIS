import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  /// Reset password after OTP verification
  Future<Either<Failure, void>> resetPassword({
    required String phone,
    required String newPassword,
  }) async {
    return repository.resetPassword(phone: phone, newPassword: newPassword);
  }
}
