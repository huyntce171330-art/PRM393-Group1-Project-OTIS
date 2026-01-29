import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int userId;
  final String phone;
  final String passwordHash;
  final String? fullName;
  final String? address;
  final String? shopName;
  final int roleId;
  final String status;
  final DateTime createdAt;

  const User({
    required this.userId,
    required this.phone,
    required this.passwordHash,
    this.fullName,
    this.address,
    this.shopName,
    required this.roleId,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    userId,
    phone,
    passwordHash,
    fullName,
    address,
    shopName,
    roleId,
    status,
    createdAt,
  ];
}
