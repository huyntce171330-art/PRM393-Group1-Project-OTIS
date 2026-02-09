// Product services section widget.
//
// Displays service information like:
// - Warranty details
// - Delivery options

import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';

/// Widget to display product services (warranty, delivery, etc.)
///
/// Shows service information in a list format with icons following
/// the Thai Phung design system.
class ProductServicesSection extends StatelessWidget {
  /// Creates a new ProductServicesSection instance.
  const ProductServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Services list
          _buildServiceItem(
            icon: Icons.verified_user,
            title: '6 Year Warranty',
            subtitle: 'Standard manufacturer warranty included',
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 12),
          _buildServiceItem(
            icon: Icons.local_shipping,
            title: 'Free Delivery',
            subtitle: 'Available for Ho Chi Minh City area',
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  /// Builds a single service item with icon, title, and subtitle.
  Widget _buildServiceItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        // Icon container
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Chevron icon
        Icon(
          Icons.chevron_right,
          size: 20,
          color: isDarkMode ? Colors.white.withOpacity(0.4) : Colors.grey[400],
        ),
      ],
    );
  }
}
