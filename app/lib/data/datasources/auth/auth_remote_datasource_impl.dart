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

import '../../../core/error/failures.dart';
import 'auth_remote_datasource.dart';
import '../../models/user_model.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Database database;

  /// In-memory OTP store
  static final Map<String, _OtpSession> _otpStore = {};


  AuthRemoteDatasourceImpl(this.database);

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
    final exists = await database.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );

    if (exists.isNotEmpty) {
      throw ServerFailure('Phone number already exists');
    }

    await database.insert(
      'users',
      {
        'full_name': fullName,
        'phone': phone,
        'password_hash': password,
        'status': 'active',
        'role_id': 0,
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
      throw ServerFailure('Phone number not found');
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
      throw ServerFailure('OTP not requested');
    }

    if (DateTime.now().isAfter(session.expiresAt)) {
      _otpStore.remove(phone);
      throw ServerFailure('OTP expired');
    }

    if (session.otp != otp) {
      throw ServerFailure('Invalid OTP');
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
      throw ServerFailure('OTP verification required');
    }

    final count = await database.update(
      'users',
      {'password_hash': newPassword},
      where: 'phone = ?',
      whereArgs: [phone],
    );

    if (count == 0) {
      throw ServerFailure('Failed to reset password');
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
      throw ServerFailure('Failed to change password');
    }
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
