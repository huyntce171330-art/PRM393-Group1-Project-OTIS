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
import 'dart:async';
import 'package:frontend_otis/presentation/bloc/auth/auth_bloc.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_state.dart';
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
import 'package:frontend_otis/presentation/bloc/notification/notification_bloc.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_state.dart';
import 'package:frontend_otis/core/utils/ui_utils.dart';
import 'package:frontend_otis/presentation/widgets/common/nav_bar.dart';
import 'package:frontend_otis/presentation/widgets/filter/smart_filter_sheet.dart';
import 'package:frontend_otis/presentation/bloc/chat/chat_bloc.dart';
import 'package:frontend_otis/presentation/widgets/chat/chat_bottom_sheet.dart';
import 'package:frontend_otis/core/network/socket_service.dart';
import 'package:frontend_otis/domain/usecases/chat/get_room_by_user_id_usecase.dart';
import 'package:frontend_otis/domain/usecases/chat/insert_message_usecase.dart';
import 'package:frontend_otis/domain/usecases/chat/mark_room_messages_as_read_usecase.dart';
import 'package:frontend_otis/domain/usecases/chat/get_unread_count_for_room_usecase.dart';

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
  bool _chatInitialized = false;
  static const String _socketUrl = 'http://10.0.2.2:3000';

  StreamSubscription? _chatBadgeSub;
  bool _isChatSheetOpen = false;

  int? get _currentUserId {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      return int.tryParse(authState.user.id);
    }
    return null;
  }

  Future<int?> _getCurrentRoomId() async {
    final userId = _currentUserId;
    if (userId == null) return null;
    final result = await sl<GetRoomByUserIdUseCase>()(userId);
    return result.fold((_) => null, (id) => id);
  }

  Future<void> _initUserChatBadge() async {
    final userId = _currentUserId;
    if (userId == null) return;

    final roomId = await _getCurrentRoomId();
    if (roomId == null) return;

    SocketService.instance.reset();
    SocketService.instance.connect(url: _socketUrl, userId: userId);

    SocketService.instance.joinRoom(roomId, userId: userId);

    await _chatBadgeSub?.cancel();
    _chatBadgeSub = SocketService.instance.messageStream.listen((msg) async {
      final msgRoomId = msg['roomId'] ?? msg['room_id'];
      final senderId = msg['senderId'] ?? msg['sender_id'];
      final content = (msg['content'] ?? '').toString();
      final createdAt = (msg['createdAt'] ?? msg['created_at'])?.toString();

      if (_isChatSheetOpen) return;

      if (msgRoomId == roomId &&
          senderId != null &&
          senderId != userId &&
          content.isNotEmpty) {
        await sl<InsertMessageUseCase>()(
          roomId: roomId,
          senderId: senderId as int,
          content: content,
          createdAt: createdAt,
          isRead: 0,
        );

        if (mounted) setState(() {});
      }
    });
  }

  // Banner data
  final List<Map<String, String>> _banners = [
    {
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCyc2sGVAca2Hw2aS4Y_yRr3Gs5HWz9pU4Vo4gA3DyIiH6CxKUQZM9KBnWsDrm6vUHjvalu5KFk2bqELSmtQTX6FHAyC8ugZyVJSkIwB4gJacnqvzewp6a068UQDvDUxFShoWWbHougyHjr0tFz3E38fX8e0bnTUpya-P0mXW-gpOnMXrouIAk-CfEQDty2j_IyRoVWxLGxgTpoZPkOiBdsrKMr11t_toXU241N8Ja6dUF9OLHqJr0gtsGJGDLSAPPRVeX6Ish-URE',
      'title': 'Summer Sale',
      'subtitle': '15% off all Michelin Tires',
      'badge': 'PROMO',
    },
    {
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCsAl8SBoQTX23DBYA0h8vlyPvXJeoaQNmGIcyjbZnAVEpHii-NZpA7Fw6yOFQhV_9aQCt7RKwkI2pSgT3gcuPzLI7T5U8rP0cjFht7N8ceWpi9U5VFMUQDvDUxFShoWWbHougyHjr0tFz3E38fX8e0bnTUpya-P0mXW_WzqGzGdLBjQlCOpvNJi9zrdgkVMHNA3OMRHfV3r2DYQceWoAbrG8Y8Sd0FSWye0kd1CYzyVZzqZjuOrlX_tMB7075TbByjMzwik2bskLA',
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_chatInitialized) {
      _chatInitialized = true;
      _initUserChatBadge();
    }
  }

  @override
  void dispose() {
    _chatBadgeSub?.cancel();
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

  Future<void> _openSmartFilter(BuildContext context) async {
    final filter = await SmartFilterSheet.show(context);
    if (filter != null && mounted) {
      // Navigate to product list with the filter
      context.push('/products', extra: filter).then((_) {
        if (mounted) {
          _productBloc.add(const RestoreProductListEvent());
        }
      });
    }
  }

  void _navigateToProductList() {
    context.push('/products');
  }

  void _navigateToProductDetail(Product product) {
    // Use push() to maintain back stack, allowing user to navigate back
    context.push('/product/${product.id}').then((_) {
      if (mounted) {
        _productBloc.add(const RestoreProductListEvent());
      }
    });
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

  Future<void> _openChatBottomSheet() async {
    final userId = _currentUserId;
    if (userId == null) return;

    final roomId = await _getCurrentRoomId();
    if (roomId == null) return;

    _isChatSheetOpen = true;

    await sl<MarkRoomMessagesAsReadUseCase>()(roomId: roomId, viewerId: userId);

    if (mounted) setState(() {});

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider(
          create: (_) => sl<ChatBloc>(),
          child: ChatBottomSheet(
            roomId: roomId,
            userId: userId,
            peerTitle: 'Admin',
            socketUrl: _socketUrl,
          ),
        );
      },
    );

    _isChatSheetOpen = false;
    if (mounted) setState(() {});
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
        floatingActionButton: FutureBuilder<int?>(
          future: _getCurrentRoomId(),
          builder: (context, roomSnap) {
            final roomId = roomSnap.data;
            final userId = _currentUserId;

            if (roomId == null || userId == null) {
              return FloatingActionButton(
                onPressed: _openChatBottomSheet,
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.chat_bubble, color: Colors.white),
              );
            }

            return FutureBuilder<int>(
              future: sl<GetUnreadCountForRoomUseCase>()(
                roomId: roomId,
                viewerId: userId,
              ).then((res) => res.getOrElse(() => 0)),
              builder: (context, snap) {
                final unread = snap.data ?? 0;
                final badgeText = unread > 9 ? '9+' : unread.toString();

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FloatingActionButton(
                      onPressed: _openChatBottomSheet,
                      backgroundColor: AppColors.primary,
                      child: const Icon(Icons.chat_bubble, color: Colors.white),
                    ),
                    if (unread > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 22,
                            minHeight: 22,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              badgeText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
        // Bottom Navigation
        bottomNavigationBar: NavBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 3) {
              context.push('/profile');
            }
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
                  suffixIcon: GestureDetector(
                    onTap: () => _openSmartFilter(context),
                    child: Icon(Icons.tune, color: Colors.grey[400], size: 20),
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

          // Notifications
          GestureDetector(
            onTap: () => context.push('/notifications'),
            child: _buildNotificationIcon(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const size = 40.0;

    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        final unreadCount = state is NotificationLoaded
            ? state.notifications.where((n) => !n.isRead).length
            : 0;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(size / 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_outlined,
                color: isDarkMode ? Colors.white : Colors.grey[600],
                size: 24,
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
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
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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
                  UiUtils.showComingSoon(context, featureName: 'All Services');
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
                        UiUtils.showComingSoon(
                          context,
                          featureName: service['label'] as String,
                        );
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Products',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: _navigateToProductList,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Explore',
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
        const SizedBox(height: 12),

        // Products Horizontal List
        SizedBox(
          height: isSmallScreen ? 230 : 250,
          child: state is ProductLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : state is ProductLoaded
              ? ListView.builder(
                  padding: const EdgeInsets.only(left: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.products.length,
                  cacheExtent: 1000,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return Container(
                      width: cardWidth,
                      margin: const EdgeInsets.only(right: 12),
                      child: ProductCard(
                        product: product,
                        onTap: () => _navigateToProductDetail(product),
                        onAddToCart: () => _onAddToCart(product),
                      ),
                    );
                  },
                )
              : state is ProductError
              ? Center(child: Text(state.message))
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
