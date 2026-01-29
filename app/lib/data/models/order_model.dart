import '../../domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    required int orderId,
    required String code,
    required int userId,
    required double totalAmount,
    required String status,
    required String shippingAddress,
    required DateTime createdAt,
  }) : super(
         orderId: orderId,
         code: code,
         userId: userId,
         totalAmount: totalAmount,
         status: status,
         shippingAddress: shippingAddress,
         createdAt: createdAt,
       );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'],
      code: json['code'],
      userId: json['user_id'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
      shippingAddress: json['shipping_address'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'code': code,
      'user_id': userId,
      'total_amount': totalAmount,
      'status': status,
      'shipping_address': shippingAddress,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
