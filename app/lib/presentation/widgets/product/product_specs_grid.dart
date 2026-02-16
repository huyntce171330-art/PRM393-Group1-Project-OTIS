// Product specifications grid widget.
//
// Displays tire specifications in a grid layout with two sections:
// - Section 1: Specifications (Width, Profile, Rim) - 3 columns
// - Section 2: Compatibility (Brand, Vehicle Make) - 2 columns

import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/domain/entities/brand.dart';
import 'package:frontend_otis/domain/entities/tire_spec.dart';
import 'package:frontend_otis/domain/entities/vehicle_make.dart';

/// Widget to display product specifications in a grid format.
///
/// Shows tire specifications (Width, Profile, Rim) and compatibility 
/// (Brand, Vehicle Make) in two separate sections following the 
/// Thai Phung design system.
class ProductSpecsGrid extends StatelessWidget {
  /// The tire specification data to display
  final TireSpec? tireSpec;

  /// The vehicle make compatibility (nullable)
  final VehicleMake? vehicleMake;

  /// The brand of the tire (nullable)
  final Brand? brand;

  /// Creates a new ProductSpecsGrid instance.
  ///
  /// [tireSpec]: TireSpec object containing the specifications (nullable)
  /// [vehicleMake]: VehicleMake object for vehicle compatibility (nullable)
  /// [brand]: Brand object for the tire brand (nullable)
  const ProductSpecsGrid({
    super.key,
    required this.tireSpec,
    this.vehicleMake,
    this.brand,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Specifications
          Text(
            'Specifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Specs grid - 3 columns for Width, Profile, Rim
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.0,
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
            ],
          ),
          const SizedBox(height: 24),
          // Section 2: Compatibility
          Text(
            'Compatibility',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Compatibility grid - 2 columns for Brand and Vehicle Make
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
            children: [
              _buildBrandItem(
                brand: brand,
                isDarkMode: isDarkMode,
              ),
              _buildVehicleMakeItem(
                vehicleMake: vehicleMake,
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

  /// Builds a brand item with logo and name.
  Widget _buildBrandItem({
    required Brand? brand,
    required bool isDarkMode,
  }) {
    final hasBrand = brand != null && brand.isValid;
    final showLogo = hasBrand && brand.hasLogo;

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
          // Brand logo or placeholder icon
          if (showLogo)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                brand.logoUrl,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.factory,
                  size: 32,
                  color: Colors.grey[400],
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Icon(
              Icons.factory,
              size: 32,
              color: Colors.grey[400],
            ),
          const SizedBox(height: 8),
          Text(
            hasBrand ? brand.displayName : 'N/A',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            'Brand',
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

  /// Builds a vehicle make item with logo and name.
  Widget _buildVehicleMakeItem({
    required VehicleMake? vehicleMake,
    required bool isDarkMode,
  }) {
    final hasVehicleMake = vehicleMake != null && vehicleMake.isValid;
    final showLogo = hasVehicleMake && vehicleMake.hasLogo;

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
          // Vehicle make logo or placeholder icon
          if (showLogo)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                vehicleMake.logoUrl,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.directions_car,
                  size: 32,
                  color: Colors.grey[400],
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Icon(
              Icons.directions_car,
              size: 32,
              color: Colors.grey[400],
            ),
          const SizedBox(height: 8),
          Text(
            hasVehicleMake ? vehicleMake.displayName : 'N/A',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            'Vehicle',
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
