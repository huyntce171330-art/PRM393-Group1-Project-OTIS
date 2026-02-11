import 'package:frontend_otis/domain/entities/bank_account.dart';
import 'package:frontend_otis/domain/entities/payment.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentInitiated extends PaymentState {
  final Payment payment;
  final BankAccount? bankAccount;
  PaymentInitiated(this.payment, {this.bankAccount});
}

class PaymentFailure extends PaymentState {
  final String message;
  PaymentFailure(this.message);
}
