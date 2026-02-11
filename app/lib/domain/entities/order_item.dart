import 'package:equatable/equatable.dart';

/// Domain entity representing an order item in an order.
class OrderItem extends Equatable {
  final String productId;
  final int quantity;
  final double unitPrice;
  final String? productName;

  const OrderItem({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.productName,
  });

  @override
  List<Object?> get props => [productId, quantity, unitPrice, productName];

  OrderItem copyWith({
    String? productId,
    int? quantity,
    double? unitPrice,
    String? productName,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      productName: productName ?? this.productName,
    );
  }

  double get totalPrice => unitPrice * quantity;

  String get formattedUnitPrice {
    return '${unitPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ';
  }

  String get formattedTotalPrice {
    return '${totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ';
  }

  bool get isValid => productId.isNotEmpty && quantity > 0 && unitPrice >= 0;
}
