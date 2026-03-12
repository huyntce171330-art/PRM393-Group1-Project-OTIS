import 'package:frontend_otis/domain/entities/shop_location.dart';

/// Data model for ShopLocation entity with JSON serialization support.
/// Handles conversion between JSON/API responses and domain entities.
class ShopLocationModel {
  const ShopLocationModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  /// Unique identifier for the shop location
  final String id;

  /// Shop name
  final String name;

  /// Shop phone number
  final String phone;

  /// Full address (street, district, city)
  final String address;

  /// Latitude coordinate
  final double latitude;

  /// Longitude coordinate
  final double longitude;

  /// URL to shop storefront image
  final String? imageUrl;

  /// Whether the shop is active
  final bool isActive;

  /// When the shop was created
  final DateTime createdAt;

  /// When the shop was last updated
  final DateTime? updatedAt;

  /// Convert ShopLocationModel to JSON for database/API requests.
  Map<String, dynamic> toJson() {
    return {
      'shop_id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Factory constructor to create ShopLocationModel from JSON.
  factory ShopLocationModel.fromJson(Map<String, dynamic> json) {
    return ShopLocationModel(
      id: _parseString(json['shop_id']),
      name: _parseString(json['name'], defaultValue: ''),
      phone: _parseString(json['phone'], defaultValue: ''),
      address: _parseString(json['address'], defaultValue: ''),
      latitude: _parseDouble(json['latitude'], defaultValue: 0.0),
      longitude: _parseDouble(json['longitude'], defaultValue: 0.0),
      imageUrl: _parseStringOrNull(json['image_url']),
      isActive: _parseBoolFromInt(json['is_active'], defaultValue: true),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTimeOrNull(json['updated_at']),
    );
  }

  /// Convert ShopLocationModel to domain ShopLocation entity.
  ShopLocation toDomain() {
    return ShopLocation(
      id: id,
      name: name,
      phone: phone,
      address: address,
      latitude: latitude,
      longitude: longitude,
      imageUrl: imageUrl,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create ShopLocationModel from domain ShopLocation entity.
  factory ShopLocationModel.fromDomain(ShopLocation shopLocation) {
    return ShopLocationModel(
      id: shopLocation.id,
      name: shopLocation.name,
      phone: shopLocation.phone,
      address: shopLocation.address,
      latitude: shopLocation.latitude,
      longitude: shopLocation.longitude,
      imageUrl: shopLocation.imageUrl,
      isActive: shopLocation.isActive,
      createdAt: shopLocation.createdAt,
      updatedAt: shopLocation.updatedAt,
    );
  }

  /// Parse string values with null safety and default values.
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value.trim();
    return value.toString().trim();
  }

  /// Parse string or null values.
  static String? _parseStringOrNull(dynamic value) {
    if (value == null) return null;
    if (value is String && value.trim().isEmpty) return null;
    return value.toString().trim();
  }

  /// Parse double values with null safety and default values.
  static double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value.trim());
      if (parsed != null) return parsed;
    }
    return defaultValue;
  }

  /// Parse boolean from INTEGER (0/1) stored in SQLite.
  static bool _parseBoolFromInt(dynamic value, {bool defaultValue = true}) {
    if (value == null) return defaultValue;
    if (value is int) return value == 1;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return defaultValue;
  }

  /// Parse DateTime values with null safety.
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
    return DateTime.now();
  }

  /// Parse DateTime or null values.
  static DateTime? _parseDateTimeOrNull(dynamic value) {
    if (value == null) return null;
    if (value is String && value.trim().isEmpty) return null;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
