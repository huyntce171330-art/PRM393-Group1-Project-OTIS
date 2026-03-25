import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final Duration duration;
  final IconData icon;
  final Color iconColor;

  const SuccessDialog({
    super.key,
    this.title = 'Success!',
    required this.message,
    this.duration = const Duration(milliseconds: 800),
    this.icon = Icons.check,
    this.iconColor = AppColors.success,
  });

  static Future<void> show(
    BuildContext context, {
    String title = 'Success!',
    required String message,
    Duration duration = const Duration(milliseconds: 800),
    IconData icon = Icons.check,
    Color iconColor = AppColors.success,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) {
        Future.delayed(duration, () {
          if (context.mounted) {
            final route = ModalRoute.of(context);
            // Only pop if the dialog is still the active (topmost) route.
            if (route != null && route.isCurrent) {
              Navigator.of(context).pop();
            }
          }
        });
        return SuccessDialog(
          title: title,
          message: message,
          duration: duration,
          icon: icon,
          iconColor: iconColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2A1A1B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
