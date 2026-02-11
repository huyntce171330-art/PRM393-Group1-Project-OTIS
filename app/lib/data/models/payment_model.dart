import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.orderId,
    required super.paymentCode,
    required super.amount,
    required super.method,
    required super.status,
    required super.createdAt,
    super.paidAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['payment_id'].toString(),
      orderId: json['order_id'].toString(),
      paymentCode: json['payment_code'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      method: const PaymentMethodConverter().fromJson(
        json['method'] as String? ?? 'cash',
      ),
      status: const PaymentStatusConverter().fromJson(
        json['status'] as String? ?? 'pending',
      ),
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': id,
      'order_id': orderId,
      'payment_code': paymentCode,
      'amount': amount,
      'method': const PaymentMethodConverter().toJson(method),
      'status': const PaymentStatusConverter().toJson(status),
      'created_at': createdAt.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
    };
  }

  factory PaymentModel.fromDomain(Payment payment) {
    return PaymentModel(
      id: payment.id,
      orderId: payment.orderId,
      paymentCode: payment.paymentCode,
      amount: payment.amount,
      method: payment.method,
      status: payment.status,
      createdAt: payment.createdAt,
      paidAt: payment.paidAt,
    );
  }
}
