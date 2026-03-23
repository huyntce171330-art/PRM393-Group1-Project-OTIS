import 'package:frontend_otis/core/error/exceptions.dart' as app_exceptions;
import 'package:frontend_otis/data/datasources/map/map_remote_datasource.dart';
import 'package:frontend_otis/data/models/shop_location_model.dart';
import 'package:sqflite/sqflite.dart';

/// Implementation of [MapRemoteDatasource] using SQLite database.
/// Handles all shop location-related database operations.
class MapRemoteDatasourceImpl implements MapRemoteDatasource {
  final Database database;

  MapRemoteDatasourceImpl({required this.database});

  @override
  Future<List<ShopLocationModel>> getShopLocations() async {
    try {
      final results = await database.query(
        'shop_locations',
        where: 'is_active = ?',
        whereArgs: [1],
        orderBy: 'created_at DESC',
      );
      return results.map((json) => ShopLocationModel.fromJson(json)).toList();
    } catch (e) {
      throw app_exceptions.DatabaseException('Failed to fetch shop locations: $e');
    }
  }

  @override
  Future<ShopLocationModel> getShopLocationById({required String shopId}) async {
    try {
      final results = await database.query(
        'shop_locations',
        where: 'shop_id = ?',
        whereArgs: [shopId],
      );
      if (results.isEmpty) {
        throw app_exceptions.DatabaseException('Shop location not found: $shopId');
      }
      return ShopLocationModel.fromJson(results.first);
    } catch (e) {
      if (e is app_exceptions.DatabaseException) rethrow;
      throw app_exceptions.DatabaseException('Failed to fetch shop location: $e');
    }
  }

  @override
  Future<ShopLocationModel> createShopLocation({
    required ShopLocationModel shopLocation,
  }) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();
      
      final newShop = ShopLocationModel(
        id: id,
        name: shopLocation.name,
        phone: shopLocation.phone,
        address: shopLocation.address,
        latitude: shopLocation.latitude,
        longitude: shopLocation.longitude,
        imageUrl: shopLocation.imageUrl,
        isActive: true,
        createdAt: now,
        updatedAt: null,
      );
      
      await database.insert('shop_locations', newShop.toJson());
      return newShop;
    } catch (e) {
      throw app_exceptions.DatabaseException('Failed to create shop location: $e');
    }
  }

  @override
  Future<ShopLocationModel> updateShopLocation({
    required String shopId,
    required ShopLocationModel shopLocation,
  }) async {
    try {
      final now = DateTime.now();
      
      final updatedShop = ShopLocationModel(
        id: shopId,
        name: shopLocation.name,
        phone: shopLocation.phone,
        address: shopLocation.address,
        latitude: shopLocation.latitude,
        longitude: shopLocation.longitude,
        imageUrl: shopLocation.imageUrl,
        isActive: shopLocation.isActive,
        createdAt: shopLocation.createdAt,
        updatedAt: now,
      );
      
      final count = await database.update(
        'shop_locations',
        updatedShop.toJson(),
        where: 'shop_id = ?',
        whereArgs: [shopId],
      );
      
      if (count == 0) {
        throw app_exceptions.DatabaseException('Shop location not found: $shopId');
      }
      return updatedShop;
    } catch (e) {
      if (e is app_exceptions.DatabaseException) rethrow;
      throw app_exceptions.DatabaseException('Failed to update shop location: $e');
    }
  }

  @override
  Future<bool> deleteShopLocation({required String shopId}) async {
    try {
      final count = await database.update(
        'shop_locations',
        {'is_active': 0},
        where: 'shop_id = ?',
        whereArgs: [shopId],
      );
      
      if (count == 0) {
        throw app_exceptions.DatabaseException('Shop location not found: $shopId');
      }
      return true;
    } catch (e) {
      if (e is app_exceptions.DatabaseException) rethrow;
      throw app_exceptions.DatabaseException('Failed to delete shop location: $e');
    }
  }

  @override
  Future<bool> restoreShopLocation({required String shopId}) async {
    try {
      final count = await database.update(
        'shop_locations',
        {'is_active': 1},
        where: 'shop_id = ?',
        whereArgs: [shopId],
      );
      
      if (count == 0) {
        throw app_exceptions.DatabaseException('Shop location not found: $shopId');
      }
      return true;
    } catch (e) {
      if (e is app_exceptions.DatabaseException) rethrow;
      throw app_exceptions.DatabaseException('Failed to restore shop location: $e');
    }
  }

  @override
  Future<bool> permanentDeleteShopLocation({required String shopId}) async {
    try {
      final count = await database.delete(
        'shop_locations',
        where: 'shop_id = ?',
        whereArgs: [shopId],
      );
      
      if (count == 0) {
        throw app_exceptions.DatabaseException('Shop location not found: $shopId');
      }
      return true;
    } catch (e) {
      if (e is app_exceptions.DatabaseException) rethrow;
      throw app_exceptions.DatabaseException('Failed to permanently delete shop location: $e');
    }
  }

  @override
  Future<({double latitude, double longitude})> getCurrentLocation() async {
    // TODO: Implement actual device location retrieval
    // This is a placeholder that returns a default location (Ho Chi Minh City)
    return (latitude: 10.8231, longitude: 106.6297);
  }

  @override
  Future<List<({double lat, double lng})>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    // TODO: Implement actual route calculation using Google Maps API
    // This returns a simple straight line path for demonstration
    return [
      (lat: startLat, lng: startLng),
      (lat: endLat, lng: endLng),
    ];
  }
}
