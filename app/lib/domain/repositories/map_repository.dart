// Interface for Map/Location Repository.
//
// Steps:
// 1. Define abstract class `MapRepository`.
// 2. Define methods for shop locations CRUD and map operations.
// 3. Return types must be `Future<Either<Failure, Type>>`.

import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/shop_location.dart';

/// Abstract interface for Map/Location data operations.
/// Defines the contract for shop location and map-related data access.
abstract class MapRepository {
  /// Retrieves all shop locations.
  ///
  /// Returns [Either<Failure, List<ShopLocation>>].
  Future<Either<Failure, List<ShopLocation>>> getShopLocations();

  /// Retrieves a single shop location by its ID.
  ///
  /// [shopId] - The unique identifier of the shop
  ///
  /// Returns [Either<Failure, ShopLocation>].
  Future<Either<Failure, ShopLocation>> getShopLocationById({
    required String shopId,
  });

  /// Creates a new shop location.
  ///
  /// [shopLocation] - The shop location data to create
  ///
  /// Returns [Either<Failure, ShopLocation>] - Created shop location or failure
  Future<Either<Failure, ShopLocation>> createShopLocation({
    required ShopLocation shopLocation,
  });

  /// Updates an existing shop location.
  ///
  /// [shopId] - The unique identifier of the shop to update
  /// [shopLocation] - The shop location data with updated values
  ///
  /// Returns [Either<Failure, ShopLocation>] - Updated shop location or failure
  Future<Either<Failure, ShopLocation>> updateShopLocation({
    required String shopId,
    required ShopLocation shopLocation,
  });

  /// Deletes a shop location by its ID (soft delete).
  ///
  /// [shopId] - The unique identifier of the shop
  ///
  /// Returns [Either<Failure, bool>] - true if deletion was successful, or failure
  Future<Either<Failure, bool>> deleteShopLocation({required String shopId});

  /// Restores a soft-deleted shop location.
  ///
  /// [shopId] - The unique identifier of the shop
  ///
  /// Returns [Either<Failure, bool>] - true if restore was successful, or failure
  Future<Either<Failure, bool>> restoreShopLocation({required String shopId});

  /// Permanently deletes a shop location from the database.
  ///
  /// [shopId] - The unique identifier of the shop
  ///
  /// Returns [Either<Failure, bool>] - true if deletion was successful, or failure
  Future<Either<Failure, bool>> permanentDeleteShopLocation({
    required String shopId,
  });

  /// Gets the current device location.
  ///
  /// Returns [Either<Failure, ({double latitude, double longitude})>].
  Future<Either<Failure, ({double latitude, double longitude})>>
      getCurrentLocation();

  /// Gets route between two points.
  ///
  /// [startLat], [startLng] - Starting coordinates
  /// [endLat], [endLng] - Destination coordinates
  ///
  /// Returns [Either<Failure, List<({double lat, double lng})>>] - List of route points.
  Future<Either<Failure, List<({double lat, double lng})>>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  });
}
