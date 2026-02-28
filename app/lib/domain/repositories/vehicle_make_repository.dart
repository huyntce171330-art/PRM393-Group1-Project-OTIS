import 'package:fpdart/fpdart.dart';

import '../entities/vehicle_make.dart';
import '../../core/error/failures.dart';

abstract class VehicleMakeRepository {
  /// Get all vehicle makes
  Future<Either<Failure, List<VehicleMake>>> getAll();

  /// Get vehicle make by ID
  Future<Either<Failure, VehicleMake>> getById(String id);

  /// Create a new vehicle make
  Future<Either<Failure, Unit>> create(VehicleMake make);

  /// Update an existing vehicle make
  Future<Either<Failure, Unit>> update(VehicleMake make);

  /// Delete a vehicle make by ID
  Future<Either<Failure, Unit>> delete(String id);
}