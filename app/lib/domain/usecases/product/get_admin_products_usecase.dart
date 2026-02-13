// Use case to get paginated admin products with brand and stock filters.
//
// Steps:
// 1. Create `GetAdminProductsUsecase`.
// 2. Inject `ProductRepository`.
// 3. Call `repository.getAdminProducts(filter)`.
//
// Architecture:
// - UseCase acts as a clean interface between Bloc and Repository
// - It encapsulates business logic (if any) before calling repository
// - Always returns `Either<Failure, List<Product>>` for error handling

import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

/// Use case for retrieving paginated admin products.
///
/// This use case handles the business logic for fetching products
/// for the admin inventory screen with support for:
/// - Brand name filtering
/// - Stock status filtering (all, low stock, out of stock)
/// - Pagination
/// - Search
///
/// Parameters:
/// - [filter]: Admin filter containing base filter, brand name, and stock status
///
/// Returns:
/// - [Either<Failure, ({List<Product> products, int totalCount, int totalPages, bool hasMore})>]
///
/// Usage in Bloc:
/// ```dart
/// final result = await getAdminProductsUsecase(filter);
/// result.fold(
///   (failure) => emit(ProductState.error(message: failure.message)),
///   (metadata) => emit(ProductState.loaded(
///     products: metadata.products,
///     totalCount: metadata.totalCount,
///     totalPages: metadata.totalPages,
///     hasMore: metadata.hasMore,
///   )),
/// );
/// ```
class GetAdminProductsUsecase {
  /// The repository interface for product operations
  final ProductRepository productRepository;

  /// Creates a new GetAdminProductsUsecase instance.
  ///
  /// [productRepository]: The repository implementation to fetch admin products from
  const GetAdminProductsUsecase({
    required this.productRepository,
  });

  /// Executes the use case to fetch admin products with metadata.
  ///
  /// [filter]: The admin filter criteria containing brand name, stock status, and pagination
  /// [showInactive]: Filter by active status: true=inactive only, false=active only, null=all
  ///
  /// Returns a [Future] containing either a [Failure] or a tuple of
  /// (products, totalCount, totalPages, hasMore)
  Future<Either<Failure, ({List<Product> products, int totalCount, int totalPages, bool hasMore})>>
      call(AdminProductFilter filter, {bool? showInactive}) {
    // Delegate to repository with admin filter
    return productRepository.getAdminProducts(
      filter: filter,
      page: filter.page,
      limit: filter.limit,
      showInactive: showInactive,
    );
  }
}
