import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/exceptions.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/data/datasources/cart/cart_remote_datasource.dart';
import 'package:frontend_otis/domain/entities/cart_item.dart';
import 'package:frontend_otis/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDatasource cartRemoteDatasource;

  CartRepositoryImpl({required this.cartRemoteDatasource});

  @override
  Future<Either<Failure, List<CartItem>>> getCart() async {
    try {
      final cartModels = await cartRemoteDatasource.getCart();
      final cartItems = cartModels.map((e) => e.toDomain()).toList();
      return Right(cartItems);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> addToCart(
    String productId,
    int quantity,
  ) async {
    try {
      final cartModels = await cartRemoteDatasource.addToCart(
        productId,
        quantity,
      );
      final cartItems = cartModels.map((e) => e.toDomain()).toList();
      return Right(cartItems);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to add to cart'));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> updateCartItem(
    String productId,
    int quantity,
  ) async {
    try {
      final cartModels = await cartRemoteDatasource.updateCartItem(
        productId,
        quantity,
      );
      final cartItems = cartModels.map((e) => e.toDomain()).toList();
      return Right(cartItems);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to update cart'));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> removeFromCart(
    String productId,
  ) async {
    try {
      final cartModels = await cartRemoteDatasource.removeFromCart(productId);
      final cartItems = cartModels.map((e) => e.toDomain()).toList();
      return Right(cartItems);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Failed to remove from cart'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await cartRemoteDatasource.clearCart();
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
