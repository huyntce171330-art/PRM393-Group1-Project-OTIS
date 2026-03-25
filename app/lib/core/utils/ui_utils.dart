import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/presentation/widgets/common/coming_soon_dialog.dart';
import 'package:frontend_otis/presentation/widgets/common/success_dialog.dart';

class UiUtils {
  static void showSuccessPopup(BuildContext context, String message, {String title = 'Success!'}) {
    SuccessDialog.show(context, message: message, title: title);
  }

  static void showCancelPopup(BuildContext context, String message, {String title = 'Canceled'}) {
    SuccessDialog.show(
      context,
      message: message,
      title: title,
      icon: Icons.close,
      iconColor: AppColors.error,
    );
  }

  static void showComingSoon(BuildContext context, {String? featureName}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return ComingSoonDialog(featureName: featureName);
      },
    );
  }
}
