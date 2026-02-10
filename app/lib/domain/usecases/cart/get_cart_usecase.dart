import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/cart_item.dart';
import 'package:frontend_otis/domain/repositories/cart_repository.dart';

class GetCartUsecase {
  final CartRepository cartRepository;

  GetCartUsecase({required this.cartRepository});

  Future<Either<Failure, List<CartItem>>> call() async {
    return await cartRepository.getCart();
  }
}
