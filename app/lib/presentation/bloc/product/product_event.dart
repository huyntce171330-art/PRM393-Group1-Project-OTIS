// Events for Product BLoC.
//
// Steps:
// 1. Define events: `GetProductsEvent`, `SearchProductsEvent`, `GetProductDetailEvent`.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';

part 'product_event.freezed.dart';

/// Events that can occur in the Product feature.
///
/// These events trigger state changes in the ProductBloc.
/// Use Freezed for immutable event classes.
///
/// Usage:
/// ```dart
/// on<GetProductsEvent>((event, emit) async {
///   emit(ProductState.loading());
///   final result = await getProductsUsecase(event.filter);
///   result.fold(
///     (failure) => emit(ProductState.error(message: failure.message)),
///     (products) => emit(ProductState.loaded(products: products)),
///   );
/// });
/// ```
@freezed
class ProductEvent with _$ProductEvent {
  /// Event to fetch a paginated list of products
  /// Use this for initial load, pagination, and applying filters
  const factory ProductEvent.getProducts({required ProductFilter filter}) =
      GetProductsEvent;

  /// Event to search products by query
  /// Automatically resets to page 1 and applies search query
  const factory ProductEvent.searchProducts({required String query}) =
      SearchProductsEvent;

  /// Event to clear search and reset to default filter
  const factory ProductEvent.clearSearch() = ClearSearchEvent;

  /// Event to fetch a single product by ID
  const factory ProductEvent.getProductDetail({required String id}) =
      GetProductDetailEvent;

  /// Event to refresh the product list
  /// Resets to page 1 and reloads data
  const factory ProductEvent.refreshProducts() = RefreshProductsEvent;
}
