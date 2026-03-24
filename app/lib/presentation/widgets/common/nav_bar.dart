import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_bloc.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_state.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmallScreen = screenWidth < 360;

    final iconSize = isSmallScreen ? 20.0 : 24.0;
    final itemPadding = isSmallScreen ? 8.0 : 10.0;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int cartItemCount = 0;
        if (state is CartLoaded) {
          cartItemCount = state.itemCount;
        }

        return Container(
          padding: EdgeInsets.only(
            left: isSmallScreen ? 12 : 16,
            right: isSmallScreen ? 12 : 16,
            bottom: isSmallScreen ? 4 : 8,
            top: isSmallScreen ? 4 : 8,
          ),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
            border: Border(
              top: BorderSide(
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home
              _buildNavItem(
                context,
                icon: Icons.home,
                label: 'Home',
                isSelected: currentIndex == 0,
                iconSize: iconSize,
                padding: itemPadding,
                onTap: () => onTap(0),
              ),
              // Service
              _buildNavItem(
                context,
                icon: Icons.build,
                label: 'Service',
                isSelected: currentIndex == 1,
                iconSize: iconSize,
                padding: itemPadding,
                onTap: () => onTap(1),
              ),
              // Cart with badge
              _buildNavItemWithBadge(
                context,
                icon: Icons.shopping_cart,
                label: 'Cart',
                isSelected: currentIndex == 2,
                badgeCount: cartItemCount,
                iconSize: iconSize,
                padding: itemPadding,
                onTap: () {
                  onTap(2);
                  context.push('/cart');
                },
              ),
              // Account
              _buildNavItem(
                context,
                icon: Icons.person,
                label: 'Account',
                isSelected: currentIndex == 3,
                iconSize: iconSize,
                padding: itemPadding,
                onTap: () => onTap(3),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required double iconSize,
    required double padding,
    required VoidCallback onTap,
  }) {
    final selectedColor = isSelected ? AppColors.primary : Colors.grey[400];
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: selectedColor),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: selectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemWithBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required int badgeCount,
    required double iconSize,
    required double padding,
    required VoidCallback onTap,
  }) {
    final selectedColor = isSelected ? AppColors.primary : Colors.grey[400];
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: iconSize, color: selectedColor),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: selectedColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  width: 1.5,
                ),
              ),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              child: Text(
                badgeCount > 99 ? '99+' : '$badgeCount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
