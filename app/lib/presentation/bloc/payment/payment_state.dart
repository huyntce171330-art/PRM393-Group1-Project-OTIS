import 'package:frontend_otis/domain/entities/payment.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentInitiated extends PaymentState {
  final Payment payment;
  PaymentInitiated(this.payment);
}

class PaymentFailure extends PaymentState {
  final String message;
  PaymentFailure(this.message);
}
