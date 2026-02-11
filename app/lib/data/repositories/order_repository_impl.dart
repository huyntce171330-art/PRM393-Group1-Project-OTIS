import 'package:dartz/dartz.dart' hide Order;
import 'package:frontend_otis/core/error/exceptions.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/data/datasources/order/order_remote_datasource.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:frontend_otis/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource remoteDatasource;

  OrderRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    try {
      final orderModels = await remoteDatasource.fetchOrders();
      final orders = orderModels.map((model) => model.toDomain()).toList();
      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Unknown server error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderDetail(String id) async {
    try {
      final orderModel = await remoteDatasource.fetchOrderDetail(id);
      return Right(orderModel.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Unknown server error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> createOrder(Order order) async {
    try {
      // Convert domain entity to model/JSON if needed, or pass specific params
      // Since createOrder usually sends new data, might need a model.toJson() or custom map
      // For now assuming order properties are passed in a map
      final orderData = {
        'items': order.items
            .map(
              (item) => {
                'product_id': item.productId,
                'quantity': item.quantity,
                'price': item.unitPrice,
                'product_name': item.productName,
              },
            )
            .toList(),
        'total_amount': order.totalAmount,
        'shipping_address': order.shippingAddress,
        'code': order.code,
        'status': const OrderStatusConverter().toJson(order.status),
      };

      final orderModel = await remoteDatasource.createOrder(orderData);
      return Right(orderModel.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Unknown server error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> updateOrderStatus(
    String id,
    String status,
  ) async {
    try {
      final orderModel = await remoteDatasource.updateOrderStatus(id, status);
      return Right(orderModel.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Unknown server error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
