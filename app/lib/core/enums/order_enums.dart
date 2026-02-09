import 'package:json_annotation/json_annotation.dart';

/// Order status in the system.
/// Maps to database status: 'pending', 'shipping', 'delivered', 'cancelled'
enum OrderStatus {
  pending,
  shipping,
  delivered,
  cancelled,
}

/// Payment method for orders.
/// Maps to database payment_method: 'cash', 'transfer'
enum PaymentMethod {
  cash,
  transfer,
}

/// JSON converter for OrderStatus to handle string mapping from database.
/// Maps status from database (string values) to enum values.
class OrderStatusConverter implements JsonConverter<OrderStatus, String> {
  const OrderStatusConverter();

  @override
  OrderStatus fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'shipping':
        return OrderStatus.shipping;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        // Default to pending for unknown values (defensive programming)
        return OrderStatus.pending;
    }
  }

  @override
  String toJson(OrderStatus object) {
    switch (object) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.shipping:
        return 'shipping';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
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

/// Extension methods for OrderStatus enum
extension OrderStatusExtension on OrderStatus {
  /// Get the display name for the status
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.shipping:
        return 'Shipping';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Check if the order can be cancelled
  bool get canBeCancelled =>
      this == OrderStatus.pending || this == OrderStatus.shipping;

  /// Check if the order is completed
  bool get isCompleted => this == OrderStatus.delivered;

  /// Check if the order is in progress
  bool get isInProgress => this == OrderStatus.pending || this == OrderStatus.shipping;
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