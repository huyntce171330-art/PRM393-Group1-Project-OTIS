// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_make_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleMakeModel _$VehicleMakeModelFromJson(Map<String, dynamic> json) =>
    VehicleMakeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
    );

Map<String, dynamic> _$VehicleMakeModelToJson(VehicleMakeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
    };
