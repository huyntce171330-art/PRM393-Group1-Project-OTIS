import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';

class AdminNavBar extends StatelessWidget {
  final int currentIndex;

  const AdminNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDarkMode ? const Color(0xFF1A2230) : Colors.white;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.dashboard, 'Home', 0),
          _buildNavItem(context, Icons.receipt_long, 'Orders', 1),
          _buildNavItem(context, Icons.tire_repair, 'Products', 2),
          _buildNavItem(context, Icons.category, 'Categories', 3),
          _buildNavItem(context, Icons.settings, 'Settings', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context,
      IconData icon,
      String label,
      int index,
      ) {
    final isActive = currentIndex == index;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activeColor = AppColors.primary;
    final inactiveColor = isDarkMode ? Colors.grey[600] : Colors.grey[400];

    return GestureDetector(
      onTap: () {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            context.go('/admin/home');
            break;
          case 1:
            context.go('/admin/orders');
            break;
          case 2:
            context.go('/admin/products');
            break;
          case 3:
            context.go('/admin/categories');
            break;
          case 4:
            context.go('/admin/settings');
            break;
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isActive)
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          Icon(icon, color: isActive ? activeColor : inactiveColor, size: 26),
          Text(
            label,
            style: TextStyle(
              color: isActive ? activeColor : inactiveColor,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}