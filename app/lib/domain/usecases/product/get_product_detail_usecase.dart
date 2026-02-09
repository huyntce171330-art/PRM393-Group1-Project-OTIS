// Use case to get product details.
//
// Steps:
// 1. Create `GetProductDetailUsecase`.
// 2. Inject `ProductRepository`.
// 3. Call `repository.getProductDetail(id)`.
//
// Architecture:
// - UseCase acts as a clean interface between Bloc and Repository
// - It encapsulates business logic (if any) before calling repository
// - Always returns `Either<Failure, Product>` for error handling

import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

/// Use case for retrieving a single product by ID.
///
/// This use case handles the business logic for fetching product details
/// and follows the Clean Architecture pattern.
///
/// Parameters:
/// - [productId]: The unique identifier of the product to fetch
///
/// Returns:
/// - [Either<Failure, Product>]: Single product or a failure
///
/// Usage in Bloc:
/// ```dart
/// final result = await getProductDetailUsecase(productId);
/// result.fold(
///   (failure) => emit(ProductState.error(message: failure.message)),
///   (product) => emit(ProductState.detailLoaded(product: product)),
/// );
/// ```
class GetProductDetailUsecase {
  /// The repository interface for product operations
  final ProductRepository productRepository;

  /// Creates a new GetProductDetailUsecase instance.
  ///
  /// [productRepository]: The repository implementation to fetch product details from
  const GetProductDetailUsecase({
    required this.productRepository,
  });

  /// Executes the use case to fetch a single product.
  ///
  /// [productId]: The unique identifier of the product to fetch
  ///
  /// Returns a [Future] containing either a [Failure] or a [Product]
  Future<Either<Failure, Product>> call(String productId) {
    return productRepository.getProductDetail(productId: productId);
  }
}