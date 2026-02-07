// Filter parameters for product list pagination and search.
// Encapsulates pagination, search, and filter parameters when fetching product list.
//
// Features:
// - Pagination (page, limit)
// - Search by name/SKU (searchQuery)
// - Filter by category, brand, price range (categoryId, brandId, minPrice, maxPrice)
// - Sorting (sortBy, sortOrder)
//
// Examples:
// - page=1, limit=10 -> Fetch first 10 products
// - page=2, limit=10 -> Fetch next 10 products
// - searchQuery='Michelin' -> Search products containing 'Michelin'
// - categoryId='1', brandId='2' -> Filter by category and brand

import 'package:equatable/equatable.dart';

class ProductFilter with EquatableMixin {
  // Pagination parameters
  final int page;
  final int limit;

  // Search parameters
  final String? searchQuery;

  // Filter parameters
  final String? categoryId;
  final String? brandId;
  final String? vehicleMakeId;
  final double? minPrice;
  final double? maxPrice;

  // Sorting parameters
  final String? sortBy; // 'price', 'name', 'createdAt', 'stockQuantity'
  final bool sortAscending; // true = ASC, false = DESC

  const ProductFilter({
    this.page = 1,
    this.limit = 10,
    this.searchQuery,
    this.categoryId,
    this.brandId,
    this.vehicleMakeId,
    this.minPrice,
    this.maxPrice,
    this.sortBy,
    this.sortAscending = true,
  }) : assert(page >= 1, 'Page must be >= 1'),
       assert(limit >= 1, 'Limit must be >= 1'),
       assert(
         minPrice == null || maxPrice == null || minPrice <= maxPrice,
         'minPrice must be <= maxPrice',
       );

  @override
  List<Object?> get props => [
        page,
        limit,
        searchQuery,
        categoryId,
        brandId,
        vehicleMakeId,
        minPrice,
        maxPrice,
        sortBy,
        sortAscending,
      ];

  /// Check if any filter is active
  bool get hasFilters {
    return searchQuery != null ||
        categoryId != null ||
        brandId != null ||
        vehicleMakeId != null ||
        minPrice != null ||
        maxPrice != null ||
        sortBy != null;
  }

  /// Check if this is a search query (not just pagination)
  bool get isSearch => searchQuery != null && searchQuery!.isNotEmpty;

  /// Convert to query parameters for API/SQL request.
  /// Example: ProductFilter(page: 2, limit: 20, searchQuery: 'test') ->
  /// {'page': 2, 'limit': 20, 'search_query': 'test'}
  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{'page': page, 'limit': limit};

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      params['search_query'] = searchQuery;
    }
    if (categoryId != null) {
      params['category_id'] = categoryId;
    }
    if (brandId != null) {
      params['brand_id'] = brandId;
    }
    if (vehicleMakeId != null) {
      params['vehicle_make_id'] = vehicleMakeId;
    }
    if (minPrice != null) {
      params['min_price'] = minPrice;
    }
    if (maxPrice != null) {
      params['max_price'] = maxPrice;
    }
    if (sortBy != null) {
      params['sort_by'] = sortBy;
      params['sort_order'] = sortAscending ? 'ASC' : 'DESC';
    }

    return params;
  }

  /// Create a new filter with updated values.
  /// Use for pagination: copyWith(page: current.page + 1)
  /// or update search: copyWith(searchQuery: 'new query')
  ProductFilter copyWith({
    int? page,
    int? limit,
    String? searchQuery,
    String? categoryId,
    String? brandId,
    String? vehicleMakeId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    bool? sortAscending,
  }) {
    return ProductFilter(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      vehicleMakeId: vehicleMakeId ?? this.vehicleMakeId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  /// Create a new filter for search - reset to page 1
  ProductFilter withSearch(String query) {
    return copyWith(
      searchQuery: query,
      page: 1, // Reset to page 1 when searching
    );
  }

  /// Create a new filter for pagination - preserve search/filter
  ProductFilter withPage(int newPage) {
    return copyWith(page: newPage);
  }

  /// Clear all filters, preserve pagination
  ProductFilter clearFilters() {
    return ProductFilter(page: page, limit: limit);
  }

  /// Clear search query, preserve other filters
  ProductFilter clearSearch() {
    return copyWith(searchQuery: null);
  }

  @override
  String toString() {
    return 'ProductFilter('
        'page: $page, '
        'limit: $limit, '
        'searchQuery: ${searchQuery ?? 'null'}, '
        'categoryId: ${categoryId ?? 'null'}, '
        'brandId: ${brandId ?? 'null'}, '
        'vehicleMakeId: ${vehicleMakeId ?? 'null'}, '
        'minPrice: ${minPrice ?? 'null'}, '
        'maxPrice: ${maxPrice ?? 'null'}, '
        'sortBy: ${sortBy ?? 'null'}, '
        'sortAscending: $sortAscending'
        ')';
  }
}
