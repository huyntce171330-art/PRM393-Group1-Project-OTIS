import 'package:fpdart/fpdart.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/brand.dart';
import '../../domain/repositories/brand_repository.dart';
import '../datasources/category/brand_datasource.dart';
import '../models/brand_model.dart';

class TireBrandRepositoryImpl implements TireBrandRepository {
  final TireBrandDataSource dataSource;

  TireBrandRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Brand>>> getAll() async {
    try {
      final models = await dataSource.getAll();
      final entities = models.map((e) => e.toDomain()).toList();
      return right(entities);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Brand>> getById(String id) async {
    try {
      final model = await dataSource.getById(id);
      return right(model.toDomain());
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> create(Brand brand) async {
    try {
      await dataSource.create(
        BrandModel.fromDomain(brand),
      );
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> update(Brand brand) async {
    try {
      await dataSource.update(
        BrandModel.fromDomain(brand),
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