// Interface for Product Repository (Domain Layer).
//
// Steps:
// 1. Define abstract class `ProductRepository`.
// 2. Methods: `getProducts`, `getProductDetail`, `search`, `filter`, `create`, `update`, `delete`.
// 3. Return types must be `Future<Either<Failure, Type>>`.

import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';

/// Abstract interface for Product data operations.
/// Defines the contract for product-related data access in the domain layer.
abstract class ProductRepository {
  /// Retrieves a paginated list of products with optional filtering.
  ///
  /// [filter] - Optional filter criteria for products
  /// [page] - Page number (1-indexed)
  /// [limit] - Number of items per page
  ///
  /// Returns [Either<Failure, ({List<Product> products, int totalCount, int totalPages, bool hasMore})>].
  Future<Either<Failure, ({List<Product> products, int totalCount, int totalPages, bool hasMore})>>
      getProductsWithMetadata({
    required ProductFilter filter,
    required int page,
    required int limit,
  });

  /// Retrieves a paginated list of products with optional filtering.
  /// Simpler method that returns just the products list.
  ///
  /// [filter] - Optional filter criteria for products
  /// [page] - Page number (1-indexed)
  /// [limit] - Number of items per page
  ///
  /// Returns [Either<Failure, List<Product>>].
  Future<Either<Failure, List<Product>>> getProducts({
    required ProductFilter filter,
    required int page,
    required int limit,
  });

  /// Retrieves a single product by its ID.
  ///
  /// [productId] - The unique identifier of the product
  ///
  /// Returns [Either<Failure, Product>] - Single product or failure
  Future<Either<Failure, Product>> getProductDetail({required String productId});

  /// Retrieves a paginated list of products for admin inventory management.
  ///
  /// Supports additional filtering by brand name and stock status
  /// beyond standard ProductFilter capabilities.
  ///
  /// [filter] - Admin filter containing base filter, brand name, and stock status
  /// [page] - Page number (1-indexed)
  /// [limit] - Number of items per page
  ///
  /// Returns [Either<Failure, ({List<Product> products, int totalCount, int totalPages, bool hasMore})>].
  Future<Either<Failure, ({List<Product> products, int totalCount, int totalPages, bool hasMore})>>
      getAdminProducts({
    required AdminProductFilter filter,
    required int page,
    required int limit,
  });

  /// Deletes a product by its ID.
  ///
  /// [productId] - The unique identifier of the product
  ///
  /// Returns [Either<Failure, bool>] - true if deletion was successful, or failure
  Future<Either<Failure, bool>> deleteProduct({required String productId});
}