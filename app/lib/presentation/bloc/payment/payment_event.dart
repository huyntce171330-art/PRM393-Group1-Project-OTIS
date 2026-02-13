import 'package:frontend_otis/core/enums/order_enums.dart';

abstract class PaymentEvent {}

class ProcessPaymentEvent extends PaymentEvent {
  final String orderId;
  ProcessPaymentEvent(this.orderId);
}

class SelectPaymentMethodEvent extends PaymentEvent {
  final String orderId;
  final PaymentMethod method;
  final double amount;
  SelectPaymentMethodEvent({
    required this.orderId,
    required this.method,
    required this.amount,
  });
}
