import 'package:equatable/equatable.dart';

/// Domain entity representing an order item in an order.
class OrderItem extends Equatable {
  final String productId;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  @override
  List<Object?> get props => [productId, quantity, unitPrice];

  OrderItem copyWith({String? productId, int? quantity, double? unitPrice}) {
    return OrderItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
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
