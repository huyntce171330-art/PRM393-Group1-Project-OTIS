// Use case to get list of products.
//
// Steps:
// 1. Create `GetProductsUsecase`.
// 2. Inject `ProductRepository`.
// 3. Call `repository.getProducts(filterParams)`.
//
// Architecture:
// - UseCase acts as a clean interface between Bloc and Repository
// - It encapsulates business logic (if any) before calling repository
// - Always returns `Either<Failure, List<Product>>` for error handling

import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

/// Use case for retrieving a paginated list of products.
///
/// This use case handles the business logic for fetching products
/// and follows the Clean Architecture pattern.
///
/// Parameters:
/// - [filter]: Filter criteria including pagination (page, limit)
///
/// Returns:
/// - [Either<Failure, List<Product>>]: List of products or a failure
///
/// Usage in Bloc:
/// ```dart
/// final result = await getProductsUsecase(filter);
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
class GetProductsUsecase {
  /// The repository interface for product operations
  final ProductRepository productRepository;

  /// Creates a new GetProductsUsecase instance.
  ///
  /// [productRepository]: The repository implementation to fetch products from
  const GetProductsUsecase({
    required this.productRepository,
  });

  /// Executes the use case to fetch products with metadata.
  ///
  /// [filter]: The filter criteria containing pagination parameters
  ///
  /// Returns a [Future] containing either a [Failure] or a tuple of
  /// (products, totalCount, totalPages, hasMore)
  Future<Either<Failure, ({List<Product> products, int totalCount, int totalPages, bool hasMore})>>
      call(ProductFilter filter) {
    // Delegate to repository with metadata
    return productRepository.getProductsWithMetadata(
      filter: filter,
      page: filter.page,
      limit: filter.limit,
    );
  }
}