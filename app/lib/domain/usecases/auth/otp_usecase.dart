import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class OtpUseCase {
  final AuthRepository repository;

  OtpUseCase(this.repository);

  /// Request OTP (Forgot / Change password)
  Future<Either<Failure, void>> requestOtp({
    required String phone,
  }) async {
    return repository.requestOtp(
      phone: phone,
    );
  }

  /// Verify OTP
  Future<Either<Failure, void>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    return repository.verifyOtp(
      phone: phone,
      otp: otp,
    );
  }
}
