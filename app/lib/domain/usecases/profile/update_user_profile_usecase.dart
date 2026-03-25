import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, int>> call({
    required int userId,
    required String fullName,
    required String address,
    required String phone,
  }) {
    return repository.updateUserProfile(
      userId: userId,
      fullName: fullName,
      address: address,
      phone: phone,
    );
  }
}
