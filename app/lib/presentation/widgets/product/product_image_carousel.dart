// Product image carousel with pagination dots.
//
// Features:
// - PageView for swiping through images
// - Dot indicators showing current position
// - Support for single or multiple images
// - Dark mode support

import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';

/// Widget to display product images in a carousel with pagination dots.
///
/// Accepts a list of image URLs and displays them in a swipeable PageView
/// with dot indicators at the bottom.
class ProductImageCarousel extends StatefulWidget {
  /// List of image URLs to display
  final List<String> imageUrls;

  /// Creates a new ProductImageCarousel instance.
  ///
  /// [imageUrls]: List of image URLs (required)
  const ProductImageCarousel({
    super.key,
    required this.imageUrls,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  /// Current page index for the PageView
  int _currentPage = 0;

  /// PageController for managing PageView scroll
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Image PageView
        SizedBox(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return _buildImagePage(
                  widget.imageUrls[index],
                  isDarkMode,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Pagination dots
        _buildPaginationDots(
          widget.imageUrls.length,
          _currentPage,
          isDarkMode,
        ),
      ],
    );
  }

  /// Builds a single image page with loading and error handling.
  Widget _buildImagePage(String imageUrl, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                    color: isDarkMode ? Colors.white.withOpacity(0.3) : Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to load image',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white.withOpacity(0.5) : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the pagination dot indicators.
  Widget _buildPaginationDots(int totalDots, int currentIndex, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDots,
        (index) {
          final isActive = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : isDarkMode
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }
}
