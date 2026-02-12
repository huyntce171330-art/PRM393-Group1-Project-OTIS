  // This file defines the interface for the Authentication Remote Data Source.
//
// Steps to implement:
// 1. Define an abstract class `AuthRemoteDatasource`.
// 2. Define `Future<UserModel> login(String email, String password);`
// 3. Define `Future<UserModel> register(String name, String email, String password, String phone);`
// 4. Define `Future<void> logout();` (optional if handled locally, but API might have logout endpoint).

  import '../../models/user_model.dart';

  abstract class AuthRemoteDatasource {
    /// Login
    Future<UserModel> login(String phone, String password);

    /// Register
    Future<UserModel> register(
        String fullName,
        String password,
        String phone,
        );

    /// Logout
    Future<void> logout();

    // ─────────────────────────────────────────────
    //  OTP
    // ─────────────────────────────────────────────

    /// Generate & send OTP (console)
    Future<void> requestOtp(String phone);

    /// Verify OTP
    Future<void> verifyOtp(String phone, String otp);

    // ─────────────────────────────────────────────
    //  Password
    // ─────────────────────────────────────────────

    /// Forgot password flow
    Future<void> resetPassword(String phone, String newPassword);

    /// Change password (logged-in user)
    Future<void> changePassword(String phone, String newPassword);
  }


