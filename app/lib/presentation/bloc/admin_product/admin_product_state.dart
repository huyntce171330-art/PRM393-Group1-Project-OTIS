// States for Admin Product Inventory management.
//
// Features:
// - Loading state during data fetch
// - Loaded state with products and filter info
// - Error state with message
// - Deletion in progress state
//
// Steps:
// 1. Define states: `AdminProductInitial`, `AdminProductLoading`, `AdminProductLoaded`, `AdminProductError`.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';
import 'package:frontend_otis/domain/entities/product.dart';

part 'admin_product_state.freezed.dart';

/// States for the Admin Product Inventory feature.
///
/// Use Freezed for immutable state classes.
/// Follows the pattern: Initial -> Loading -> Loaded/Error
///
/// Usage:
/// ```dart
/// BlocBuilder<AdminProductBloc, AdminProductState>(
///   builder: (context, state) {
///     return state.when(
///       initial: () => SizedBox.shrink(),
///       loading: () => CircularProgressIndicator(),
///       loaded: (products, filter, ...) => ProductListView(products: products),
///       error: (message) => ErrorWidget(message: message),
///     );
///   },
/// );
/// ```
@freezed
class AdminProductState with _$AdminProductState {
  const AdminProductState._();

  /// Initial state - no data loaded yet
  const factory AdminProductState.initial() = AdminProductInitial;

  /// Loading state - fetching data
  const factory AdminProductState.loading() = AdminProductLoading;

  /// Loaded state - data ready for display
  ///
  /// [products]: List of products to display
  /// [filter]: Current filter state
  /// [selectedBrand]: Currently selected brand filter (null = all)
  /// [stockStatus]: Currently selected stock status filter
  /// [currentPage]: Current page number (1-indexed)
  /// [totalPages]: Total number of pages
  /// [hasMore]: Whether there are more pages to load
  /// [totalCount]: Total number of products matching filters
  /// [isLoadingMore]: Whether more products are being loaded (pagination)
  /// [isRefreshing]: Whether list is being silently refreshed in background
  const factory AdminProductState.loaded({
    required List<Product> products,
    required AdminProductFilter filter,
    required String? selectedBrand,
    required StockStatus stockStatus,
    required int currentPage,
    required int totalPages,
    required bool hasMore,
    required int totalCount,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isRefreshing,
  }) = AdminProductLoaded;

  /// Error state - something went wrong
  const factory AdminProductState.error({
    required String message,
  }) = AdminProductError;

  /// Deletion in progress state
  const factory AdminProductState.deleting({
    required String productId,
  }) = AdminProductDeleting;

  /// Deletion success state
  const factory AdminProductState.deleted({
    required String productId,
  }) = AdminProductDeleted;

  /// Detail loading state - fetching single product details
  const factory AdminProductState.detailLoading() = AdminProductDetailLoading;

  /// Detail loaded state - single product ready for display
  const factory AdminProductState.detailLoaded({
    required Product product,
  }) = AdminProductDetailLoaded;

  /// Create product in progress state
  const factory AdminProductState.creating() = AdminProductCreating;

  /// Create product success state
  const factory AdminProductState.createSuccess({
    required Product product,
  }) = AdminProductCreateSuccess;

  /// Create product error state
  const factory AdminProductState.createError({
    required String message,
  }) = AdminProductCreateError;

  /// Restoring in progress state
  const factory AdminProductState.restoring({
    required String productId,
  }) = AdminProductRestoring;

  /// Restore success state
  const factory AdminProductState.restored({
    required String productId,
  }) = AdminProductRestored;

  /// Helper: Check if state is initial
  bool get isInitial => this is AdminProductInitial;

  /// Helper: Check if state is loading (initial load)
  bool get isLoading => this is AdminProductLoading;

  /// Helper: Check if state is loaded
  bool get isLoaded => this is AdminProductLoaded;

  /// Helper: Check if state is error
  bool get isError => this is AdminProductError;

  /// Helper: Check if currently deleting
  bool get isDeleting => this is AdminProductDeleting;

  /// Helper: Get products list (returns empty list if not loaded)
  List<Product> get products {
    return whenOrNull(
      loaded: (
        products,
        filter,
        selectedBrand,
        stockStatus,
        currentPage,
        totalPages,
        hasMore,
        totalCount,
        isLoadingMore,
        isRefreshing,
      ) =>
          products,
    ) ?? [];
  }

  /// Helper: Get error message (null if not error)
  String? get errorMessage {
    return whenOrNull(error: (message) => message);
  }

  /// Helper: Get current filter (null if not loaded)
  AdminProductFilter? get filter {
    return whenOrNull(
      loaded: (
        products,
        filter,
        selectedBrand,
        stockStatus,
        currentPage,
        totalPages,
        hasMore,
        totalCount,
        isLoadingMore,
        isRefreshing,
      ) =>
          filter,
    );
  }

  /// Helper: Get current page (1 if not loaded)
  int get currentPage {
    return whenOrNull(
      loaded: (
        products,
        filter,
        selectedBrand,
        stockStatus,
        currentPage,
        totalPages,
        hasMore,
        totalCount,
        isLoadingMore,
        isRefreshing,
      ) =>
          currentPage,
    ) ?? 1;
  }

  /// Helper: Get total count (0 if not loaded)
  int get totalCount {
    return whenOrNull(
      loaded: (
        products,
        filter,
        selectedBrand,
        stockStatus,
        currentPage,
        totalPages,
        hasMore,
        totalCount,
        isLoadingMore,
        isRefreshing,
      ) =>
          totalCount,
    ) ?? 0;
  }

  /// Helper: Get hasMore flag (false if not loaded)
  bool get hasMore {
    return whenOrNull(
      loaded: (
        products,
        filter,
        selectedBrand,
        stockStatus,
        currentPage,
        totalPages,
        hasMore,
        totalCount,
        isLoadingMore,
        isRefreshing,
      ) =>
          hasMore,
    ) ?? false;
  }

  /// Helper: Get isLoadingMore flag (false if not loaded)
  bool get isLoadingMore {
    return whenOrNull(
      loaded: (
        products,
        filter,
        selectedBrand,
        stockStatus,
        currentPage,
        totalPages,
        hasMore,
        totalCount,
        isLoadingMore,
        isRefreshing,
      ) =>
          isLoadingMore,
    ) ?? false;
  }

  /// Helper: Get isRefreshing flag (false if not loaded)
  bool get isRefreshing {
    return whenOrNull(
      loaded: (
        products,
        filter,
        selectedBrand,
        stockStatus,
        currentPage,
        totalPages,
        hasMore,
        totalCount,
        isLoadingMore,
        isRefreshing,
      ) =>
          isRefreshing,
    ) ?? false;
  }

  /// Helper: Get selected brand (null if not loaded)
  String? get selectedBrand {
    return whenOrNull(
      loaded: (
        products,
        filter,
        selectedBrand,
        stockStatus,
        currentPage,
        totalPages,
        hasMore,
        totalCount,
        isLoadingMore,
        isRefreshing,
      ) =>
          selectedBrand,
    );
  }

  /// Helper: Get stock status (all if not loaded)
  StockStatus get stockStatus {
    return whenOrNull(
      loaded: (
        products,
        filter,
        selectedBrand,
        stockStatus,
        currentPage,
        totalPages,
        hasMore,
        totalCount,
        isLoadingMore,
        isRefreshing,
      ) =>
          stockStatus,
    ) ?? StockStatus.all;
  }

  /// Helper: Check if any filter is active
  bool get hasActiveFilters {
    return whenOrNull(
      loaded: (
        products,
        filter,
        selectedBrand,
        stockStatus,
        currentPage,
        totalPages,
        hasMore,
        totalCount,
        isLoadingMore,
        isRefreshing,
      ) =>
          selectedBrand != null || stockStatus != StockStatus.all,
    ) ?? false;
  }

  /// Helper: Check if detail is loading
  bool get isDetailLoading => this is AdminProductDetailLoading;

  /// Helper: Check if detail is loaded
  bool get isDetailLoaded => this is AdminProductDetailLoaded;

  /// Helper: Get detail product (null if not loaded)
  Product? get detailProduct {
    return whenOrNull(detailLoaded: (product) => product);
  }

  /// Helper: Check if creating product
  bool get isCreating => this is AdminProductCreating;

  /// Helper: Check if create success
  bool get isCreateSuccess => this is AdminProductCreateSuccess;

  /// Helper: Check if create error
  bool get isCreateError => this is AdminProductCreateError;

  /// Helper: Get created product (null if not create success)
  Product? get createdProduct {
    return whenOrNull(createSuccess: (product) => product);
  }

  /// Helper: Get create error message (null if not create error)
  String? get createErrorMessage {
    return whenOrNull(createError: (message) => message);
  }

  /// Helper: Check if restoring
  bool get isRestoring => this is AdminProductRestoring;

  /// Helper: Check if restored
  bool get isRestored => this is AdminProductRestored;
}
