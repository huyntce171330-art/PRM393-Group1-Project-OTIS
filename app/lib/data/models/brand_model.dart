import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:frontend_otis/domain/entities/brand.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brand_model.g.dart';

/// Data model for Brand entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
@JsonSerializable(includeIfNull: false)
class BrandModel extends Equatable {
  const BrandModel({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  /// Unique identifier for the brand
  @JsonKey(name: 'brand_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String id;

  /// Brand name
  @JsonKey(fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String name;

  /// URL to brand logo image
  @JsonKey(name: 'logo_url', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String logoUrl;

  @override
  List<Object?> get props => [id, name, logoUrl];

  /// Factory constructor using generated code from json_annotation
  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  /// Convert BrandModel to JSON for API requests.
  Map<String, dynamic> toJson() => _$BrandModelToJson(this);

  /// Convert BrandModel to domain Brand entity.
  Brand toDomain() {
    return Brand(
      id: id,
      name: name,
      logoUrl: logoUrl,
    );
  }

  /// Create BrandModel from domain Brand entity.
  factory BrandModel.fromDomain(Brand brand) {
    return BrandModel(
      id: brand.id,
      name: brand.name,
      logoUrl: brand.logoUrl,
    );
  }
}
