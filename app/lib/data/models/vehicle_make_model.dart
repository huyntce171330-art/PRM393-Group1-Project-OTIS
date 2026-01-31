import 'package:frontend_otis/domain/entities/vehicle_make.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_make_model.g.dart';

/// Data model for VehicleMake entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Implements defensive parsing for robustness.
@JsonSerializable()
class VehicleMakeModel {
  const VehicleMakeModel({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  /// Unique identifier for the vehicle make
  final String id;

  /// Vehicle make name
  final String name;

  /// URL to vehicle make logo image
  final String logoUrl;

  /// Factory constructor to create VehicleMakeModel from JSON.
  /// Implements defensive parsing to handle null values and invalid data.
  factory VehicleMakeModel.fromJson(Map<String, dynamic> json) {
    return VehicleMakeModel(
      id: _parseMakeId(json['make_id']),
      name: _parseString(json['name'], defaultValue: ''),
      logoUrl: _parseString(json['logo_url'], defaultValue: ''),
    );
  }

  /// Convert VehicleMakeModel to JSON for API requests.
  Map<String, dynamic> toJson() => _$VehicleMakeModelToJson(this);

  /// Convert VehicleMakeModel to domain VehicleMake entity.
  VehicleMake toDomain() {
    return VehicleMake(
      id: id,
      name: name,
      logoUrl: logoUrl,
    );
  }

  /// Create VehicleMakeModel from domain VehicleMake entity.
  factory VehicleMakeModel.fromDomain(VehicleMake vehicleMake) {
    return VehicleMakeModel(
      id: vehicleMake.id,
      name: vehicleMake.name,
      logoUrl: vehicleMake.logoUrl,
    );
  }

  /// Parse make_id from JSON to String with defensive handling.
  static String _parseMakeId(dynamic value) {
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