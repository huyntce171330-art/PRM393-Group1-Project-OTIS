import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:frontend_otis/domain/entities/order_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_item_model.g.dart';

/// Data model for OrderItem entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Represents a snapshot of a product at the time of purchase.
@JsonSerializable(includeIfNull: false)
class OrderItemModel extends Equatable {
  const OrderItemModel({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  /// Product ID reference
  @JsonKey(name: 'product_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String productId;

  /// Quantity ordered
  @JsonKey(fromJson: safeIntFromJson, toJson: safeIntToJson)
  final int quantity;

  /// Unit price at the time of purchase (snapshot)
  @JsonKey(name: 'unit_price', fromJson: safeDoubleFromJson, toJson: safeDoubleToJson)
  final double unitPrice;

  @override
  List<Object?> get props => [productId, quantity, unitPrice];

  /// Factory constructor using generated code from json_annotation
  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  /// Convert OrderItemModel to JSON for API requests.
  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  /// Convert OrderItemModel to domain OrderItem entity.
  OrderItem toDomain() {
    return OrderItem(
      productId: productId,
      quantity: quantity,
      unitPrice: unitPrice,
    );
  }

  /// Create OrderItemModel from domain OrderItem entity.
  factory OrderItemModel.fromDomain(OrderItem orderItem) {
    return OrderItemModel(
      productId: orderItem.productId,
      quantity: orderItem.quantity,
      unitPrice: orderItem.unitPrice,
    );
  }
}
