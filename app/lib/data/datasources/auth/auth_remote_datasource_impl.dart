// This file calls the API for authentication.
//
// Steps to implement:
// 1. Create `AuthRemoteDatasourceImpl` implementing `AuthRemoteDatasource`.
// 2. Inject `ApiClient`.
// 3. Implement `login`:
//    - POST to `/auth/login` with email/password.
//    - Parse response to `UserModel` (and save Token to local storage if needed).
// 4. Implement `register`:
//    - POST to `/auth/register` with user details.
//    - Parse response to `UserModel`.
// 5. Implement `logout`:
//    - Call (optional) API `/auth/logout`.
//    - Clear local tokens (SharedPreferences/SecureStorage).

import 'package:sqflite/sqflite.dart';

import '../../../core/error/failures.dart';
import 'auth_remote_datasource.dart';
import '../../models/user_model.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Database database;

  AuthRemoteDatasourceImpl(this.database);

  @override
  Future<UserModel> login(String phone, String password) async {
    final result = await database.query(
      'users',
      where: 'phone = ? AND password_hash = ? AND status = ?',
      whereArgs: [phone, password, 'active'],
      limit: 1,
    );

    if (result.isEmpty) {
      throw ServerFailure('Invalid phone or password');
    }

    return UserModel.fromJson(result.first);
  }

  @override
  Future<UserModel> register(
      String fullName,
      String password,
      String phone,
      ) async {
    await database.insert(
      'users',
      {
        'full_name': fullName,
        'phone': phone,
        'password_hash': password,
        'status': 'active',
        'role_id': 0, // default role (customer)
        'created_at': DateTime.now().toIso8601String(),
      },
    );

    final result = await database.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );

    if (result.isEmpty) {
      throw ServerFailure('Failed to create user');
    }

    return UserModel.fromJson(result.first);
  }

  @override
  Future<void> logout() async {
    // Local auth: nothing to clear
    return;
  }
}
