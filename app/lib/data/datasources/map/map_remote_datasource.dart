import 'package:frontend_otis/data/models/shop_location_model.dart';

/// Abstract interface for Map/Shop Location data operations.
/// Defines the contract for shop location data access in the data layer.
abstract class MapRemoteDatasource {
  /// Retrieves all shop locations.
  Future<List<ShopLocationModel>> getShopLocations();

  /// Retrieves a single shop location by its ID.
  Future<ShopLocationModel> getShopLocationById({required String shopId});

  /// Creates a new shop location.
  Future<ShopLocationModel> createShopLocation({
    required ShopLocationModel shopLocation,
  });

  /// Updates an existing shop location.
  Future<ShopLocationModel> updateShopLocation({
    required String shopId,
    required ShopLocationModel shopLocation,
  });

  /// Deletes a shop location by its ID (soft delete).
  Future<bool> deleteShopLocation({required String shopId});

  /// Restores a soft-deleted shop location.
  Future<bool> restoreShopLocation({required String shopId});

  /// Permanently deletes a shop location.
  Future<bool> permanentDeleteShopLocation({required String shopId});

  /// Gets the current device location.
  Future<({double latitude, double longitude})> getCurrentLocation();

  /// Gets route between two points (returns list of lat/lng points).
  Future<List<({double lat, double lng})>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  });
}
