import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required int userId,
    required int productId,
    required int quantity,
  }) : super(userId: userId, productId: productId, quantity: quantity);

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      userId: json['user_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'product_id': productId, 'quantity': quantity};
  }
}
