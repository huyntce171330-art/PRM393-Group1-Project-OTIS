// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRoleModel _$UserRoleModelFromJson(Map<String, dynamic> json) =>
    UserRoleModel(
      id: safeStringFromJson(json['role_id']),
      name: safeStringFromJson(json['name']),
    );

Map<String, dynamic> _$UserRoleModelToJson(UserRoleModel instance) =>
    <String, dynamic>{
      'role_id': safeStringToJson(instance.id),
      'name': safeStringToJson(instance.name),
    };
