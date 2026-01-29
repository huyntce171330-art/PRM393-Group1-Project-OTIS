import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final int orderId;
  final String code;
  final int userId;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final DateTime createdAt;

  const Order({
    required this.orderId,
    required this.code,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    orderId,
    code,
    userId,
    totalAmount,
    status,
    shippingAddress,
    createdAt,
  ];
}
