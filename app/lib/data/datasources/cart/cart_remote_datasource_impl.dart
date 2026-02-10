import 'package:frontend_otis/data/datasources/cart/cart_remote_datasource.dart';
import 'package:frontend_otis/data/models/cart_item_model.dart';
import 'package:frontend_otis/core/network/api_client.dart';

class CartRemoteDatasourceImpl implements CartRemoteDatasource {
  final ApiClient apiClient;

  CartRemoteDatasourceImpl({required this.apiClient});

  // Mock data to simulate backend response
  List<CartItemModel> _mockCart = [];

  @override
  Future<List<CartItemModel>> getCart() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCart;
  }

  @override
  Future<List<CartItemModel>> addToCart(String productId, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockCart.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      final existing = _mockCart[index];
      _mockCart[index] = CartItemModel(
        productId: productId,
        quantity: existing.quantity + quantity,
      );
    } else {
      _mockCart.add(CartItemModel(productId: productId, quantity: quantity));
    }
    return _mockCart;
  }

  @override
  Future<List<CartItemModel>> updateCartItem(
    String productId,
    int quantity,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockCart.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _mockCart.removeAt(index);
      } else {
        _mockCart[index] = CartItemModel(
          productId: productId,
          quantity: quantity,
        );
      }
    }
    return _mockCart;
  }

  @override
  Future<List<CartItemModel>> removeFromCart(String productId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockCart.removeWhere((item) => item.productId == productId);
    return _mockCart;
  }

  @override
  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockCart.clear();
  }
}
