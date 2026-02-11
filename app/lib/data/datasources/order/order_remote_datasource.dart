import 'package:frontend_otis/data/models/order_model.dart';

abstract class OrderRemoteDatasource {
  Future<List<OrderModel>> fetchOrders();
  Future<OrderModel> fetchOrderDetail(String id);
  Future<OrderModel> createOrder(Map<String, dynamic> orderData);
  Future<OrderModel> updateOrderStatus(String id, String status);
}
