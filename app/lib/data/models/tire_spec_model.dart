import 'package:frontend_otis/domain/entities/tire_spec.dart';

/// Data model for TireSpec entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Implements defensive parsing for robustness.
class TireSpecModel {
  const TireSpecModel({
    required this.id,
    required this.width,
    required this.aspectRatio,
    required this.rimDiameter,
  });

  /// Unique identifier for the tire specification
  final String id;

  /// Tire width in millimeters
  final int width;

  /// Tire aspect ratio (height/width percentage)
  final int aspectRatio;

  /// Rim diameter in inches
  final int rimDiameter;

  /// Factory constructor to create TireSpecModel from JSON.
  /// Implements defensive parsing to handle null values and invalid data.
  factory TireSpecModel.fromJson(Map<String, dynamic> json) {
    return TireSpecModel(
      id: _parseTireSpecId(json['tire_spec_id']),
      width: _parseInt(json['width'], defaultValue: 0),
      aspectRatio: _parseInt(json['aspect_ratio'], defaultValue: 0),
      rimDiameter: _parseInt(json['rim_diameter'], defaultValue: 0),
    );
  }

  /// Convert TireSpecModel to JSON for API requests.
  Map<String, dynamic> toJson() {
    return {
      'tire_spec_id': id,
      'width': width,
      'aspect_ratio': aspectRatio,
      'rim_diameter': rimDiameter,
    };
  }

  /// Convert TireSpecModel to domain TireSpec entity.
  TireSpec toDomain() {
    return TireSpec(
      id: id,
      width: width,
      aspectRatio: aspectRatio,
      rimDiameter: rimDiameter,
    );
  }

  /// Create TireSpecModel from domain TireSpec entity.
  factory TireSpecModel.fromDomain(TireSpec tireSpec) {
    return TireSpecModel(
      id: tireSpec.id,
      width: tireSpec.width,
      aspectRatio: tireSpec.aspectRatio,
      rimDiameter: tireSpec.rimDiameter,
    );
  }

  /// Parse tire_spec_id from JSON to String with defensive handling.
  static String _parseTireSpecId(dynamic value) {
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
}
