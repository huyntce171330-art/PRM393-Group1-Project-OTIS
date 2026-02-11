import 'package:json_annotation/json_annotation.dart';

/// Order status in the system.
/// Maps to database status: 'pending_payment', 'shipping', 'completed', 'canceled'
enum OrderStatus { pendingPayment, paid, processing, completed, canceled }

/// Payment method for orders.
/// Maps to database payment_method: 'cash', 'transfer'
enum PaymentMethod { cash, transfer }

/// Payment status in the system.
/// Maps to database status: 'pending', 'success', 'failed'
enum PaymentStatus { pending, success, failed }

/// JSON converter for OrderStatus to handle string mapping from database.
class OrderStatusConverter implements JsonConverter<OrderStatus, String> {
  const OrderStatusConverter();

  @override
  OrderStatus fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'pending_payment':
      case 'pendingpayment':
        return OrderStatus.pendingPayment;
      case 'paid':
        return OrderStatus.paid;
      case 'processing':
        return OrderStatus.processing;
      case 'completed':
        return OrderStatus.completed;
      case 'canceled':
        return OrderStatus.canceled;
      default:
        return OrderStatus.pendingPayment;
    }
  }

  @override
  String toJson(OrderStatus object) {
    switch (object) {
      case OrderStatus.pendingPayment:
        return 'pending_payment';
      case OrderStatus.paid:
        return 'paid';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.canceled:
        return 'canceled';
    }
  }
}

/// JSON converter for PaymentMethod to handle string mapping from database.
/// Maps payment_method from database (string values) to enum values.
class PaymentMethodConverter implements JsonConverter<PaymentMethod, String> {
  const PaymentMethodConverter();

  @override
  PaymentMethod fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'cash':
        return PaymentMethod.cash;
      case 'transfer':
        return PaymentMethod.transfer;
      default:
        // Default to cash for unknown values (defensive programming)
        return PaymentMethod.cash;
    }
  }

  @override
  String toJson(PaymentMethod object) {
    switch (object) {
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.transfer:
        return 'transfer';
    }
  }
}

/// JSON converter for PaymentStatus to handle string mapping from database.
class PaymentStatusConverter implements JsonConverter<PaymentStatus, String> {
  const PaymentStatusConverter();

  @override
  PaymentStatus fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'success':
        return PaymentStatus.success;
      case 'failed':
        return PaymentStatus.failed;
      default:
        return PaymentStatus.pending;
    }
  }

  @override
  String toJson(PaymentStatus object) {
    switch (object) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.success:
        return 'success';
      case PaymentStatus.failed:
        return 'failed';
    }
  }
}

/// Extension methods for OrderStatus enum
extension OrderStatusExtension on OrderStatus {
  /// Get the display name for the status
  String get displayName {
    switch (this) {
      case OrderStatus.pendingPayment:
        return 'Pending Payment';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.canceled:
        return 'Cancelled';
    }
  }

  /// Check if the order can be cancelled
  bool get canBeCancelled =>
      this == OrderStatus.pendingPayment || this == OrderStatus.paid;

  /// Check if the order is completed
  bool get isCompleted => this == OrderStatus.completed;

  /// Check if the order is in progress
  bool get isInProgress =>
      this == OrderStatus.processing || this == OrderStatus.paid;
}

/// Extension methods for PaymentMethod enum
extension PaymentMethodExtension on PaymentMethod {
  /// Get the display name for the payment method
  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.transfer:
        return 'Bank Transfer';
    }
  }

  /// Get the description for the payment method
  String get description {
    switch (this) {
      case PaymentMethod.cash:
        return 'Pay with cash upon delivery';
      case PaymentMethod.transfer:
        return 'Pay via bank transfer';
    }
  }
}

/// Extension methods for PaymentStatus enum
extension PaymentStatusExtension on PaymentStatus {
  /// Get the display name for the payment status
  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.success:
        return 'Success';
      case PaymentStatus.failed:
        return 'Failed';
    }
  }
}
