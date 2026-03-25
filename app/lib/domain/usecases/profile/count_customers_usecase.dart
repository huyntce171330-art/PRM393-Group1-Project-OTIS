import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/profile_repository.dart';

class CountCustomersUseCase {
  final ProfileRepository repository;

  CountCustomersUseCase(this.repository);

  Future<Either<Failure, int>> call() {
    return repository.countCustomers();
  }
}
