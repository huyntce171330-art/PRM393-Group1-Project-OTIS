import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required int userId,
    required String phone,
    required String passwordHash,
    String? fullName,
    String? address,
    String? shopName,
    required int roleId,
    required String status,
    required DateTime createdAt,
  }) : super(
         userId: userId,
         phone: phone,
         passwordHash: passwordHash,
         fullName: fullName,
         address: address,
         shopName: shopName,
         roleId: roleId,
         status: status,
         createdAt: createdAt,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      phone: json['phone'],
      passwordHash: json['password_hash'],
      fullName: json['full_name'],
      address: json['address'],
      shopName: json['shop_name'],
      roleId: json['role_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'phone': phone,
      'password_hash': passwordHash,
      'full_name': fullName,
      'address': address,
      'shop_name': shopName,
      'role_id': roleId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
