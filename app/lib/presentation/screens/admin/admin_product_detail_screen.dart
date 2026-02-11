// Screen to show admin product details.
//
// Features:
// - Product image with Hero animation
// - Product info (name, SKU, price, stock)
// - Specifications grid (Brand, Width, Ratio, Rim)
// - Description section
// - Edit and Delete action buttons
//
// Follows the Thai Phung design system and Clean Architecture pattern.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_event.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_state.dart';

/// Screen to display full admin product details.
///
/// Follows the Thai Phung design system and Clean Architecture pattern.
/// Uses BLoC for state management.
class AdminProductDetailScreen extends StatefulWidget {
  /// The product ID to fetch details for
  final String productId;

  /// Creates a new AdminProductDetailScreen instance.
  ///
  /// [productId]: The unique identifier of the product to display
  const AdminProductDetailScreen({super.key, required this.productId});

  @override
  State<AdminProductDetailScreen> createState() =>
      _AdminProductDetailScreenState();
}

class _AdminProductDetailScreenState extends State<AdminProductDetailScreen> {
  late final AdminProductBloc _bloc;

  @override
  void initState() {
    super.initState();
    // Use existing Bloc from parent BlocProvider (shared with list screen)
    _bloc = BlocProvider.of<AdminProductBloc>(context)
      ..add(GetProductDetailEvent(productId: widget.productId));
  }

  @override
  void dispose() {
    // DO NOT close the Bloc - it's managed by the parent ShellRoute
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminProductBloc>.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: _buildAppBar(context),
        body: BlocBuilder<AdminProductBloc, AdminProductState>(
          builder: (context, state) {
            // Handle different states for detail view
            return state.when(
              initial: () => _buildLoadingState(),
              loading: () => _buildLoadingState(),
              loaded:
                  (
                    products,
                    filter,
                    selectedBrand,
                    stockStatus,
                    currentPage,
                    totalPages,
                    hasMore,
                    totalCount,
                    isLoadingMore,
                    isRefreshing,
                  ) {
                    // When coming from List, show loading while fetching detail
                    // or show cached info if available
                    return _buildLoadingState();
                  },
              detailLoading: () => _buildLoadingState(),
              detailLoaded: (product) => _buildContent(product, context),
              deleting: (_) => _buildLoadingState(),
              deleted: (_) => _buildLoadingState(),
              error: (message) => _buildErrorState(message, context),
              creating: () => _buildLoadingState(),
              createSuccess: (_) => _buildLoadingState(),
              createError: (message) => _buildErrorState(message, context),
            );
          },
        ),
        bottomNavigationBar: _buildBottomActions(context),
      ),
    );
  }

  /// Builds the app bar with back button and title.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
      ),
      title: const Text(
        'Chi tiết sản phẩm',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Show more options menu
          },
          icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  /// Builds the loading state with skeleton UI.
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
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
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _bloc.add(GetProductDetailEvent(productId: widget.productId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Thử lại',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the main content with all product details.
  Widget _buildContent(Product product, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Hero animation
          _buildProductImage(product),
          const SizedBox(height: 16),

          // Product Info Section
          _buildProductInfo(product),
          const SizedBox(height: 16),

          // Divider
          Container(height: 8, color: Colors.grey[100]),
          const SizedBox(height: 16),

          // Specifications Grid
          _buildSpecifications(product),
          const SizedBox(height: 100), // Space for bottom actions
        ],
      ),
    );
  }

  /// Builds the product image with Hero animation and stock badge.
  Widget _buildProductImage(Product product) {
    final stockStatus = _getStockStatus(product);

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Hero(
            tag: 'product_image_${product.id}',
            child: Container(
              decoration: BoxDecoration(
                image: product.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.contain,
                      )
                    : null,
                color: Colors.grey[200],
              ),
              child: product.imageUrl.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                    )
                  : null,
            ),
          ),
        ),
        // Stock badge
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: stockStatus.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  stockStatus.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the product info section (name, SKU, price, stock).
  Widget _buildProductInfo(Product product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // SKU
          Text(
            'SKU: ${product.sku}',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // Price and Stock
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Unit Price',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    product.formattedPrice,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              // Stock
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Available Stock',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${product.stockQuantity} units',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the specifications grid.
  Widget _buildSpecifications(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Specifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: [
              _buildSpecItem(
                icon: Icons.verified,
                label: 'Brand',
                value: product.brand?.name ?? 'Unknown',
              ),
              _buildSpecItem(
                icon: Icons.straighten,
                label: 'Width',
                value: product.tireSpec != null
                    ? '${product.tireSpec!.width} mm'
                    : 'N/A',
              ),
              _buildSpecItem(
                icon: Icons.aspect_ratio,
                label: 'Ratio',
                value: product.tireSpec != null
                    ? '${product.tireSpec!.aspectRatio}%'
                    : 'N/A',
              ),
              _buildSpecItem(
                icon: Icons.tire_repair,
                label: 'Rim',
                value: product.tireSpec != null
                    ? 'R${product.tireSpec!.rimDiameter}'
                    : 'N/A',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a single specification item.
  Widget _buildSpecItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the bottom action buttons.
  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Delete Button
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                _showDeleteConfirmation(context);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.error),
                foregroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Delete Product',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Edit Button
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                final result = await context.push(
                  '/admin/products/${widget.productId}/edit',
                );
                if (result == true) {
                  // Refresh detail data after edit
                  _bloc.add(GetProductDetailEvent(productId: widget.productId));
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.textPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Edit Product',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows delete confirmation dialog.
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product?'),
        content: const Text(
          'Are you sure you want to delete this product? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop(true); // Return true to indicate deletion
              _bloc.add(DeleteProductEvent(productId: widget.productId));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Returns stock status information.
  ({Color color, String label}) _getStockStatus(Product product) {
    if (product.stockQuantity <= 0) {
      return (color: AppColors.error, label: 'Out of Stock');
    } else if (product.stockQuantity <= 10) {
      return (color: AppColors.warning, label: 'Low Stock');
    } else {
      return (color: AppColors.success, label: 'In Stock');
    }
  }
}
