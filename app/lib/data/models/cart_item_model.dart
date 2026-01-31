import 'package:frontend_otis/domain/entities/cart_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_item_model.g.dart';

/// Data model for CartItem entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Only parses product_id - the full Product object is resolved separately.
@JsonSerializable()
class CartItemModel {
  const CartItemModel({
    required this.productId,
    required this.quantity,
  });

  /// Product ID reference
  final String productId;

  /// Quantity of the product in cart
  final int quantity;

  /// Factory constructor to create CartItemModel from JSON.
  /// Only parses product_id and quantity - Product object resolved separately.
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: _parseProductId(json['product_id']),
      quantity: _parseInt(json['quantity'], defaultValue: 1),
    );
  }

  /// Convert CartItemModel to JSON for API requests.
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  /// Convert CartItemModel to domain CartItem entity.
  /// Note: This creates a CartItem without the Product object.
  /// The Product should be resolved separately by the repository.
  CartItem toDomain() {
    return CartItem(
      productId: productId,
      quantity: quantity,
      product: null, // Product will be resolved by repository
    );
  }

  /// Create CartItemModel from domain CartItem entity.
  factory CartItemModel.fromDomain(CartItem cartItem) {
    return CartItemModel(
      productId: cartItem.productId,
      quantity: cartItem.quantity,
    );
  }

  /// Parse product_id from JSON to String with defensive handling.
  static String _parseProductId(dynamic value) {
    if (value == null) return '';

    if (value is int) {
      return value.toString();
    }

    if (value is String) {
      return value;
    }

    // Fallback for unexpected types
    return value.toString();
  }

  /// Parse integer values with null safety and default values.
  static int _parseInt(dynamic value, {int defaultValue = 1}) {
    if (value == null) return defaultValue;

    if (value is int) {
      return value;
    }

    if (value is String) {
      final parsed = int.tryParse(value.trim());
      if (parsed != null) {
        return parsed;
      }
    }

    if (value is double) {
      return value.toInt();
    }

    // Fallback to default for unexpected types
    return defaultValue;
  }
}