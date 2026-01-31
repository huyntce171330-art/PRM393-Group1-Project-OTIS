// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tire_spec_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TireSpecModel _$TireSpecModelFromJson(Map<String, dynamic> json) =>
    TireSpecModel(
      id: json['id'] as String,
      width: (json['width'] as num).toInt(),
      aspectRatio: (json['aspectRatio'] as num).toInt(),
      rimDiameter: (json['rimDiameter'] as num).toInt(),
    );

Map<String, dynamic> _$TireSpecModelToJson(TireSpecModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'width': instance.width,
      'aspectRatio': instance.aspectRatio,
      'rimDiameter': instance.rimDiameter,
    };
