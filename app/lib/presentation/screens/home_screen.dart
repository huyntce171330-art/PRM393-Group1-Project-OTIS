// Home screen.
//
// Features:
// - Header with search bar and avatar
// - Promo banner carousel
// - Services categories grid
// - Featured products horizontal scroll
// - Bottom navigation bar
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
import 'package:frontend_otis/presentation/bloc/cart/cart_event.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_state.dart';
import 'package:frontend_otis/core/utils/ui_utils.dart';
import 'package:frontend_otis/presentation/widgets/nav_bar.dart';

/// Home screen - Main landing page.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductBloc _productBloc = sl<ProductBloc>();
  final PageController _bannerController = PageController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  int _currentBannerPage = 0;

  // Banner data
  final List<Map<String, String>> _banners = [
    {
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCyc2sGVAca2Hw2aS4Y_yRr3Gs5HWz9pU4Vo4gA3DyIiH6CxKUQZM9KBnWsDrm6vUHjvalu5KFk2bqELSmtQTX6FHAyC8ugZyVJSkIwB4gJacnqvzewp6a068ElACuqoFBJ1D8ewrQfZIo4gaAOh7CQnbFK5XUQ3V0BOoerbd-gpOnMXrouIAk-CfEQDty2j_IyRoVWxLGxgTpoZPkOiBdsrKMr11t_toXU241N8Ja6dUF9OLHqJr0gtsGJGDLSAPPRVeX6Ish-URE',
      'title': 'Summer Sale',
      'subtitle': '15% off all Michelin Tires',
      'badge': 'PROMO',
    },
    {
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCsAl8SBoQTX23DBYA0h8vlyPvXJeoaQNmGIcyjbZnAVEpHii-NZpA7Fw6yOFQhV_9aQCt7RKwkI2pSgT3gcuPzLI7T5U8rP0cjFht7N8ceWpi9U5VFMEndSir53sVq4OkSO2ejeziuYiY6HE67Ar5gVTRAlSa2cRYDZ_WzqGzGdLBjQlCOpvNJi9zrdgkVMHNA3OMRHfV3r2DYQceWoAbrG8Y8Sd0FSWye0kd1CYzyVZzqZjuOrlX_tMB7075TbByjMzwik2bskLA',
      'title': 'Bridgestone Deals',
      'subtitle': 'Buy 3 Get 1 Free on select models',
      'badge': 'NEW',
    },
  ];

  // Services categories data
  final List<Map<String, dynamic>> _services = [
    {'icon': Icons.directions_car, 'label': 'Passenger'},
    {'icon': Icons.local_shipping, 'label': 'Truck'},
    {'icon': Icons.oil_barrel, 'label': 'Oil'},
    {'icon': Icons.battery_charging_full, 'label': 'Battery'},
  ];

  @override
  void initState() {
    super.initState();
    _productBloc.add(const GetProductsEvent(filter: ProductFilter()));
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearAndUnfocus() {
    _searchController.clear();
    _onSearchChanged(); // Trigger search with empty query
    FocusScope.of(context).unfocus();
  }

  void _onSearchChanged() {
    _productBloc.add(SearchProductsEvent(query: _searchController.text));
  }

  void _navigateToProductList() {
    context.push('/products');
  }

  void _navigateToProductDetail(Product product) {
    // Use push() to maintain back stack, allowing user to navigate back
    context.push('/product/${product.id}');
  }

  void _onAddToCart(Product product) {
    context.read<CartBloc>().add(
      AddProductToCartEvent(product: product, quantity: 1),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    UiUtils.showSuccessPopup(context, '${product.name} added to cart');
  }

  Future<void> _onRefresh() async {
    _productBloc.add(const GetProductsEvent(filter: ProductFilter()));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmallScreen = screenWidth < 360;
    final bannerHeight = isSmallScreen ? 140.0 : 160.0;
    final serviceIconSize = isSmallScreen ? 48.0 : 52.0;
    final productCardWidth = isSmallScreen ? 140.0 : 155.0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: isDarkMode
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        body: BlocProvider<ProductBloc>.value(
          value: _productBloc,
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return SafeArea(
                child: Column(
                  children: [
                    // Header Section
                    _buildHeader(context),
                    // Main Content
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: AppColors.primary,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Promo Banner Carousel
                              _buildPromoBanner(context, bannerHeight),
                              const SizedBox(height: 16),
                              // Services Categories Grid
                              _buildServicesSection(
                                context,
                                serviceIconSize,
                                isSmallScreen,
                              ),
                              const SizedBox(height: 16),
                              // All Products Section
                              _buildAllProductsSection(
                                context,
                                state,
                                productCardWidth,
                                isSmallScreen,
                              ),
                              SizedBox(
                                height:
                                    kBottomNavigationBarHeight +
                                    (isSmallScreen ? 8 : 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Bottom Navigation
        bottomNavigationBar: NavBar(
          currentIndex: 0,
          onTap: (index) {
            // Logic for other tabs can be added here
          },
        ),
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
                    gapPadding: 0,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Admin Button (Temporary for demo)
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            color: isDarkMode ? Colors.white : AppColors.primary,
            onPressed: () => context.push('/admin/orders'),
          ),
          const SizedBox(width: 8),
          // Avatar
          GestureDetector(
            onTap: () => context.push('/orders'),
            child: _buildAvatar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const avatarSize = 40.0;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(avatarSize / 2),
        border: Border.all(
          color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
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
        borderRadius: BorderRadius.circular(avatarSize / 2),
        child: Image.network(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDoMz-m7oRFdmKmL5PET_dO5sHFaZjichh44_wwwVs0PAlFU_gDPh2pCfn8-wMnRVEn4YXj4ItTQPDv__swxN9ylZtQQOFbIj6TbFNDn9zwJ3VV3vTbl_nnCo-_vfPEgtR9P53rP28VZiBJ8zkE02TwgGupNiEf58xm-fuGju55E8qh6KhYsbpejjngMZ9D6baAxvyDZS13XwktZGri0Jlg16X9JOO4FGMduD-jXuaeur1QTVJKbiHQbInfJ6CYEXOrR9jIfjAOgl8',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              color: Colors.grey[400],
              size: avatarSize * 0.6,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context, double bannerHeight) {
    return Column(
      children: [
        SizedBox(
          height: bannerHeight,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (page) {
              setState(() {
                _currentBannerPage = page;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      // Background image
                      Positioned.fill(
                        child: Image.network(
                          banner['imageUrl']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                            );
                          },
                        ),
                      ),
                      // Gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.85),
                                Colors.black.withValues(alpha: 0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Content
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: banner['badge'] == 'PROMO'
                                    ? AppColors.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                banner['badge']!,
                                style: TextStyle(
                                  color: banner['badge'] == 'PROMO'
                                      ? Colors.white
                                      : AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Title
                            Text(
                              banner['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            // Subtitle
                            Text(
                              banner['subtitle']!,
                              style: TextStyle(
                                color: Colors.grey[200],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentBannerPage == index
                    ? AppColors.primary
                    : Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection(
    BuildContext context,
    double iconSize,
    bool isSmallScreen,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final spacing = isSmallScreen ? 8.0 : 12.0;
    final crossAxisSpacing = isSmallScreen ? 8.0 : 12.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Services',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: View all services
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Services Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: spacing,
              childAspectRatio: 1,
            ),
            itemCount: _services.length,
            itemBuilder: (context, index) {
              final service = _services[index];
              return Column(
                children: [
                  // Service Icon Button
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.surfaceDark
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.grey[800]!
                            : Colors.grey[100]!,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        // TODO: Navigate to service
                      },
                      icon: Icon(
                        service['icon'] as IconData,
                        size: iconSize * 0.45,
                        color: AppColors.primary,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Label
                  Expanded(
                    child: Text(
                      service['label'] as String,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 9 : 10,
                        color: isDarkMode
                            ? Colors.grey[300]
                            : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAllProductsSection(
    BuildContext context,
    ProductState state,
    double cardWidth,
    bool isSmallScreen,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    List<Product> allProducts = [];
    if (state is ProductLoaded && state.products.isNotEmpty) {
      allProducts = state.products;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : AppColors.textPrimary,
                ),
              ),
              // View All link
              GestureDetector(
                onTap: _navigateToProductList,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // All Products Horizontal List
        if (state is ProductLoading)
          SizedBox(
            height: isSmallScreen ? 190 : 210,
            child: const Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
          )
        else if (state is ProductLoaded && state.products.isNotEmpty)
          SizedBox(
            height: isSmallScreen ? 190 : 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemCount: allProducts.length,
              itemBuilder: (context, index) {
                final product = allProducts[index];
                return SizedBox(
                  width: cardWidth,
                  child: BlocBuilder<CartBloc, CartState>(
                    builder: (context, cartState) {
                      bool isInCart = false;
                      if (cartState is CartLoaded) {
                        isInCart = cartState.cartItems.any(
                          (item) => item.productId == product.id,
                        );
                      }
                      return ProductCard(
                        product: product,
                        onTap: () => _navigateToProductDetail(product),
                        isInCart: isInCart,
                        onViewCart: () => context.push('/cart'),
                        onAddToCart: () => _onAddToCart(product),
                      );
                    },
                  ),
                );
              },
            ),
          )
        else if (state is ProductError)
          Container(
            constraints: const BoxConstraints(minHeight: 150),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.message,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : AppColors.textPrimary,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _onRefresh,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
