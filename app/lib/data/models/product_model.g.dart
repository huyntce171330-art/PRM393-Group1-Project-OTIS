// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: safeStringFromJson(json['product_id']),
  sku: safeStringFromJson(json['sku']),
  name: safeStringFromJson(json['name']),
  imageUrl: safeStringFromJson(json['image_url']),
  brand: BrandModel.fromJson(json['brand'] as Map<String, dynamic>),
  vehicleMake: VehicleMakeModel.fromJson(
    json['vehicleMake'] as Map<String, dynamic>,
  ),
  tireSpec: TireSpecModel.fromJson(json['tireSpec'] as Map<String, dynamic>),
  price: safeDoubleFromJson(json['price']),
  stockQuantity: safeIntFromJson(json['stock_quantity']),
  isActive: safeBoolFromJson(json['is_active']),
  createdAt: safeDateTimeFromJson(json['created_at']),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'product_id': safeStringToJson(instance.id),
      'sku': safeStringToJson(instance.sku),
      'name': safeStringToJson(instance.name),
      'image_url': safeStringToJson(instance.imageUrl),
      'brand': instance.brand,
      'vehicleMake': instance.vehicleMake,
      'tireSpec': instance.tireSpec,
      'price': safeDoubleToJson(instance.price),
      'stock_quantity': safeIntToJson(instance.stockQuantity),
      'is_active': safeBoolToJson(instance.isActive),
      'created_at': safeDateTimeToJson(instance.createdAt),
    };
