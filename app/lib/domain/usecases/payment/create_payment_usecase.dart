import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/payment.dart';
import 'package:frontend_otis/domain/repositories/payment_repository.dart';

class CreatePaymentUseCase {
  final PaymentRepository repository;

  CreatePaymentUseCase(this.repository);

  Future<Either<Failure, Payment>> call(Payment payment) {
    return repository.createPayment(payment);
  }
}
