import 'package:frontend_otis/domain/entities/user_role.dart';

/// Data model for UserRole entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Implements defensive parsing for robustness.
class UserRoleModel {
  const UserRoleModel({required this.id, required this.name});

  /// Unique identifier for the role
  final String id;

  /// Role name (e.g., 'admin', 'customer')
  final String name;

  /// Factory constructor to create UserRoleModel from JSON.
  /// Implements defensive parsing to handle null values and invalid data.
  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      id: _parseRoleId(json['role_id']),
      name: _parseString(json['role_name'], defaultValue: ''),
    );
  }

  /// Convert UserRoleModel to JSON for API requests.
  Map<String, dynamic> toJson() {
    return {'role_id': id, 'role_name': name};
  }

  /// Convert UserRoleModel to domain UserRole entity.
  UserRole toDomain() {
    return UserRole(id: id, name: name);
  }

  /// Create UserRoleModel from domain UserRole entity.
  factory UserRoleModel.fromDomain(UserRole userRole) {
    return UserRoleModel(id: userRole.id, name: userRole.name);
  }

  /// Parse role_id from JSON to String with defensive handling.
  static String _parseRoleId(dynamic value) {
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
}
