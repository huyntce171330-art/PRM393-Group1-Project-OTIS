// This file manages the Authentication state.
//
// Steps to implement:
// 1. Create `AuthBloc` extending `Bloc<AuthEvent, AuthState>`.
// 2. Inject `LoginUsecase`, `RegisterUsecase`, `LogoutUsecase`.
// 3. Handle `LoginEvent`:
//    - Emit `AuthLoading`.
//    - Call `loginUsecase`.
//    - Emit `Authenticated(user)` or `AuthError`.
// 4. Handle `RegisterEvent`:
//    - Emit `AuthLoading`.
//    - Call `registerUsecase`.
//    - Emit `Authenticated(user)` or `AuthError`.
// 5. Handle `LogoutEvent`:
//    - Call `logoutUsecase`.
//    - Emit `Unauthenticated`.
