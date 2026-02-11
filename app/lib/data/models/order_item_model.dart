import 'package:frontend_otis/domain/entities/order_item.dart';

/// Data model for OrderItem with JSON mapping.
class OrderItemModel {
  final String productId;
  final int quantity;
  final double unitPrice;
  final String? productName;

  const OrderItemModel({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.productName,
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
      productName: json['product_name'] as String?,
    );
  }

  OrderItem toDomain() {
    return OrderItem(
      productId: productId,
      quantity: quantity,
      unitPrice: unitPrice,
      productName: productName,
    );
  }

  factory OrderItemModel.fromDomain(OrderItem orderItem) {
    return OrderItemModel(
      productId: orderItem.productId,
      quantity: orderItem.quantity,
      unitPrice: orderItem.unitPrice,
      productName: orderItem.productName,
    );
  }
}
