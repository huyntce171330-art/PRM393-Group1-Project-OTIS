import 'package:flutter/material.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDarkMode ? const Color(0xFF1A2230) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF333333);
    final textSecondaryColor = isDarkMode
        ? Colors.grey[400]
        : const Color(0xFF6B7280);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: surfaceColor.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thai Phung Admin',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Dashboard',
                style: TextStyle(
                  color: textSecondaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
                color: textSecondaryColor,
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuD8YWidUUkqIitQsKH0Xj1BREkpvbhijdepzuqA_Da7KY6sVqLLfwQgwKUF9ajSgmIMnTK0j4b0lW5CkUPGvtwFsjNt2kHd8yr7_dEwL5bx51eY3jU3_u31A2YSvWEFA00LNez6c73az5gA1bCFT0EEn4VjFiJVlHZn88Ebl-X_XiKkoFtdil-UCs5KFqAl7wEnKq8OLGx60Cizj1NUiG97bPDbHHbp5LaKFDQzgFSHOcwQW9yHMP5fpRLrvtR7YpdR7Wd2dLwd7G4',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
