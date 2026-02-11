import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/enums/enums.dart' as enums;
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:frontend_otis/domain/entities/user.dart';
import 'package:frontend_otis/domain/entities/user_role.dart' as entities;
import 'package:json_annotation/json_annotation.dart';

import 'user_role_model.dart';

part 'user_model.g.dart';

/// Data model for User entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Uses centralized converters for primitive types and enums.
@JsonSerializable(includeIfNull: false)
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.address,
    required this.shopName,
    required this.avatarUrl,
    this.role,
    required this.status,
    required this.createdAt,
  });

  /// Unique identifier for the user
  @JsonKey(name: 'user_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String id;

  /// User's phone number
  @JsonKey(fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String phone;

  /// User's full name
  @JsonKey(name: 'full_name', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String fullName;

  /// User's address
  @JsonKey(fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String address;

  /// User's shop name (if applicable)
  @JsonKey(name: 'shop_name', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String shopName;

  /// URL to user's avatar image
  @JsonKey(name: 'avatar_url', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String avatarUrl;

  /// User's role in the system (nullable for dynamic roles from DB)
  /// Can be Map (nested object), int (role_id), or null
  final dynamic role;

  /// User's current status
  @JsonKey(fromJson: userStatusFromJson, toJson: userStatusToJson)
  final enums.UserStatus status;

  /// When the user was created
  @JsonKey(name: 'created_at', fromJson: safeDateTimeFromJson, toJson: safeDateTimeToJson)
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        phone,
        fullName,
        address,
        shopName,
        avatarUrl,
        role,
        status,
        createdAt,
      ];

  /// Factory constructor using generated code from json_annotation
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  /// Convert UserModel to JSON for API requests.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Convert UserModel to domain User entity.
  User toDomain() {
    return User(
      id: id,
      phone: phone,
      fullName: fullName,
      address: address,
      shopName: shopName,
      avatarUrl: avatarUrl,
      role: _parseUserRole(role),
      status: status,
      createdAt: createdAt,
    );
  }

  /// Create UserModel from domain User entity.
  factory UserModel.fromDomain(User user) {
    return UserModel(
      id: user.id,
      phone: user.phone,
      fullName: user.fullName,
      address: user.address,
      shopName: user.shopName,
      avatarUrl: user.avatarUrl,
      role: user.role,
      status: user.status,
      createdAt: user.createdAt,
    );
  }

  /// Parse role from JSON - handles Map, int, or null.
  static entities.UserRole? _parseUserRole(dynamic value) {
    if (value == null) return null;

    if (value is entities.UserRole) return value;

    if (value is Map<String, dynamic>) {
      final roleModel = UserRoleModel.fromJson(value);
      return roleModel.toDomain();
    }

    if (value is int) {
      final enumRole = const enums.UserRoleConverter().fromJson(value);
      return _enumToEntity(enumRole);
    }

    return null;
  }

  /// Convert enum UserRole to entity UserRole.
  static entities.UserRole? _enumToEntity(enums.UserRole? enumRole) {
    if (enumRole == null) return null;
    switch (enumRole) {
      case enums.UserRole.admin:
        return const entities.UserRole(id: '1', name: 'admin');
      case enums.UserRole.customer:
        return const entities.UserRole(id: '2', name: 'customer');
    }
  }
  }

/// Convert UserRole entity to JSON.
dynamic userRoleToJson(entities.UserRole? object) {
  if (object == null) return null;
  return {'id': object.id, 'name': object.name};
}
