import '../../domain/entities/user_role.dart';

class UserRoleModel extends UserRole {
  const UserRoleModel({required int roleId, required String roleName})
    : super(roleId: roleId, roleName: roleName);

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(roleId: json['role_id'], roleName: json['role_name']);
  }

  Map<String, dynamic> toJson() {
    return {'role_id': roleId, 'role_name': roleName};
  }
}
