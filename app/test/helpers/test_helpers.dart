/// Shared test utilities and helper functions for Product feature tests.
///
/// This module provides:
/// - Mock data factories for Product entities
/// - Mock data factories for ProductFilter
/// - Pagination metadata helpers
/// - Extension methods for product lists
library;

import 'package:frontend_otis/domain/entities/brand.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/domain/entities/tire_spec.dart';
import 'package:frontend_otis/domain/entities/vehicle_make.dart';

/// Creates a test Product with customizable fields.
///
/// Useful for generating test products with specific properties
/// without having to specify all fields each time.
///
/// Example:
/// ```dart
/// final product = TestProduct.create(
///   id: '123',
///   name: 'Test Tire',
///   price: 1500000.0,
/// );
/// ```
class TestProduct {
  /// Creates a new Product instance with default or overridden values.
  ///
  /// [id]: Unique identifier for the product (default: '1')
  /// [sku]: Product SKU (default: 'TEST-SKU-001')
  /// [name]: Product name (default: 'Test Product')
  /// [imageUrl]: Product image URL (default: '')
  /// [price]: Product price (default: 1000000.0)
  /// [stockQuantity]: Available stock quantity (default: 10)
  /// [isActive]: Whether product is active (default: true)
  /// [brand]: Product brand (default: null)
  /// [vehicleMake]: Compatible vehicle make (default: null)
  /// [tireSpec]: Tire specifications (default: null)
  /// [createdAt]: Creation date (default: DateTime(2024, 1, 1))
  static Product create({
    String id = '1',
    String sku = 'TEST-SKU-001',
    String name = 'Test Product',
    String imageUrl = '',
    double price = 1000000.0,
    int stockQuantity = 10,
    bool isActive = true,
    Brand? brand,
    VehicleMake? vehicleMake,
    TireSpec? tireSpec,
    DateTime? createdAt,
  }) {
    return Product(
      id: id,
      sku: sku,
      name: name,
      imageUrl: imageUrl,
      price: price,
      stockQuantity: stockQuantity,
      isActive: isActive,
      brand: brand,
      vehicleMake: vehicleMake,
      tireSpec: tireSpec,
      createdAt: createdAt ?? DateTime(2024, 1, 1),
    );
  }

  /// Creates a default test product (Michelin Primacy 4).
  static Product defaultProduct() {
    return create(
      id: '1',
      sku: 'SKU001',
      name: 'Michelin Primacy 4',
      imageUrl: 'https://example.com/tire1.jpg',
      price: 2450000.0,
      stockQuantity: 50,
      isActive: true,
      brand: const Brand(id: '1', name: 'Michelin', logoUrl: ''),
      vehicleMake: const VehicleMake(id: '1', name: 'Toyota', logoUrl: ''),
      tireSpec: const TireSpec(id: '1', width: 205, aspectRatio: 55, rimDiameter: 16),
      createdAt: DateTime(2024, 1, 15),
    );
  }

  /// Creates a second test product (Bridgestone Turanza).
  static Product secondProduct() {
    return create(
      id: '2',
      sku: 'SKU002',
      name: 'Bridgestone Turanza',
      imageUrl: 'https://example.com/tire2.jpg',
      price: 2100000.0,
      stockQuantity: 30,
      isActive: true,
      brand: const Brand(id: '2', name: 'Bridgestone', logoUrl: ''),
      vehicleMake: const VehicleMake(id: '2', name: 'Honda', logoUrl: ''),
      tireSpec: const TireSpec(id: '2', width: 195, aspectRatio: 65, rimDiameter: 15),
      createdAt: DateTime(2024, 1, 14),
    );
  }

  /// Creates an out-of-stock product.
  static Product outOfStock() {
    return create(
      id: 'out-of-stock',
      sku: 'OUT-OF-STOCK',
      name: 'Out of Stock Product',
      stockQuantity: 0,
    );
  }

  /// Creates a low stock product (less than 10 units).
  static Product lowStock() {
    return create(
      id: 'low-stock',
      sku: 'LOW-STOCK',
      name: 'Low Stock Product',
      stockQuantity: 5,
    );
  }

  /// Creates a product with a specific tire specification.
  static Product withTireSpec({
    required int width,
    required int aspectRatio,
    required int rimDiameter,
  }) {
    return create(
      tireSpec: TireSpec(
        id: 'spec-${width}-${aspectRatio}-${rimDiameter}',
        width: width,
        aspectRatio: aspectRatio,
        rimDiameter: rimDiameter,
      ),
    );
  }

  /// Creates a list of products with incrementing IDs.
  static List<Product> createMultiple({
    required int count,
    double startPrice = 1000000.0,
    int startStock = 10,
  }) {
    return List.generate(
      count,
      (index) => create(
        id: 'product-$index',
        sku: 'SKU-$index',
        name: 'Test Product $index',
        price: startPrice + (index * 100000),
        stockQuantity: startStock + index,
      ),
    );
  }
}

/// Creates a test ProductFilter with customizable fields.
///
/// Useful for generating test filters without having to specify
/// all fields each time.
///
/// Example:
/// ```dart
/// final filter = TestFilter.withSearch('michelin');
/// ```
class TestFilter {
  /// Creates a default ProductFilter (page 1, limit 10).
  static ProductFilter defaultFilter() {
    return const ProductFilter();
  }

  /// Creates a filter with pagination.
  static ProductFilter withPagination({
    required int page,
    int limit = 10,
  }) {
    return ProductFilter(page: page, limit: limit);
  }

  /// Creates a filter with search query.
  ///
  /// This automatically resets to page 1 as expected by the application.
  static ProductFilter withSearch(String query) {
    return ProductFilter(searchQuery: query);
  }

  /// Creates a filter with category.
  static ProductFilter withCategory(String categoryId) {
    return ProductFilter(categoryId: categoryId);
  }

  /// Creates a filter with brand.
  static ProductFilter withBrand(String brandId) {
    return ProductFilter(brandId: brandId);
  }

  /// Creates a filter with price range.
  static ProductFilter withPriceRange({
    required double minPrice,
    required double maxPrice,
  }) {
    return ProductFilter(minPrice: minPrice, maxPrice: maxPrice);
  }

  /// Creates a filter with sorting.
  static ProductFilter withSorting({
    required String sortBy,
    bool ascending = true,
  }) {
    return ProductFilter(sortBy: sortBy, sortAscending: ascending);
  }

  /// Creates a complex filter with multiple parameters.
  static ProductFilter complex({
    int page = 1,
    int limit = 20,
    String? searchQuery,
    String? categoryId,
    String? brandId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    bool sortAscending = true,
  }) {
    return ProductFilter(
      page: page,
      limit: limit,
      searchQuery: searchQuery,
      categoryId: categoryId,
      brandId: brandId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sortBy: sortBy,
      sortAscending: sortAscending,
    );
  }
}

/// Creates pagination metadata for testing.
///
/// Combines a list of products with pagination information.
///
/// Example:
/// ```dart
/// final metadata = TestPagination.metadata(
///   products: [product1, product2],
///   totalCount: 25,
///   hasMore: true,
/// );
/// ```
class TestPagination {
  /// Creates pagination metadata with products and metadata.
  static ({
    List<Product> products,
    int totalCount,
    int totalPages,
    bool hasMore,
  }) metadata({
    required List<Product> products,
    required int totalCount,
    bool hasMore = false,
  }) {
    final limit = products.isNotEmpty ? products.length : 10;
    final totalPages = (totalCount / limit).ceil();
    return (
      products: products,
      totalCount: totalCount,
      totalPages: totalPages,
      hasMore: hasMore,
    );
  }

  /// Creates pagination metadata for first page.
  static ({
    List<Product> products,
    int totalCount,
    int totalPages,
    bool hasMore,
  }) firstPage({
    required List<Product> products,
    int totalCount = 10,
    int limit = 10,
  }) {
    final hasMore = products.length < totalCount;
    return metadata(
      products: products,
      totalCount: totalCount,
      hasMore: hasMore,
    );
  }

  /// Creates pagination metadata for subsequent page.
  static ({
    List<Product> products,
    int totalCount,
    int totalPages,
    bool hasMore,
  }) nextPage({
    required List<Product> products,
    required int currentPage,
    required int totalCount,
    int limit = 10,
  }) {
    final hasMore = currentPage * limit < totalCount;
    return metadata(
      products: products,
      totalCount: totalCount,
      hasMore: hasMore,
    );
  }

  /// Creates empty pagination metadata.
  static ({
    List<Product> products,
    int totalCount,
    int totalPages,
    bool hasMore,
  }) empty() {
    return (
      products: <Product>[],
      totalCount: 0,
      totalPages: 1,
      hasMore: false,
    );
  }
}

/// Extension on List<Product> for common test operations.
extension ProductListTestExtensions on List<Product> {
  /// Returns the IDs of all products in the list.
  List<String> get ids => map((p) => p.id).toList();

  /// Returns the total stock quantity of all products.
  int get totalStock => fold(0, (sum, p) => sum + p.stockQuantity);

  /// Returns the total value of all products.
  double get totalValue => fold(0.0, (sum, p) => sum + p.price);

  /// Returns products that are in stock.
  List<Product> get inStock => where((p) => p.isInStock).toList();

  /// Returns products that are out of stock.
  List<Product> get outOfStock => where((p) => p.isOutOfStock).toList();

  /// Returns products with low stock (less than 10 units).
  List<Product> get lowStock => where((p) => p.isLowStock).toList();

  /// Checks if all products have unique IDs.
  bool get hasUniqueIds => ids.toSet().length == length;

  /// Checks if products are sorted by price ascending.
  bool get isSortedByPriceAscending {
    if (length <= 1) return true;
    for (int i = 0; i < length - 1; i++) {
      if (this[i].price > this[i + 1].price) return false;
    }
    return true;
  }

  /// Checks if products are sorted by price descending.
  bool get isSortedByPriceDescending {
    if (length <= 1) return true;
    for (int i = 0; i < length - 1; i++) {
      if (this[i].price < this[i + 1].price) return false;
    }
    return true;
  }
}
