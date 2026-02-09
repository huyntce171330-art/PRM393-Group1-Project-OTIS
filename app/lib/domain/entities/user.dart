import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend_otis/core/enums/enums.dart' as enums;

import 'user_role.dart';

part 'user.freezed.dart';

/// Domain entity representing a user in the system.
/// This entity contains business logic and is immutable.
@freezed
class User with _$User {
  const User._(); // Private constructor for adding custom methods

  const factory User({
    /// Unique identifier for the user
    required String id,

    /// User's phone number
    required String phone,

    /// User's full name
    required String fullName,

    /// User's address
    required String address,

    /// User's shop name (if applicable)
    required String shopName,

    /// URL to user's avatar image
    required String avatarUrl,

    /// User's role in the system (nullable for dynamic roles from DB)
    UserRole? role,

    /// User's current status
    required enums.UserStatus status,

    /// When the user was created
    required DateTime createdAt,
  }) = _User;

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
