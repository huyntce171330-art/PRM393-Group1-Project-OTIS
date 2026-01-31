import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend_otis/domain/entities/product.dart';

part 'cart_item.freezed.dart';

/// Domain entity representing a cart item in the system.
/// This entity contains business logic and is immutable.
/// Uses composition to hold the Product object after repository lookup.
@freezed
class CartItem with _$CartItem {
  const CartItem._(); // Private constructor for adding custom methods

  const factory CartItem({
    /// Unique identifier for the product in cart
    required String productId,

    /// Quantity of the product in cart
    required int quantity,

    /// The actual product object (resolved after repository lookup)
    /// Nullable because it might not be loaded yet
    Product? product,
  }) = _CartItem;

  /// Check if the cart item has a valid product
  bool get hasProduct => product != null;

  /// Get the total price for this cart item
  double get totalPrice {
    if (product == null) return 0.0;
    return product!.price * quantity;
  }

  /// Get the formatted total price
  String get formattedTotalPrice {
    return '${totalPrice.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )} VND';
  }

  /// Check if the cart item is valid (has product and positive quantity)
  bool get isValid => hasProduct && quantity > 0 && product!.isAvailable;

  /// Get the product name or fallback
  String get productName => product?.name ?? 'Unknown Product';

  /// Get the product SKU or fallback
  String get productSku => product?.sku ?? '';

  /// Check if the product is in stock for the requested quantity
  bool get isInStock {
    if (product == null) return false;
    return product!.stockQuantity >= quantity;
  }

  /// Get available quantity message
  String get availabilityMessage {
    if (product == null) return 'Product not available';
    if (!product!.isAvailable) return 'Product not available';
    if (!isInStock) {
      return 'Only ${product!.stockQuantity} available (requested: $quantity)';
    }
    return '${product!.stockQuantity} available';
  }

  /// Create a copy with updated quantity (clamped to available stock)
  CartItem withQuantity(int newQuantity) {
    final clampedQuantity = product != null
        ? newQuantity.clamp(0, product!.stockQuantity)
        : newQuantity;

    return copyWith(quantity: clampedQuantity);
  }
}