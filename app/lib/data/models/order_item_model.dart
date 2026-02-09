import 'package:frontend_otis/domain/entities/order_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_item_model.g.dart';

/// Data model for OrderItem entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Represents a snapshot of a product at the time of purchase.
@JsonSerializable()
class OrderItemModel {
  const OrderItemModel({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  /// Product ID reference
  final String productId;

  /// Quantity ordered
  final int quantity;

  /// Unit price at the time of purchase (snapshot)
  final double unitPrice;

  /// Factory constructor to create OrderItemModel from JSON.
  /// Implements defensive parsing to handle null values and invalid data.
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: _parseProductId(json['product_id']),
      quantity: _parseInt(json['quantity'], defaultValue: 1),
      unitPrice: _parseDouble(json['unit_price'], defaultValue: 0.0),
    );
  }

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
}
