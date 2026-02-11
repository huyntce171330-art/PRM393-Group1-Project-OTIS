// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandModel _$BrandModelFromJson(Map<String, dynamic> json) => BrandModel(
  id: safeStringFromJson(json['brand_id']),
  name: safeStringFromJson(json['name']),
  logoUrl: safeStringFromJson(json['logo_url']),
);

Map<String, dynamic> _$BrandModelToJson(BrandModel instance) =>
    <String, dynamic>{
      'brand_id': safeStringToJson(instance.id),
      'name': safeStringToJson(instance.name),
      'logo_url': safeStringToJson(instance.logoUrl),
    };
