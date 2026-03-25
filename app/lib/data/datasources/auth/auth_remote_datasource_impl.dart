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

import 'dart:math';
import 'package:sqflite/sqflite.dart';
import '../../../core/error/exceptions.dart';
import 'auth_remote_datasource.dart';
import '../../models/user_model.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Database database;
  bool _migrationChecked = false;

  /// In-memory OTP store
  static final Map<String, _OtpSession> _otpStore = {};

  AuthRemoteDatasourceImpl(this.database);

  Future<void> _ensureMigrated() async {
    if (_migrationChecked) return;
    _migrationChecked = true;
    await _ensureAppSessionTable(database);
  }

  static Future<void> _ensureAppSessionTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS app_session (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
    } catch (e) {
      print("Failed to create app_session table: $e");
    }
  }

  // ─────────────────────────────────────────────
  // AUTH
  // ─────────────────────────────────────────────

  @override
  Future<UserModel> login(String phone, String password) async {
    final result = await database.query(
      'users',
      where: 'phone = ? AND password_hash = ? AND status = ?',
      whereArgs: [phone, password, 'active'],
      limit: 1,
    );

    if (result.isEmpty) {
      throw const ServerException(message: 'Invalid phone or password');
    }

    return UserModel.fromJson(result.first);
  }

  @override
  Future<UserModel> register(
    String fullName,
    String password,
    String phone,
  ) async {
    final exists = await database.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );

    if (exists.isNotEmpty) {
      throw const ServerException(message: 'Phone number already exists');
    }

    await database.insert('users', {
      'full_name': fullName,
      'phone': phone,
      'password_hash': password,
      'status': 'active',
      'role_id': 2, // customer
      'created_at': DateTime.now().toIso8601String(),
    });

    final result = await database.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );

    if (result.isEmpty) {
      throw const ServerException(message: 'Failed to create account, please try again');
    }

    return UserModel.fromJson(result.first);
  }

  @override
  Future<void> logout() async {
    return;
  }

  // ─────────────────────────────────────────────
  //  OTP
  // ─────────────────────────────────────────────

  @override
  Future<void> requestOtp(String phone) async {
    final user = await database.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );

    if (user.isEmpty) {
      throw const ServerException(message: 'Phone number not found');
    }

    final otp = _generateOtp();

    _otpStore[phone] = _OtpSession(
      otp: otp,
      verified: false,
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
    );

    // DEBUG ONLY
    print('OTP for $phone → $otp (expires in 5 minutes)');
  }

  @override
  Future<void> verifyOtp(String phone, String otp) async {
    final session = _otpStore[phone];

    if (session == null) {
      throw const ServerException(message: 'Please request an OTP first');
    }

    if (DateTime.now().isAfter(session.expiresAt)) {
      _otpStore.remove(phone);
      throw const ServerException(message: 'OTP has expired');
    }

    if (session.otp != otp) {
      throw const ServerException(message: 'Invalid OTP code');
    }

    // Mark as verified (OTP itself is now useless)
    session.verified = true;
  }

  // ─────────────────────────────────────────────
  // 🔑 PASSWORD
  // ─────────────────────────────────────────────

  @override
  Future<void> resetPassword(String phone, String newPassword) async {
    final session = _otpStore[phone];

    if (session == null || session.verified != true) {
      throw const ServerException(message: 'Please verify OTP before resetting password');
    }

    final count = await database.update(
      'users',
      {'password_hash': newPassword},
      where: 'phone = ?',
      whereArgs: [phone],
    );

    if (count == 0) {
      throw const ServerException(message: 'Failed to reset password');
    }

    // OTP is single-use → destroy session
    _otpStore.remove(phone);
  }

  @override
  Future<void> changePassword(String phone, String newPassword) async {
    final count = await database.update(
      'users',
      {'password_hash': newPassword},
      where: 'phone = ?',
      whereArgs: [phone],
    );

    if (count == 0) {
      throw const ServerException(message: 'Failed to change password');
    }
  }

  @override
  Future<UserModel> getUserById(int userId) async {
    final result = await database.query(
      'users',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isEmpty) {
      throw const ServerException(message: 'User not found');
    }

    return UserModel.fromJson(result.first);
  }

  // ─────────────────────────────────────────────
  // 📁 SESSION PERSISTENCE
  // ─────────────────────────────────────────────

  @override
  Future<void> saveCurrentUser(int userId) async {
    await _ensureMigrated();
    await database.delete('app_session');
    await database.insert('app_session', {
      'user_id': userId,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<int?> getCurrentUserId() async {
    await _ensureMigrated();
    final rows = await database.query('app_session', limit: 1);
    if (rows.isEmpty) return null;
    final val = rows.first['user_id'];
    if (val is int) return val;
    return int.tryParse(val.toString());
  }

  @override
  Future<void> clearCurrentUser() async {
    await _ensureMigrated();
    await database.delete('app_session');
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────

  String _generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6-digit OTP
  }
}

class _OtpSession {
  final String otp;
  bool verified;
  final DateTime expiresAt;

  _OtpSession({
    required this.otp,
    required this.verified,
    required this.expiresAt,
  });
}
