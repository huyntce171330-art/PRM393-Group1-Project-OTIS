import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/enums/enums.dart' as enums;

import 'user_role.dart';

/// Domain entity representing a user in the system.
/// This entity contains business logic and is immutable.
class User extends Equatable {
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
  final UserRole? role;

  /// User's current status
  final enums.UserStatus status;

  /// When the user was created
  final DateTime createdAt;

  const User({
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

  /// Create a copy of User with modified fields
  User copyWith({
    String? id,
    String? phone,
    String? fullName,
    String? address,
    String? shopName,
    String? avatarUrl,
    UserRole? role,
    enums.UserStatus? status,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      shopName: shopName ?? this.shopName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if the user has admin privileges
  bool get isAdmin => role?.isAdmin ?? false;

  /// Check if the user is active
  bool get isActive => status == enums.UserStatus.active;

  /// Get the user's display name (full name or phone if name is empty)
  String get displayName => fullName.isNotEmpty ? fullName : phone;

  /// Check if the user has a shop (non-empty shop name)
  bool get hasShop => shopName.isNotEmpty;

  /// Get formatted creation date
  String get formattedCreatedAt {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
  }
}
