// This file handles dependency injection using `get_it`.
//
// Steps to implement:
// 1. Import `get_it`.
// 2. Create a function `init()` to register dependencies.
// 3. Register External (SharedPreferences, Dio).
// 4. Register Core (NetworkInfo).
// 5. Register Data Sources, Repositories, Use Cases, and BLoCs for each feature.
//    - Ensure strict order: Bloc -> UseCase -> Repository -> DataSource.

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:frontend_otis/core/injections/database_helper.dart';
import 'package:frontend_otis/core/network/network_info.dart';
import 'package:frontend_otis/core/network/network_info_impl.dart';
import 'package:frontend_otis/data/datasources/product/product_remote_datasource.dart';
import 'package:frontend_otis/data/datasources/product/product_remote_datasource_impl.dart';
import 'package:frontend_otis/data/repositories/product_repository_impl.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';
import 'package:frontend_otis/domain/usecases/product/create_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_brands_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_products_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_vehicle_makes_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/search_products_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/delete_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_admin_products_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/permanent_delete_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/restore_product_usecase.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/product/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ========== 1. EXTERNAL ==========
  // Database instance (singleton)
  final database = await DatabaseHelper.database;
  sl.registerLazySingleton<Database>(() => database);

  // Connectivity checker
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // ========== 2. CORE ==========
  // Network info implementation
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  // ========== 3. DATA SOURCES ==========
  // Product Data Source
  sl.registerLazySingleton<ProductRemoteDatasource>(
    () => ProductRemoteDatasourceImpl(database: sl()),
  );

  // ========== 4. REPOSITORIES ==========
  // Product Repository
  sl.registerLazySingleton<ProductRepository>(
    () =>
        ProductRepositoryImpl(productRemoteDatasource: sl(), networkInfo: sl()),
  );

  // ========== 5. USE CASES ==========
  // Product Use Cases
  sl.registerLazySingleton<GetProductsUsecase>(
    () => GetProductsUsecase(productRepository: sl()),
  );

  // Search Products Use Case
  sl.registerLazySingleton<SearchProductsUsecase>(
    () => SearchProductsUsecase(productRepository: sl()),
  );

  // Get Product Detail Use Case
  sl.registerLazySingleton<GetProductDetailUsecase>(
    () => GetProductDetailUsecase(productRepository: sl()),
  );

  // Delete Product Use Case
  sl.registerLazySingleton<DeleteProductUsecase>(
    () => DeleteProductUsecase(productRepository: sl()),
  );

  // Get Admin Products Use Case
  sl.registerLazySingleton<GetAdminProductsUsecase>(
    () => GetAdminProductsUsecase(productRepository: sl()),
  );

  // Create Product Use Case
  sl.registerLazySingleton<CreateProductUsecase>(
    () => CreateProductUsecase(productRepository: sl()),
  );

  // Get Brands Use Case
  sl.registerLazySingleton<GetBrandsUsecase>(
    () => GetBrandsUsecase(productRepository: sl()),
  );

  // Get Vehicle Makes Use Case
  sl.registerLazySingleton<GetVehicleMakesUsecase>(
    () => GetVehicleMakesUsecase(productRepository: sl()),
  );

  // Restore Product Use Case
  sl.registerLazySingleton<RestoreProductUsecase>(
    () => RestoreProductUsecase(productRepository: sl()),
  );

  // Permanent Delete Product Use Case
  sl.registerLazySingleton<PermanentDeleteProductUsecase>(
    () => PermanentDeleteProductUsecase(productRepository: sl()),
  );

  // ========== 6. BLOCS ==========
  // Product BLoC
  sl.registerLazySingleton<ProductBloc>(
    () => ProductBloc(
      getProductsUsecase: sl(),
      getProductDetailUsecase: sl(),
    ),
  );

  // Admin Product BLoC
  sl.registerLazySingleton<AdminProductBloc>(
    () => AdminProductBloc(
      getAdminProductsUsecase: sl(),
      getProductDetailUsecase: sl(),
      deleteProductUsecase: sl(),
      createProductUsecase: sl(),
      restoreProductUsecase: sl(),
      permanentDeleteProductUsecase: sl(),
    ),
  );

  print("✅ All dependencies registered successfully");
}
