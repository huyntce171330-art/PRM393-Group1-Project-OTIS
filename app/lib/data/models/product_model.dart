import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
import 'package:frontend_otis/data/models/tire_spec_model.dart';

/// Data model for Product entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Implements defensive parsing for robustness.
class ProductModel {
  const ProductModel({
    required this.id,
    required this.sku,
    required this.name,
    required this.imageUrl,
    required this.brand,
    required this.vehicleMake,
    required this.tireSpec,
    required this.price,
    required this.stockQuantity,
    required this.isActive,
    required this.createdAt,
  });

  /// Unique identifier for the product
  final String id;

  /// Product SKU (Stock Keeping Unit)
  final String sku;

  /// Product name
  final String name;

  /// URL to product image
  final String imageUrl;

  /// Product brand model
  final BrandModel brand;

  /// Vehicle make model
  final VehicleMakeModel vehicleMake;

  /// Tire specification model
  final TireSpecModel tireSpec;

  /// Product price
  final double price;

  /// Available stock quantity
  final int stockQuantity;

  /// Whether the product is active/available
  /// SQLite stores as INTEGER (0/1) - converter handles the mapping
  final bool isActive;

  /// When the product was created
  final DateTime createdAt;

  /// Convert ProductModel to JSON for API requests.
  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'sku': sku,
      'name': name,
      'image_url': imageUrl,
      'brand': brand.toJson(),
      'vehicle_make': vehicleMake.toJson(),
      'tire_spec': tireSpec.toJson(),
      'price': price,
      'stock_quantity': stockQuantity,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Factory constructor to create ProductModel from JSON.
  /// Implements defensive parsing to handle null values and invalid data.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: _parseProductId(json['product_id']),
      sku: _parseString(json['sku'], defaultValue: ''),
      name: _parseString(json['name'], defaultValue: ''),
      imageUrl: _parseString(json['image_url'], defaultValue: ''),
      brand: BrandModel.fromJson(json['brand'] ?? {}),
      vehicleMake: VehicleMakeModel.fromJson(json['vehicle_make'] ?? {}),
      tireSpec: TireSpecModel.fromJson(json['tire_spec'] ?? {}),
      price: _parseDouble(json['price'], defaultValue: 0.0),
      stockQuantity: _parseInt(json['stock_quantity'], defaultValue: 0),
      isActive: _parseBoolFromInt(json['is_active'], defaultValue: true),
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  /// Convert ProductModel to domain Product entity.
  Product toDomain() {
    return Product(
      id: id,
      sku: sku,
      name: name,
      imageUrl: imageUrl,
      brand: brand.toDomain(),
      vehicleMake: vehicleMake.toDomain(),
      tireSpec: tireSpec.toDomain(),
      price: price,
      stockQuantity: stockQuantity,
      isActive: isActive,
      createdAt: createdAt,
    );
  }

  /// Create ProductModel from domain Product entity.
  factory ProductModel.fromDomain(Product product) {
    return ProductModel(
      id: product.id,
      sku: product.sku,
      name: product.name,
      imageUrl: product.imageUrl,
      brand: product.brand != null
          ? BrandModel.fromDomain(product.brand!)
          : BrandModel(id: '', name: '', logoUrl: ''),
      vehicleMake: product.vehicleMake != null
          ? VehicleMakeModel.fromDomain(product.vehicleMake!)
          : VehicleMakeModel(id: '', name: '', logoUrl: ''),
      tireSpec: product.tireSpec != null
          ? TireSpecModel.fromDomain(product.tireSpec!)
          : const TireSpecModel(
              id: '',
              width: 0,
              aspectRatio: 0,
              rimDiameter: 0,
            ),
      price: product.price,
      stockQuantity: product.stockQuantity,
      isActive: product.isActive,
      createdAt: product.createdAt,
    );
  }

  /// Parse product_id from JSON to String with defensive handling.
  static String _parseProductId(dynamic value) {
    if (value == null) return '';

    if (value is int) {
      return value.toString();
    }

    if (value is String) {
      return value;
    }

    // Fallback for unexpected types
    return value.toString();
  }

  /// Parse string values with null safety and default values.
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;

    if (value is String) {
      return value.trim();
    }

    // Convert other types to string
    return value.toString().trim();
  }

  /// Parse integer values with null safety and default values.
  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;

    if (value is int) {
      return value;
    }

    if (value is String) {
      final parsed = int.tryParse(value.trim());
      if (parsed != null) {
        return parsed;
      }
    }

    if (value is double) {
      return value.toInt();
    }

    // Fallback to default for unexpected types
    return defaultValue;
  }

  /// Parse double values with null safety and default values.
  static double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is String) {
      final parsed = double.tryParse(value.trim());
      if (parsed != null) {
        return parsed;
      }
    }

    // Fallback to default for unexpected types
    return defaultValue;
  }

  /// Parse boolean from INTEGER (0/1) stored in SQLite.
  /// This method handles the int-only nature of SQLite boolean storage.
  static bool _parseBoolFromInt(dynamic value, {bool defaultValue = true}) {
    if (value == null) return defaultValue;

    if (value is int) {
      return value == 1;
    }

    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }

    // Fallback to default for unexpected types
    return defaultValue;
  }

  /// Parse created_at from JSON to DateTime with defensive handling.
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }

    // Fallback to current time for invalid date values
    return DateTime.now();
  }
}
