// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String,
  sku: json['sku'] as String,
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String,
  brand: BrandModel.fromJson(json['brand'] as Map<String, dynamic>),
  vehicleMake: VehicleMakeModel.fromJson(
    json['vehicleMake'] as Map<String, dynamic>,
  ),
  tireSpec: TireSpecModel.fromJson(json['tireSpec'] as Map<String, dynamic>),
  price: (json['price'] as num).toDouble(),
  stockQuantity: (json['stockQuantity'] as num).toInt(),
  isActive: const BoolFromIntConverter().fromJson(
    (json['isActive'] as num).toInt(),
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'brand': instance.brand,
      'vehicleMake': instance.vehicleMake,
      'tireSpec': instance.tireSpec,
      'price': instance.price,
      'stockQuantity': instance.stockQuantity,
      'isActive': const BoolFromIntConverter().toJson(instance.isActive),
      'createdAt': instance.createdAt.toIso8601String(),
    };
