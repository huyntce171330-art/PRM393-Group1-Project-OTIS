import 'package:frontend_otis/domain/entities/brand.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brand_model.g.dart';

/// Data model for Brand entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Implements defensive parsing for robustness.
@JsonSerializable()
class BrandModel {
  const BrandModel({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  /// Unique identifier for the brand
  final String id;

  /// Brand name
  final String name;

  /// URL to brand logo image
  final String logoUrl;

  /// Factory constructor to create BrandModel from JSON.
  /// Implements defensive parsing to handle null values and invalid data.
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: _parseBrandId(json['brand_id']),
      name: _parseString(json['name'], defaultValue: ''),
      logoUrl: _parseString(json['logo_url'], defaultValue: ''),
    );
  }

  /// Convert BrandModel to JSON for API requests.
  Map<String, dynamic> toJson() => _$BrandModelToJson(this);

  /// Convert BrandModel to domain Brand entity.
  Brand toDomain() {
    return Brand(id: id, name: name, logoUrl: logoUrl);
  }

  /// Create BrandModel from domain Brand entity.
  factory BrandModel.fromDomain(Brand brand) {
    return BrandModel(id: brand.id, name: brand.name, logoUrl: brand.logoUrl);
  }

  /// Parse brand_id from JSON to String with defensive handling.
  static String _parseBrandId(dynamic value) {
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
}
