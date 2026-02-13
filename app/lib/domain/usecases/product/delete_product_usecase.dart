// Use case to delete a product.
//
// Steps:
// 1. Create `DeleteProductUsecase`.
// 2. Inject `ProductRepository`.
// 3. Call `repository.deleteProduct(id)`.
//
// Returns:
// - true if deletion was successful
// - Failure if deletion failed
import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

/// Use case for deleting a product.
///
/// This use case handles the business logic for deleting products
/// and follows the Clean Architecture pattern.
///
/// Parameters:
/// - [productId]: The unique identifier of the product to delete
///
/// Returns:
/// - [Either<Failure, bool>]: true if successful, or a failure
class DeleteProductUsecase {
  /// The repository interface for product operations
  final ProductRepository productRepository;

  /// Creates a new DeleteProductUsecase instance.
  ///
  /// [productRepository]: The repository implementation to delete products from
  const DeleteProductUsecase({
    required this.productRepository,
  });

  /// Executes the use case to delete a product.
  ///
  /// [productId]: The unique identifier of the product to delete
  ///
  /// Returns a [Future] containing either a [Failure] or [true] if successful
  Future<Either<Failure, bool>> call(String productId) async {
    return productRepository.deleteProduct(productId: productId);
  }
}