import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:frontend_otis/domain/entities/tire_spec.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tire_spec_model.g.dart';

/// Data model for TireSpec entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
@JsonSerializable(includeIfNull: false)
class TireSpecModel extends Equatable {
  const TireSpecModel({
    required this.id,
    required this.width,
    required this.aspectRatio,
    required this.rimDiameter,
  });

  /// Unique identifier for the tire specification
  @JsonKey(name: 'tire_spec_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String id;

  /// Tire width in millimeters
  @JsonKey(fromJson: safeIntFromJson, toJson: safeIntToJson)
  final int width;

  /// Tire aspect ratio (height/width percentage)
  @JsonKey(name: 'aspect_ratio', fromJson: safeIntFromJson, toJson: safeIntToJson)
  final int aspectRatio;

  /// Rim diameter in inches
  @JsonKey(name: 'rim_diameter', fromJson: safeIntFromJson, toJson: safeIntToJson)
  final int rimDiameter;

  @override
  List<Object?> get props => [id, width, aspectRatio, rimDiameter];

  /// Factory constructor using generated code from json_annotation
  factory TireSpecModel.fromJson(Map<String, dynamic> json) =>
      _$TireSpecModelFromJson(json);

  /// Convert TireSpecModel to JSON for API requests.
  Map<String, dynamic> toJson() => _$TireSpecModelToJson(this);

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
}
