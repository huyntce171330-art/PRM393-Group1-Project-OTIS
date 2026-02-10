import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const HeaderBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor:
          backgroundColor ??
          (isDarkMode ? AppColors.backgroundDark : Colors.white),
      elevation: 0,
      centerTitle: true,
      leading: showBack
          ? IconButton(
              onPressed: onBack ?? () => context.pop(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: isDarkMode ? Colors.white : AppColors.textPrimary,
              ),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
