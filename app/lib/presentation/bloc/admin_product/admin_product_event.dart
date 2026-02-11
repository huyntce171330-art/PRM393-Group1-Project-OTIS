// Events for Admin Product Inventory management.
//
// Features:
// - Get products with admin-specific filters
// - Filter by brand name
// - Filter by stock status
// - Search products
// - Delete product
//
// Steps:
// 1. Define events: `GetAdminProductsEvent`, `FilterByBrandEvent`, etc.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';

part 'admin_product_event.freezed.dart';

/// Events that can occur in the Admin Product Inventory feature.
///
/// These events trigger state changes in the AdminProductBloc.
/// Use Freezed for immutable event classes.
///
/// Usage:
/// ```dart
/// on<GetAdminProductsEvent>((event, emit) async {
///   emit(AdminProductState.loading());
///   final result = await getAdminProductsUsecase(event.filter);
///   result.fold(
///     (failure) => emit(AdminProductState.error(message: failure.message)),
///     (metadata) => emit(AdminProductState.loaded(...)),
///   );
/// });
/// ```
@freezed
class AdminProductEvent with _$AdminProductEvent {
  /// Event to fetch a paginated list of products with admin filters
  /// Use this for initial load, pagination, and applying filters
  const factory AdminProductEvent.getProducts({
    AdminProductFilter? filter,
  }) = GetAdminProductsEvent;

  /// Event to filter products by brand name
  /// Resets to page 1 when applying new brand filter
  const factory AdminProductEvent.filterByBrand({
    required String? brandName,
  }) = FilterByBrandEvent;

  /// Event to filter products by stock status
  /// Resets to page 1 when applying new stock status filter
  const factory AdminProductEvent.filterByStockStatus({
    required StockStatus status,
  }) = FilterByStockStatusEvent;

  /// Event to search products by query
  /// Combines with current brand/stock filters
  const factory AdminProductEvent.searchProducts({
    required String query,
  }) = SearchAdminProductsEvent;

  /// Event to clear search query
  /// Preserves brand and stock filters
  const factory AdminProductEvent.clearSearch() = ClearAdminSearchEvent;

  /// Event to refresh the product list
  /// Resets to page 1, preserves filters
  /// [silent]: If true, refreshes in background without showing loading spinner
  const factory AdminProductEvent.refreshProducts({
    @Default(false) bool silent,
  }) = RefreshAdminProductsEvent;

  /// Event to delete a product by ID
  const factory AdminProductEvent.deleteProduct({
    required String productId,
  }) = DeleteProductEvent;

  /// Event to get product details by ID
  const factory AdminProductEvent.getProductDetail({
    required String productId,
  }) = GetProductDetailEvent;

  /// Event to create a new product
  /// Triggers product creation and returns success/error state
  const factory AdminProductEvent.createProduct({
    required ProductModel product,
  }) = CreateProductEvent;
}
