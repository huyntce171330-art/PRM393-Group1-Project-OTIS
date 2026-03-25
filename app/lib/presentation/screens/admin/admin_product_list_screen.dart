// Admin Product List Screen for inventory management.
//
// Features:
// - Header with menu button, title, notifications, and avatar
// - Search bar for finding products
// - Filter chips for brand and stock status
// - Product list with edit and delete actions
// - Floating action button for adding new products
// - Pull to refresh
// - Loading, empty, and error states
//
// Based on UI reference from admin_product_list_1/code.html
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';
import 'package:frontend_otis/domain/usecases/product/get_brands_usecase.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_event.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_state.dart';
import 'package:frontend_otis/presentation/widgets/admin/admin_filter_chip.dart';
import 'package:frontend_otis/presentation/widgets/admin/admin_product_card.dart';
import 'package:frontend_otis/presentation/widgets/admin/admin_header.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_profile_screen.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_bloc.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_state.dart';
import 'package:frontend_otis/core/injections/injection_container.dart' as di;

/// Admin Product List Screen for inventory management.
class AdminProductListScreen extends StatefulWidget {
  const AdminProductListScreen({super.key});

  @override
  State<AdminProductListScreen> createState() => _AdminProductListScreenState();
}

class _AdminProductListScreenState extends State<AdminProductListScreen> {
  late final AdminProductBloc _adminProductBloc;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Debounce timer for search
  Timer? _debounceTimer;

  // Brands loaded from database for filter chips
  List<BrandModel> _brands = [];

  @override
  void initState() {
    super.initState();
    // Use existing Bloc from parent BlocProvider (shared with detail screen)
    _adminProductBloc = BlocProvider.of<AdminProductBloc>(context);
    // Load products - will use cached data if filter is preserved
    _adminProductBloc.add(const GetAdminProductsEvent(filter: null));
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
    // Load brands for filter chips
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    final getBrandsUsecase = GetBrandsUsecase(productRepository: sl());
    final result = await getBrandsUsecase();
    result.fold(
      (failure) {
        print('DEBUG: Failed to load brands: $failure');
      },
      (brands) {
        if (mounted) {
          setState(() => _brands = brands);
        }
      },
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pixels = _scrollController.position.pixels;
    final maxExtent = _scrollController.position.maxScrollExtent;
    final triggerThreshold = maxExtent * 0.8;
    final willTrigger = pixels >= triggerThreshold;
    final state = _adminProductBloc.state;

    if (willTrigger &&
        state is AdminProductLoaded &&
        state.hasMore &&
        !state.isLoadingMore) {
      _adminProductBloc.loadNextPage();
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();

    // Cancel previous debounce timer
    _debounceTimer?.cancel();

    // Empty query - show all products
    if (query.isEmpty) {
      _adminProductBloc.searchProducts('');
      return;
    }

    // Minimum 2 characters required for search
    if (query.length < 2) {
      // Don't call API, just return (hint will be shown by UI)
      return;
    }

    // Sanitize input to prevent XSS/SQL injection
    final sanitizedQuery = _sanitizeSearchInput(query);

    // Debounce API call by 300ms
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _adminProductBloc.searchProducts(sanitizedQuery);
    });
  }

  /// Sanitizes search input to prevent XSS and SQL injection attacks.
  String _sanitizeSearchInput(String input) {
    String result = input;

    // Remove HTML tags
    result = result.replaceAll(RegExp(r'<[^>]*>'), '');
    // Remove HTML entities
    result = result.replaceAll(RegExp(r'&[#a-zA-Z0-9]+;'), '');

    // Remove special characters that could be used for injection
    const specialChars = '<>&"\'\\;';
    for (final char in specialChars.split('')) {
      result = result.replaceAll(char, '');
    }

    return result.trim();
  }

  Future<void> _onRefresh() async {
    _adminProductBloc.refresh();
  }

  void _onEditProduct(BuildContext context, String productId) async {
    // Navigate to edit product screen and wait for result
    final result = await context.push('/admin/products/$productId/edit');

    // If product was updated, silently refresh to get fresh data
    if (result == true) {
      _adminProductBloc.silentRefresh();
      return;
    }

    // CRITICAL FIX: Restore List state from cache when just viewing
    _adminProductBloc.add(
      GetAdminProductsEvent(filter: _adminProductBloc.currentFilter),
    );
  }

  void _onDeleteProduct(BuildContext context, String productId) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _adminProductBloc.deleteProduct(productId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onAddProduct() async {
    // Navigate to create product screen and wait for result
    final result = await context.push('/admin/products/create');

    // If product was created, silently refresh to get new data
    if (result == true) {
      _adminProductBloc.silentRefresh();
      return;
    }

    // Restore list state from cache when just viewing
    _adminProductBloc.add(
      GetAdminProductsEvent(filter: _adminProductBloc.currentFilter),
    );
  }

  void _onProductTap(String productId) async {
    // 1. Wait for result from Detail page
    final result = await context.push('/admin/products/$productId');

    // 2. Only force reload if product was DELETED
    if (result == true) {
      print('DEBUG: Product was deleted, reloading list...');
      final newFilter = _adminProductBloc.currentFilter.withPage(1);
      _adminProductBloc.add(
        GetAdminProductsEvent(filter: newFilter, showInactive: false),
      );
      return;
    }

    // 3. For normal navigation back - RESTORE FROM CACHE
    // The Bloc cached products before navigating to detail
    // Pass filter: null to trigger useCache logic in Bloc
    final currentState = _adminProductBloc.state;
    final isInListState = currentState is AdminProductLoaded;

    if (!isInListState) {
      // State is not loaded (e.g., DetailLoaded), restore from cache
      // Pass null filter to use Bloc's cache
      print('DEBUG: Restoring list state from cache...');
      _adminProductBloc.add(
        GetAdminProductsEvent(filter: null, showInactive: false),
      );
    } else {
      print(
        'DEBUG: Already in Loaded state with ${currentState.products.length} products',
      );
    }
  }

  void _onFilterByBrand(String? brandName) {
    _adminProductBloc.filterByBrand(brandName);
  }

  void _onFilterByStockStatus() {
    // Toggle low stock filter
    final currentState = _adminProductBloc.state;
    if (currentState is AdminProductLoaded) {
      if (currentState.stockStatus == StockStatus.lowStock) {
        _adminProductBloc.filterByStockStatus(StockStatus.all);
      } else {
        _adminProductBloc.filterByStockStatus(StockStatus.lowStock);
      }
    }
  }

  void _onNavigateToTrash() async {
    // Navigate to trash screen and wait for result
    await context.push('/admin/products/trash');

    // CRITICAL FIX: Always refresh the list when returning from Trash screen
    // The BLoC is still in "trash" state (showing deleted products) after returning
    // We must restore it to normal "active products" state
    _adminProductBloc.add(
      GetAdminProductsEvent(
        filter: _adminProductBloc.currentFilter,
        showInactive: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AdminHeader(
          showBack: false,
          actions: [
            BlocProvider.value(
              value: di.sl<NotificationBloc>(),
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  final unreadCount = state is NotificationLoaded
                      ? state.notifications.where((n) => !n.isRead).length
                      : 0;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () => context.push('/admin/notifications'),
                        icon: const Icon(Icons.notifications_outlined),
                        color: Colors.black,
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminProfileScreen(),
                  ),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuD8YWidUUkqIitQsKH0Xj1BREkpvbhijdepzuqA_Da7KY6sVqLLfwQgwKUF9ajSgmIMnTK0j4b0lW5CkUPGvtwFsjNt2kHd8yr7_dEwL5bx51eY3jU3_u31A2YSvWEFA00LNez6c73az5gA1bCFT0EEn4VjFiJVlHZn88Ebl-X_XiKkoFtdil-UCs5KFqAl7wEnKq8OLGx60Cizj1NUiG97bPDbHHbp5LaKFDQzgFSHOcwQW9yHMP5fpRLrvtR7YpdR7Wd2dLwd7G4',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: BlocProvider<AdminProductBloc>.value(
          value: _adminProductBloc,
          child: BlocListener<AdminProductBloc, AdminProductState>(
            listenWhen: (previous, current) => current is AdminProductDeleted,
            listener: (context, state) {
              if (state is AdminProductDeleted) {
                // Show success feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product deleted successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: BlocBuilder<AdminProductBloc, AdminProductState>(
              builder: (context, state) {
                return Container(
                  color: isDarkMode
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Inventory Title Section with Trash
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Inventory',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: isDarkMode
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                              IconButton(
                                onPressed: _onNavigateToTrash,
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: isDarkMode
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: _buildSearchBar(),
                        ),
                        const SizedBox(height: 8),
                        // Filter Chips Section
                        _buildFilterChips(state),
                        // Main Content - Product List
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _onRefresh,
                            color: AppColors.primary,
                            child: _buildProductList(context, state),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ), // Floating Action Button - Add Product
        floatingActionButton: FloatingActionButton(
          onPressed: _onAddProduct,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDarkMode ? const Color(0xFF1A2230) : Colors.white;
    final textSub = isDarkMode ? Colors.grey[400]! : const Color(0xFF896161);
    const primaryColor = Color(0xFFEC1313);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: (_) => _onSearchChanged(),
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: textSub, size: 20),
          hintText: 'Search tire size, brand...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (context, value, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (value.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.close, color: textSub, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged();
                      },
                    ),
                  Icon(Icons.tune, color: primaryColor, size: 20),
                  const SizedBox(width: 4),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(AdminProductState state) {
    String? selectedBrand = state.selectedBrand;
    bool isLowStockSelected = state.stockStatus == StockStatus.lowStock;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Brand filter chips - use dynamic brands from database
          ...AdminBrandFilters.createBrandChips(
            brands: _brands,
            selectedBrand: selectedBrand,
            onSelect: _onFilterByBrand,
          ),
          const SizedBox(width: 8),
          // Low Stock filter chip
          LowStockFilterChip(
            isSelected: isLowStockSelected,
            onTap: _onFilterByStockStatus,
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context, AdminProductState state) {
    final currentProducts = state.products;

    // Handle different states
    if (state is AdminProductLoading && currentProducts.isEmpty) {
      return _buildLoadingSkeleton();
    }

    if (state is AdminProductError && currentProducts.isEmpty) {
      return _buildErrorState(context, state.errorMessage ?? 'Unknown error');
    }

    if (state is AdminProductLoaded && currentProducts.isEmpty) {
      return _buildEmptyState(context);
    }

    // Display list with products
    return CustomScrollView(
      key: const PageStorageKey('admin_product_list'),
      controller: _scrollController,
      slivers: [
        // Silent refresh indicator
        if (state is AdminProductLoaded && state.isRefreshing)
          SliverToBoxAdapter(
            child: LinearProgressIndicator(
              color: AppColors.primary,
              minHeight: 2,
            ),
          ),
        // Product List
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final product = currentProducts[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: AdminProductCard(
                product: product,
                onEdit: () => _onEditProduct(context, product.id),
                onDelete: () => _onDeleteProduct(context, product.id),
                onTap: () => _onProductTap(product.id),
              ),
            );
          }, childCount: currentProducts.length),
        ),
        // Loading more indicator
        if (state is AdminProductLoaded && state.isLoadingMore)
          SliverToBoxAdapter(child: _buildLoadMoreIndicator()),
        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildProductSkeleton();
      },
    );
  }

  Widget _buildProductSkeleton() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Image placeholder
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          // Info placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
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

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Center(
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
                  color: isDarkMode
                      ? Colors.grey[400]
                      : AppColors.textSecondary,
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
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Center(
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
                  color: isDarkMode
                      ? Colors.grey[400]
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
