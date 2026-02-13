import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/cart_item.dart';
import 'package:frontend_otis/domain/repositories/cart_repository.dart';

class AddProductToCartUsecase {
  final CartRepository cartRepository;

  AddProductToCartUsecase({required this.cartRepository});

  Future<Either<Failure, List<CartItem>>> call(
    String productId,
    int quantity,
  ) async {
    return await cartRepository.addToCart(productId, quantity);
  }
}
