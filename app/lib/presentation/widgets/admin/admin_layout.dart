import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/presentation/widgets/admin/admin_nav_bar.dart';
import 'package:frontend_otis/presentation/widgets/admin/directional_page_transition.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;

  const AdminLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    // Reset direction tracker when entering the shell at a specific tab
    TabNavigationDirection.resetTo(currentIndex);

    return Scaffold(
      body: DirectionalPageTransition(
        currentIndex: currentIndex,
        child: child,
      ),
      bottomNavigationBar: AdminNavBar(
        currentIndex: currentIndex,
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    // Exact match for main tabs first
    if (location == '/admin/home') return 0;
    if (location == '/admin/orders') return 1;
    if (location == '/admin/products') return 2;
    if (location == '/admin/categories') return 3;
    // Sub-routes inherit parent tab
    if (location.startsWith('/admin/orders') ||
        location.startsWith('/admin/order/')) {
      return 1;
    }
    if (location.startsWith('/admin/products')) {
      return 2;
    }
    if (location.startsWith('/admin/categories')) {
      return 3;
    }
    return 0; // Default to Home
  }
}
