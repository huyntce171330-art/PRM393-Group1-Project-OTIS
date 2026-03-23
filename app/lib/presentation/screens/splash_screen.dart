import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/injections/injection_container.dart' as di;
import 'package:frontend_otis/presentation/bloc/auth/auth_bloc.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_state.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_event.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_bloc.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_event.dart';

/// Splash screen shown at app startup.
///
/// Restores session from DB, then navigates to:
/// - Admin home  → user is admin
/// - Customer home → user is customer
/// - Login       → no session found
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5),
    );

    _controller.forward();

    // Dispatch restore event immediately — StreamBuilder in build() will handle navigation
    di.sl<AuthBloc>().add(RestoreSessionEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!mounted) return;

        if (state is Authenticated) {
          // Load notifications for badge
          di.sl<NotificationBloc>().add(LoadNotificationsEvent());

          if (state.user.isAdmin) {
            context.go('/admin/home');
          } else {
            context.go('/home');
          }
        } else if (state is Unauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: isDarkMode
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with animation
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeInAnimation,
                    child: ScaleTransition(scale: _scaleAnimation, child: child),
                  );
                },
                child: const Logo(size: 150, fit: BoxFit.contain),
              ),
              const SizedBox(height: 24),
              // App Name
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.5, 1.0),
                    ),
                    child: child,
                  );
                },
                child: const Text(
                  'OTIS',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 8,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.7, 1.0),
                    ),
                    child: child,
                  );
                },
                child: Text(
                  'Premium Tires & Auto Parts',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[500] : AppColors.textTertiary,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Loading indicator
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.8, 1.0),
                    ),
                    child: child,
                  );
                },
                child: const Column(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  final double size;
  final BoxFit fit;

  const Logo({super.key, required this.size, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shopping_cart,
            size: size * 0.5,
            color: AppColors.primary,
          ),
        );
      },
    );
  }
}
