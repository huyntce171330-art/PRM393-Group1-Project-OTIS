// Use case to update a product.
//
// Steps:
// 1. Create `UpdateProductUsecase`.
// 2. Inject `ProductRepository`.
// 3. Call `repository.updateProduct(product)`.

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

/// Use case to update an existing product.
/// 
/// Calls the repository to update a product with the given ID.
class UpdateProductUsecase {
  final ProductRepository productRepository;

  UpdateProductUsecase({required this.productRepository});

  /// Executes the use case to update a product.
  ///
  /// [params] - Contains the product ID and updated product data
  ///
  /// Returns [Either<Failure, Product>] - Updated product entity or failure
  Future<Either<Failure, Product>> call(UpdateProductParams params) async {
    return await productRepository.updateProduct(
      productId: params.productId,
      product: params.product,
    );
  }
}

/// Parameters for UpdateProductUsecase
class UpdateProductParams extends Equatable {
  final String productId;
  final ProductModel product;

  const UpdateProductParams({
    required this.productId,
    required this.product,
  });

  @override
  List<Object?> get props => [productId, product];
}