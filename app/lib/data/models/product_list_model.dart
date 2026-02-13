import 'dart:math';

import 'package:frontend_otis/data/models/product_model.dart';

/// Paginated response model for product list.
/// Wraps a list of products with pagination metadata from API responses.
///
/// Handles conversion between paginated JSON API responses and domain entities.
/// Provides metadata for client-side pagination (load more, infinite scroll).
///
/// JSON structure from API:
/// ```json
/// {
///   "data": [...products],
///   "page": 1,
///   "limit": 10,
///   "total": 100,
///   "total_pages": 10,
///   "has_more": true
/// }
/// ```
///
/// Usage:
/// ```dart
/// final response = await productDatasource.getProducts(page: 1, limit: 10);
/// final productList = ProductListModel.fromJson(response);
/// print('Page ${productList.page} of ${productList.totalPages}');
/// print('Has more: ${productList.hasMore}');
/// ```
class ProductListModel {
  const ProductListModel({
    required this.products,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasMore,
  });

  /// List of products in this page
  /// JSON key: 'data' (API response wraps products in 'data' field)
  final List<ProductModel> products;

  /// Current page number (1-indexed)
  final int page;

  /// Number of items per page
  final int limit;

  /// Total number of products across all pages
  final int total;

  /// Total number of pages available
  final int totalPages;

  /// Whether there are more pages to load
  final bool hasMore;

  /// Factory constructor to create ProductListModel from JSON.
  factory ProductListModel.fromJson(Map<String, dynamic> json) {
    return ProductListModel(
      products: _productsFromJson(json['data']),
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      total: json['total'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 0,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }

  /// Convert products list from JSON with null safety
  static List<ProductModel> _productsFromJson(dynamic data) {
    if (data == null) return [];
    if (data is! List<dynamic>) return [];
    return data
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Convert ProductListModel to domain ProductList entity.
  /// NOTE: Uncomment when ProductList entity is created
  // ProductList toDomain() {
  //   return ProductList(
  //     products: products.map((model) => model.toDomain()).toList(),
  //     page: page,
  //     limit: limit,
  //     total: total,
  //     totalPages: totalPages,
  //     hasMore: hasMore,
  //   );
  // }

  /// Check if there are more pages to load
  bool get canLoadMore => hasMore && page < totalPages;

  /// Get the next page number, or null if no more pages
  int? get nextPage => canLoadMore ? page + 1 : null;

  /// Get the range of products displayed (e.g., "1-10 of 100")
  String get productRange {
    final start = (page - 1) * limit + 1;
    final end = min(page * limit, total);
    return '$start-$end of $total';
  }
}
