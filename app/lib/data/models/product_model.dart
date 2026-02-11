import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/data/models/tire_spec_model.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

/// Data model for Product entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Uses centralized converters for type safety and consistent parsing.
@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.none)
class ProductModel extends Equatable {
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
  @JsonKey(
    name: 'product_id',
    fromJson: safeStringFromJson,
    toJson: safeStringToJson,
  )
  final String id;

  /// Product SKU (Stock Keeping Unit)
  @JsonKey(fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String sku;

  /// Product name
  @JsonKey(fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String name;

  /// URL to product image
  @JsonKey(
    name: 'image_url',
    fromJson: safeStringFromJson,
    toJson: safeStringToJson,
  )
  final String imageUrl;

  /// Product brand model
  final BrandModel brand;

  /// Vehicle make model
  final VehicleMakeModel vehicleMake;

  /// Tire specification model
  final TireSpecModel tireSpec;

  /// Product price
  @JsonKey(fromJson: safeDoubleFromJson, toJson: safeDoubleToJson)
  final double price;

  /// Available stock quantity
  @JsonKey(
    name: 'stock_quantity',
    fromJson: safeIntFromJson,
    toJson: safeIntToJson,
  )
  final int stockQuantity;

  /// Whether the product is active/available
  /// SQLite stores as INTEGER (0/1) - converter handles the mapping
  @JsonKey(
    name: 'is_active',
    fromJson: safeBoolFromJson,
    toJson: safeBoolToJson,
  )
  final bool isActive;

  /// When the product was created
  @JsonKey(
    name: 'created_at',
    fromJson: safeDateTimeFromJson,
    toJson: safeDateTimeToJson,
  )
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    sku,
    name,
    imageUrl,
    brand,
    vehicleMake,
    tireSpec,
    price,
    stockQuantity,
    isActive,
    createdAt,
  ];

  /// Factory constructor using generated code from json_annotation
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  /// Convert ProductModel to JSON for API requests.
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

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
          : const BrandModel(id: '', name: '', logoUrl: ''),
      vehicleMake: product.vehicleMake != null
          ? VehicleMakeModel.fromDomain(product.vehicleMake!)
          : const VehicleMakeModel(id: '', name: '', logoUrl: ''),
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
}
