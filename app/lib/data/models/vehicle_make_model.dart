import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:frontend_otis/domain/entities/vehicle_make.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_make_model.g.dart';

/// Data model for VehicleMake entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
@JsonSerializable(includeIfNull: false)
class VehicleMakeModel extends Equatable {
  const VehicleMakeModel({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  /// Unique identifier for the vehicle make
  @JsonKey(name: 'make_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String id;

  /// Vehicle make name
  @JsonKey(fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String name;

  /// URL to vehicle make logo image
  @JsonKey(name: 'logo_url', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String logoUrl;

  @override
  List<Object?> get props => [id, name, logoUrl];

  /// Factory constructor using generated code from json_annotation
  factory VehicleMakeModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleMakeModelFromJson(json);

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
}
