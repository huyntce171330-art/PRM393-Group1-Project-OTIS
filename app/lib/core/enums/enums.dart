import 'package:json_annotation/json_annotation.dart';

/// User roles in the system.
/// Maps to database role_id: 1 = admin, 2 = customer
enum UserRole {
  admin,
  customer,
}

/// User status in the system.
/// Maps to database status: 'active' or 'inactive'
@JsonEnum()
enum UserStatus {
  active,
  inactive,
}

/// JSON converter for UserRole to handle integer mapping from database.
/// Maps role_id from database (1 = admin, 2 = customer) to enum values.
class UserRoleConverter implements JsonConverter<UserRole, int> {
  const UserRoleConverter();

  @override
  UserRole fromJson(int json) {
    switch (json) {
      case 1:
        return UserRole.admin;
      case 2:
        return UserRole.customer;
      default:
        // Default to customer for unknown values (defensive programming)
        return UserRole.customer;
    }
  }

  @override
  int toJson(UserRole object) {
    switch (object) {
      case UserRole.admin:
        return 1;
      case UserRole.customer:
        return 2;
    }
  }
}

/// Extension methods for UserRole enum
extension UserRoleExtension on UserRole {
  /// Get the role ID as used in the database
  int get id {
    switch (this) {
      case UserRole.admin:
        return 1;
      case UserRole.customer:
        return 2;
    }
  }

  /// Get the display name for the role
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.customer:
        return 'Customer';
    }
  }
}

/// Extension methods for UserStatus enum
extension UserStatusExtension on UserStatus {
  /// Get the display name for the status
  String get displayName {
    switch (this) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.inactive:
        return 'Inactive';
    }
  }

  /// Check if the status is active
  bool get isActive => this == UserStatus.active;
}