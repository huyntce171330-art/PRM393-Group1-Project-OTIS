// Product action bar widget.
//
// Sticky bottom bar with:
// - Add to Cart button (outline style)
// - Buy Now button (filled primary color)

import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';

/// Widget to display the product action bar (Add to Cart, Buy Now).
///
/// Sticky bottom bar fixed at the bottom of the screen with two action buttons.
/// Follows the Thai Phung design system with primary brand color.
class ProductActionBar extends StatelessWidget {
  /// Callback when Add to Cart button is pressed
  final VoidCallback onAddToCart;
  /// Callback when Buy Now button is pressed
  final VoidCallback onBuyNow;
  /// Whether the buttons should be disabled (out of stock)
  final bool isDisabled;

  /// Creates a new ProductActionBar instance.
  ///
  /// [onAddToCart]: Callback for Add to Cart action
  /// [onBuyNow]: Callback for Buy Now action
  /// [isDisabled]: Whether buttons should be disabled (default: false)
  const ProductActionBar({
    super.key,
    required this.onAddToCart,
    required this.onBuyNow,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.surfaceDark
              : AppColors.surfaceLight,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.1)
                  : AppColors.outline,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Add to Cart button
              Expanded(
                child: OutlinedButton(
                  onPressed: isDisabled ? null : onAddToCart,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: AppColors.primary,
                    backgroundColor: Colors.transparent,
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Buy Now button
              Expanded(
                child: ElevatedButton(
                  onPressed: isDisabled ? null : onBuyNow,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    'Buy Now',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
