// Product list screen.
//
// Features:
// - Header with search bar and avatar
// - Products grid with pagination
// - Loading, empty, and error states
// - Pull to refresh
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/presentation/bloc/product/product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/product/product_event.dart';
import 'package:frontend_otis/presentation/bloc/product/product_state.dart';
import 'package:frontend_otis/presentation/widgets/product/product_card.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_bloc.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_state.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_event.dart';

/// Product list screen.
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductBloc _productBloc = sl<ProductBloc>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _productBloc.add(const GetProductsEvent(filter: ProductFilter()));
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearAndUnfocus() {
    _searchController.clear();
    _onSearchChanged(); // Trigger search with empty query
    FocusScope.of(context).unfocus();
  }

  void _onScroll() {
    final pixels = _scrollController.position.pixels;
    final maxExtent = _scrollController.position.maxScrollExtent;
    final triggerThreshold = maxExtent * 0.8;
    final willTrigger = pixels >= triggerThreshold;
    final state = _productBloc.state;

    if (willTrigger &&
        state is ProductLoaded &&
        state.hasMore &&
        !state.isLoadingMore) {
      final currentFilter = state.filter;
      final nextPage = currentFilter.page + 1;
      final nextFilter = currentFilter.copyWith(page: nextPage);
      _productBloc.add(GetProductsEvent(filter: nextFilter));
    }
  }

  void _onSearchChanged() {
    _productBloc.add(SearchProductsEvent(query: _searchController.text));
  }

  Future<void> _onRefresh() async {
    // Get filter from state, preserve filter when refreshing
    final state = _productBloc.state;
    final currentFilter = state is ProductLoaded
        ? state.filter
        : const ProductFilter();
    final refreshFilter = currentFilter.copyWith(page: 1);
    _productBloc.add(GetProductsEvent(filter: refreshFilter));
  }

  void _navigateToProductDetail(BuildContext context, String productId) {
    // Navigate to product detail using GoRouter with push to maintain back stack
    context.push('/product/$productId');
  }

  void _navigateBack() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocProvider<ProductBloc>.value(
          value: _productBloc,
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return Container(
                color: isDarkMode
                    ? AppColors.backgroundDark
                    : AppColors.backgroundLight,
                child: SafeArea(
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      _buildHeader(context),
                      // Main Content - Expanded to take remaining space
                      Expanded(
                        flex: 1,
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          color: AppColors.primary,
                          child: _buildAllProductsGrid(context, state),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Bottom Navigation
        bottomNavigationBar: _buildBottomNavigation(context),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: isDarkMode
          ? AppColors.backgroundDark.withValues(alpha: 0.95)
          : AppColors.backgroundLight.withValues(alpha: 0.95),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: _navigateBack,
            icon: Icon(
              Icons.arrow_back,
              color: isDarkMode ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          // Search Bar
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(9999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                textInputAction: TextInputAction.done,
                onEditingComplete: _clearAndUnfocus,
                onChanged: (_) => _onSearchChanged(),
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search for tires, batteries...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  suffixIcon: Icon(
                    Icons.tune,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9999),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          _buildAvatar(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.surfaceDark
              : AppColors.surfaceLight,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9999),
        child: Image.network(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDoMz-m7oRFdmKmL5PET_dO5sHFaZjichh44_wwwVs0PAlFU_gDPh2pCfn8-wMnRVEn4YXj4ItTQPDv__swxN9ylZtQQOFbIj6TbFNDn9zwJ3VV3vTbl_nnCo-_vfPEgtR9P53rP28VZiBJ8zkE02TwgGupNiEf58xm-fuGju55E8qh6KhYsbpejjngMZ9D6baAxvyDZS13XwktZGri0Jlg16X9JOO4FGMduD-jXuaeur1QTVJKbiHQbInfJ6CYEXOrR9jIfxAOgl8',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.person, color: Colors.grey[400]);
          },
        ),
      ),
    );
  }

  Widget _buildAllProductsGrid(BuildContext context, ProductState state) {
    // Products from state (Bloc handles append)
    final currentProducts = state.products ?? [];

    // Handle different states
    if (state is ProductLoading) {
      if (currentProducts.isEmpty) {
        return _buildLoadingSkeleton();
      }
      // If products exist, show products + loading indicator at bottom
      return _buildProductsScrollView(
        context,
        currentProducts,
        isLoadingMore: true,
      );
    }

    if (state is ProductError) {
      if (currentProducts.isEmpty) {
        return _buildErrorState(context, state.errorMessage ?? 'Unknown error');
      }
      // If products exist but error occurred, still show products + error message
      return _buildProductsScrollView(
        context,
        currentProducts,
        isLoadingMore: false,
      );
    }

    if (state is ProductLoaded && currentProducts.isEmpty) {
      return _buildEmptyState(context);
    }

    // Display grid with products from state
    // Get pagination info from state
    final totalCount = state.totalCount;
    final totalPages = state.totalPages;
    final currentPage = state.currentPage;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Section Header - wrapped in SliverToBoxAdapter
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'All Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ),
        // Products Grid with pagination support
        _buildProductsSliverGrid(
          context,
          currentProducts,
          isLoadingMore: state.hasMore && state.isLoadingMore,
        ),
        // Page Dots Indicator - wrapped in SliverToBoxAdapter
        if (currentProducts.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildPageDotsIndicatorForList(
              totalCount: totalCount,
              totalPages: totalPages,
              currentPage: currentPage,
            ),
          ),
      ],
    );
  }

  /// Widget SliverGrid with pagination support
  Widget _buildProductsSliverGrid(
    BuildContext context,
    List<Product> products, {
    bool isLoadingMore = false,
  }) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        // Show loading indicator at the bottom
        if (index >= products.length) {
          return _buildLoadMoreIndicator();
        }

        final product = products[index];
        return _ProductGridItem(
          product: product,
          onTap: () => _navigateToProductDetail(context, product.id),
        );
      }, childCount: isLoadingMore ? products.length + 1 : products.length),
    );
  }

  /// Helper method to build products scroll view (used for loading/error states)
  Widget _buildProductsScrollView(
    BuildContext context,
    List<Product> products, {
    bool isLoadingMore = false,
  }) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'All Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ),
        // Products Grid
        _buildProductsSliverGrid(
          context,
          products,
          isLoadingMore: isLoadingMore,
        ),
      ],
    );
  }

  /// Helper widget displaying page dots indicator
  Widget _buildPageDotsIndicatorForList({
    required int totalCount,
    required int totalPages,
    required int currentPage,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        children: [
          Text(
            'Trang $currentPage / $totalPages ($totalCount sản phẩm)',
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages.clamp(1, 10), (index) {
              final page = index + 1;
              final isActive = page == currentPage;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 12 : 8,
                height: isActive ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? AppColors.primary
                      : (isDarkMode ? Colors.grey[600] : Colors.grey[300]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        // Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'All Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
        // Skeleton Grid
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildProductSkeleton(),
            childCount: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildProductSkeleton() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 80,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 16,
                  width: 100,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading products',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int cartItemCount = 0;
        if (state is CartLoaded) {
          cartItemCount = state.itemCount;
        }

        return Container(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 8,
            top: 8,
          ),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
            border: Border(
              top: BorderSide(
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home
              _buildNavItem(
                context,
                icon: Icons.home,
                label: 'Home',
                isSelected: false,
                onTap: _navigateBack,
              ),
              // Service
              _buildNavItem(
                context,
                icon: Icons.build,
                label: 'Service',
                isSelected: false,
              ),
              // Cart with badge
              _buildNavItemWithBadge(
                context,
                icon: Icons.shopping_cart,
                label: 'Cart',
                isSelected: false,
                badgeCount: cartItemCount,
                onTap: () => context.push('/cart'),
              ),
              // Account
              _buildNavItem(
                context,
                icon: Icons.person,
                label: 'Account',
                isSelected: false,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    final selectedColor = isSelected ? AppColors.primary : Colors.grey[400];
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: selectedColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: selectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemWithBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required int badgeCount,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isSelected ? AppColors.primary : Colors.grey[400];
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 24, color: selectedColor),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: selectedColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Badge
        if (badgeCount > 0)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  width: 2,
                ),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                badgeCount > 99 ? '99+' : '$badgeCount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Grid item widget with Hero animation support for product images.
///
/// Wraps [ProductCard] in a [Hero] widget to enable smooth
/// transition animations when navigating to the product detail screen.
class _ProductGridItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductGridItem({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'product_image_${product.id}',
      child: ProductCard(
        product: product,
        onTap: onTap,
        onAddToCart: () {
          context.read<CartBloc>().add(
            AddProductToCartEvent(product: product, quantity: 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${product.name} added to cart'),
              action: SnackBarAction(
                label: 'View Cart',
                onPressed: () => context.push('/cart'),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
