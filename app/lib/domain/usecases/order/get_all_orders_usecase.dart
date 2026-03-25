import 'package:dartz/dartz.dart' hide Order;
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:frontend_otis/domain/repositories/order_repository.dart';

class GetAllOrdersUseCase {
  final OrderRepository repository;

  GetAllOrdersUseCase(this.repository);

  Future<Either<Failure, List<Order>>> call() {
    return repository.getAllOrders();
  }
}
