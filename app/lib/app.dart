import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/injections/injection_container.dart' as di;
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_create_product_screen.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_edit_product_screen.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_product_detail_screen.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_product_list_screen.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_trash_screen.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_bloc.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_event.dart';
import 'package:frontend_otis/presentation/bloc/order/order_bloc.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_bloc.dart';

import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/cart_item.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/presentation/bloc/payment/payment_bloc.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_orders_screen.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_home_screen.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_order_details_screen.dart';
import 'package:frontend_otis/presentation/widgets/admin/admin_layout.dart';
import 'package:frontend_otis/presentation/screens/cart/cart_screen.dart';
import 'package:frontend_otis/presentation/screens/cart/checkout_screen.dart';
import 'package:frontend_otis/presentation/screens/home_screen.dart';
import 'package:frontend_otis/presentation/screens/payment/payment_screen.dart';
import 'package:frontend_otis/presentation/screens/order/booking_success_screen.dart';
import 'package:frontend_otis/presentation/screens/order/order_detail_screen.dart';
import 'package:frontend_otis/presentation/screens/order/order_list_screen.dart';
import 'package:frontend_otis/presentation/screens/product/product_list_screen.dart';
import 'package:frontend_otis/presentation/screens/product/product_detail_screen.dart';
import 'package:frontend_otis/presentation/screens/splash_screen.dart';
import 'package:frontend_otis/presentation/screens/auth/login_screen.dart';
import 'package:frontend_otis/presentation/screens/auth/register_screen.dart';
import 'package:frontend_otis/presentation/screens/profile/profile_screen.dart';
import 'package:frontend_otis/presentation/screens/profile/profile_update_screen.dart';
import 'package:frontend_otis/presentation/screens/notification/notification_list_screen.dart';

/// GoRouter configuration for the OTIS app.
///
/// Provides type-safe navigation with support for:
/// - Named routes
/// - Path parameters
/// - Deep linking
/// - Route guards
final GoRouter router = GoRouter(
  // Thay đổi dòng dưới để test: '/' = customer, '/admin/products' = admin
  initialLocation: '/customer/products',
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
          builder: (context, state) => const AdminCreateProductScreen(),
        ),
        GoRoute(
          path: '/admin/products/trash',
          name: 'admin-trash',
          builder: (context, state) => const AdminTrashScreen(),
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
            return AdminEditProductScreen(productId: productId);
          },
        ),
      ],
    ), // Customer Routes
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
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
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/orders',
      name: 'order-list',
      builder: (context, state) => const OrderListScreen(),
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return BlocProvider(
          create: (context) => di.sl<PaymentBloc>(),
          child: CheckoutScreen(
            checkoutSource: extras['source'] as String,
            items: (extras['items'] as List<CartItem>?) ?? [],
            product: extras['product'] as Product?,
            quantity: extras['quantity'] as int?,
          ),
        );
      },
    ),
    GoRoute(
      path: '/payment',
      name: 'payment',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final order = extras['order'] as Order;
        final method = extras['method'] as PaymentMethod?;
        return BlocProvider(
          create: (context) => di.sl<PaymentBloc>(),
          child: PaymentScreen(order: order, initialMethod: method),
        );
      },
    ),
    GoRoute(
      path: '/booking-success',
      name: 'booking-success',
      builder: (context, state) {
        final order = state.extra as Order;
        return BookingSuccessScreen(order: order);
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AdminLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/admin/home',
          name: 'admin-home',
          builder: (context, state) => const AdminHomeScreen(),
        ),
        GoRoute(
          path: '/admin/orders',
          name: 'admin-orders',
          builder: (context, state) => const AdminOrdersScreen(),
        ),
        GoRoute(
          path: '/admin/order/:orderId',
          name: 'admin-order-detail',
          builder: (context, state) {
            final orderId = state.pathParameters['orderId']!;
            return AdminOrderDetailsScreen(orderId: orderId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/order/:id',
      name: 'order-detail',
      builder: (context, state) {
        final orderId = state.pathParameters['id']!;
        return OrderDetailScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/profile/update',
      name: 'profile-update',
      builder: (context, state) => const ProfileUpdateScreen(),
    ),
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      builder: (context, state) => const NotificationListScreen(),
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => di.sl<AuthBloc>()),
        BlocProvider<CartBloc>.value(
          value: di.sl<CartBloc>()..add(LoadCartEvent()),
        ),
        BlocProvider<OrderBloc>(create: (context) => di.sl<OrderBloc>()),
      ],
      child: MaterialApp.router(
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
      ),
    );
  }
}
