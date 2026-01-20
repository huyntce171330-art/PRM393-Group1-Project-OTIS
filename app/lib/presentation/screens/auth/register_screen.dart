// This screen handles user registration.
//
// Steps to implement:
// 1. Create `StatefulWidget` `RegisterScreen`.
// 2. Create controllers for name, email, password, phone, confirm password.
// 3. Build UI with form fields and "Register" button.
// 4. On button press:
//    - Validate inputs (e.g., passwords match).
//    - Dispatch `RegisterEvent(...)` to `AuthBloc`.
// 5. Listen to `AuthState`:
//    - If `Authenticated`: Navigate to `HomeScreen`.
//    - If `AuthError`: Show snackbar.
