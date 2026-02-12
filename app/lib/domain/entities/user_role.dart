import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_role.freezed.dart';

/// Domain entity representing a user role in the system.
/// This entity contains business logic and is immutable.
@immutable
@freezed
class UserRole with _$UserRole {
  const UserRole._(); // Private constructor for adding custom methods

  const factory UserRole({
    /// Unique identifier for the role
    @Assert('id.isNotEmpty', 'Role ID cannot be empty') required String id,

    /// Role name (e.g., 'admin', 'customer')
    @Assert('name.isNotEmpty', 'Role name cannot be empty') required String name,
  }) = _UserRole;

  /// Check if this is an admin role
  bool get isAdmin => name.toLowerCase() == 'admin';

  /// Check if this is a customer role
  bool get isCustomer => name.toLowerCase() == 'customer';

  /// Get the display name (capitalized)
  String get displayName {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  /// Check if the role is valid (has non-empty name)
  bool get isValid => id.isNotEmpty && name.isNotEmpty;

  /// Check if this role matches another role name
  bool matches(String roleName) => name.toLowerCase() == roleName.toLowerCase();
}
