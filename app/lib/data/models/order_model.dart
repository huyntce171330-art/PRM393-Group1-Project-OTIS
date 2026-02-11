import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:frontend_otis/data/models/order_item_model.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

/// Data model for Order entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Uses explicitToJson: true to properly serialize nested order items.
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class OrderModel extends Equatable {
  const OrderModel({
    required this.id,
    required this.code,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.createdAt,
    required this.items,
    this.userId,
  });

  /// Unique identifier for the order
  @JsonKey(name: 'order_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String id;

  /// Order code (human-readable identifier)
  @JsonKey(fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String code;

  /// Total amount of the order
  @JsonKey(name: 'total_amount', fromJson: safeDoubleFromJson, toJson: safeDoubleToJson)
  final double totalAmount;

  /// Current status of the order
  @JsonKey(fromJson: orderStatusFromJson, toJson: orderStatusToJson)
  final OrderStatus status;

  /// Shipping address for the order
  @JsonKey(name: 'shipping_address', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String shippingAddress;

  /// When the order was created
  @JsonKey(name: 'created_at', fromJson: safeDateTimeFromJson, toJson: safeDateTimeToJson)
  final DateTime createdAt;

  /// List of order item models
  final List<OrderItemModel> items;

  /// User ID who placed the order (optional)
  @JsonKey(name: 'user_id', fromJson: nullableSafeStringFromJson, toJson: nullableSafeStringToJson)
  final String? userId;

  @override
  List<Object?> get props => [
        id,
        code,
        totalAmount,
        status,
        shippingAddress,
        createdAt,
        items,
        userId,
      ];

  /// Factory constructor using generated code from json_annotation
  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  /// Convert OrderModel to JSON for API requests.
  /// explicitToJson: true ensures nested objects are properly serialized.
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  /// Convert OrderModel to domain Order entity.
  Order toDomain() {
    return Order(
      id: id,
      code: code,
      totalAmount: totalAmount,
      status: status,
      shippingAddress: shippingAddress,
      createdAt: createdAt,
      items: items.map((item) => item.toDomain()).toList(),
    );
  }

  /// Create OrderModel from domain Order entity.
  factory OrderModel.fromDomain(Order order) {
    return OrderModel(
      id: order.id,
      code: order.code,
      totalAmount: order.totalAmount,
      status: order.status,
      shippingAddress: order.shippingAddress,
      createdAt: order.createdAt,
      items: order.items.map((item) => OrderItemModel.fromDomain(item)).toList(),
      userId: null,
    );
  }
}
