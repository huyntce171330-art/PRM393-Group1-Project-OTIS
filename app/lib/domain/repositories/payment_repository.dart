import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/payment.dart';

abstract class PaymentRepository {
  Future<Either<Failure, Payment>> createPayment(Payment payment);
  Future<Either<Failure, Payment>> processPayment(String orderId);
}
