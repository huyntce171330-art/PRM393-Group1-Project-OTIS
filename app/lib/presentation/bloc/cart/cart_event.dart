import 'package:equatable/equatable.dart';
import 'package:frontend_otis/domain/entities/cart_item.dart';
import 'package:frontend_otis/domain/entities/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {}

class AddProductToCartEvent extends CartEvent {
  final Product product;
  final int quantity;

  const AddProductToCartEvent({required this.product, required this.quantity});

  @override
  List<Object?> get props => [product, quantity];
}

class UpdateCartItemEvent extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateCartItemEvent({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final String productId;

  const RemoveFromCartEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ClearCartEvent extends CartEvent {}
