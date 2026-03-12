import 'package:fpdart/fpdart.dart';

import '../entities/tire_spec.dart';
import '../../core/error/failures.dart';

abstract class TireSpecRepository {
  /// Get all tire specifications
  Future<Either<Failure, List<TireSpec>>> getAll();

  /// Get tire specification by ID
  Future<Either<Failure, TireSpec>> getById(String id);

  /// Create a new tire specification
  Future<Either<Failure, Unit>> create(TireSpec spec);

  /// Update an existing tire specification
  Future<Either<Failure, Unit>> update(TireSpec spec);

  /// Delete a tire specification by ID
  Future<Either<Failure, Unit>> delete(String id);
}