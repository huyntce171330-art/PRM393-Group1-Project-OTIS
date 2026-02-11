import 'package:dartz/dartz.dart' hide Order;
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<Order>>> getOrders();
  Future<Either<Failure, Order>> getOrderDetail(String id);
  Future<Either<Failure, Order>> createOrder(Order order);
  Future<Either<Failure, Order>> updateOrderStatus(String id, String status);
}
