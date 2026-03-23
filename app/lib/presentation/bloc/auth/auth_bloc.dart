import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend_otis/domain/usecases/auth/login_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/register_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/logout_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/otp_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/forgot_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/change_usecase.dart';
import 'package:frontend_otis/core/injections/database_helper.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final LogoutUsecase logoutUsecase;
  final OtpUseCase otpUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
    required this.otpUseCase,
    required this.forgotPasswordUseCase,
    required this.changePasswordUseCase,
  }) : super(AuthInitial()) {

    /// ───────────── LOGIN ─────────────
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await loginUsecase(
        phone: event.phone,
        password: event.password,
      );

      if (result.isRight()) {
        final user = result.getOrElse(() => throw UnimplementedError());
        await DatabaseHelper.saveCurrentUser(int.parse(user.id));
        emit(Authenticated(user));
      } else {
        final failure = result.swap().getOrElse(() => throw UnimplementedError());
        emit(AuthError(failure.message));
      }
    });

    /// ───────────── REGISTER ─────────────
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await registerUsecase(
        fullName: event.fullName,
        phone: event.phone,
        password: event.password,
      );

      if (result.isRight()) {
        final user = result.getOrElse(() => throw UnimplementedError());
        await DatabaseHelper.saveCurrentUser(int.parse(user.id));
        emit(Authenticated(user));
      } else {
        final failure = result.swap().getOrElse(() => throw UnimplementedError());
        emit(AuthError(failure.message));
      }
    });

    /// ───────────── LOGOUT ─────────────
    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());

      await DatabaseHelper.clearCurrentUser();

      final result = await logoutUsecase();

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(Unauthenticated()),
      );
    });

    /// ───────────── RESTORE SESSION ─────────────
    on<RestoreSessionEvent>((event, emit) async {
      emit(AuthLoading());

      final userId = await DatabaseHelper.getCurrentUserId();
      if (userId == null) {
        emit(Unauthenticated());
        return;
      }

      final result = await loginUsecase.fromUserId(userId);

      if (result.isRight()) {
        emit(Authenticated(result.getOrElse(() => throw UnimplementedError())));
      } else {
        await DatabaseHelper.clearCurrentUser();
        emit(Unauthenticated());
      }
    });

    /// ───────────── REQUEST OTP ─────────────
    on<RequestOtpEvent>((event, emit) async {
      final previousState = state;

      if (state is! Authenticated) {
        emit(AuthLoading());
      }

      final result = await otpUseCase.requestOtp(phone: event.phone);

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) {
          emit(OtpSent());
          if (previousState is Authenticated) {
            emit(previousState);
          }
        },
      );
    });

    /// ───────────── VERIFY OTP ─────────────
    on<VerifyOtpEvent>((event, emit) async {
      final previousState = state;

      if (state is! Authenticated) {
        emit(AuthLoading());
      }

      final result = await otpUseCase.verifyOtp(
        phone: event.phone,
        otp: event.otp,
      );

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) {
          emit(OtpVerified());
          if (previousState is Authenticated) {
            emit(previousState);
          }
        },
      );
    });

    /// ───────────── FORGOT PASSWORD ─────────────
    on<ResetPasswordEvent>((event, emit) async {
      final previousState = state;

      if (state is! Authenticated) {
        emit(AuthLoading());
      }

      final result = await forgotPasswordUseCase.resetPassword(
        phone: event.phone,
        newPassword: event.newPassword,
      );

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) {
          emit(PasswordChanged());
          if (previousState is Authenticated) {
            emit(previousState);
          }
        },
      );
    });

    /// ───────────── CHANGE PASSWORD ─────────────
    on<ChangePasswordEvent>((event, emit) async {
      final previousState = state;

      if (state is! Authenticated) {
        emit(AuthLoading());
      }

      final result = await changePasswordUseCase.changePassword(
        phone: event.phone,
        newPassword: event.newPassword,
      );

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) {
          emit(PasswordChanged());
          if (previousState is Authenticated) {
            emit(previousState);
          }
        },
      );
    });

    /// ───────────── CHECK AUTH ─────────────
    on<CheckAuthStatusEvent>((event, emit) async {
      // Delegate to RestoreSessionEvent logic
      add(RestoreSessionEvent());
    });

    on<AuthUserUpdated>((event, emit) {
      final current = state;
      if (current is Authenticated) {
        emit(Authenticated(event.updatedUser));
      }
    });
  }
}