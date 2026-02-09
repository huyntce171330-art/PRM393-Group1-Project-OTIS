// Product specifications grid widget.
//
// Displays tire specifications in a 4-column grid layout:
// - Width (e.g., 205)
// - Profile (e.g., 55)
// - Rim (e.g., 16)
// - Speed (e.g., V)

import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/domain/entities/tire_spec.dart';

/// Widget to display product specifications in a grid format.
///
/// Shows tire specifications (Width, Profile, Rim, Speed) in a 4-column
/// grid with icons and labels following the Thai Phung design system.
class ProductSpecsGrid extends StatelessWidget {
  /// The tire specification data to display
  final TireSpec? tireSpec;

  /// Creates a new ProductSpecsGrid instance.
  ///
  /// [tireSpec]: TireSpec object containing the specifications (nullable)
  const ProductSpecsGrid({
    super.key,
    required this.tireSpec,
  });

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
            'Specifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Specs grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.85,  // FIX: Tang chieu cao de fit noi dung
            children: [
              _buildSpecItem(
                icon: Icons.straighten,
                value: tireSpec?.width.toString() ?? '-',
                label: 'Width',
                isDarkMode: isDarkMode,
              ),
              _buildSpecItem(
                icon: Icons.aspect_ratio,
                value: tireSpec?.aspectRatio.toString() ?? '-',
                label: 'Profile',
                isDarkMode: isDarkMode,
              ),
              _buildSpecItem(
                icon: Icons.circle,
                value: tireSpec?.rimDiameter.toString() ?? '-',
                label: 'Rim',
                isDarkMode: isDarkMode,
              ),
              _buildSpecItem(
                icon: Icons.speed,
                value: tireSpec != null ? 'V' : '-',
                label: 'Speed',
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a single specification item with icon, value, and label.
  Widget _buildSpecItem({
    required IconData icon,
    required String value,
    required String label,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey[100]!,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
