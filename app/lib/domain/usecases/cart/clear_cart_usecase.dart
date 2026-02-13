import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/repositories/cart_repository.dart';

class ClearCartUsecase {
  final CartRepository cartRepository;

  const ClearCartUsecase(this.cartRepository);

  Future<Either<Failure, void>> call() {
    return cartRepository.clearCart();
  }
}
