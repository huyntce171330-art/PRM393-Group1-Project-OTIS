import 'package:flutter/material.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';

class StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case OrderStatus.pendingPayment:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        icon = Icons.pending_outlined;
        break;
      case OrderStatus.paid:
      case OrderStatus.processing:
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
        icon = Icons.sync_outlined;
        break;
      case OrderStatus.completed:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        icon = Icons.check_circle_outline;
        break;
      case OrderStatus.canceled:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
