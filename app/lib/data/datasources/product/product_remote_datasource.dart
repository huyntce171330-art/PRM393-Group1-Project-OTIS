// Interface for Product Remote Data Source.
//
// This interface defines the contract for product data operations.
// It follows the repository pattern with pagination support.
//
// Steps:
// 1. Define `ProductRemoteDatasource`.
// 2. Methods: `getProducts`, `getProductDetail`, `createProduct`, `updateProduct`, `deleteProduct`.
//

import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/data/models/product_list_model.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';

/// Interface for Product data source operations.
/// Provides methods for CRUD operations with pagination support.
abstract class ProductRemoteDatasource {
  /// Retrieves a paginated list of products.
  ///
  /// [page] - The page number (1-indexed)
  /// [limit] - Number of items per page
  /// [filter] - Optional filter criteria including search query
  ///
  /// Returns [ProductListModel] containing products and pagination metadata.
  Future<ProductListModel> getProducts({
    required int page,
    required int limit,
    ProductFilter? filter,
  });

  /// Retrieves a single product by its ID.
  ///
  /// [productId] - The unique identifier of the product
  ///
  /// Returns [ProductModel] or null if not found.
  Future<ProductListModel> getProductDetail({required String productId});

  /// Creates a new product.
  ///
  /// [product] - The product data to create
  ///
  /// Returns created [ProductModel].
  Future<ProductModel> createProduct({required ProductModel product});

  /// Updates an existing product.
  ///
  /// [productId] - The product to update
  /// [product] - Updated product data
  ///
  /// Returns updated [ProductModel].
  Future<ProductListModel> updateProduct({
    required String productId,
    required ProductListModel product,
  });

  /// Deletes a product by its ID.
  ///
  /// [productId] - The product to delete
  ///
  /// Returns true if deletion was successful.
  Future<bool> deleteProduct({required String productId});

  /// Retrieves a paginated list of products for admin inventory management.
  ///
  /// Supports additional filtering by brand name and stock status.
  ///
  /// [page] - The page number (1-indexed)
  /// [limit] - Number of items per page
  /// [filter] - Admin filter containing brand name and stock status
  ///
  /// Returns [ProductListModel] containing products and pagination metadata.
  Future<ProductListModel> getAdminProducts({
    required int page,
    required int limit,
    AdminProductFilter? filter,
  });

  /// Retrieves a list of all brands.
  ///
  /// Returns list of [BrandModel].
  Future<List<BrandModel>> getBrands();

  /// Retrieves a list of all vehicle makes.
  ///
  /// Returns list of [VehicleMakeModel].
  Future<List<VehicleMakeModel>> getVehicleMakes();
}