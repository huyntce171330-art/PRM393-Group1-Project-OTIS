import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/constants/app_strings.dart';
import 'package:frontend_otis/presentation/widgets/common/custom_button.dart';

/// A reusable premium dialog for features that are coming soon.
class ComingSoonDialog extends StatelessWidget {
  final String? featureName;
  final String? iconPath;
  final IconData? iconData;

  const ComingSoonDialog({
    super.key,
    this.featureName,
    this.iconPath,
    this.iconData,
  });

  /// Displays the Coming Soon dialog.
  static Future<void> show(BuildContext context, {String? featureName}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ComingSoonDialog(featureName: featureName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rocket / Construction Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                color: AppColors.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              featureName != null
                  ? '$featureName'
                  : AppStrings.comingSoon,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            if (featureName != null)
              const Text(
                AppStrings.comingSoon,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
            const SizedBox(height: 16),

            // Message
            Text(
              AppStrings.featureUnderDevelopment,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Got it!',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
