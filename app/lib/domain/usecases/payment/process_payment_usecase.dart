import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/payment.dart';
import 'package:frontend_otis/domain/repositories/payment_repository.dart';

class ProcessPaymentUseCase {
  final PaymentRepository repository;

  ProcessPaymentUseCase(this.repository);

  Future<Either<Failure, Payment>> call(String orderId) {
    return repository.processPayment(orderId);
  }
}
