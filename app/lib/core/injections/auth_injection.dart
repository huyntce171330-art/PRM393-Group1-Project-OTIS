import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:frontend_otis/data/datasources/auth/auth_remote_datasource.dart';
import 'package:frontend_otis/data/datasources/auth/auth_remote_datasource_impl.dart';
import 'package:frontend_otis/data/repositories/auth_repository_impl.dart';

import 'package:frontend_otis/domain/repositories/auth_repository.dart';
import 'package:frontend_otis/domain/usecases/auth/login_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/register_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/logout_usecase.dart';

import 'package:frontend_otis/presentation/bloc/auth/auth_bloc.dart';

class AuthInjection {
  static AuthBloc provideAuthBloc() {
    final getIt = GetIt.instance;

    // Register Dio only once
    if (!getIt.isRegistered<Dio>()) {
      getIt.registerLazySingleton<Dio>(
            () => Dio(
          BaseOptions(
            baseUrl: 'https://api.example.com', // replace later
          ),
        ),
      );
    }

    // Remote datasource
    if (!getIt.isRegistered<AuthRemoteDatasource>()) {
      getIt.registerLazySingleton<AuthRemoteDatasource>(
            () => AuthRemoteDatasourceImpl(getIt()),
      );
    }

    // Repository
    if (!getIt.isRegistered<AuthRepository>()) {
      getIt.registerLazySingleton<AuthRepository>(
            () => AuthRepositoryImpl(getIt()),
      );
    }

    // UseCases
    if (!getIt.isRegistered<LoginUsecase>()) {
      getIt.registerLazySingleton(() => LoginUsecase(getIt()));
      getIt.registerLazySingleton(() => RegisterUsecase(getIt()));
      getIt.registerLazySingleton(() => LogoutUsecase(getIt()));
    }

    // Bloc (always new instance)
    return AuthBloc(
      loginUsecase: getIt(),
      registerUsecase: getIt(),
      logoutUsecase: getIt(),
    );
  }
}
