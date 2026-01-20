// This screen handles user login.
//
// Steps to implement:
// 1. Create `StatefulWidget` `LoginScreen`.
// 2. Create `TextEditingController` for email and password.
// 3. Build UI with fields and a "Login" button.
// 4. On button press:
//    - Dispatch `LoginEvent(email, password)` to `AuthBloc`.
// 5. Use `BlocListener<AuthBloc, AuthState>`:
//    - If `Authenticated`: Navigate to `HomeScreen`.
//    - If `AuthError`: Show snackbar.
// 6. Add a "Register" button (TextButton) to navigate to `RegisterScreen`.
