// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  phone: json['phone'] as String,
  fullName: json['fullName'] as String,
  address: json['address'] as String,
  shopName: json['shopName'] as String,
  avatarUrl: json['avatarUrl'] as String,
  role: UserModel._roleFromJson(json['role']),
  status: $enumDecode(_$UserStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'fullName': instance.fullName,
  'address': instance.address,
  'shopName': instance.shopName,
  'avatarUrl': instance.avatarUrl,
  'role': UserModel._roleToJson(instance.role),
  'status': _$UserStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$UserStatusEnumMap = {
  enums.UserStatus.active: 'active',
  enums.UserStatus.inactive: 'inactive',
};
