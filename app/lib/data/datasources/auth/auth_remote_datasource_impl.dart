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

import 'auth_remote_datasource.dart';
import '../../models/user_model.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Database database;

  AuthRemoteDatasourceImpl(this.database);

  @override
  Future<UserModel> login(String email, String password) async {
    final result = await database.query(
      'users',
      where: 'email = ? AND password_hash = ? AND status = ?',
      whereArgs: [email, password, 'active'],
    );

    if (result.isEmpty) {
      throw Exception('Invalid email or password');
    }

    return UserModel.fromJson(result.first);
  }

  @override
  Future<UserModel> register(
      String name,
      String email,
      String password,
      String phone,
      ) async {
    await database.insert(
      'users',
      {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    );

    final result = await database.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    return UserModel.fromJson(result.first);
  }

  @override
  Future<void> logout() async {
    // Local app → nothing to clear
    return;
  }
}
