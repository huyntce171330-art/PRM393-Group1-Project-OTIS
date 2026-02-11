import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:frontend_otis/presentation/bloc/order/order_bloc.dart';
import 'package:frontend_otis/presentation/bloc/order/order_event.dart';
import 'package:frontend_otis/presentation/bloc/order/order_state.dart';
import 'package:go_router/go_router.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  String _activeTab = 'All';
  final List<String> _tabs = [
    'All',
    'Pending',
    'Processing',
    'Completed',
    'Cancelled',
  ];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(const GetOrdersEvent());
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Order> _getFilteredOrders(List<Order> orders) {
    return orders.where((order) {
      // Filter by tab
      bool matchesTab = true;
      if (_activeTab == 'Pending') {
        matchesTab = order.status == OrderStatus.pendingPayment;
      } else if (_activeTab == 'Processing') {
        matchesTab =
            (order.status == OrderStatus.processing ||
            order.status == OrderStatus.paid);
      } else if (_activeTab == 'Completed') {
        matchesTab = order.status == OrderStatus.completed;
      } else if (_activeTab == 'Cancelled') {
        matchesTab = order.status == OrderStatus.canceled;
      }

      // Filter by search query
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        matchesSearch =
            order.code.toLowerCase().contains(_searchQuery) ||
            order.shippingAddress.toLowerCase().contains(_searchQuery);
      }

      return matchesTab && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFFEC1313);
    final bgColor = isDarkMode
        ? const Color(0xFF221010)
        : const Color(0xFFF8F6F6);
    final surfaceColor = isDarkMode ? const Color(0xFF361B1B) : Colors.white;
    final textMain = isDarkMode ? Colors.white : const Color(0xFF181111);
    final textSub = isDarkMode ? Colors.grey[400]! : const Color(0xFF896161);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'TP Tire Shop',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none, color: textMain),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: surfaceColor, width: 2),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 8),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: const NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAi4sYgmQPIM6M3CzGbezCW9ZxiPKCGcLd9SUZfxwsX4OmsAse7fPac0hAiWvf6eSSoFelIJmtVkBU3SgIUe8V2Tfu9kZzAkiONq36Y_eD8H0LjhFv3KamqwRujw67qzjSEn_213l1KQ66MEj6KN8nv5veXu_0fBJrkTW1wVlykVO7rV8A--pSS_hLoVdIE5QN5odc5EQtKJMijCK8NkkyxXQO3SAotJhCapl5SHbGiT9tlKtR_yT6PXdzSwWiux4e2DQmQ-tH4uQM',
              ),
              backgroundColor: Colors.grey[300]!,
            ),
          ),
        ],
        shape: Border(
          bottom: BorderSide(
            color: isDarkMode ? const Color(0xFF4A2A2A) : Colors.grey[100]!,
            width: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          // Sticky Top Bar (Search & Tabs)
          Container(
            color: bgColor.withValues(alpha: 0.95),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              children: [
                // Search Input
                Container(
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
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: textSub, size: 20),
                      hintText: 'Search order ID, customer...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      suffixIcon: Icon(
                        Icons.tune,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Tabs
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tabs.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final tab = _tabs[index];
                      final isSelected = tab == _activeTab;
                      return GestureDetector(
                        onTap: () => setState(() => _activeTab = tab),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : surfaceColor,
                            borderRadius: BorderRadius.circular(99),
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: isDarkMode
                                        ? const Color(0xFF4A2A2A)
                                        : Colors.grey[200]!,
                                  ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: primaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              tab,
                              style: TextStyle(
                                color: isSelected ? Colors.white : textSub,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrderLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFEC1313)),
                  );
                } else if (state is OrderLoaded) {
                  final filteredOrders = _getFilteredOrders(state.orders);

                  if (filteredOrders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey[300]!,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No orders found',
                            style: TextStyle(color: textSub, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return _buildOrderCard(
                        context,
                        order,
                        surfaceColor,
                        textMain,
                        textSub,
                        primaryColor,
                      );
                    },
                  );
                } else if (state is OrderError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(surfaceColor, textSub, primaryColor),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    Order order,
    Color surfaceColor,
    Color textMain,
    Color textSub,
    Color primaryColor,
  ) {
    String statusLabel = order.status.displayName;
    Color statusBg = Colors.grey[100]!;
    Color statusText = Colors.grey[700]!;

    switch (order.status) {
      case OrderStatus.pendingPayment:
        statusBg = const Color(0xFFFEF3C7); // Orange 100
        statusText = const Color(0xFFB45309); // Orange 700
        break;
      case OrderStatus.paid:
      case OrderStatus.processing:
        statusBg = const Color(0xFFDBEAFE); // Blue 100
        statusText = const Color(0xFF1D4ED8); // Blue 700
        break;
      case OrderStatus.completed:
        statusBg = const Color(0xFFD1FAE5); // Green 100
        statusText = const Color(0xFF047857); // Green 700
        break;
      case OrderStatus.canceled:
        statusBg = const Color(0xFFFEE2E2); // Red 100
        statusText = const Color(0xFFB91C1C); // Red 700
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.pushNamed(
          'admin-order-detail',
          pathParameters: {'orderId': order.id},
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.code.substring(order.code.length - 5)}',
                      style: TextStyle(
                        color: textSub,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getCustomerName(order),
                      style: TextStyle(
                        color: textMain,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    statusLabel.toUpperCase(),
                    style: TextStyle(
                      color: statusText,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: textSub),
                        const SizedBox(width: 4),
                        Text(
                          _formatDateTime(order.createdAt),
                          style: TextStyle(color: textSub, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 14,
                          color: textSub,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${order.items.length} Items',
                          style: TextStyle(color: textSub, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      order.formattedTotalAmount,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right, color: Colors.grey[300]),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCustomerName(Order order) {
    // Since we don't have customer name, we use first part of address or id
    if (order.shippingAddress.contains(',')) {
      return order.shippingAddress.split(',').first;
    }
    return 'Customer #${order.id.substring(order.id.length - 4)}';
  }

  String _formatDateTime(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year} • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildBottomNav(
    Color surfaceColor,
    Color textSub,
    Color primaryColor,
  ) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: surfaceColor.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            Icons.grid_view_outlined,
            'Home',
            false,
            textSub,
            primaryColor,
          ),
          _buildNavItem(Icons.list_alt, 'Orders', true, textSub, primaryColor),
          _buildNavItem(
            Icons.inventory_2_outlined,
            'Products',
            false,
            textSub,
            primaryColor,
          ),
          _buildNavItem(
            Icons.group_outlined,
            'Users',
            false,
            textSub,
            primaryColor,
          ),
          _buildNavItem(
            Icons.settings_outlined,
            'Settings',
            false,
            textSub,
            primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    Color textSub,
    Color primaryColor,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? primaryColor : textSub, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? primaryColor : textSub,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
