import 'package:frontend_otis/core/enums/enums.dart';
import 'package:frontend_otis/domain/entities/user.dart';
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

  /// User's role in the system
  @UserRoleConverter()
  final UserRole role;

  /// User's current status
  final UserStatus status;

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
      role: _parseUserRole(json['role_id']),
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
  static UserRole _parseUserRole(dynamic value) {
    if (value == null) return UserRole.customer; // Default to customer

    if (value is int) {
      return const UserRoleConverter().fromJson(value);
    }

    if (value is String) {
      // Try to parse string as int first
      final intValue = int.tryParse(value);
      if (intValue != null) {
        return const UserRoleConverter().fromJson(intValue);
      }
    }

    // Default to customer for invalid values
    return UserRole.customer;
  }

  /// Parse status from JSON to UserStatus enum with defensive handling.
  static UserStatus _parseUserStatus(dynamic value) {
    if (value == null) return UserStatus.active; // Default to active

    if (value is String) {
      final normalized = value.toLowerCase().trim();
      switch (normalized) {
        case 'active':
          return UserStatus.active;
        case 'inactive':
          return UserStatus.inactive;
        default:
          // Default to active for unknown status values
          return UserStatus.active;
      }
    }

    // Default to active for non-string values
    return UserStatus.active;
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