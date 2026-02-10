import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCart();
  Future<Either<Failure, List<CartItem>>> addToCart(
    String productId,
    int quantity,
  );
  Future<Either<Failure, List<CartItem>>> updateCartItem(
    String productId,
    int quantity,
  );
  Future<Either<Failure, List<CartItem>>> removeFromCart(String productId);
  Future<Either<Failure, void>> clearCart();
}
