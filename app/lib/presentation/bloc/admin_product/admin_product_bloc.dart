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
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_event.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_state.dart';

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
  /// Use case for fetching paginated admin product list with brand/stock filters
  final GetAdminProductsUsecase getAdminProductsUsecase;

  /// Use case for fetching single product detail
  final GetProductDetailUsecase getProductDetailUsecase;

  /// Use case for deleting a product
  final DeleteProductUsecase deleteProductUsecase;

  /// Use case for creating a product
  final CreateProductUsecase createProductUsecase;

  /// Current filter state for pagination and filtering
  AdminProductFilter _currentFilter = const AdminProductFilter();

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
  AdminProductBloc({
    required this.getAdminProductsUsecase,
    required this.getProductDetailUsecase,
    required this.deleteProductUsecase,
    required this.createProductUsecase,
  }) : super(AdminProductState.initial()) {
    // Register event handlers
    _registerEventHandlers();
  }

  void _registerEventHandlers() {
    // Handle GetProductsEvent - Fetch paginated product list with admin filters
    on<GetAdminProductsEvent>((event, emit) async {
      print('=== DEBUG BLOC: GetAdminProductsEvent ===');
      print('DEBUG: event.filter: ${event.filter}');
      print('DEBUG: _currentFilter BEFORE: brandName=${_currentFilter.brandName}, stockStatus=${_currentFilter.stockStatus}');
      print('DEBUG: _cachedProducts count: ${_cachedProducts.length}');
      print('DEBUG: _cachedFilter: $_cachedFilter');
      print('DEBUG: state type: ${state.runtimeType}');

      // Check if we should use cached products (back navigation from detail)
      // Use cache if: event.filter is null AND we have cached products AND coming from detail state
      // OR: we have cached products AND _currentFilter is preserved (back navigation with filter)
      final useCache = event.filter == null &&
          _cachedProducts.isNotEmpty;

      print('DEBUG: useCache=$useCache');
      print('DEBUG: _cachedProducts.length=${_cachedProducts.length}');
      print('DEBUG: _cachedFilter?.brandName=${_cachedFilter?.brandName}');
      print('DEBUG: _currentFilter.brandName=${_currentFilter.brandName}');

      if (useCache) {
        print('DEBUG: USING CACHED PRODUCTS!');
        
        // If we have cachedFilter, restore it. Otherwise, use currentFilter.
        final filterToUse = _cachedFilter ?? _currentFilter;
        _currentFilter = filterToUse;
        _cachedFilter = null;  // Clear after use
        
        // Emit loaded state with cached products immediately (no API call!)
        emit(
          AdminProductState.loaded(
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

      print('DEBUG: _currentFilter AFTER: brandName=${_currentFilter.brandName}, stockStatus=${_currentFilter.stockStatus}');

      final filter = _currentFilter;
      final isLoadMore = filter.page > 1;

      // Preserve products when emitting loading state
      // This ensures UI shows cached products while reloading
      if (isLoadMore && state is AdminProductLoaded) {
        emit((state as AdminProductLoaded).copyWith(isLoadingMore: true));
      } else if (state is AdminProductLoaded) {
        // Keep showing current products while loading (don't clear!)
        emit((state as AdminProductLoaded).copyWith());
      } else {
        emit(AdminProductState.loading());
      }

      // Use getAdminProductsUsecase to support brandName and stockStatus filters
      final result = await getAdminProductsUsecase(filter);
      result.fold(
        (failure) {
          // On failure, emit error and reset loading more flag
          if (isLoadMore && state is AdminProductLoaded) {
            emit((state as AdminProductLoaded).copyWith(isLoadingMore: false));
          } else {
            emit(AdminProductState.error(message: failure.message));
          }
        },
        (metadata) {
          final hasMore = metadata.hasMore;
          final products = metadata.products;

          if (isLoadMore && state is AdminProductLoaded) {
            // APPEND products when loading more pages
            final currentState = state as AdminProductLoaded;
            final existingIds = currentState.products.map((p) => p.id).toSet();
            final newProducts =
                products.where((p) => !existingIds.contains(p.id)).toList();

            emit(currentState.copyWith(
              products: [...currentState.products, ...newProducts],
              filter: filter,
              selectedBrand: filter.brandName,
              stockStatus: filter.stockStatus,
              currentPage: filter.page,
              totalPages: metadata.totalPages,
              hasMore: hasMore,
              totalCount: metadata.totalCount,
              isLoadingMore: false,
            ));
          } else {
            // First page - replace products
            emit(
              AdminProductState.loaded(
                products: products,
                filter: filter,
                selectedBrand: filter.brandName,
                stockStatus: filter.stockStatus,
                currentPage: filter.page,
                totalPages: metadata.totalPages,
                hasMore: hasMore,
                totalCount: metadata.totalCount,
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
      print('DEBUG: _currentFilter BEFORE: brandName=${_currentFilter.brandName}');

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

      emit(AdminProductState.loading());
      print('DEBUG: Emitted loading state');

      // Use getAdminProductsUsecase to support brandName filter
      final result = await getAdminProductsUsecase(newFilter);
      print('DEBUG: Repository result: ${result.isRight() ? 'success' : 'failure'}');
      result.fold(
        (failure) => emit(AdminProductState.error(message: failure.message)),
        (metadata) {
          emit(
            AdminProductState.loaded(
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

      emit(AdminProductState.loading());

      // Use getAdminProductsUsecase to support stockStatus filter
      final result = await getAdminProductsUsecase(newFilter);
      result.fold(
        (failure) => emit(AdminProductState.error(message: failure.message)),
        (metadata) {
          emit(
            AdminProductState.loaded(
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

      emit(AdminProductState.loading());

      // Use getAdminProductsUsecase to preserve brand/stock filters
      final result = await getAdminProductsUsecase(searchFilter);
      result.fold(
        (failure) => emit(AdminProductState.error(message: failure.message)),
        (metadata) {
          emit(
            AdminProductState.loaded(
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

      emit(AdminProductState.loading());

      // Use getAdminProductsUsecase to preserve brand/stock filters
      final result = await getAdminProductsUsecase(clearedFilter);
      result.fold(
        (failure) => emit(AdminProductState.error(message: failure.message)),
        (metadata) {
          emit(
            AdminProductState.loaded(
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
        final result = await getAdminProductsUsecase(refreshFilter);
        result.fold(
          (failure) {
            // On failure, just clear refresh flag
            if (state is AdminProductLoaded) {
              emit((state as AdminProductLoaded).copyWith(isRefreshing: false));
            }
          },
          (metadata) {
            emit(
              AdminProductState.loaded(
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
        emit(AdminProductState.loading());

        // Use getAdminProductsUsecase to preserve brand/stock filters
        final result = await getAdminProductsUsecase(refreshFilter);
        result.fold(
          (failure) => emit(AdminProductState.error(message: failure.message)),
          (metadata) {
            emit(
              AdminProductState.loaded(
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
      // Emit deleting state
      emit(AdminProductState.deleting(productId: event.productId));

      final result = await deleteProductUsecase(event.productId);
      result.fold(
        (failure) {
          // Emit error state but stay on current page
          emit(AdminProductState.error(message: failure.message));
          // Re-emit loaded state to recover
          if (state is AdminProductDeleting) {
            final oldState = _getPreviousState();
            if (oldState != null) {
              emit(oldState);
            }
          }
        },
        (success) {
          // Emit deleted state briefly, then reload
          emit(AdminProductState.deleted(productId: event.productId));

          // Remove deleted product from current list
          if (state is AdminProductDeleted) {
            final deletedState = state as AdminProductDeleted;
            final currentState = _getPreviousState();
            if (currentState is AdminProductLoaded) {
              final updatedProducts = currentState.products
                  .where((p) => p.id != deletedState.productId)
                  .toList();

              emit(currentState.copyWith(
                products: updatedProducts,
                totalCount: updatedProducts.length,
              ));
            }
          }

          // Reload to refresh data
          add(RefreshAdminProductsEvent());
        },
      );
    });

    // Handle GetProductDetailEvent - Get single product details
    on<GetProductDetailEvent>((event, emit) async {
      print('=== DEBUG BLOC: GetProductDetailEvent ===');
      print('DEBUG: current state: ${state.runtimeType}');
      print('DEBUG: _currentFilter.brandName: ${_currentFilter.brandName}');
      
      // Cache current products and filter before navigating to detail
      // CRITICAL: Use _currentFilter (which preserves brand filter) NOT state.filter
      if (state is AdminProductLoaded) {
        final currentState = state as AdminProductLoaded;
        _cachedProducts = List<Product>.from(currentState.products);
        // Use _currentFilter to preserve the brand filter that user applied!
        _cachedFilter = _currentFilter;
        print('DEBUG: Cached ${_cachedProducts.length} products');
        print('DEBUG: Cached filter: brandName=${_cachedFilter?.brandName}');
      } else if (state is AdminProductDetailLoaded) {
        // Already in detail - don't clear cache, keep original List data
        print('DEBUG: Already in detail, keeping cache (brandName=${_cachedFilter?.brandName})');
      }

      // Emit loading state
      emit(AdminProductState.detailLoading());

      final result = await getProductDetailUsecase(event.productId);
      result.fold(
        (failure) => emit(AdminProductState.error(message: failure.message)),
        (product) {
          print('DEBUG: Detail loaded for product: ${product.id}');
          emit(AdminProductState.detailLoaded(product: product));
        },
      );
    });

    // Handle CreateProductEvent - Create a new product
    on<CreateProductEvent>((event, emit) async {
      print('=== DEBUG BLOC: CreateProductEvent ===');
      print('DEBUG: product.name: ${event.product.name}');
      print('DEBUG: product.sku: ${event.product.sku}');

      // Emit creating state
      emit(AdminProductState.creating());

      // Use createProductUsecase to create the product
      final result = await createProductUsecase(CreateProductParams(product: event.product));

      result.fold(
        (failure) {
          print('DEBUG: Create failed: ${failure.message}');
          emit(AdminProductState.createError(message: failure.message));
        },
        (product) {
          print('DEBUG: Product created successfully: ${product.id}');
          emit(AdminProductState.createSuccess(product: product));
        },
      );
    });
  }

  /// Get previous loaded state for recovery after errors
  AdminProductLoaded? _getPreviousState() {
    if (state is AdminProductLoaded) {
      return state as AdminProductLoaded;
    }
    return null;
  }

  /// Get current filter for pagination and filtering
  AdminProductFilter get currentFilter => _currentFilter;

  /// Get current search query (null if not searching)
  String? get currentSearchQuery => _currentFilter.searchQuery;

  /// Check if currently searching
  bool get isSearching =>
      _currentFilter.searchQuery != null && _currentFilter.searchQuery!.isNotEmpty;

  /// Check if any filters are active
  bool get hasFilters => _currentFilter.hasAdminFilters;

  /// Load first page with default filter
  void loadProducts() {
    add(const GetAdminProductsEvent(filter: null));
  }

  /// Filter by brand name (null = show all brands)
  void filterByBrand(String? brandName) {
    add(FilterByBrandEvent(brandName: brandName));
  }

  /// Filter by stock status
  void filterByStockStatus(StockStatus status) {
    add(FilterByStockStatusEvent(status: status));
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
}
