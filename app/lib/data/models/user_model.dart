import 'package:frontend_otis/core/enums/enums.dart' as enums;
import 'package:frontend_otis/domain/entities/user.dart';
import 'package:frontend_otis/domain/entities/user_role.dart' as entities;
import 'package:frontend_otis/data/models/user_role_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// Data model for User entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Implements defensive parsing for robustness.
@JsonSerializable()
class UserModel {
  const UserModel({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.address,
    required this.shopName,
    required this.avatarUrl,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  /// Unique identifier for the user
  final String id;

  /// User's phone number
  final String phone;

  /// User's full name
  final String fullName;

  /// User's address
  final String address;

  /// User's shop name (if applicable)
  final String shopName;

  /// URL to user's avatar image
  final String avatarUrl;

  /// User's role in the system (nullable for dynamic roles from DB)
  @JsonKey(fromJson: _roleFromJson, toJson: _roleToJson)
  final entities.UserRole? role;

  /// User's current status
  final enums.UserStatus status;

  /// When the user was created
  final DateTime createdAt;

  /// Factory constructor to create UserModel from JSON.
  /// Implements defensive parsing to handle null values and invalid data.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _parseUserId(json['user_id']),
      phone: _parseString(json['phone'], defaultValue: ''),
      fullName: _parseString(json['full_name'], defaultValue: ''),
      address: _parseString(json['address'], defaultValue: ''),
      shopName: _parseString(json['shop_name'], defaultValue: ''),
      avatarUrl: _parseString(json['avatar_url'], defaultValue: ''),
      role: _parseUserRole(json['role_id'], json['role']),
      status: _parseUserStatus(json['status']),
      createdAt: _parseDateTime(json['created_at']),
    );
  }

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
      role: role,
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

  /// Parse user_id from JSON (int) to String with defensive handling.
  static String _parseUserId(dynamic value) {
    if (value == null) return '';

    if (value is int) {
      return value.toString();
    }

    if (value is String) {
      return value;
    }

    // Fallback for unexpected types
    return value.toString();
  }

  /// Parse string values with null safety and default values.
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;

    if (value is String) {
      return value.trim();
    }

    // Convert other types to string
    return value.toString().trim();
  }

  /// Parse role_id from JSON to UserRole enum with defensive handling.
  /// Falls back to enum conversion if role object not provided.
  static entities.UserRole? _parseUserRole(dynamic value, dynamic roleJson) {
    // Try to parse from role object if available
    if (roleJson != null && roleJson is Map<String, dynamic>) {
      final roleModel = UserRoleModel.fromJson(roleJson);
      return roleModel.toDomain();
    }

    // Fallback to role_id integer conversion
    if (value == null) return null;

    if (value is int) {
      return const enums.UserRoleConverter().fromJson(value) as entities.UserRole?;
    }

    if (value is String) {
      final intValue = int.tryParse(value);
      if (intValue != null) {
        return const enums.UserRoleConverter().fromJson(intValue) as entities.UserRole?;
      }
    }

    return null;
  }

  /// Custom fromJson for UserRole? field
  static entities.UserRole? _roleFromJson(dynamic json) {
    if (json == null) return null;
    if (json is Map<String, dynamic>) {
      final roleModel = UserRoleModel.fromJson(json);
      return roleModel.toDomain();
    }
    // Handle integer role_id
    if (json is int) {
      return const enums.UserRoleConverter().fromJson(json) as entities.UserRole?;
    }
    return null;
  }

  /// Custom toJson for UserRole? field
  static dynamic _roleToJson(entities.UserRole? role) {
    if (role == null) return null;
    return UserRoleModel.fromDomain(role).toJson();
  }

  /// Parse status from JSON to UserStatus enum with defensive handling.
  static enums.UserStatus _parseUserStatus(dynamic value) {
    if (value == null) return enums.UserStatus.active; // Default to active

    if (value is String) {
      final normalized = value.toLowerCase().trim();
      switch (normalized) {
        case 'active':
          return enums.UserStatus.active;
        case 'inactive':
          return enums.UserStatus.inactive;
        default:
          // Default to active for unknown status values
          return enums.UserStatus.active;
      }
    }

    // Default to active for non-string values
    return enums.UserStatus.active;
  }

  /// Parse created_at from JSON to DateTime with defensive handling.
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now(); // Default to current time

    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }

    // Fallback to current time for invalid date values
    return DateTime.now();
  }
}