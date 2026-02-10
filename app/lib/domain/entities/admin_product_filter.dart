// Admin-specific product filter entity for inventory management.
// Extends ProductFilter with brand and stock status filtering.
//
// Features:
// - Brand name filtering (Michelin, Bridgestone, etc.)
// - Stock status filtering (all, lowStock, outOfStock)
// - Wraps ProductFilter for pagination/search support
//
// Examples:
// - AdminProductFilter(brandName: 'Michelin', stockStatus: StockStatus.all)
// - AdminProductFilter(stockStatus: StockStatus.lowStock)
// - AdminProductFilter(brandName: 'Bridgestone') + ProductFilter(searchQuery: '205')

import 'package:equatable/equatable.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';

// Sentinel value to distinguish between "not provided" and "explicitly null"
class _Unset<T> {
  const _Unset();
  const _Unset._();
}

const _unset = _Unset._();

/// Stock status enumeration for filtering products.
enum StockStatus {
  /// Show all products regardless of stock level
  all,

  /// Show only products with low stock (1-10 units)
  lowStock,

  /// Show only products with zero stock
  outOfStock,
}

/// Extension for StockStatus to get display name and API value.
extension StockStatusExtension on StockStatus {
  /// Human-readable display name
  String get displayName {
    switch (this) {
      case StockStatus.all:
        return 'All';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
    }
  }

  /// API query parameter value
  String get queryValue {
    switch (this) {
      case StockStatus.all:
        return 'all';
      case StockStatus.lowStock:
        return 'low';
      case StockStatus.outOfStock:
        return 'out';
    }
  }
}

/// Admin-specific filter for product inventory management.
///
/// Combines ProductFilter's pagination/search capabilities with
/// admin-specific filtering: brand name and stock status.
class AdminProductFilter with EquatableMixin {
  /// Base filter for pagination, search, and general filtering
  final ProductFilter baseFilter;

  /// Filter by brand name (e.g., 'Michelin', 'Bridgestone')
  final String? brandName;

  /// Filter by stock status level
  final StockStatus stockStatus;

  /// Creates an AdminProductFilter.
  ///
  /// [baseFilter]: Base filter for pagination/search (defaults to default ProductFilter)
  /// [brandName]: Optional brand name filter
  /// [stockStatus]: Stock status filter (defaults to StockStatus.all)
  const AdminProductFilter({
    ProductFilter? baseFilter,
    this.brandName,
    this.stockStatus = StockStatus.all,
  }) : baseFilter = baseFilter ?? const ProductFilter();

  @override
  List<Object?> get props => [
        baseFilter,
        brandName,
        stockStatus,
      ];

  /// Check if any admin-specific filter is active
  bool get hasAdminFilters {
    return brandName != null || stockStatus != StockStatus.all;
  }

  /// Check if brand filter is active
  bool get hasBrandFilter => brandName != null && brandName!.isNotEmpty;

  /// Check if stock status filter is active (non-default)
  bool get hasStockStatusFilter => stockStatus != StockStatus.all;

  /// Get current page from base filter
  int get page => baseFilter.page;

  /// Get current limit from base filter
  int get limit => baseFilter.limit;

  /// Get search query from base filter
  String? get searchQuery => baseFilter.searchQuery;

  /// Create a copy with updated values.
  ///
  /// Uses _Unset sentinel to distinguish between "not provided" (keep current)
  /// and "explicitly null" (clear the field).
  AdminProductFilter copyWith({
    Object? baseFilter = _unset,
    Object? brandName = _unset,
    Object? stockStatus = _unset,
  }) {
    return AdminProductFilter(
      baseFilter: baseFilter == _unset
          ? this.baseFilter
          : baseFilter as ProductFilter?,
      brandName: brandName == _unset ? this.brandName : brandName as String?,
      stockStatus: stockStatus == _unset
          ? this.stockStatus
          : stockStatus as StockStatus,
    );
  }

  /// Create a copy with updated pagination.
  AdminProductFilter withPage(int newPage) {
    return copyWith(
      baseFilter: baseFilter.copyWith(page: newPage),
    );
  }

  /// Create a copy with updated search query.
  AdminProductFilter withSearch(String? query) {
    return copyWith(
      baseFilter: baseFilter.copyWith(searchQuery: query),
    );
  }

  /// Create a copy with cleared admin filters (preserve pagination/search).
  AdminProductFilter clearAdminFilters() {
    return AdminProductFilter(
      baseFilter: baseFilter,
      brandName: null,
      stockStatus: StockStatus.all,
    );
  }

  /// Create a copy with cleared brand filter.
  AdminProductFilter clearBrandFilter() {
    return copyWith(brandName: null);
  }

  /// Create a copy with cleared stock status filter.
  AdminProductFilter clearStockStatusFilter() {
    return copyWith(stockStatus: StockStatus.all);
  }

  /// Convert to query parameters for API request.
  ///
  /// Combines base filter params with admin-specific filters.
  Map<String, dynamic> toQueryParameters() {
    final params = baseFilter.toQueryParameters();

    // Add admin-specific filters
    if (brandName != null && brandName!.isNotEmpty) {
      params['brand_name'] = brandName;
    }

    if (stockStatus != StockStatus.all) {
      params['stock_status'] = stockStatus.queryValue;
    }

    return params;
  }

  @override
  String toString() {
    return 'AdminProductFilter('
        'baseFilter: $baseFilter, '
        'brandName: ${brandName ?? 'null'}, '
        'stockStatus: $stockStatus'
        ')';
  }
}
