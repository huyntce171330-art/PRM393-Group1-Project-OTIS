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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/domain/usecases/auth/login_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/register_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final LogoutUsecase logoutUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
  }) : super(AuthInitial()) {
    // Handle LoginEvent
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUsecase(phone: event.phone, password: event.password);

      result.fold(
            (failure) => emit(AuthError(failure.message)),
            (user) => emit(Authenticated(user)),
      );
    });

    // Handle RegisterEvent
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await registerUsecase(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        phone: event.phone,
      );

      result.fold(
            (failure) => emit(AuthError(failure.message)),
            (user) => emit(Authenticated(user)),
      );
    });

    // Handle LogoutEvent
    on<LogoutEvent>((event, emit) async {
      final result = await logoutUsecase();
      result.fold(
            (failure) => emit(AuthError(failure.message)),
            (_) => emit(Unauthenticated()),
      );
    });

    // Optional: Handle CheckAuthStatusEvent
    on<CheckAuthStatusEvent>((event, emit) async {
      // Implementation depends on local token check if desired
      // Example: emit(Unauthenticated()) if no token
      emit(Unauthenticated());
    });
  }
}
