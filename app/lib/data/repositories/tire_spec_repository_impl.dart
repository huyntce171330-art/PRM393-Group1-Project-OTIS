import 'package:fpdart/fpdart.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/tire_spec.dart';
import '../../domain/repositories/tire_spec_repository.dart';
import '../datasources/category/tire_spec_datasource.dart';
import '../models/tire_spec_model.dart';

class TireSpecRepositoryImpl implements TireSpecRepository {
  final TireSpecDataSource dataSource;

  TireSpecRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<TireSpec>>> getAll() async {
    try {
      final models = await dataSource.getAll();
      final entities = models.map((e) => e.toDomain()).toList();
      return right(entities);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TireSpec>> getById(String id) async {
    try {
      final model = await dataSource.getById(id);
      return right(model.toDomain());
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> create(TireSpec spec) async {
    try {
      await dataSource.create(
        TireSpecModel.fromDomain(spec),
      );
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> update(TireSpec spec) async {
    try {
      await dataSource.update(
        TireSpecModel.fromDomain(spec),
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