import 'package:flutter/material.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';

class StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData? icon;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    switch (status) {
      case OrderStatus.pendingPayment:
      case OrderStatus.paid:
      case OrderStatus.processing:
        backgroundColor = isDarkMode
            ? Colors.orange[900]!.withValues(alpha: 0.2)
            : Colors.orange[50]!;
        textColor = isDarkMode ? Colors.orange[400]! : Colors.orange[700]!;
        icon = null; // Template shows a pulse dot, we can omit or add
        break;
      case OrderStatus.completed:
        backgroundColor = isDarkMode
            ? Colors.green[900]!.withValues(alpha: 0.2)
            : Colors.green[50]!;
        textColor = isDarkMode ? Colors.green[400]! : Colors.green[700]!;
        icon = Icons.check_circle;
        break;
      case OrderStatus.canceled:
        backgroundColor = isDarkMode
            ? Colors.red[900]!.withValues(alpha: 0.2)
            : Colors.red[50]!;
        textColor = isDarkMode ? Colors.red[400]! : Colors.red[700]!;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ] else ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: textColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            status.displayName,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
