// Use case to create a new product.
//
// Steps:
// 1. Create `CreateProductUsecase`.
// 2. Inject `ProductRepository`.
// 3. Call `repository.createProduct(productData)`.
//
import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

/// Parameters for creating a product.
/// Wraps the ProductModel to be created.
class CreateProductParams {
  /// The product data to create
  final ProductModel product;

  /// Creates a new CreateProductParams instance.
  const CreateProductParams({required this.product});
}

/// Use case for creating a new product.
///
/// This use case handles the business logic for creating a product:
/// - Validates input through repository
/// - Returns the created Product domain entity
/// - Handles errors appropriately
class CreateProductUsecase {
  /// Repository for product data operations
  final ProductRepository productRepository;

  /// Creates a new CreateProductUsecase instance.
  ///
  /// [productRepository]: The repository to use for creating products
  const CreateProductUsecase({required this.productRepository});

  /// Creates a new product.
  ///
  /// [params] - The parameters containing the product to create
  ///
  /// Returns [Either<Failure, Product>] - Created product or failure
  Future<Either<Failure, Product>> call(CreateProductParams params) async {
    print('=== DEBUG CreateProductUsecase ===');
    print('DEBUG: product.name: ${params.product.name}');
    print('DEBUG: product.sku: ${params.product.sku}');

    return await productRepository.createProduct(product: params.product);
  }
}
