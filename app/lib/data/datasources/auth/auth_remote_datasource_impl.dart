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

import 'package:dio/dio.dart';
import 'package:frontend_otis/data/models/user_model.dart';
import 'auth_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of AuthRemoteDatasource using Dio
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasourceImpl(this.dio);

  /// Login user with email & password
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final userModel = UserModel.fromJson(response.data);

      // Optional: Save token to SharedPreferences if API returns one
      final token = response.data['token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
      }

      return userModel;
    } catch (e) {
      // Throw exception to be handled in repository
      throw Exception('Login failed: $e');
    }
  }

  /// Register user with name, email, password, phone
  @override
  Future<UserModel> register(
      String name, String email, String password, String phone) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'full_name': name,
          'email': email,
          'password': password,
          'phone': phone,
        },
      );

      final userModel = UserModel.fromJson(response.data);

      // Optional: Save token if API returns one
      final token = response.data['token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
      }

      return userModel;
    } catch (e) {
      throw Exception('Register failed: $e');
    }
  }

  /// Logout user
  @override
  Future<void> logout() async {
    try {
      await dio.post('/auth/logout');

      // Clear token from local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
