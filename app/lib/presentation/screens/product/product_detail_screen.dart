// Screen to show product details.
//
// Features:
// - Image carousel with pagination
// - Product header (name, brand, prices)
// - Specifications grid (Width, Profile, Rim, Speed)
// - Services section (Warranty, Delivery)
// - Sticky action bar (Add to Cart, Buy Now)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/constants/app_strings.dart';
import 'package:frontend_otis/core/injections/injection_container.dart' as di;
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/presentation/bloc/product/product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/product/product_event.dart';
import 'package:frontend_otis/presentation/bloc/product/product_state.dart';
import 'package:frontend_otis/presentation/widgets/product/product_action_bar.dart';
import 'package:frontend_otis/presentation/widgets/product/product_image_carousel.dart';
import 'package:frontend_otis/presentation/widgets/product/product_specs_grid.dart';
import 'package:frontend_otis/presentation/widgets/product/product_services_section.dart';

/// Screen to display full product details.
///
/// Follows the Thai Phung design system and Clean Architecture pattern.
/// Uses BLoC for state management.
class ProductDetailScreen extends StatelessWidget {
  /// The product ID to fetch details for
  final String productId;

  /// Creates a new ProductDetailScreen instance.
  ///
  /// [productId]: The unique identifier of the product to display
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // Use BlocProvider.value instead of create to prevent closing the singleton Bloc
    // when this screen is disposed. The Bloc is a singleton managed by GetIt.
    return BlocProvider<ProductBloc>.value(
      value: di.sl<ProductBloc>()..add(GetProductDetailEvent(id: productId)),
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: _buildAppBar(context),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductInitial) {
              return const Center(child: SizedBox());
            } else if (state is ProductLoading) {
              return _buildLoadingState();
            } else if (state is ProductDetailLoaded) {
              return _buildContent(state.product, context);
            } else if (state is ProductError) {
              return _buildErrorState(state.message, context);
            } else {
              // Fallback for other states (e.g. ProductLoaded not used here)
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  /// Builds the app bar with back button and cart icon.
  AppBar _buildAppBar(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDarkMode
          ? AppColors.backgroundDark
          : Colors.white.withOpacity(0.9),
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back,
          color: isDarkMode ? Colors.white : AppColors.textPrimary,
        ),
      ),
      title: Text(
        AppStrings.productDetails,
        style: TextStyle(
          color: isDarkMode ? Colors.white : AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Cart icon with badge
        _buildCartBadge(context),
      ],
    );
  }

  /// Builds the cart icon with badge showing item count.
  Widget _buildCartBadge(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // TODO: Replace with CartBloc state when Cart feature is implemented
    const cartItemCount = 0;

    return Stack(
      children: [
        IconButton(
          onPressed: () => context.push('/cart'),
          icon: Icon(
            Icons.shopping_cart,
            color: isDarkMode ? Colors.white : AppColors.textPrimary,
          ),
        ),
        if (cartItemCount > 0)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDarkMode ? AppColors.backgroundDark : Colors.white,
                  width: 2,
                ),
              ),
              child: Text(
                '$cartItemCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Builds the loading state with skeleton UI.
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text(AppStrings.loadingProductDetails),
        ],
      ),
    );
  }

  /// Builds the error state with retry button.
  Widget _buildErrorState(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(
                GetProductDetailEvent(id: productId),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }

  /// Builds the main content with all product details.
  Widget _buildContent(Product product, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Main content
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image carousel with Hero animation
              Hero(
                tag: 'product_image_${product.id}',
                child: ProductImageCarousel(
                  imageUrls: [
                    product.imageUrl,
                    // Add more images if available
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Product info section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stock status badge
                    _buildStockBadge(product, isDarkMode),
                    const SizedBox(height: 8),

                    // Product name
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Prices
                    _buildPriceSection(product, isDarkMode),
                    const SizedBox(height: 8),

                    // VAT note
                    Text(
                      AppStrings.priceIncludesVat,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Divider
              Divider(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey[200],
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),

              // Specifications grid
              ProductSpecsGrid(tireSpec: product.tireSpec),

              // Services section
              const ProductServicesSection(),

              // Divider
              Divider(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey[200],
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),

              // Bottom spacing for action bar
              const SizedBox(height: 80),
            ],
          ),
        ),

        // Sticky action bar
        ProductActionBar(
          onAddToCart: () {
            // Add to cart logic
          },
          onBuyNow: () {
            // Buy now logic
          },
          isDisabled: product.stockQuantity <= 0,
        ),
      ],
    );
  }

  /// Builds the stock status badge.
  Widget _buildStockBadge(Product product, bool isDarkMode) {
    final isInStock = product.stockQuantity > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isInStock
            ? AppColors.success.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isInStock ? AppStrings.inStock : AppStrings.outOfStock,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isInStock ? AppColors.success : AppColors.error,
        ),
      ),
    );
  }

  /// Builds the price section with sale/original price.
  Widget _buildPriceSection(Product product, bool isDarkMode) {
    // Format the price
    final formattedPrice = product.formattedPrice;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          formattedPrice,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
