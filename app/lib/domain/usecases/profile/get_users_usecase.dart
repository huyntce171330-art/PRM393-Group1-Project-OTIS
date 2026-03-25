import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/profile_repository.dart';

class GetUsersUseCase {
  final ProfileRepository repository;

  GetUsersUseCase(this.repository);

  Future<Either<Failure, List<User>>> call({
    String? query,
    String? status,
    String? sortBy,
  }) {
    return repository.getUsers(
      query: query,
      status: status,
      sortBy: sortBy,
    );
  }
}
