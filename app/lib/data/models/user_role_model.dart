import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:frontend_otis/domain/entities/user_role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_role_model.g.dart';

/// Data model for UserRole entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
@JsonSerializable(includeIfNull: false)
class UserRoleModel extends Equatable {
  const UserRoleModel({
    required this.id,
    required this.name,
  });

  /// Unique identifier for the role
  @JsonKey(name: 'role_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String id;

  /// Role name (e.g., 'admin', 'customer')
  @JsonKey(fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String name;

  @override
  List<Object?> get props => [id, name];

  /// Factory constructor using generated code from json_annotation
  factory UserRoleModel.fromJson(Map<String, dynamic> json) =>
      _$UserRoleModelFromJson(json);

  /// Convert UserRoleModel to JSON for API requests.
  Map<String, dynamic> toJson() => _$UserRoleModelToJson(this);

  /// Convert UserRoleModel to domain UserRole entity.
  UserRole toDomain() {
    return UserRole(
      id: id,
      name: name,
    );
  }

  /// Create UserRoleModel from domain UserRole entity.
  factory UserRoleModel.fromDomain(UserRole userRole) {
    return UserRoleModel(
      id: userRole.id,
      name: userRole.name,
    );
  }
}
