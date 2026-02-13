// Use case for fetching list of vehicle makes.
//
// Use case pattern following Clean Architecture:
// 1. Input: No parameters required
// 2. Output: Either<Failure, List<VehicleMakeModel>>
//
// Steps:
// 1. Call repository.getVehicleMakes()
// 2. Return result

import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

/// Use case for fetching all vehicle makes from the repository.
///
/// This use case retrieves a list of all available vehicle makes
/// which can be used for product creation and filtering.
class GetVehicleMakesUsecase {
  /// The repository instance used for data operations.
  final ProductRepository productRepository;

  /// Creates a new instance of [GetVehicleMakesUsecase].
  ///
  /// [productRepository] - The repository to fetch vehicle makes from (required)
  const GetVehicleMakesUsecase({required this.productRepository});

  /// Executes the use case to fetch all vehicle makes.
  ///
  /// Returns:
  /// - [Right(List<VehicleMakeModel>)] containing list of vehicle makes on success
  /// - [Left(Failure)] with error details on failure
  ///
  /// Common failures:
  /// - [NetworkFailure] - No internet connection
  /// - [ServerFailure] - Server error (500, timeout, etc.)
  /// - [CacheFailure] - Local data access error
  Future<Either<Failure, List<VehicleMakeModel>>> call() async {
    return await productRepository.getVehicleMakes();
  }
}
