import 'package:equatable/equatable.dart';

/// Domain entity representing an order item in an order.
/// This entity contains business logic and is immutable.
/// Represents a snapshot of a product at the time of purchase.
class OrderItem extends Equatable {
  /// Product ID reference
  final String productId;

  /// Quantity ordered
  final int quantity;

  /// Unit price at the time of purchase (snapshot)
  final double unitPrice;

  const OrderItem({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  @override
  List<Object?> get props => [productId, quantity, unitPrice];

  /// Create a copy of OrderItem with modified fields
  OrderItem copyWith({String? productId, int? quantity, double? unitPrice}) {
    return OrderItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

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
