// Use case for fetching list of brands.
//
// Use case pattern following Clean Architecture:
// 1. Input: No parameters required
// 2. Output: Either<Failure, List<BrandModel>>
//
// Steps:
// 1. Call repository.getBrands()
// 2. Return result

import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

/// Use case for fetching all brands from the repository.
///
/// This use case retrieves a list of all available brands
/// which can be used for product creation and filtering.
class GetBrandsUsecase {
  /// The repository instance used for data operations.
  final ProductRepository productRepository;

  /// Creates a new instance of [GetBrandsUsecase].
  ///
  /// [productRepository] - The repository to fetch brands from (required)
  const GetBrandsUsecase({required this.productRepository});

  /// Executes the use case to fetch all brands.
  ///
  /// Returns:
  /// - [Right(List<BrandModel>)] containing list of brands on success
  /// - [Left(Failure)] with error details on failure
  ///
  /// Common failures:
  /// - [NetworkFailure] - No internet connection
  /// - [ServerFailure] - Server error (500, timeout, etc.)
  /// - [CacheFailure] - Local data access error
  Future<Either<Failure, List<BrandModel>>> call() async {
    return await productRepository.getBrands();
  }
}
