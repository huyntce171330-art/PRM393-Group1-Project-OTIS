import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/presentation/widgets/admin/admin_nav_bar.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;

  const AdminLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AdminNavBar(
        currentIndex: _calculateSelectedIndex(context),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/admin/orders') ||
        location.startsWith('/admin/order/')) {
      return 1;
    }
    if (location.startsWith('/admin/products')) {
      return 2;
    }
    if (location.startsWith('/admin/settings')) {
      return 3;
    }
    return 0; // Default to Home
  }
}
