// Use case to restore a deleted product.
//
// Steps:
// 1. Create `RestoreProductUsecase`.
// 2. Inject `ProductRepository`.
// 3. Call `repository.restoreProduct(id)`.
//
// Returns:
// - true if restore was successful
// - Failure if restore failed

import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

/// Use case for restoring a deleted product.
///
/// This use case handles the business logic for restoring soft-deleted products
/// by setting is_active = 1.
///
/// Parameters:
/// - [productId]: The unique identifier of the product to restore
///
/// Returns:
/// - [Either<Failure, bool>]: true if successful, or a failure
class RestoreProductUsecase {
  /// The repository interface for product operations
  final ProductRepository productRepository;

  /// Creates a new RestoreProductUsecase instance.
  ///
  /// [productRepository]: The repository implementation to restore products from
  const RestoreProductUsecase({
    required this.productRepository,
  });

  /// Executes the use case to restore a product.
  ///
  /// [productId]: The unique identifier of the product to restore
  ///
  /// Returns a [Future] containing either a [Failure] or [true] if successful
  Future<Either<Failure, bool>> call(String productId) async {
    return productRepository.restoreProduct(productId: productId);
  }
}
