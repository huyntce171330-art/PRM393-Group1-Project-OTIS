// BLoC for Product management.
//
// Steps:
// 1. Extend `Bloc<ProductEvent, ProductState>`.
// 2. Inject use cases.
// 3. Handle events: GetProductsEvent, SearchProductsEvent, GetProductDetailEvent.
//
// Architecture Flow:
// UI → ProductEvent → ProductBloc → UseCase → Repository → DataSource → UI

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_products_usecase.dart';
import 'package:frontend_otis/presentation/bloc/product/product_event.dart';
import 'package:frontend_otis/presentation/bloc/product/product_state.dart';

/// BLoC for managing Product state and business logic.
///
/// Follows the Clean Architecture pattern:
/// - Receives events from UI
/// - Calls use cases for business logic
/// - Emits new states to UI
///
/// Dependency Injection:
/// All use cases are injected via constructor for testability.
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  /// Use case for fetching paginated product list
  final GetProductsUsecase getProductsUsecase;

  /// Use case for fetching single product detail
  final GetProductDetailUsecase getProductDetailUsecase;

  /// Current filter state for pagination and search
  ProductFilter _currentFilter = const ProductFilter();

  /// Creates a new ProductBloc instance.
  ///
  /// [getProductsUsecase]: Required use case for fetching products
  /// [getProductDetailUsecase]: Required use case for fetching product detail
  ProductBloc({
    required this.getProductsUsecase,
    required this.getProductDetailUsecase,
  }) : super(const ProductInitial()) {
    // Register event handlers
    _registerEventHandlers();
  }

  void _registerEventHandlers() {
    // Handle GetProductsEvent - Fetch paginated product list with filters
    on<GetProductsEvent>((event, emit) async {
      // Track if this is a load more (page > 1)
      final isLoadMore = event.filter.page > 1;

      // Emit loading state - if load more, keep current products visible
      if (isLoadMore && state is ProductLoaded) {
        emit((state as ProductLoaded).copyWith(isLoadingMore: true));
      } else {
        emit(const ProductLoading());
      }
      _currentFilter = event.filter;

      final result = await getProductsUsecase(event.filter);
      result.fold(
        (failure) {
          // On failure, emit error and reset loading more flag
          if (isLoadMore && state is ProductLoaded) {
            emit((state as ProductLoaded).copyWith(isLoadingMore: false));
          } else {
            emit(ProductError(message: failure.message));
          }
        },
        (metadata) {
          // metadata contains: products, totalCount, totalPages, hasMore
          final hasMore = metadata.hasMore;
          final products = metadata.products;

          if (isLoadMore && state is ProductLoaded) {
            // APPEND products when loading more pages (FIX: Bug #1)
            final currentState = state as ProductLoaded;
            final existingIds = currentState.products.map((p) => p.id).toSet();
            final newProducts = products
                .where((p) => !existingIds.contains(p.id))
                .toList();

            emit(
              currentState.copyWith(
                products: [...currentState.products, ...newProducts],
                filter: event.filter,
                currentPage: event.filter.page,
                totalPages: metadata.totalPages,
                hasMore: hasMore,
                totalCount: metadata.totalCount,
                isLoadingMore: false,
              ),
            );
          } else {
            // First page - replace products
            emit(
              ProductLoaded(
                products: products,
                filter: event.filter,
                currentPage: event.filter.page,
                totalPages: metadata.totalPages,
                hasMore: hasMore,
                totalCount: metadata.totalCount,
              ),
            );
          }
        },
      );
    });

    // Handle SearchProductsEvent - Search products by query
    on<SearchProductsEvent>((event, emit) async {
      emit(const ProductLoading());

      // Create filter with search query, reset to page 1
      final searchFilter = _currentFilter.withSearch(event.query);
      _currentFilter = searchFilter;

      final result = await getProductsUsecase(searchFilter);
      result.fold((failure) => emit(ProductError(message: failure.message)), (
        metadata,
      ) {
        emit(
          ProductLoaded(
            products: metadata.products,
            filter: searchFilter,
            currentPage: 1,
            totalPages: metadata.totalPages,
            hasMore: metadata.hasMore,
            totalCount: metadata.totalCount,
          ),
        );
      });
    });

    // Handle ClearSearchEvent - Clear search and reset to default filter
    on<ClearSearchEvent>((event, emit) async {
      emit(const ProductLoading());

      // Clear search query but keep other filters if any
      final clearedFilter = _currentFilter.clearSearch();
      _currentFilter = clearedFilter;

      final result = await getProductsUsecase(clearedFilter);
      result.fold((failure) => emit(ProductError(message: failure.message)), (
        metadata,
      ) {
        emit(
          ProductLoaded(
            products: metadata.products,
            filter: clearedFilter,
            currentPage: 1,
            totalPages: metadata.totalPages,
            hasMore: metadata.hasMore,
            totalCount: metadata.totalCount,
          ),
        );
      });
    });

    // Handle RefreshProductsEvent - Reset to page 1 and reload
    on<RefreshProductsEvent>((event, emit) async {
      emit(const ProductLoading());

      // Reset to page 1, keep other filters
      final refreshFilter = _currentFilter.copyWith(page: 1);
      _currentFilter = refreshFilter;

      final result = await getProductsUsecase(refreshFilter);
      result.fold((failure) => emit(ProductError(message: failure.message)), (
        metadata,
      ) {
        emit(
          ProductLoaded(
            products: metadata.products,
            filter: refreshFilter,
            currentPage: 1,
            totalPages: metadata.totalPages,
            hasMore: metadata.hasMore,
            totalCount: metadata.totalCount,
          ),
        );
      });
    });

    // Handle GetProductDetailEvent - Fetch single product
    on<GetProductDetailEvent>((event, emit) async {
      // Capture current list state if available
      ProductLoaded? cachedState;
      if (state is ProductLoaded) {
        cachedState = state as ProductLoaded;
      } else if (state is ProductDetailLoaded) {
        cachedState = (state as ProductDetailLoaded).cachedState;
      }

      emit(const ProductLoading());

      final result = await getProductDetailUsecase(event.id);
      result.fold(
        (failure) => emit(ProductError(message: failure.message)),
        (product) => emit(
          ProductDetailLoaded(product: product, cachedState: cachedState),
        ),
      );
    });

    // Handle RestoreProductListEvent - Restore cached list state
    on<RestoreProductListEvent>((event, emit) {
      if (state is ProductDetailLoaded) {
        final cachedState = (state as ProductDetailLoaded).cachedState;
        if (cachedState != null) {
          emit(cachedState);
        } else {
          // Fallback to initial load if no cache
          add(const GetProductsEvent(filter: ProductFilter()));
        }
      }
    });
  }

  /// Get current filter for pagination and search
  ProductFilter get currentFilter => _currentFilter;

  /// Get current search query (null if not searching)
  String? get currentSearchQuery => _currentFilter.searchQuery;

  /// Check if currently searching
  bool get isSearching => _currentFilter.isSearch;

  /// Check if any filters are active
  bool get hasFilters => _currentFilter.hasFilters;

  /// Load first page with default filter
  void loadProducts() {
    add(const GetProductsEvent(filter: ProductFilter()));
  }

  /// Load products with custom filter
  void loadProductsWithFilter(ProductFilter filter) {
    add(GetProductsEvent(filter: filter));
  }

  /// Search products by query
  void searchProducts(String query) {
    if (query.trim().isEmpty) {
      // If empty query, clear search
      add(const ClearSearchEvent());
    } else {
      add(SearchProductsEvent(query: query.trim()));
    }
  }

  /// Clear search and reset to default
  void clearSearch() {
    add(const ClearSearchEvent());
  }

  /// Refresh product list to first page
  void refresh() {
    add(const RefreshProductsEvent());
  }

  /// Load next page (pagination)
  void loadNextPage() {
    final nextPage = _currentFilter.page + 1;
    final nextFilter = _currentFilter.withPage(nextPage);
    add(GetProductsEvent(filter: nextFilter));
  }

  /// Check if can load more pages (has more products)
  bool canLoadMore(List<dynamic> currentProducts) {
    // Check if current state has hasMore flag from metadata
    if (state is ProductLoaded) {
      return (state as ProductLoaded).hasMore;
    }
    // Fallback: if current products count >= limit, likely no more
    return currentProducts.length >= _currentFilter.limit;
  }

  /// Apply new filter and reload
  void applyFilter(ProductFilter filter) {
    _currentFilter = filter;
    add(GetProductsEvent(filter: filter));
  }

  /// Update sort and reload
  void sortBy({required String sortBy, bool ascending = true}) {
    final sortedFilter = _currentFilter.copyWith(
      sortBy: sortBy,
      sortAscending: ascending,
    );
    _currentFilter = sortedFilter;
    add(GetProductsEvent(filter: sortedFilter));
  }

  /// Clear all filters and reload
  void clearFilters() {
    final clearedFilter = _currentFilter.clearFilters();
    _currentFilter = clearedFilter;
    add(GetProductsEvent(filter: clearedFilter));
  }

  // #region DEBUG_LOGGING
  @override
  Future<void> close() async {
    print('🔍 DEBUG: ProductBloc.close() called - Stack trace:');
    try {
      throw Exception('ProductBloc.close() trace');
    } catch (e) {
      print(e.toString().split('\n').take(5).join('\n'));
    }
    await super.close();
  }

  // #endregion
}
