import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:frontend_otis/domain/entities/cart_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_item_model.g.dart';

/// Data model for CartItem entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
@JsonSerializable(includeIfNull: false)
class CartItemModel extends Equatable {
  const CartItemModel({required this.productId, required this.quantity});

  /// Product ID reference
  @JsonKey(
    name: 'product_id',
    fromJson: safeStringFromJson,
    toJson: safeStringToJson,
  )
  final String productId;

  /// Quantity of the product in cart
  @JsonKey(fromJson: safeIntFromJson, toJson: safeIntToJson)
  final int quantity;

  @override
  List<Object?> get props => [productId, quantity];

  /// Factory constructor using generated code from json_annotation
  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

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
}
