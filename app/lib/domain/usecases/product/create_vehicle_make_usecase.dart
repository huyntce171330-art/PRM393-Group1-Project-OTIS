// Use case for creating a new vehicle make.
//
// Use case pattern following Clean Architecture:
// 1. Input: name (required), logoUrl (optional)
// 2. Output: Either<Failure, VehicleMakeModel>
//
// Steps:
// 1. Call repository.createVehicleMake()
// 2. Return result

import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

/// Use case for creating a new vehicle make in the repository.
///
/// This use case creates a new vehicle make that can be used
/// for product creation and filtering.
class CreateVehicleMakeUsecase {
  /// The repository instance used for data operations.
  final ProductRepository productRepository;

  /// Creates a new instance of [CreateVehicleMakeUsecase].
  ///
  /// [productRepository] - The repository to create vehicle make in (required)
  const CreateVehicleMakeUsecase({required this.productRepository});

  /// Executes the use case to create a new vehicle make.
  ///
  /// [name] - The name of the vehicle make (required)
  /// [logoUrl] - Optional logo URL
  ///
  /// Returns:
  /// - [Right(VehicleMakeModel)] containing the created vehicle make on success
  /// - [Left(Failure)] with error details on failure
  ///
  /// Common failures:
  /// - [NetworkFailure] - No internet connection
  /// - [ServerFailure] - Server error (500, timeout, etc.)
  /// - [CacheFailure] - Local data access error
  Future<Either<Failure, VehicleMakeModel>> call({
    required String name,
    String? logoUrl,
  }) async {
    return await productRepository.createVehicleMake(
      name: name,
      logoUrl: logoUrl,
    );
  }
}
