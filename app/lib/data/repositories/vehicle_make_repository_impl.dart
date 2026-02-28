import 'package:fpdart/fpdart.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/vehicle_make.dart';
import '../../domain/repositories/vehicle_make_repository.dart';
import '../datasources/category/vehicle_make_datasource.dart';
import '../models/vehicle_make_model.dart';

class VehicleMakeRepositoryImpl implements VehicleMakeRepository {
  final VehicleMakeDataSource dataSource;

  VehicleMakeRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<VehicleMake>>> getAll() async {
    try {
      final models = await dataSource.getAll();
      final entities = models.map((e) => e.toDomain()).toList();
      return right(entities);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VehicleMake>> getById(String id) async {
    try {
      final model = await dataSource.getById(id);
      return right(model.toDomain());
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> create(VehicleMake make) async {
    try {
      await dataSource.create(
        VehicleMakeModel.fromDomain(make),
      );
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> update(VehicleMake make) async {
    try {
      await dataSource.update(
        VehicleMakeModel.fromDomain(make),
      );
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      await dataSource.delete(id);
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }
}