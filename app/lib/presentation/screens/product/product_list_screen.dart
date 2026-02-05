// Product list screen.
//
// Features:
// - Header with search bar and avatar
// - Products grid with pagination
// - Loading, empty, and error states
// - Pull to refresh
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/presentation/bloc/product/product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/product/product_event.dart';
import 'package:frontend_otis/presentation/bloc/product/product_state.dart';
import 'package:frontend_otis/presentation/widgets/product/product_card.dart';
import 'package:frontend_otis/presentation/widgets/search_bar.dart';

// DEBUG LOGGING HELPER - Use debugPrint for Flutter
const String _kSessionId = 'debug-session';

void _logDebug({
  required String location,
  required String message,
  required Map<String, dynamic> data,
}) {
  debugPrint('[$_kSessionId] $location | $message | ${data.toString()}');
}

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

  @override
  void initState() {
    super.initState();
    _productBloc.add(const ProductEvent.getProducts(filter: ProductFilter()));
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // DEBUG PAGINATION: Log every scroll event with detailed info
    final pixels = _scrollController.position.pixels;
    final maxExtent = _scrollController.position.maxScrollExtent;
    final triggerThreshold = maxExtent * 0.8;
    final willTrigger = pixels >= triggerThreshold;
    final state = _productBloc.state;
    final isLoaded = state is ProductLoaded;
    final hasMore = isLoaded ? state.hasMore : false;
    final isLoadingMore = isLoaded ? state.isLoadingMore : false;
    final canLoadMore = isLoaded && hasMore && !isLoadingMore;

    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('[$_kSessionId] PAGINATION DEBUG');
    debugPrint('  Scroll: pixels=${pixels.toStringAsFixed(0)}/${maxExtent.toStringAsFixed(0)} (${maxExtent > 0 ? (pixels/maxExtent*100).toStringAsFixed(1) : 0}%)');
    debugPrint('  Threshold: >=${(triggerThreshold).toStringAsFixed(0)} (80% of $maxExtent)');
    debugPrint('  Will Trigger: $willTrigger');
    debugPrint('  State: ${state.runtimeType}');
    debugPrint('  hasMore: $hasMore | isLoadingMore: $isLoadingMore');
    debugPrint('  Can Load More: $canLoadMore');
    debugPrint('═══════════════════════════════════════════════════════');

    if (willTrigger && canLoadMore) {
      final currentFilter = state.filter;
      final nextPage = currentFilter.page + 1;
      final nextFilter = currentFilter.copyWith(page: nextPage);

      debugPrint('🚀 TRIGGERING PAGINATION: Page $nextPage');

      _productBloc.add(ProductEvent.getProducts(filter: nextFilter));
    }
  }

  void _onSearchChanged() {
    _productBloc.add(
      ProductEvent.searchProducts(query: _searchController.text),
    );
  }

  Future<void> _onRefresh() async {
    // Lấy filter từ state, giữ nguyên filter khi refresh
    final state = _productBloc.state;
    final currentFilter = state is ProductLoaded
        ? state.filter
        : const ProductFilter();
    final refreshFilter = currentFilter.copyWith(page: 1);
    _productBloc.add(ProductEvent.getProducts(filter: refreshFilter));
  }

  void _navigateToProductDetail(Product product) {
    // TODO: Navigate to product detail
    // Navigator.pushNamed(context, '/product/${product.id}');
  }

  void _onAddToCart(Product product) {
    // TODO: Add to cart logic
    // context.read<CartBloc>().add(AddToCartEvent(product: product));
  }

  void _navigateBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // HYPOTHESIS B & D: Log build context and layout info
    _logDebug(
      location: 'product_list_screen.dart:build',
      message: 'Building ProductListScreen',
      data: {
        'isDarkMode': isDarkMode,
        'screenSize': 'checking MediaQuery...',
      },
    );

    return Scaffold(
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
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
            child: SearchBarWithFilter(
              controller: _searchController,
              hintText: 'Search for tires, batteries...',
              onChanged: (_) => _onSearchChanged(),
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
    // Products từ state (Bloc đã handle append)
    final currentProducts = state.products ?? [];

    // HYPOTHESIS B: Check GridView shrinkWrap overflow
    // HYPOTHESIS C: Check padding accumulation
    _logDebug(
      location: 'product_list_screen.dart:_buildAllProductsGrid',
      message: 'Building products grid',
      data: {
        'productsCount': currentProducts.length,
        'stateType': state.runtimeType.toString(),
        'stateHasProducts': currentProducts.isNotEmpty,
      },
    );

    // Handle different states
    if (state is ProductLoading) {
      _logDebug(
        location: 'product_list_screen.dart',
        message: 'STATE: ProductLoading',
        data: {
          'currentProductsEmpty': currentProducts.isEmpty,
        },
      );

      if (currentProducts.isEmpty) {
        return _buildLoadingSkeleton();
      }
      // Nếu đã có products, hiển thị products + loading indicator ở cuối
      return _buildProductsScrollView(
        context,
        currentProducts,
        isLoadingMore: true,
      );
    }

    if (state is ProductError) {
      _logDebug(
        location: 'product_list_screen.dart',
        message: 'STATE: ProductError',
        data: {
          'errorMessage': state.errorMessage,
          'currentProductsEmpty': currentProducts.isEmpty,
        },
      );

      if (currentProducts.isEmpty) {
        return _buildErrorState(context, state.errorMessage ?? 'Unknown error');
      }
      // Nếu đã có products nhưng có lỗi, vẫn hiện products + error message
      return _buildProductsScrollView(
        context,
        currentProducts,
        isLoadingMore: false,
      );
    }

    if (state is ProductLoaded && currentProducts.isEmpty) {
      _logDebug(
        location: 'product_list_screen.dart',
        message: 'STATE: ProductLoaded - EMPTY',
        data: {
          'totalCount': state.totalCount,
        },
      );
      return _buildEmptyState(context);
    }

    // Hiển thị grid với products từ state
    // Lấy pagination info từ state
    final totalCount = state.totalCount;
    final totalPages = state.totalPages;
    final currentPage = state.currentPage;

    _logDebug(
      location: 'product_list_screen.dart',
      message: 'STATE: ProductLoaded - WITH PRODUCTS',
      data: {
        'productsCount': currentProducts.length,
        'totalCount': totalCount,
        'totalPages': totalPages,
        'hasMore': state.hasMore,
      },
    );

    // FIX: Use CustomScrollView instead of Column + GridView to avoid overflow
    // FIX: Add scrollController to CustomScrollView for pagination detection
    return CustomScrollView(
      controller: _scrollController, // CRITICAL: Attach scroll controller for pagination
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

  /// Widget SliverGrid với pagination support - FIX for overflow issue
  Widget _buildProductsSliverGrid(
    BuildContext context,
    List<Product> products, {
    bool isLoadingMore = false,
  }) {
    _logDebug(
      location: 'product_list_screen.dart:_buildProductsSliverGrid',
      message: 'Building products sliver grid',
      data: {
        'productsLength': products.length,
        'isLoadingMore': isLoadingMore,
      },
    );

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Show loading indicator at the bottom
          if (index >= products.length) {
            return _buildLoadMoreIndicator();
          }

          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () => _navigateToProductDetail(product),
            onAddToCart: () => _onAddToCart(product),
          );
        },
        childCount: isLoadingMore ? products.length + 1 : products.length,
      ),
    );
  }

  /// Helper method to build products scroll view (used for loading/error states)
  Widget _buildProductsScrollView(
    BuildContext context,
    List<Product> products, {
    bool isLoadingMore = false,
  }) {
    _logDebug(
      location: 'product_list_screen.dart:_buildProductsScrollView',
      message: 'Building products scroll view',
      data: {
        'productsLength': products.length,
        'isLoadingMore': isLoadingMore,
      },
    );

    return CustomScrollView(
      controller: _scrollController, // CRITICAL: Attach scroll controller for pagination
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
        _buildProductsSliverGrid(context, products, isLoadingMore: isLoadingMore),
      ],
    );
  }

  /// Helper widget hiển thị page dots indicator
  Widget _buildPageDotsIndicatorForList({
    required int totalCount,
    required int totalPages,
    required int currentPage,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // HYPOTHESIS C: Log page indicator dimensions
    _logDebug(
      location: 'product_list_screen.dart:_buildPageDotsIndicator',
      message: 'Building page dots indicator',
      data: {
        'totalCount': totalCount,
        'totalPages': totalPages,
        'currentPage': currentPage,
      },
    );

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
    _logDebug(
      location: 'product_list_screen.dart:_buildLoadingSkeleton',
      message: 'Building loading skeleton',
      data: {'isDarkMode': isDarkMode},
    );

    // FIX: Use CustomScrollView + SliverGrid instead of Column + GridView
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
    _logDebug(
      location: 'product_list_screen.dart:_buildErrorState',
      message: 'Building error state',
      data: {
        'message': message,
        'isDarkMode': isDarkMode,
      },
    );

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
    _logDebug(
      location: 'product_list_screen.dart:_buildEmptyState',
      message: 'Building empty state',
      data: {'isDarkMode': isDarkMode},
    );

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
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8, top: 8),
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
            badgeCount: 2,
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
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isSelected ? AppColors.primary : Colors.grey[400];
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () {
            // TODO: Navigate to cart
          },
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
            child: Text(
              '$badgeCount',
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
