// BLoC for Admin Product Inventory management.
//
// Features:
// - Fetch products with brand/stock status filters
// - Pagination support
// - Search functionality
// - Product deletion
//
// Steps:
// 1. Extend `Bloc<AdminProductEvent, AdminProductState>`.
// 2. Inject use cases.
// 3. Handle events: GetProducts, FilterByBrand, FilterByStockStatus, DeleteProduct.
//
// Architecture Flow:
// UI → AdminProductEvent → AdminProductBloc → UseCase → Repository → DataSource → UI

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/usecases/product/create_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/delete_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_admin_products_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/permanent_delete_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/restore_product_usecase.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_event.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_state.dart';

/// Filter status for showing active/inactive products
enum FilterStatus {
  active, // Show only active products (is_active = 1)
  inactive, // Show only inactive products (is_active = 0)
  all, // Show all products (no filter)
}

/// BLoC for managing Admin Product Inventory state and business logic.
///
/// Follows the Clean Architecture pattern:
/// - Receives events from UI
/// - Calls use cases for business logic
/// - Emits new states to UI
///
/// Dependency Injection:
/// All use cases are injected via constructor for testability.
class AdminProductBloc extends Bloc<AdminProductEvent, AdminProductState> {
  // Track the currently loading product ID to prevent duplicate calls
  String? _currentlyLoadingProductId;

  // Track the last loaded product ID
  String? _lastLoadedProductId;

  // ... existing code ...
  /// Use case for fetching paginated admin product list with brand/stock filters
  final GetAdminProductsUsecase getAdminProductsUsecase;

  /// Use case for fetching single product detail
  final GetProductDetailUsecase getProductDetailUsecase;

  /// Use case for deleting a product
  final DeleteProductUsecase deleteProductUsecase;

  /// Use case for creating a product
  final CreateProductUsecase createProductUsecase;

  /// Use case for restoring a deleted product
  final RestoreProductUsecase restoreProductUsecase;

  /// Use case for permanently deleting a product
  final PermanentDeleteProductUsecase permanentDeleteProductUsecase;

  /// Current filter state for pagination and filtering
  AdminProductFilter _currentFilter = const AdminProductFilter();

  /// Current showInactive filter status (default: active only)
  bool? _currentShowInactive = false;

  /// Cache for products when navigating to detail screen
  /// This preserves products so List screen can show cached data when back navigation
  List<Product> _cachedProducts = [];

  /// Cache for filter when navigating to detail screen
  AdminProductFilter? _cachedFilter;

  /// Creates a new AdminProductBloc instance.
  ///
  /// [getAdminProductsUsecase]: Required use case for fetching admin products
  /// [getProductDetailUsecase]: Required use case for fetching product details
  /// [deleteProductUsecase]: Required use case for deleting products
  /// [createProductUsecase]: Required use case for creating products
  /// [restoreProductUsecase]: Required use case for restoring deleted products
  /// [permanentDeleteProductUsecase]: Required use case for permanent deletion
  AdminProductBloc({
    required this.getAdminProductsUsecase,
    required this.getProductDetailUsecase,
    required this.deleteProductUsecase,
    required this.createProductUsecase,
    required this.restoreProductUsecase,
    required this.permanentDeleteProductUsecase,
  }) : super(const AdminProductInitial()) {
    // Register event handlers
    _registerEventHandlers();
  }

  void _registerEventHandlers() {
    // Handle GetProductsEvent - Fetch paginated product list with admin filters
    on<GetAdminProductsEvent>((event, emit) async {
      print('=== DEBUG BLOC: GetAdminProductsEvent ===');
      print('DEBUG: event.filter: ${event.filter}');
      print('DEBUG: event.showInactive: ${event.showInactive}');
      print(
        'DEBUG: _currentFilter BEFORE: brandName=${_currentFilter.brandName}, stockStatus=${_currentFilter.stockStatus}',
      );
      print('DEBUG: _currentShowInactive BEFORE: $_currentShowInactive');
      print('DEBUG: _cachedProducts count: ${_cachedProducts.length}');
      print('DEBUG: _cachedFilter: $_cachedFilter');
      print('DEBUG: state type: ${state.runtimeType}');

      // Check if we should use cached products (back navigation from detail)
      // Use cache if: event.filter is null AND we have cached products AND coming from detail state
      // OR: we have cached products AND _currentFilter is preserved (back navigation with filter)
      final useCache = event.filter == null && _cachedProducts.isNotEmpty;

      print('DEBUG: useCache=$useCache');
      print('DEBUG: _cachedProducts.length=${_cachedProducts.length}');
      print('DEBUG: _cachedFilter?.brandName=${_cachedFilter?.brandName}');
      print('DEBUG: _currentFilter.brandName=${_currentFilter.brandName}');

      if (useCache) {
        print('DEBUG: USING CACHED PRODUCTS!');

        // If we have cachedFilter, restore it. Otherwise, use currentFilter.
        final filterToUse = _cachedFilter ?? _currentFilter;
        _currentFilter = filterToUse;
        _cachedFilter = null; // Clear after use

        // Emit loaded state with cached products immediately (no API call!)
        emit(
          AdminProductLoaded(
            products: _cachedProducts,
            filter: filterToUse,
            selectedBrand: filterToUse.brandName,
            stockStatus: filterToUse.stockStatus,
            currentPage: 1,
            totalPages: (_cachedProducts.length / 10).ceil(),
            hasMore: _cachedProducts.length > 10,
            totalCount: _cachedProducts.length,
            isLoadingMore: false,
          ),
        );

        // Clear cache after using
        _cachedProducts = [];
        print('DEBUG: Cache cleared');
        return;
      }

      // Clear cache if not using it (e.g., normal app start)
      if (_cachedProducts.isNotEmpty) {
        print('DEBUG: Clearing unused cache');
        _cachedProducts = [];
        _cachedFilter = null;
      }

      // Preserve existing _currentFilter if event.filter is null
      // This fixes the bug where navigating back from Detail screen
      // would reset filters (brand, stock status, search)
      if (event.filter != null) {
        _currentFilter = event.filter!;
        print('DEBUG: Used event.filter');
      }
      // else: DO NOTHING - keep existing _currentFilter

      // Update showInactive if provided
      if (event.showInactive != null) {
        _currentShowInactive = event.showInactive;
        print('DEBUG: Updated _currentShowInactive to: $_currentShowInactive');
      }

      print(
        'DEBUG: _currentFilter AFTER: brandName=${_currentFilter.brandName}, stockStatus=${_currentFilter.stockStatus}',
      );
      print('DEBUG: _currentShowInactive AFTER: $_currentShowInactive');

      final filter = _currentFilter;
      final showInactive = _currentShowInactive;
      final isLoadMore = filter.page > 1;

      // Preserve products when emitting loading state
      // This ensures UI shows cached products while reloading
      if (isLoadMore && state is AdminProductLoaded) {
        emit((state as AdminProductLoaded).copyWith(isLoadingMore: true));
      } else if (state is AdminProductLoaded) {
        // Show refreshing state (keeps products in UI but adds loading indicator)
        emit((state as AdminProductLoaded).copyWith(isRefreshing: true));
      } else {
        emit(const AdminProductLoading());
      }

      // Use getAdminProductsUsecase to support brandName and stockStatus filters
      // Pass showInactive to filter by active status
      final result = await getAdminProductsUsecase(
        filter,
        showInactive: showInactive,
      );
      result.fold(
        (failure) {
          // On failure, emit error and reset loading more flag
          if (isLoadMore && state is AdminProductLoaded) {
            emit((state as AdminProductLoaded).copyWith(isLoadingMore: false));
          } else {
            emit(AdminProductError(message: failure.message));
          }
        },
        (metadata) {
          final hasMore = metadata.hasMore;
          final products = metadata.products;

          if (isLoadMore && state is AdminProductLoaded) {
            // APPEND products when loading more pages
            final currentState = state as AdminProductLoaded;
            final existingIds = currentState.products.map((p) => p.id).toSet();
            final newProducts = products
                .where((p) => !existingIds.contains(p.id))
                .toList();

            emit(
              currentState.copyWith(
                products: [...currentState.products, ...newProducts],
                filter: filter,
                selectedBrand: filter.brandName,
                stockStatus: filter.stockStatus,
                currentPage: filter.page,
                totalPages: metadata.totalPages,
                hasMore: hasMore,
                totalCount: metadata.totalCount,
                isLoadingMore: false,
                isRefreshing: false,
              ),
            );
          } else {
            // First page - replace products
            emit(
              AdminProductLoaded(
                products: products,
                filter: filter,
                selectedBrand: filter.brandName,
                stockStatus: filter.stockStatus,
                currentPage: filter.page,
                totalPages: metadata.totalPages,
                hasMore: hasMore,
                totalCount: metadata.totalCount,
                isRefreshing: false,
              ),
            );
          }
          _currentFilter = filter;
        },
      );
    });

    // Handle FilterByBrandEvent - Filter products by brand name
    on<FilterByBrandEvent>((event, emit) async {
      print('=== DEBUG BLOC: FilterByBrandEvent ===');
      print('DEBUG: event.brandName: ${event.brandName}');
      print(
        'DEBUG: _currentFilter BEFORE: brandName=${_currentFilter.brandName}',
      );

      // Create new filter with brand, reset to page 1
      // If brandName is null, explicitly clear the brand filter
      final newFilter = event.brandName == null
          ? _currentFilter.clearBrandFilter()
          : _currentFilter.copyWith(
              brandName: event.brandName,
              baseFilter: _currentFilter.baseFilter.copyWith(page: 1),
            );

      print('DEBUG: newFilter.brandName: ${newFilter.brandName}');
      print('DEBUG: newFilter.stockStatus: ${newFilter.stockStatus}');

      _currentFilter = newFilter;

      emit(const AdminProductLoading());
      print('DEBUG: Emitted loading state');

      // Use getAdminProductsUsecase to support brandName filter
      // Preserve current showInactive filter
      final result = await getAdminProductsUsecase(
        newFilter,
        showInactive: _currentShowInactive,
      );
      print(
        'DEBUG: Repository result: ${result.isRight() ? 'success' : 'failure'}',
      );
      result.fold(
        (failure) => emit(AdminProductError(message: failure.message)),
        (metadata) {
          emit(
            AdminProductLoaded(
              products: metadata.products,
              filter: newFilter,
              selectedBrand: newFilter.brandName,
              stockStatus: newFilter.stockStatus,
              currentPage: 1,
              totalPages: metadata.totalPages,
              hasMore: metadata.hasMore,
              totalCount: metadata.totalCount,
            ),
          );
        },
      );
    });

    // Handle FilterByStockStatusEvent - Filter products by stock status
    on<FilterByStockStatusEvent>((event, emit) async {
      // Create new filter with stock status, reset to page 1
      final newFilter = _currentFilter.copyWith(
        stockStatus: event.status,
        baseFilter: _currentFilter.baseFilter.copyWith(page: 1),
      );
      _currentFilter = newFilter;

      emit(const AdminProductLoading());

      // Use getAdminProductsUsecase to support stockStatus filter
      // Preserve current showInactive filter
      final result = await getAdminProductsUsecase(
        newFilter,
        showInactive: _currentShowInactive,
      );
      result.fold(
        (failure) => emit(AdminProductError(message: failure.message)),
        (metadata) {
          emit(
            AdminProductLoaded(
              products: metadata.products,
              filter: newFilter,
              selectedBrand: newFilter.brandName,
              stockStatus: newFilter.stockStatus,
              currentPage: 1,
              totalPages: metadata.totalPages,
              hasMore: metadata.hasMore,
              totalCount: metadata.totalCount,
            ),
          );
        },
      );
    });

    // Handle SearchAdminProductsEvent - Search products by query
    on<SearchAdminProductsEvent>((event, emit) async {
      // Create filter with search query, reset to page 1, preserve brand/stock
      final searchFilter = _currentFilter.withSearch(
        event.query.isEmpty ? null : event.query,
      );
      _currentFilter = searchFilter;

      emit(const AdminProductLoading());

      // Use getAdminProductsUsecase to preserve brand/stock filters
      // Preserve current showInactive filter
      final result = await getAdminProductsUsecase(
        searchFilter,
        showInactive: _currentShowInactive,
      );
      result.fold(
        (failure) => emit(AdminProductError(message: failure.message)),
        (metadata) {
          emit(
            AdminProductLoaded(
              products: metadata.products,
              filter: searchFilter,
              selectedBrand: searchFilter.brandName,
              stockStatus: searchFilter.stockStatus,
              currentPage: 1,
              totalPages: metadata.totalPages,
              hasMore: metadata.hasMore,
              totalCount: metadata.totalCount,
            ),
          );
        },
      );
    });

    // Handle ClearAdminSearchEvent - Clear search and reset
    on<ClearAdminSearchEvent>((event, emit) async {
      // Clear search query, preserve other filters
      final clearedFilter = _currentFilter.withSearch(null);
      _currentFilter = clearedFilter;

      emit(const AdminProductLoading());

      // Use getAdminProductsUsecase to preserve brand/stock filters
      // Preserve current showInactive filter
      final result = await getAdminProductsUsecase(
        clearedFilter,
        showInactive: _currentShowInactive,
      );
      result.fold(
        (failure) => emit(AdminProductError(message: failure.message)),
        (metadata) {
          emit(
            AdminProductLoaded(
              products: metadata.products,
              filter: clearedFilter,
              selectedBrand: clearedFilter.brandName,
              stockStatus: clearedFilter.stockStatus,
              currentPage: 1,
              totalPages: metadata.totalPages,
              hasMore: metadata.hasMore,
              totalCount: metadata.totalCount,
            ),
          );
        },
      );
    });

    // Handle RefreshAdminProductsEvent - Reset to page 1 and reload
    on<RefreshAdminProductsEvent>((event, emit) async {
      // Reset to page 1, keep other filters
      final refreshFilter = _currentFilter.withPage(1);
      _currentFilter = refreshFilter;

      if (event.silent) {
        // SILENT MODE: Keep showing current data, fetch in background
        if (state is AdminProductLoaded) {
          emit((state as AdminProductLoaded).copyWith(isRefreshing: true));
        }
        // Do NOT emit loading() - keeps current products visible

        // Use getAdminProductsUsecase to preserve brand/stock filters
        // Preserve current showInactive filter
        final result = await getAdminProductsUsecase(
          refreshFilter,
          showInactive: _currentShowInactive,
        );
        result.fold(
          (failure) {
            // On failure, just clear refresh flag
            if (state is AdminProductLoaded) {
              emit((state as AdminProductLoaded).copyWith(isRefreshing: false));
            }
          },
          (metadata) {
            emit(
              AdminProductLoaded(
                products: metadata.products,
                filter: refreshFilter,
                selectedBrand: refreshFilter.brandName,
                stockStatus: refreshFilter.stockStatus,
                currentPage: 1,
                totalPages: metadata.totalPages,
                hasMore: metadata.hasMore,
                totalCount: metadata.totalCount,
                isRefreshing: false,
              ),
            );
          },
        );
      } else {
        // NORMAL MODE: Show full loading spinner
        emit(const AdminProductLoading());

        // Use getAdminProductsUsecase to preserve brand/stock filters
        // Preserve current showInactive filter
        final result = await getAdminProductsUsecase(
          refreshFilter,
          showInactive: _currentShowInactive,
        );
        result.fold(
          (failure) => emit(AdminProductError(message: failure.message)),
          (metadata) {
            emit(
              AdminProductLoaded(
                products: metadata.products,
                filter: refreshFilter,
                selectedBrand: refreshFilter.brandName,
                stockStatus: refreshFilter.stockStatus,
                currentPage: 1,
                totalPages: metadata.totalPages,
                hasMore: metadata.hasMore,
                totalCount: metadata.totalCount,
              ),
            );
          },
        );
      }
    });

    // Handle DeleteProductEvent - Delete a product
    on<DeleteProductEvent>((event, emit) async {
      print('=== DEBUG BLOC: DeleteProductEvent ===');
      print('DEBUG: productId: ${event.productId}');

      // Capture current state for recovery
      final previousState = state;

      // Emit deleting state
      emit(AdminProductDeleting(productId: event.productId));
      print('DEBUG: Emitted deleting state');

      final result = await deleteProductUsecase(event.productId);
      print('DEBUG: deleteProductUsecase result: $result');

      result.fold(
        (failure) {
          // Emit error state but stay on current page
          emit(AdminProductError(message: failure.message));

          // recover previous state if possible
          if (previousState is AdminProductLoaded) {
            emit(previousState);
          }
        },
        (success) {
          // Emit deleted state briefly
          emit(AdminProductDeleted(productId: event.productId));
          print('DEBUG: Emitted deleted state');

          // Trigger a refresh of the list to ensure UI is in sync
          // This will emit Loading and then Loaded with updated counts
          add(const GetAdminProductsEvent());

          // Remove deleted product from current list in memory (optimistic update)
          if (previousState is AdminProductLoaded) {
            final updatedProducts = previousState.products
                .where((p) => p.id != event.productId)
                .toList();

            emit(
              previousState.copyWith(
                products: updatedProducts,
                totalCount: updatedProducts.length,
              ),
            );
          }
        },
      );
    });

    // Handle GetProductDetailEvent - Get single product details
    on<GetProductDetailEvent>((event, emit) async {
      print('=== DEBUG BLOC: GetProductDetailEvent ===');
      print('DEBUG: productId: ${event.productId}');
      print('DEBUG: current state: ${state.runtimeType}');
      print('DEBUG: _currentlyLoadingProductId: $_currentlyLoadingProductId');
      print('DEBUG: _lastLoadedProductId: $_lastLoadedProductId');

      // DEDUPLICATION: Skip if already loading or already loaded the same product
      if (_currentlyLoadingProductId == event.productId) {
        print('DEBUG: Skip - already loading product ${event.productId}');
        return;
      }

      if (_lastLoadedProductId == event.productId &&
          state is AdminProductDetailLoaded) {
        final currentDetail = (state as AdminProductDetailLoaded).product;
        if (currentDetail.id == event.productId) {
          print('DEBUG: Skip - product ${event.productId} already loaded');
          return;
        }
      }

      // Start loading this product
      _currentlyLoadingProductId = event.productId;

      // Cache current products and filter before navigating to detail
      if (state is AdminProductLoaded) {
        final currentState = state as AdminProductLoaded;
        _cachedProducts = List<Product>.from(currentState.products);
        _cachedFilter = _currentFilter;
        print('DEBUG: Cached ${_cachedProducts.length} products');
      } else if (state is AdminProductDetailLoaded) {
        print('DEBUG: Already in detail, keeping cache');
      }

      // Emit loading state
      emit(const AdminProductDetailLoading());

      final result = await getProductDetailUsecase(event.productId);

      // Clear loading flag
      _currentlyLoadingProductId = null;

      result.fold(
        (failure) {
          print('DEBUG: Detail load failed: ${failure.message}');
          emit(AdminProductError(message: failure.message));
        },
        (product) {
          print('DEBUG: Detail loaded successfully for product: ${product.id}');
          _lastLoadedProductId = product.id;
          emit(AdminProductDetailLoaded(product: product));
        },
      );
    });

    // Handle CreateProductEvent - Create a new product
    on<CreateProductEvent>((event, emit) async {
      print('=== DEBUG BLOC: CreateProductEvent ===');
      print('DEBUG: product.name: ${event.product.name}');
      print('DEBUG: product.sku: ${event.product.sku}');

      // Emit creating state
      emit(const AdminProductCreating());

      // Use createProductUsecase to create the product
      final result = await createProductUsecase(
        CreateProductParams(product: event.product),
      );

      result.fold(
        (failure) {
          print('DEBUG: Create failed: ${failure.message}');
          emit(AdminProductCreateError(message: failure.message));
        },
        (product) {
          print('DEBUG: Product created successfully: ${product.id}');
          emit(AdminProductCreateSuccess(product: product));
        },
      );
    });

    // Handle GetTrashProductsEvent - Get all deleted products
    on<GetTrashProductsEvent>((event, emit) async {
      print('=== DEBUG BLOC: GetTrashProductsEvent ===');

      // Emit loading state
      emit(const AdminProductLoading());

      // Use getAdminProductsUsecase with showInactive = true to get deleted products
      final result = await getAdminProductsUsecase(
        const AdminProductFilter(),
        showInactive: true,
      );

      result.fold(
        (failure) => emit(AdminProductError(message: failure.message)),
        (metadata) {
          print('DEBUG: Trash products loaded: ${metadata.products.length}');
          emit(
            AdminProductLoaded(
              products: metadata.products,
              filter: const AdminProductFilter(),
              selectedBrand: null,
              stockStatus: StockStatus.all,
              currentPage: 1,
              totalPages: metadata.totalPages,
              hasMore: metadata.hasMore,
              totalCount: metadata.totalCount,
            ),
          );
        },
      );
    });

    // Handle RestoreProductEvent - Restore a deleted product
    on<RestoreProductEvent>((event, emit) async {
      print('=== DEBUG BLOC: RestoreProductEvent ===');
      print('DEBUG: productId: ${event.productId}');

      // Capture current state for recovery
      final previousState = state;

      // Emit restoring state
      emit(AdminProductRestoring(productId: event.productId));

      final result = await restoreProductUsecase(event.productId);

      result.fold(
        (failure) {
          print('DEBUG: Restore failed: ${failure.message}');
          emit(AdminProductError(message: failure.message));

          // recover previous state if possible
          if (previousState is AdminProductLoaded) {
            emit(previousState);
          }
        },
        (success) {
          print('DEBUG: Product restored successfully');
          // Emit restored state briefly, then reload trash
          emit(AdminProductRestored(productId: event.productId));

          // Reload trash products
          add(const GetTrashProductsEvent());
        },
      );
    });

    // Handle PermanentDeleteProductEvent - Permanently delete a product
    on<PermanentDeleteProductEvent>((event, emit) async {
      print('=== DEBUG BLOC: PermanentDeleteProductEvent ===');
      print('DEBUG: productId: ${event.productId}');

      // Capture current state for recovery
      final previousState = state;

      // Emit deleting state
      emit(AdminProductDeleting(productId: event.productId));

      final result = await permanentDeleteProductUsecase(event.productId);

      result.fold(
        (failure) {
          print('DEBUG: Permanent delete failed: ${failure.message}');
          emit(AdminProductError(message: failure.message));

          // recover previous state if possible
          if (previousState is AdminProductLoaded) {
            emit(previousState);
          }
        },
        (success) {
          print('DEBUG: Product permanently deleted');
          // Emit deleted state briefly, then reload trash
          emit(AdminProductDeleted(productId: event.productId));

          // Reload trash products
          add(const GetTrashProductsEvent());
        },
      );
    });
  }

  /// Get current filter for pagination and filtering
  AdminProductFilter get currentFilter => _currentFilter;

  /// Get current search query (null if not searching)
  String? get currentSearchQuery => _currentFilter.searchQuery;

  /// Check if currently searching
  bool get isSearching =>
      _currentFilter.searchQuery != null &&
      _currentFilter.searchQuery!.isNotEmpty;

  /// Check if any filters are active
  bool get hasFilters => _currentFilter.hasAdminFilters;

  /// Load first page with default filter (active only by default)
  void loadProducts() {
    // Default to showing active products only
    if (_currentShowInactive == null) {
      _currentShowInactive = false;
    }
    add(
      GetAdminProductsEvent(filter: null, showInactive: _currentShowInactive),
    );
  }

  /// Filter by brand name (null = show all brands)
  void filterByBrand(String? brandName) {
    add(FilterByBrandEvent(brandName: brandName));
  }

  /// Filter by stock status
  void filterByStockStatus(StockStatus status) {
    add(FilterByStockStatusEvent(status: status));
  }

  /// Filter by active status (show active, inactive, or all products)
  void filterByActiveStatus(FilterStatus status) {
    // Convert FilterStatus to showInactive parameter
    // active -> false (show active only)
    // inactive -> true (show inactive only)
    // all -> null (show all)
    bool? showInactive;
    switch (status) {
      case FilterStatus.active:
        showInactive = false;
        break;
      case FilterStatus.inactive:
        showInactive = true;
        break;
      case FilterStatus.all:
        showInactive = null;
        break;
    }
    // Reset to page 1 and reload with new filter
    final newFilter = _currentFilter.withPage(1);
    _currentFilter = newFilter;
    _currentShowInactive = showInactive;
    add(GetAdminProductsEvent(filter: newFilter, showInactive: showInactive));
  }

  /// Get current filter status
  FilterStatus get currentFilterStatus {
    if (_currentShowInactive == true) {
      return FilterStatus.inactive;
    } else if (_currentShowInactive == false) {
      return FilterStatus.active;
    } else {
      return FilterStatus.all;
    }
  }

  /// Search products by query (empty query clears search)
  void searchProducts(String query) {
    if (query.trim().isEmpty) {
      add(const ClearAdminSearchEvent());
    } else {
      add(SearchAdminProductsEvent(query: query.trim()));
    }
  }

  /// Clear search and reset to default
  void clearSearch() {
    add(const ClearAdminSearchEvent());
  }

  /// Refresh product list to first page
  void refresh() {
    add(const RefreshAdminProductsEvent(silent: false));
  }

  /// Silently refresh product list in background (no loading spinner)
  void silentRefresh() {
    add(const RefreshAdminProductsEvent(silent: true));
  }

  /// Load next page (pagination)
  void loadNextPage() {
    final nextPage = _currentFilter.page + 1;
    final nextFilter = _currentFilter.withPage(nextPage);
    add(GetAdminProductsEvent(filter: nextFilter));
  }

  /// Delete a product by ID
  void deleteProduct(String productId) {
    add(DeleteProductEvent(productId: productId));
  }

  /// Get product details by ID
  void getProductDetail(String productId) {
    add(GetProductDetailEvent(productId: productId));
  }

  /// Create a new product
  void createProduct(ProductModel product) {
    add(CreateProductEvent(product: product));
  }

  /// Load trash products (deleted products)
  void loadTrashProducts() {
    add(const GetTrashProductsEvent());
  }

  /// Restore a deleted product
  void restoreProduct(String productId) {
    add(RestoreProductEvent(productId: productId));
  }

  /// Permanently delete a product
  void permanentDeleteProduct(String productId) {
    add(PermanentDeleteProductEvent(productId: productId));
  }
}
