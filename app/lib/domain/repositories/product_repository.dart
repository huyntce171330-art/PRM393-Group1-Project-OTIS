// Interface for Product Repository (Domain Layer).
//
// Steps:
// 1. Define abstract class `ProductRepository`.
// 2. Methods: `getProducts`, `getProductDetail`, `search`, `filter`, `create`, `update`, `delete`.
// 3. Return types must be `Future<Either<Failure, Type>>`.

import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/data/models/tire_spec_model.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
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
  Future<
    Either<
      Failure,
      ({List<Product> products, int totalCount, int totalPages, bool hasMore})
    >
  >
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
  Future<Either<Failure, Product>> getProductDetail({
    required String productId,
  });

  /// Retrieves a paginated list of products for admin inventory management.
  ///
  /// Supports additional filtering by brand name and stock status
  /// beyond standard ProductFilter capabilities.
  ///
  /// [filter] - Admin filter containing base filter, brand name, and stock status
  /// [page] - Page number (1-indexed)
  /// [limit] - Number of items per page
  /// [showInactive] - Filter by active status: true=inactive only, false=active only, null=all
  ///
  /// Returns [Either<Failure, ({List<Product> products, int totalCount, int totalPages, bool hasMore})>].
  Future<
    Either<
      Failure,
      ({List<Product> products, int totalCount, int totalPages, bool hasMore})
    >
  >
  getAdminProducts({
    required AdminProductFilter filter,
    required int page,
    required int limit,
    bool? showInactive,
  });

  /// Deletes a product by its ID.
  ///
  /// [productId] - The unique identifier of the product
  ///
  /// Returns [Either<Failure, bool>] - true if deletion was successful, or failure
  Future<Either<Failure, bool>> deleteProduct({required String productId});

  /// Restores a soft-deleted product by setting is_active = 1.
  ///
  /// [productId] - The unique identifier of the product
  ///
  /// Returns [Either<Failure, bool>] - true if restore was successful, or failure
  Future<Either<Failure, bool>> restoreProduct({required String productId});

  /// Permanently deletes a product from the database.
  ///
  /// [productId] - The unique identifier of the product
  ///
  /// Returns [Either<Failure, bool>] - true if deletion was successful, or failure
  Future<Either<Failure, bool>> permanentDeleteProduct({
    required String productId,
  });

  /// Creates a new product.
  ///
  /// [product] - The product data to create (ProductModel)
  ///
  /// Returns [Either<Failure, Product>] - Created product domain entity or failure
  Future<Either<Failure, Product>> createProduct({
    required ProductModel product,
  });

  /// Updates an existing product.
  ///
  /// [productId] - The unique identifier of the product to update
  /// [product] - The product data with updated values
  ///
  /// Returns [Either<Failure, Product>] - Updated product domain entity or failure
  Future<Either<Failure, Product>> updateProduct({
    required String productId,
    required ProductModel product,
  });

  /// Retrieves a list of all brands.
  ///
  /// Returns [Either<Failure, List<BrandModel>>] - List of brands or failure
  Future<Either<Failure, List<BrandModel>>> getBrands();

  /// Retrieves a list of all vehicle makes.
  ///
  /// Returns [Either<Failure, List<VehicleMakeModel>>] - List of vehicle makes or failure
  Future<Either<Failure, List<VehicleMakeModel>>> getVehicleMakes();

  /// Creates a new vehicle make.
  ///
  /// [name] - The name of the vehicle make
  /// [logoUrl] - Optional logo URL
  ///
  /// Returns [Either<Failure, VehicleMakeModel>] - Created vehicle make or failure
  Future<Either<Failure, VehicleMakeModel>> createVehicleMake({
    required String name,
    String? logoUrl,
  });

  /// Retrieves a list of all distinct tire specifications for filter dropdowns.
  /// Returns distinct width, aspect_ratio, rim_diameter combinations.
  ///
  /// Returns [Either<Failure, List<TireSpecModel>>] - List of tire specs or failure
  Future<Either<Failure, List<TireSpecModel>>> getTireSpecs();
}
