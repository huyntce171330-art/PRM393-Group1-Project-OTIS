import 'package:equatable/equatable.dart';
import 'package:frontend_otis/domain/entities/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final double subtotal;
  final double vat;
  final double total;

  const CartLoaded({
    this.cartItems = const [],
    this.subtotal = 0,
    this.vat = 0,
    this.total = 0,
  });

  factory CartLoaded.fromItems(List<CartItem> items) {
    double subtotal = 0;
    for (var item in items) {
      subtotal += item.totalPrice;
    }
    final vat = subtotal * 0.07;
    final total = subtotal + vat;
    return CartLoaded(
      cartItems: items,
      subtotal: subtotal,
      vat: vat,
      total: total,
    );
  }

  @override
  List<Object?> get props => [cartItems, subtotal, vat, total];

  CartLoaded copyWith({List<CartItem>? cartItems}) {
    return CartLoaded.fromItems(cartItems ?? this.cartItems);
  }

  int get itemCount => cartItems.length;

  // Format currency helper
  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ';
  }
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}
