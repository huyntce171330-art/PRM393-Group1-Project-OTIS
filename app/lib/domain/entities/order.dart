import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/order_item.dart';

part 'order.freezed.dart';

/// Domain entity representing an order in the system.
/// This entity contains business logic and is immutable.
/// Uses composition with OrderItem entities.
@freezed
class Order with _$Order {
  const Order._(); // Private constructor for adding custom methods

  const factory Order({
    /// Unique identifier for the order
    required String id,

    /// Order code (human-readable identifier)
    required String code,

    /// Total amount of the order
    required double totalAmount,

    /// Current status of the order
    required OrderStatus status,

    /// Shipping address for the order
    required String shippingAddress,

    /// When the order was created
    required DateTime createdAt,

    /// List of order items
    required List<OrderItem> items,
  }) = _Order;

  /// Calculate total amount from order items (for validation)
  double get calculatedTotalAmount {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Check if the total amount matches the calculated amount
  bool get isTotalAmountValid {
    const tolerance = 0.01; // Allow for floating point precision issues
    return (totalAmount - calculatedTotalAmount).abs() < tolerance;
  }

  /// Get the total number of items in the order
  int get totalItemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Get the number of unique products in the order
  int get uniqueProductCount => items.length;

  /// Check if the order can be cancelled
  bool get canBeCancelled => status.canBeCancelled;

  /// Check if the order is completed
  bool get isCompleted => status.isCompleted;

  /// Check if the order is in progress
  bool get isInProgress => status.isInProgress;

  /// Get formatted total amount
  String get formattedTotalAmount {
    return '${totalAmount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )} đ';
  }

  /// Get formatted creation date
  String get formattedCreatedAt {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
  }

  /// Get formatted creation date and time
  String get formattedCreatedAtTime {
    return '${formattedCreatedAt} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  /// Check if the order contains valid items
  bool get hasValidItems => items.every((item) => item.isValid);

  /// Check if the order is valid overall
  bool get isValid => hasValidItems && totalAmount > 0 && code.isNotEmpty;
}