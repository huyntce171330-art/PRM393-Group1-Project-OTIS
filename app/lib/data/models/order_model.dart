import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:frontend_otis/data/models/order_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

/// Data model for Order entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Uses explicitToJson: true to properly serialize nested order items.
@JsonSerializable(explicitToJson: true)
class OrderModel {
  const OrderModel({
    required this.id,
    required this.code,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.createdAt,
    required this.items,
  });

  /// Unique identifier for the order
  final String id;

  /// Order code (human-readable identifier)
  final String code;

  /// Total amount of the order
  final double totalAmount;

  /// Current status of the order
  @OrderStatusConverter()
  final OrderStatus status;

  /// Shipping address for the order
  final String shippingAddress;

  /// When the order was created
  final DateTime createdAt;

  /// List of order item models
  final List<OrderItemModel> items;

  /// Factory constructor to create OrderModel from JSON.
  /// Implements defensive parsing to handle null values and invalid data.
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: _parseOrderId(json['order_id']),
      code: _parseString(json['code'], defaultValue: ''),
      totalAmount: _parseDouble(json['total_amount'], defaultValue: 0.0),
      status: _parseOrderStatus(json['status']),
      shippingAddress: _parseString(json['shipping_address'], defaultValue: ''),
      createdAt: _parseDateTime(json['created_at']),
      items: _parseOrderItems(json['order_items'] ?? json['items'] ?? []),
    );
  }

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
    );
  }

  /// Parse order_id from JSON to String with defensive handling.
  static String _parseOrderId(dynamic value) {
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

  /// Parse string values with null safety and default values.
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;

    if (value is String) {
      return value.trim();
    }

    // Convert other types to string
    return value.toString().trim();
  }

  /// Parse double values with null safety and default values.
  static double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is String) {
      final parsed = double.tryParse(value.trim());
      if (parsed != null) {
        return parsed;
      }
    }

    // Fallback to default for unexpected types
    return defaultValue;
  }

  /// Parse order status from JSON to OrderStatus enum with defensive handling.
  static OrderStatus _parseOrderStatus(dynamic value) {
    if (value == null) return OrderStatus.pending; // Default to pending

    if (value is String) {
      return const OrderStatusConverter().fromJson(value);
    }

    // Default to pending for non-string values
    return OrderStatus.pending;
  }

  /// Parse order items from JSON array.
  static List<OrderItemModel> _parseOrderItems(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value.map((item) {
        if (item is Map<String, dynamic>) {
          return OrderItemModel.fromJson(item);
        }
        return null;
      }).whereType<OrderItemModel>().toList();
    }

    return [];
  }

  /// Parse created_at from JSON to DateTime with defensive handling.
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }

    // Fallback to current time for invalid date values
    return DateTime.now();
  }
}