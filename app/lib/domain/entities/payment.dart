import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';

/// Domain entity representing a payment.
class Payment extends Equatable {
  final String id;
  final String orderId;
  final String paymentCode;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime createdAt;
  final DateTime? paidAt;

  const Payment({
    required this.id,
    required this.orderId,
    required this.paymentCode,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
    this.paidAt,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    paymentCode,
    amount,
    method,
    status,
    createdAt,
    paidAt,
  ];
}
