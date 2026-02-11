// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: safeStringFromJson(json['user_id']),
  phone: safeStringFromJson(json['phone']),
  fullName: safeStringFromJson(json['full_name']),
  address: safeStringFromJson(json['address']),
  shopName: safeStringFromJson(json['shop_name']),
  avatarUrl: safeStringFromJson(json['avatar_url']),
  role: json['role'],
  status: userStatusFromJson(json['status']),
  createdAt: safeDateTimeFromJson(json['created_at']),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'user_id': safeStringToJson(instance.id),
  'phone': safeStringToJson(instance.phone),
  'full_name': safeStringToJson(instance.fullName),
  'address': safeStringToJson(instance.address),
  'shop_name': safeStringToJson(instance.shopName),
  'avatar_url': safeStringToJson(instance.avatarUrl),
  if (instance.role case final value?) 'role': value,
  'status': userStatusToJson(instance.status),
  'created_at': safeDateTimeToJson(instance.createdAt),
};
