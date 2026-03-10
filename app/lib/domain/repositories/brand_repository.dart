import 'package:fpdart/fpdart.dart';

import '../entities/brand.dart';
import '../../core/error/failures.dart';

abstract class TireBrandRepository {
  /// Get all tire brands
  Future<Either<Failure, List<Brand>>> getAll();

  /// Get tire brand by ID
  Future<Either<Failure, Brand>> getById(String id);

  /// Create a new tire brand
  Future<Either<Failure, Unit>> create(Brand brand);

  /// Update an existing tire brand
  Future<Either<Failure, Unit>> update(Brand brand);

  /// Delete a tire brand by ID
  Future<Either<Failure, Unit>> delete(String id);
}