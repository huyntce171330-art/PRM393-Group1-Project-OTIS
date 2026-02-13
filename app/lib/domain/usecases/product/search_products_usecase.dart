// Use case to search products.
//
// Steps:
// 1. Create `SearchProductsUsecase`.
// 2. Inject `ProductRepository`.
// 3. Call `repository.getProducts(filter)` with search query.
//
// This use case handles the business logic for searching products
// and follows the Clean Architecture pattern.
import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

/// Use case for searching products by query string.
///
/// This use case creates a filter with the search query and delegates
/// to the repository to fetch matching products.
///
/// Parameters:
/// - [query]: The search query string to match against product name or SKU
///
/// Returns:
/// - [Either<Failure, List<Product>>]: List of matching products or a failure
///
/// Usage in Bloc:
/// ```dart
/// final result = await searchProductsUsecase('michelin');
/// result.fold(
///   (failure) => emit(ProductState.error(message: failure.message)),
///   (products) => emit(ProductState.loaded(products: products)),
/// );
/// ```
class SearchProductsUsecase {
  /// The repository interface for product operations
  final ProductRepository productRepository;

  /// Creates a new SearchProductsUsecase instance.
  ///
  /// [productRepository]: The repository implementation to search products from
  const SearchProductsUsecase({
    required this.productRepository,
  });

  /// Executes the use case to search products.
  ///
  /// [query]: The search query string (will be trimmed)
  ///
  /// Returns a [Future] containing either a [Failure] or a list of [Product]
  Future<Either<Failure, List<Product>>> call(String query) async {
    // Create filter with search query, reset to page 1
    final trimmedQuery = query.trim();
    final filter = ProductFilter(
      searchQuery: trimmedQuery.isEmpty ? null : trimmedQuery,
      page: 1,
      limit: 20, // Larger limit for search results
    );

    // Delegate to repository with metadata and extract products list
    final result = await productRepository.getProductsWithMetadata(
      filter: filter,
      page: filter.page,
      limit: filter.limit,
    );

    // Extract products from metadata tuple
    return result.fold(
      (failure) => Left(failure),
      (metadata) => Right(metadata.products),
    );
  }
}
