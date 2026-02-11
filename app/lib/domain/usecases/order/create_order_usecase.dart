import 'package:dartz/dartz.dart' hide Order;
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:frontend_otis/domain/repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Either<Failure, Order>> call(Order order) {
    return repository.createOrder(order);
  }
}
