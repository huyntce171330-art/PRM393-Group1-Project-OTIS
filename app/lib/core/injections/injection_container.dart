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
import 'package:frontend_otis/domain/usecases/product/update_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_brands_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_products_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_vehicle_makes_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/create_vehicle_make_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/search_products_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/delete_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_admin_products_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/permanent_delete_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/restore_product_usecase.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/product/product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_bloc.dart';
import 'package:frontend_otis/core/network/api_client.dart';
import 'package:frontend_otis/data/datasources/cart/cart_remote_datasource.dart';
import 'package:frontend_otis/data/datasources/cart/cart_remote_datasource_impl.dart';
import 'package:frontend_otis/data/repositories/cart_repository_impl.dart';
import 'package:frontend_otis/domain/repositories/cart_repository.dart';
import 'package:frontend_otis/domain/usecases/cart/add_product_to_cart_usecase.dart';
import 'package:frontend_otis/domain/usecases/cart/get_cart_usecase.dart';
import 'package:frontend_otis/domain/usecases/cart/update_cart_usecase.dart';
import 'package:frontend_otis/domain/usecases/cart/remove_from_cart_usecase.dart';
import 'package:frontend_otis/domain/usecases/cart/clear_cart_usecase.dart';
import 'package:frontend_otis/data/datasources/payment/payment_remote_datasource_impl.dart';
import 'package:frontend_otis/data/repositories/payment_repository_impl.dart';
import 'package:frontend_otis/domain/repositories/payment_repository.dart';
import 'package:frontend_otis/domain/usecases/payment/create_payment_usecase.dart';
import 'package:frontend_otis/domain/usecases/payment/process_payment_usecase.dart';
import 'package:frontend_otis/domain/usecases/payment/get_active_bank_account_usecase.dart';
import 'package:frontend_otis/presentation/bloc/payment/payment_bloc.dart';
import 'package:frontend_otis/data/datasources/order/order_remote_datasource.dart';
import 'package:frontend_otis/data/datasources/order/order_remote_datasource_impl.dart';
import 'package:frontend_otis/data/repositories/order_repository_impl.dart';
import 'package:frontend_otis/domain/repositories/order_repository.dart';
import 'package:frontend_otis/domain/usecases/order/create_order_usecase.dart';
import 'package:frontend_otis/domain/usecases/order/get_order_detail_usecase.dart';
import 'package:frontend_otis/domain/usecases/order/get_orders_usecase.dart';
import 'package:frontend_otis/domain/usecases/order/update_order_status_usecase.dart';
import 'package:frontend_otis/presentation/bloc/order/order_bloc.dart';

// AUTH IMPORTS
import 'package:frontend_otis/data/datasources/auth/auth_remote_datasource.dart';
import 'package:frontend_otis/data/datasources/auth/auth_remote_datasource_impl.dart';
import 'package:frontend_otis/data/repositories/auth_repository_impl.dart';
import 'package:frontend_otis/domain/repositories/auth_repository.dart';
import 'package:frontend_otis/domain/usecases/auth/login_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/register_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/logout_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/otp_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/forgot_usecase.dart';
import 'package:frontend_otis/domain/usecases/auth/change_usecase.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_bloc.dart';

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

  // ApiClient
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ========== 3. DATA SOURCES ==========
  // Product Data Source
  sl.registerLazySingleton<ProductRemoteDatasource>(
    () => ProductRemoteDatasourceImpl(database: sl()),
  );

  // Cart Data Source
  sl.registerLazySingleton<CartRemoteDatasource>(
    () => CartRemoteDatasourceImpl(apiClient: sl()),
  );

  // Payment Data Source
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(),
  );

  // Order Data Source
  sl.registerLazySingleton<OrderRemoteDatasource>(
    () => OrderRemoteDatasourceImpl(),
  );

  // Auth Data Source
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );

  // ========== 4. REPOSITORIES ==========
  // Product Repository
  sl.registerLazySingleton<ProductRepository>(
    () =>
        ProductRepositoryImpl(productRemoteDatasource: sl(), networkInfo: sl()),
  );

  // Cart Repository
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(cartRemoteDatasource: sl()),
  );

  // Payment Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(sl()),
  );

  // Order Repository
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDatasource: sl()),
  );

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // ========== 5. USE CASES ==========
  // Product Use Cases
  sl.registerLazySingleton<GetProductsUsecase>(
    () => GetProductsUsecase(productRepository: sl()),
  );
  sl.registerLazySingleton<SearchProductsUsecase>(
    () => SearchProductsUsecase(productRepository: sl()),
  );
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

  // Update Product Use Case
  sl.registerLazySingleton<UpdateProductUsecase>(
    () => UpdateProductUsecase(productRepository: sl()),
  );

  // Get Brands Use Case
  sl.registerLazySingleton<GetBrandsUsecase>(
    () => GetBrandsUsecase(productRepository: sl()),
  );

  // Get Vehicle Makes Use Case
  sl.registerLazySingleton<GetVehicleMakesUsecase>(
    () => GetVehicleMakesUsecase(productRepository: sl()),
  );

  // Create Vehicle Make Use Case
  sl.registerLazySingleton<CreateVehicleMakeUsecase>(
    () => CreateVehicleMakeUsecase(productRepository: sl()),
  );

  // Restore Product Use Case
  sl.registerLazySingleton<RestoreProductUsecase>(
    () => RestoreProductUsecase(productRepository: sl()),
  );

  // Permanent Delete Product Use Case
  sl.registerLazySingleton<PermanentDeleteProductUsecase>(
    () => PermanentDeleteProductUsecase(productRepository: sl()),
  );

  // Cart Use Cases
  sl.registerLazySingleton<GetCartUsecase>(
    () => GetCartUsecase(cartRepository: sl()),
  );
  sl.registerLazySingleton<AddProductToCartUsecase>(
    () => AddProductToCartUsecase(cartRepository: sl()),
  );
  sl.registerLazySingleton<UpdateCartUsecase>(
    () => UpdateCartUsecase(cartRepository: sl()),
  );
  sl.registerLazySingleton<RemoveFromCartUsecase>(
    () => RemoveFromCartUsecase(sl()),
  );
  sl.registerLazySingleton<ClearCartUsecase>(() => ClearCartUsecase(sl()));

  // Payment Use Cases
  sl.registerLazySingleton<CreatePaymentUseCase>(
    () => CreatePaymentUseCase(sl()),
  );
  sl.registerLazySingleton<ProcessPaymentUseCase>(
    () => ProcessPaymentUseCase(sl()),
  );
  sl.registerLazySingleton<GetActiveBankAccountUseCase>(
    () => GetActiveBankAccountUseCase(sl()),
  );

  // Order Use Cases
  sl.registerLazySingleton<GetOrdersUseCase>(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton<GetOrderDetailUseCase>(
    () => GetOrderDetailUseCase(sl()),
  );
  sl.registerLazySingleton<CreateOrderUseCase>(() => CreateOrderUseCase(sl()));
  sl.registerLazySingleton<UpdateOrderStatusUseCase>(
    () => UpdateOrderStatusUseCase(sl()),
  );

  // Auth Use Cases
  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(sl()));
  sl.registerLazySingleton<RegisterUsecase>(() => RegisterUsecase(sl()));
  sl.registerLazySingleton<LogoutUsecase>(() => LogoutUsecase(sl()));
  sl.registerLazySingleton<OtpUseCase>(() => OtpUseCase(sl()));
  sl.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(sl()),
  );
  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(sl()),
  );

  // ========== 6. BLOCS ==========
  // Product BLoC
  sl.registerLazySingleton<ProductBloc>(
    () => ProductBloc(getProductsUsecase: sl(), getProductDetailUsecase: sl()),
  );

  // Cart BLoC
  sl.registerLazySingleton<CartBloc>(
    () => CartBloc(
      getCartUsecase: sl(),
      addProductToCartUsecase: sl(),
      updateCartUsecase: sl(),
      removeFromCartUsecase: sl(),
      clearCartUsecase: sl(),
    ),
  );

  // Payment BLoC
  sl.registerFactory<PaymentBloc>(
    () => PaymentBloc(
      createPayment: sl(),
      processPayment: sl(),
      getActiveBankAccount: sl(),
    ),
  );

  // Order BLoC
  sl.registerFactory<OrderBloc>(
    () => OrderBloc(
      getOrdersUseCase: sl(),
      getOrderDetailUseCase: sl(),
      createOrderUseCase: sl(),
      updateOrderStatusUseCase: sl(),
    ),
  );

  // Auth BLoC
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUsecase: sl(),
      registerUsecase: sl(),
      logoutUsecase: sl(),
      otpUseCase: sl(),
      forgotPasswordUseCase: sl(),
      changePasswordUseCase: sl(),
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
      updateProductUsecase: sl(),
    ),
  );

  print("All dependencies registered successfully");
}
