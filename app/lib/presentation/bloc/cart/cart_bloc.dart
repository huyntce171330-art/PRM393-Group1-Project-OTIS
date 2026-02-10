import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/usecases/cart/add_product_to_cart_usecase.dart';
import 'package:frontend_otis/domain/usecases/cart/get_cart_usecase.dart';
import 'package:frontend_otis/domain/usecases/cart/update_cart_usecase.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_event.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_state.dart';
import 'package:frontend_otis/domain/usecases/cart/remove_from_cart_usecase.dart';
import 'package:frontend_otis/domain/usecases/cart/clear_cart_usecase.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUsecase getCartUsecase;
  final AddProductToCartUsecase addProductToCartUsecase;
  final UpdateCartUsecase updateCartUsecase;
  final RemoveFromCartUsecase removeFromCartUsecase;
  final ClearCartUsecase clearCartUsecase;

  CartBloc({
    required this.getCartUsecase,
    required this.addProductToCartUsecase,
    required this.updateCartUsecase,
    required this.removeFromCartUsecase,
    required this.clearCartUsecase,
  }) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddProductToCartEvent>(_onAddProductToCart);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await getCartUsecase();
    result.fold(
      (failure) => emit(CartError(message: _mapFailureToMessage(failure))),
      (cartItems) => emit(CartLoaded.fromItems(cartItems)),
    );
  }

  Future<void> _onAddProductToCart(
    AddProductToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await addProductToCartUsecase(
      event.product.id,
      event.quantity,
    );
    result.fold((failure) => emit(CartError(message: _mapFailureToMessage(failure))), (
      cartItems,
    ) {
      // Manually re-attach product details because the mock repo returns items without Product objects.
      // In a real app we would fetch fresh product details or have the backend return expanded items.
      // Here we optimistically attach the product we just added to the relevant item.
      final updatedItems = cartItems.map((item) {
        if (item.productId == event.product.id) {
          return item.copyWith(product: event.product);
        }
        // For other items, we might lose product info if we don't persist it.
        // Ideally we should merge with previous state items.
        if (state is CartLoaded) {
          final oldItem = (state as CartLoaded).cartItems.firstWhere(
            (old) => old.productId == item.productId,
            orElse: () =>
                item, // Fallback if not found (shouldn't happen for old items)
          );
          // If old item has product, use it.
          if (oldItem.product != null) {
            return item.copyWith(product: oldItem.product);
          }
        }
        return item;
      }).toList();

      emit(CartLoaded.fromItems(updatedItems));
    });
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await updateCartUsecase(event.productId, event.quantity);
    result.fold(
      (failure) => emit(CartError(message: _mapFailureToMessage(failure))),
      (cartItems) {
        // Merge with existing product data to avoid losing product details
        final updatedItems = cartItems.map((item) {
          if (state is CartLoaded) {
            final oldItem = (state as CartLoaded).cartItems.firstWhere(
              (old) => old.productId == item.productId,
              orElse: () => item,
            );
            if (oldItem.product != null) {
              return item.copyWith(product: oldItem.product);
            }
          }
          return item;
        }).toList();

        emit(CartLoaded.fromItems(updatedItems));
      },
    );
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await removeFromCartUsecase(event.productId);
    result.fold(
      (failure) => emit(CartError(message: _mapFailureToMessage(failure))),
      (cartItems) {
        // Merge with existing product data to avoid losing product details
        final updatedItems = cartItems.map((item) {
          if (state is CartLoaded) {
            final currentState = state as CartLoaded;
            try {
              final oldItem = currentState.cartItems.firstWhere(
                (old) => old.productId == item.productId,
              );
              if (oldItem.product != null) {
                return item.copyWith(product: oldItem.product);
              }
            } catch (_) {
              // Item might be new or not found, just ignore
            }
          }
          return item;
        }).toList();

        emit(CartLoaded.fromItems(updatedItems));
      },
    );
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await clearCartUsecase();
    result.fold(
      (failure) => emit(CartError(message: _mapFailureToMessage(failure))),
      (_) => emit(CartLoaded.fromItems([])),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Failure';
    } else if (failure is CacheFailure) {
      return 'Cache Failure';
    } else {
      return 'Unexpected Error';
    }
  }
}
