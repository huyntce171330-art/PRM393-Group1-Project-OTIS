import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/injections/injection_container.dart' as di;
import 'package:frontend_otis/domain/usecases/product/delete_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_products_usecase.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_product_detail_screen.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_product_list_screen.dart';
import 'package:frontend_otis/presentation/screens/home_screen.dart';
import 'package:frontend_otis/presentation/screens/product/product_list_screen.dart';
import 'package:frontend_otis/presentation/screens/product/product_detail_screen.dart';
import 'package:frontend_otis/presentation/screens/splash_screen.dart';

/// GoRouter configuration for the OTIS app.
///
/// Provides type-safe navigation with support for:
/// - Named routes
/// - Path parameters
/// - Deep linking
/// - Route guards
final GoRouter router = GoRouter(
  // Thay đổi dòng dưới để test: '/' = customer, '/admin/products' = admin
  initialLocation: '/admin/products',
  routes: [
    GoRoute(
      path: '/debug',
      name: 'debug',
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('🧪 Debug Menu')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => context.push('/products'),
                icon: const Icon(Icons.shopping_bag),
                label: const Text('🛒 Customer Products'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.push('/admin/products'),
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text('📦 Admin Products'),
              ),
            ],
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    // Admin Routes - Wrap with BlocProvider to share state between List and Detail
    // Use BlocProvider.value with singleton from GetIt to preserve state across navigation
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider<AdminProductBloc>.value(
          value: di.sl<AdminProductBloc>(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/admin/products',
          name: 'admin-product-list',
          builder: (context, state) => const AdminProductListScreen(),
        ),
        GoRoute(
          path: '/admin/products/create',
          name: 'admin-product-create',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Text('Create Product Screen - To be implemented'),
            ),
          ),
        ),
        GoRoute(
          path: '/admin/products/:id',
          name: 'admin-product-detail',
          builder: (context, state) {
            final productId = state.pathParameters['id']!;
            return AdminProductDetailScreen(productId: productId);
          },
        ),
        GoRoute(
          path: '/admin/products/:id/edit',
          name: 'admin-product-edit',
          builder: (context, state) {
            final productId = state.pathParameters['id']!;
            return Scaffold(
              body: Center(
                child: Text('Edit Product: $productId - To be implemented'),
              ),
            );
          },
        ),
      ],
    ),    // Customer Routes
    GoRoute(
      path: '/products',
      name: 'product-list',
      builder: (context, state) => const ProductListScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      name: 'product-detail',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Path: ${state.uri}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ),
  ),
);

class OtisApp extends StatelessWidget {
  const OtisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OTIS Project',
      routerConfig: router,
      // Using Thai Phung design system colors
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.primaryDark,
          surface: AppColors.surfaceLight,
          error: AppColors.error,
        ),
        useMaterial3: true,
        // Apply app colors to app bar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
        ),
        // Apply to elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
          ),
        ),
        // Apply to floating action button theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
