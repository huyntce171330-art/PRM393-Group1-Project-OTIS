import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/bank_account.dart';
import 'package:frontend_otis/domain/repositories/payment_repository.dart';

class GetActiveBankAccountUseCase {
  final PaymentRepository repository;

  GetActiveBankAccountUseCase(this.repository);

  Future<Either<Failure, BankAccount>> call() async {
    return await repository.getActiveBankAccount();
  }
}
