import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item.freezed.dart';

/// Domain entity representing an order item in an order.
/// This entity contains business logic and is immutable.
/// Represents a snapshot of a product at the time of purchase.
@freezed
class OrderItem with _$OrderItem {
  const OrderItem._(); // Private constructor for adding custom methods

  const factory OrderItem({
    /// Product ID reference
    required String productId,

    /// Quantity ordered
    required int quantity,

    /// Unit price at the time of purchase (snapshot)
    required double unitPrice,
  }) = _OrderItem;

  /// Calculate total price for this order item
  double get totalPrice => unitPrice * quantity;

  /// Get formatted unit price
  String get formattedUnitPrice {
    return '${unitPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ';
  }

  /// Get formatted total price
  String get formattedTotalPrice {
    return '${totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ';
  }

  /// Check if the order item is valid
  bool get isValid => productId.isNotEmpty && quantity > 0 && unitPrice >= 0;
}
