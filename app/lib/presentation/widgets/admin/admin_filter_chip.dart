// Admin filter chip widget for brand and stock status filtering.
//
// Features:
// - Brand filter chips (All, dynamic brands from database)
// - Stock status chip (Low Stock with red indicator)
// - Active/inactive state styling per Thai Phung design
// - Ripple effect on tap
import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/data/models/brand_model.dart';
/// Filter chip for admin product inventory.
///
/// Supports:
/// - Brand name filtering (with "All" option)
/// - Stock status filtering (with "Low Stock" special styling)
/// - Active/inactive visual states
class AdminFilterChip extends StatelessWidget {
  /// The label to display on the chip
  final String label;

  /// Whether this chip is currently selected/active
  final bool isSelected;

  /// Callback when the chip is tapped
  final VoidCallback onTap;

  /// Optional icon to display before the label
  final IconData? icon;

  /// Whether this is a "special" chip (e.g., Low Stock with red indicator)
  final bool isSpecial;

  /// Creates an AdminFilterChip.
  const AdminFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.isSpecial = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          // Background color based on state
          color: _getBackgroundColor(),
          // Border based on state
          border: isSelected
              ? null
              : Border.all(
                  color: Colors.grey[300]!,
                ),
          // Border radius for pill shape
          borderRadius: BorderRadius.circular(9999),
          // Subtle shadow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Special indicator for Low Stock
            if (isSpecial && !isSelected)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            // Icon if provided
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  icon,
                  size: 16,
                  color: _getIconColor(),
                ),
              ),
            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: _getTextColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Gets the background color based on selection state.
  Color _getBackgroundColor() {
    if (isSelected) {
      // Selected state: Dark background for text visibility
      return AppColors.surfaceLight;
    }
    // Unselected state: White background
    return Colors.white;
  }

  /// Gets the text color based on selection state.
  Color _getTextColor() {
    if (isSelected) {
      // Selected state: Primary color text
      return AppColors.primary;
    }
    if (isSpecial) {
      // Special unselected: Red text
      return AppColors.error;
    }
    // Normal unselected: Dark text
    return AppColors.textPrimary;
  }

  /// Gets the icon color based on selection state.
  Color _getIconColor() {
    if (isSelected) {
      return AppColors.primary;
    }
    return AppColors.textSecondary;
  }
}

/// Available brand filter options for admin inventory.
class AdminBrandFilters {
  /// All brands option
  static const String all = 'All';

  /// Default hardcoded brands (fallback when no database brands available)
  static const List<String> defaultBrands = [
    all,
    'Michelin',
    'Bridgestone',
    'Pirelli',
    'Goodyear',
    'Yokohama',
  ];

  /// Get display name for brand filter
  static String getDisplayName(String? brandName) {
    if (brandName == null || brandName.isEmpty) {
      return all;
    }
    return brandName;
  }

  /// Create filter chips for brands from database
  /// If [brands] is empty or null, falls back to default hardcoded brands
  static List<AdminFilterChip> createBrandChips({
    required List<BrandModel>? brands,
    required String? selectedBrand,
    required void Function(String?) onSelect,
  }) {
    // Use dynamic brands from database, or fallback to default
    final brandList = (brands == null || brands.isEmpty)
        ? defaultBrands
        : [all, ...brands.map((b) => b.name)];

    return brandList.map((brand) {
      final isSelected = selectedBrand == null
          ? brand == all
          : brand == selectedBrand;

      return AdminFilterChip(
        label: brand,
        isSelected: isSelected,
        onTap: () {
          if (brand == all) {
            onSelect(null);
          } else {
            onSelect(brand);
          }
        },
      );
    }).toList();
  }
}

/// Low Stock filter chip with special styling.
class LowStockFilterChip extends StatelessWidget {
  /// Whether this chip is currently selected
  final bool isSelected;

  /// Callback when the chip is tapped
  final VoidCallback onTap;

  /// Creates a LowStockFilterChip.
  const LowStockFilterChip({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AdminFilterChip(
      label: 'Low Stock',
      isSelected: isSelected,
      onTap: onTap,
      isSpecial: true,
    );
  }
}
