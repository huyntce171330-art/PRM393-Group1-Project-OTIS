import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/domain/entities/product.dart';

/// Simplified product card for home screen.
/// Shows only: product name, tire spec (205/55 R16), price, and + button.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 2,
          color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Section A: The Image (takes ALL remaining space)
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                      child: Stack(
                        children: [
                          // Actual product image
                          if (product.imageUrl.isNotEmpty)
                            Image.network(
                              product.imageUrl,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.inventory_2_outlined,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            )
                          else
                            Center(
                              child: Icon(
                                Icons.inventory_2_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Section B: The Info (sizes intrinsically)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Product Name
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Tire Spec (e.g., 205/55 R16)
                      Text(
                        product.tireSpec?.display ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Price and Add Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              product.formattedPrice,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
