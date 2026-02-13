import 'package:frontend_otis/data/models/cart_item_model.dart';

abstract class CartRemoteDatasource {
  Future<List<CartItemModel>> getCart();
  Future<List<CartItemModel>> addToCart(String productId, int quantity);
  Future<List<CartItemModel>> updateCartItem(String productId, int quantity);
  Future<List<CartItemModel>> removeFromCart(String productId);
  Future<void> clearCart();
}
