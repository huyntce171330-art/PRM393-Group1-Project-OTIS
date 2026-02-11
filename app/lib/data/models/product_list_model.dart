import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_list_model.g.dart';

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
@JsonSerializable()
class ProductListModel extends Equatable {
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
  @JsonKey(name: 'data', fromJson: _productsFromJson)
  final List<ProductModel> products;

  /// Current page number (1-indexed)
  @JsonKey(fromJson: safeIntFromJson, toJson: safeIntToJson)
  final int page;

  /// Number of items per page
  @JsonKey(fromJson: safeIntFromJson, toJson: safeIntToJson)
  final int limit;

  /// Total number of products across all pages
  @JsonKey(fromJson: safeIntFromJson, toJson: safeIntToJson)
  final int total;

  /// Total number of pages available
  @JsonKey(fromJson: safeIntFromJson, toJson: safeIntToJson)
  final int totalPages;

  /// Whether there are more pages to load
  @JsonKey(fromJson: safeBoolFromJson, toJson: safeBoolToJson)
  final bool hasMore;

  @override
  List<Object?> get props => [products, page, limit, total, totalPages, hasMore];

  /// Convert products list from JSON with null safety
  static List<ProductModel> _productsFromJson(dynamic data) {
    if (data == null) return [];
    if (data is! List<dynamic>) return [];
    return data
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Factory constructor using generated code from json_annotation
  factory ProductListModel.fromJson(Map<String, dynamic> json) =>
      _$ProductListModelFromJson(json);

  /// Convert ProductListModel to JSON for API requests.
  Map<String, dynamic> toJson() => _$ProductListModelToJson(this);

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
