import 'package:equatable/equatable.dart';

class UserRole extends Equatable {
  final int roleId;
  final String roleName;

  const UserRole({required this.roleId, required this.roleName});

  @override
  List<Object?> get props => [roleId, roleName];
}
