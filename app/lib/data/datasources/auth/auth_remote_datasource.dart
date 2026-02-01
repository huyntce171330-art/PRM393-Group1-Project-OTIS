  // This file defines the interface for the Authentication Remote Data Source.
//
// Steps to implement:
// 1. Define an abstract class `AuthRemoteDatasource`.
// 2. Define `Future<UserModel> login(String email, String password);`
// 3. Define `Future<UserModel> register(String name, String email, String password, String phone);`
// 4. Define `Future<void> logout();` (optional if handled locally, but API might have logout endpoint).

  import '../../models/user_model.dart';

  abstract class AuthRemoteDatasource {
    Future<UserModel> login(String email, String password);
    Future<UserModel> register(
        String name,
        String email,
        String password,
        String phone,
        );
    Future<void> logout();
  }

