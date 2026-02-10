// Admin product card widget for inventory management list.
//
// Features:
// - Displays product image with stock status indicator (green/yellow/red)
// - Shows product name, price, stock quantity, and tire specification
// - Provides edit and delete action buttons
// - Follows Thai Phung design system
//
// Based on UI reference from admin_product_list_1/code.html

import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/domain/entities/product.dart';

/// Admin product card for inventory management.
///
/// Displays product in a horizontal row layout with:
/// - Product image (72x72) with stock status dot
/// - Product information (name, price, stock, tire spec)
/// - Action buttons (edit, delete)
class AdminProductCard extends StatelessWidget {
  /// The product to display
  final Product product;

  /// Callback when edit button is tapped
  final VoidCallback onEdit;

  /// Callback when delete button is tapped
  final VoidCallback onDelete;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Creates an AdminProductCard.
  const AdminProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (isDarkMode ? Colors.grey[800]! : Colors.grey[100]!),
          ),
        ),
        child: Row(
          children: [
            // Product Image with Stock Status Dot
            _buildProductImage(isDarkMode),
            const SizedBox(width: 12),
            // Product Information
            _buildProductInfo(isDarkMode),
            const SizedBox(width: 8),
            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  /// Builds the product image with stock status indicator.
  Widget _buildProductImage(bool isDarkMode) {
    return Stack(
      children: [
        // Product Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 72,
            height: 72,
            color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
            child: _buildProductImageContent(isDarkMode),
          ),
        ),
        // Stock Status Indicator
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _getStockStatusColor(),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the actual image content or placeholder.
  Widget _buildProductImageContent(bool isDarkMode) {
    if (product.imageUrl.isNotEmpty) {
      return Image.network(
        product.imageUrl,
        fit: BoxFit.contain,
        width: 72,
        height: 72,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderIcon();
        },
      );
    }
    return _buildPlaceholderIcon();
  }

  /// Builds a placeholder icon when image is not available.
  Widget _buildPlaceholderIcon() {
    return Center(
      child: Icon(
        Icons.tire_repair,
        size: 32,
        color: Colors.grey[400],
      ),
    );
  }

  /// Gets the color based on stock status.
  Color _getStockStatusColor() {
    if (product.isOutOfStock) {
      return AppColors.error; // Red for out of stock
    }
    if (product.isLowStock) {
      return AppColors.warning; // Yellow for low stock
    }
    return AppColors.success; // Green for in stock
  }

  /// Builds the product information section.
  Widget _buildProductInfo(bool isDarkMode) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Product Name
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          // Price and Stock Row
          Row(
            children: [
              // Price
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  product.formattedPrice,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Stock Quantity
              Text(
                'Stock: ',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[400] : AppColors.textSecondary,
                ),
              ),
              Text(
                '${product.stockQuantity}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getStockTextColor(isDarkMode),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Tire Specification
          Text(
            product.tireSpec?.display ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode ? Colors.grey[500] : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Gets the text color based on stock status.
  Color _getStockTextColor(bool isDarkMode) {
    if (product.isOutOfStock) {
      return AppColors.error;
    }
    if (product.isLowStock) {
      return AppColors.warning;
    }
    return isDarkMode ? Colors.white : AppColors.textPrimary;
  }

  /// Builds the action buttons (edit and delete).
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Edit Button
        _buildActionButton(
          icon: Icons.edit,
          color: AppColors.primary,
          onTap: onEdit,
        ),
        const SizedBox(height: 4),
        // Delete Button
        _buildActionButton(
          icon: Icons.delete,
          color: Colors.grey[400]!,
          onTap: onDelete,
        ),
      ],
    );
  }

  /// Builds a single action button.
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
      ),
    );
  }
}
