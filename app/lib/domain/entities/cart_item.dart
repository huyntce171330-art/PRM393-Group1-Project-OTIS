import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int userId;
  final int productId;
  final int quantity;

  const CartItem({
    required this.userId,
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [userId, productId, quantity];
}
