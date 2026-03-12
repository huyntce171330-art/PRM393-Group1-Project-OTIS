// Implementation of Map Repository.
//
// Steps:
// 1. Implement `MapRepository`.
// 2. Inject `MapRemoteDatasource`.
// 3. All methods return Either<Failure, T>.

import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/exceptions.dart' as app_exceptions;
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/data/datasources/map/map_remote_datasource.dart';
import 'package:frontend_otis/data/models/shop_location_model.dart';
import 'package:frontend_otis/domain/entities/shop_location.dart';
import 'package:frontend_otis/domain/repositories/map_repository.dart';

/// Implementation of [MapRepository] using remote data source.
class MapRepositoryImpl implements MapRepository {
  final MapRemoteDatasource remoteDatasource;

  MapRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<ShopLocation>>> getShopLocations() async {
    try {
      final models = await remoteDatasource.getShopLocations();
      final entities = models.map((m) => m.toDomain()).toList();
      return Right(entities);
    } on app_exceptions.DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShopLocation>> getShopLocationById({
    required String shopId,
  }) async {
    try {
      final model = await remoteDatasource.getShopLocationById(shopId: shopId);
      return Right(model.toDomain());
    } on app_exceptions.DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShopLocation>> createShopLocation({
    required ShopLocation shopLocation,
  }) async {
    try {
      final model = ShopLocationModel.fromDomain(shopLocation);
      final created = await remoteDatasource.createShopLocation(shopLocation: model);
      return Right(created.toDomain());
    } on app_exceptions.DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShopLocation>> updateShopLocation({
    required String shopId,
    required ShopLocation shopLocation,
  }) async {
    try {
      final model = ShopLocationModel.fromDomain(shopLocation);
      final updated = await remoteDatasource.updateShopLocation(
        shopId: shopId,
        shopLocation: model,
      );
      return Right(updated.toDomain());
    } on app_exceptions.DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteShopLocation({
    required String shopId,
  }) async {
    try {
      final result = await remoteDatasource.deleteShopLocation(shopId: shopId);
      return Right(result);
    } on app_exceptions.DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> restoreShopLocation({
    required String shopId,
  }) async {
    try {
      final result = await remoteDatasource.restoreShopLocation(shopId: shopId);
      return Right(result);
    } on app_exceptions.DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> permanentDeleteShopLocation({
    required String shopId,
  }) async {
    try {
      final result = await remoteDatasource.permanentDeleteShopLocation(shopId: shopId);
      return Right(result);
    } on app_exceptions.DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({double latitude, double longitude})>>
      getCurrentLocation() async {
    try {
      final result = await remoteDatasource.getCurrentLocation();
      return Right(result);
    } catch (e) {
      return Left(LocationFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<({double lat, double lng})>>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    try {
      final result = await remoteDatasource.getRoute(
        startLat: startLat,
        startLng: startLng,
        endLat: endLat,
        endLng: endLng,
      );
      return Right(result);
    } catch (e) {
      return Left(LocationFailure(message: e.toString()));
    }
  }
}
