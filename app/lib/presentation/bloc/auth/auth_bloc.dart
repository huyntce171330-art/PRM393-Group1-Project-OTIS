import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend_otis/domain/usecases/auth/login_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/register_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/logout_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/otp_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/forgot_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/change_usecase.dart';

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

      result.fold(
            (failure) => emit(AuthError(failure.message)),
            (user) => emit(Authenticated(user)),
      );
    });

    /// ───────────── REGISTER ─────────────
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await registerUsecase(
        fullName: event.fullName,
        phone: event.phone,
        password: event.password,
      );

      result.fold(
            (failure) => emit(AuthError(failure.message)),
            (user) => emit(Authenticated(user)),
      );
    });

    /// ───────────── LOGOUT ─────────────
    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await logoutUsecase();

      result.fold(
            (failure) => emit(AuthError(failure.message)),
            (_) => emit(Unauthenticated()),
      );
    });

    /// ───────────── REQUEST OTP ─────────────
    on<RequestOtpEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await otpUseCase.requestOtp(
        phone: event.phone,
      );

      result.fold(
            (failure) => emit(AuthError(failure.message)),
            (_) => emit(OtpSent()),
      );
    });

    /// ───────────── VERIFY OTP ─────────────
    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await otpUseCase.verifyOtp(
        phone: event.phone,
        otp: event.otp,
      );

      result.fold(
            (failure) => emit(AuthError(failure.message)),
            (_) => emit(OtpVerified()),
      );
    });

    /// ───────────── FORGOT PASSWORD ─────────────
    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await forgotPasswordUseCase.resetPassword(
        phone: event.phone,
        newPassword: event.newPassword,
      );

      result.fold(
            (failure) => emit(AuthError(failure.message)),
            (_) => emit(PasswordChanged()),
      );
    });

    /// ───────────── CHANGE PASSWORD ─────────────
    on<ChangePasswordEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await changePasswordUseCase.changePassword(
        phone: event.phone,
        newPassword: event.newPassword,
      );

      result.fold(
            (failure) => emit(AuthError(failure.message)),
            (_) => emit(PasswordChanged()),
      );
    });

    /// ───────────── CHECK AUTH ─────────────
    on<CheckAuthStatusEvent>((event, emit) async {
      emit(Unauthenticated());
    });
  }
}
