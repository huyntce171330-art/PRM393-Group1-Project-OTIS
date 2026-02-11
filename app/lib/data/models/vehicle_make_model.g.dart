// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_make_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleMakeModel _$VehicleMakeModelFromJson(Map<String, dynamic> json) =>
    VehicleMakeModel(
      id: safeStringFromJson(json['make_id']),
      name: safeStringFromJson(json['name']),
      logoUrl: safeStringFromJson(json['logo_url']),
    );

Map<String, dynamic> _$VehicleMakeModelToJson(VehicleMakeModel instance) =>
    <String, dynamic>{
      'make_id': safeStringToJson(instance.id),
      'name': safeStringToJson(instance.name),
      'logo_url': safeStringToJson(instance.logoUrl),
    };
