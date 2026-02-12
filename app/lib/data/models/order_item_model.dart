import 'package:frontend_otis/domain/entities/order_item.dart';

/// Data model for OrderItem with JSON mapping.
/// Updated to match Domain Entity (removed productName).
class OrderItemModel {
  final String productId;
  final int quantity;
  final double unitPrice;

  const OrderItemModel({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id']?.toString() ?? '',
      quantity: json['quantity'] as int? ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  OrderItem toDomain() {
    return OrderItem(
      productId: productId,
      quantity: quantity,
      unitPrice: unitPrice,
    );
  }

  factory OrderItemModel.fromDomain(OrderItem orderItem) {
    return OrderItemModel(
      productId: orderItem.productId,
      quantity: orderItem.quantity,
      unitPrice: orderItem.unitPrice,
    );
  }
}
