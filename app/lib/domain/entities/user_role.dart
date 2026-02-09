import 'package:equatable/equatable.dart';

/// Domain entity representing a user role in the system.
/// This entity contains business logic and is immutable.
class UserRole extends Equatable {
  /// Unique identifier for the role
  final String id;

  /// Role name (e.g., 'admin', 'customer')
  final String name;

  const UserRole({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  /// Create a copy of UserRole with modified fields
  UserRole copyWith({String? id, String? name}) {
    return UserRole(id: id ?? this.id, name: name ?? this.name);
  }

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
