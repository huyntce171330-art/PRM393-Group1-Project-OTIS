import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/data/datasources/payment/payment_remote_datasource_impl.dart';
import 'package:frontend_otis/data/models/payment_model.dart';
import 'package:frontend_otis/domain/entities/payment.dart';
import 'package:frontend_otis/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remote;

  PaymentRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Payment>> createPayment(Payment payment) async {
    try {
      final paymentModel = await remote.createPayment(
        PaymentModel.fromDomain(payment),
      );
      return Right(paymentModel);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Payment>> processPayment(String orderId) async {
    try {
      final paymentModel = await remote.processFakePayment(orderId);
      return Right(paymentModel);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
