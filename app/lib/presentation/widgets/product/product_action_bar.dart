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
  final VoidCallback? onAddToCart;

  /// Callback when Buy Now button is pressed
  final VoidCallback? onBuyNow;

  /// Whether item is already in cart
  final bool isInCart;

  /// Whether the buttons should be disabled (out of stock)
  final bool isDisabled;

  /// Callback when View Cart button is pressed
  final VoidCallback? onViewCart;

  /// Creates a new ProductActionBar instance.
  ///
  /// [onAddToCart]: Callback for Add to Cart action
  /// [onBuyNow]: Callback for Buy Now action
  /// [isDisabled]: Whether buttons should be disabled (default: false)
  const ProductActionBar({
    super.key,
    this.onAddToCart,
    this.onBuyNow,
    this.isDisabled = false,
    this.isInCart = false,
    this.onViewCart,
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
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppColors.outline,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isDisabled
                      ? null
                      : (isInCart ? onViewCart : onAddToCart),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: isInCart ? Colors.green : AppColors.primary,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: isInCart
                        ? Colors.green
                        : AppColors.primary,
                    backgroundColor: isInCart
                        ? Colors.green.withValues(alpha: 0.05)
                        : Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isInCart) ...[
                        const Icon(Icons.check, size: 18),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        isInCart ? 'View Cart' : 'Add to Cart',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
