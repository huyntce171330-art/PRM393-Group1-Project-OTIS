// This file handles dependency injection using `get_it`.
//
// Steps to implement:
// 1. Import `get_it`.
// 2. Create a function `init()` to register dependencies.
// 3. Register External (SharedPreferences, Dio).
// 4. Register Core (NetworkInfo).
// 5. Register Data Sources, Repositories, Use Cases, and BLoCs for each feature.
//    - Ensure strict order: Bloc -> UseCase -> Repository -> DataSource.

import 'package:sqflite/sqflite.dart';
import 'package:get_it/get_it.dart';
import '../../data/datasources/auth/auth_remote_datasource.dart';
import '../../data/datasources/auth/auth_remote_datasource_impl.dart';
import './database_helper.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // DATABASE
  final database = await DatabaseHelper.database;
  sl.registerLazySingleton<Database>(() => database);

  // AUTH DATASOURCE (still called "remote" by design)
  sl.registerLazySingleton<AuthRemoteDatasource>(
        () => AuthRemoteDatasourceImpl(sl()),
  );

  print("SQLite Connected Successfully");
}
