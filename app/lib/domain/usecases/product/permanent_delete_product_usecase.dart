// Use case to permanently delete a product.
//
// Steps:
// 1. Create `PermanentDeleteProductUsecase`.
// 2. Inject `ProductRepository`.
// 3. Call `repository.permanentDeleteProduct(id)`.
//
// Returns:
// - true if permanent deletion was successful
// - Failure if permanent deletion failed

import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

/// Use case for permanently deleting a product.
///
/// This use case handles the business logic for permanently removing a product
/// from the database. This is irreversible.
///
/// Parameters:
/// - [productId]: The unique identifier of the product to permanently delete
///
/// Returns:
/// - [Either<Failure, bool>]: true if successful, or a failure
class PermanentDeleteProductUsecase {
  /// The repository interface for product operations
  final ProductRepository productRepository;

  /// Creates a new PermanentDeleteProductUsecase instance.
  ///
  /// [productRepository]: The repository implementation to permanently delete products from
  const PermanentDeleteProductUsecase({
    required this.productRepository,
  });

  /// Executes the use case to permanently delete a product.
  ///
  /// [productId]: The unique identifier of the product to permanently delete
  ///
  /// Returns a [Future] containing either a [Failure] or [true] if successful
  Future<Either<Failure, bool>> call(String productId) async {
    return productRepository.permanentDeleteProduct(productId: productId);
  }
}
