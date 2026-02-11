// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tire_spec_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TireSpecModel _$TireSpecModelFromJson(Map<String, dynamic> json) =>
    TireSpecModel(
      id: safeStringFromJson(json['tire_spec_id']),
      width: safeIntFromJson(json['width']),
      aspectRatio: safeIntFromJson(json['aspect_ratio']),
      rimDiameter: safeIntFromJson(json['rim_diameter']),
    );

Map<String, dynamic> _$TireSpecModelToJson(TireSpecModel instance) =>
    <String, dynamic>{
      'tire_spec_id': safeStringToJson(instance.id),
      'width': safeIntToJson(instance.width),
      'aspect_ratio': safeIntToJson(instance.aspectRatio),
      'rim_diameter': safeIntToJson(instance.rimDiameter),
    };
