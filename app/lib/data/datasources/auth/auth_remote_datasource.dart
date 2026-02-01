  // This file defines the interface for the Authentication Remote Data Source.
//
// Steps to implement:
// 1. Define an abstract class `AuthRemoteDatasource`.
// 2. Define `Future<UserModel> login(String email, String password);`
// 3. Define `Future<UserModel> register(String name, String email, String password, String phone);`
// 4. Define `Future<void> logout();` (optional if handled locally, but API might have logout endpoint).

  import 'package:frontend_otis/data/models/user_model.dart';

  /// Interface for authentication remote data source
  abstract class AuthRemoteDatasource {
    /// Login user with email and password
    Future<UserModel> login(String email, String password);

    /// Register user with name, email, password, phone
    Future<UserModel> register(
        String name, String email, String password, String phone);

    /// Logout user (optional API call)
    Future<void> logout();
  }
