import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/network/socket_service.dart';
import 'package:frontend_otis/domain/entities/dashboard_entity.dart';
import 'package:frontend_otis/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:frontend_otis/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:frontend_otis/presentation/bloc/dashboard/dashboard_state.dart';
import 'package:frontend_otis/presentation/widgets/admin/admin_header.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/domain/usecases/chat/get_total_unread_count_usecase.dart';
import 'package:frontend_otis/domain/usecases/chat/insert_message_usecase.dart';


class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  static const int _adminId = 1;
  static const String _socketUrl = 'http://10.0.2.2:3000';

  StreamSubscription? _chatBadgeSub;

  @override
  void initState() {
    super.initState();
    _initAdminChatSocket();
  }

  Future<void> _initAdminChatSocket() async {
    SocketService.instance.connect(url: _socketUrl, userId: _adminId);

    _chatBadgeSub = SocketService.instance.adminInboxStream.listen((msg) async {
      if (!mounted) return;
      if (!(ModalRoute.of(context)?.isCurrent ?? false)) return;

      final roomId = msg['roomId'] ?? msg['room_id'];
      final senderId = msg['senderId'] ?? msg['sender_id'];
      final content = (msg['content'] ?? '').toString();
      final createdAt = (msg['createdAt'] ?? msg['created_at'])?.toString();

      if (SocketService.instance.activeAdminRoomId == roomId) {
        return;
      }

      if (roomId != null &&
          senderId != null &&
          senderId != _adminId &&
          content.isNotEmpty) {
        await sl<InsertMessageUseCase>().call(
          roomId: roomId as int,
          senderId: senderId as int,
          content: content,
          createdAt: createdAt,
          isRead: 0,
        );

        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _chatBadgeSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? const Color(0xFF101622)
        : const Color(0xFFF8F9FB);
    final surfaceColor = isDarkMode ? const Color(0xFF1A2230) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF333333);
    final textSecondaryColor = isDarkMode
        ? Colors.grey[400]
        : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const AdminHeader(),
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load dashboard',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(color: textSecondaryColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<DashboardBloc>().add(
                          const LoadDashboardEvent(),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is DashboardLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().add(
                    const RefreshDashboardEvent(),
                  );
                },
                child: _buildDashboardContent(
                  context,
                  state.dashboard,
                  surfaceColor,
                  textColor,
                  textSecondaryColor,
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    DashboardEntity dashboard,
    Color surfaceColor,
    Color textColor,
    Color? textSecondaryColor,
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Today's Revenue Card
                _buildRevenueCard(
                  currencyFormat.format(dashboard.todayRevenue),
                  _formatLastUpdated(dashboard.lastUpdated),
                  surfaceColor,
                  textColor,
                  textSecondaryColor,
                ),
                const SizedBox(height: 24),

                // Stats Grid
                _buildStatsGrid(
                  context,
                  dashboard,
                  currencyFormat,
                  surfaceColor,
                  textColor,
                  textSecondaryColor,
                ),
                const SizedBox(height: 24),

                // Weekly Sales Chart
                _buildWeeklySales(
                  context,
                  dashboard.weeklyRevenue,
                  dashboard.todayRevenue,
                  surfaceColor,
                  textColor,
                  textSecondaryColor,
                ),
                const SizedBox(height: 24),

                // Recent Orders
                _buildRecentActivities(
                  context,
                  dashboard.recentOrders,
                  surfaceColor,
                  textColor,
                  textSecondaryColor,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatLastUpdated(DateTime lastUpdated) {
    final now = DateTime.now();
    final diff = now.difference(lastUpdated);

    if (diff.inMinutes < 1) {
      return 'Live Updates • Just now';
    } else if (diff.inMinutes < 60) {
      return 'Live Updates • ${diff.inMinutes} min ago';
    } else {
      return 'Live Updates • ${diff.inHours}h ago';
    }
  }

  Widget _buildRevenueCard(
    String todayRevenue,
    String lastUpdatedText,
    Color surfaceColor,
    Color textColor,
    Color? textSecondaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
              Text(
                "Today's Revenue",
                style: TextStyle(
                  color: textSecondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            todayRevenue,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 36,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.update, size: 14, color: textSecondaryColor),
                const SizedBox(width: 4),
                Text(
                  lastUpdatedText,
                  style: TextStyle(
                    color: textSecondaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    DashboardEntity dashboard,
    NumberFormat currencyFormat,
    Color surfaceColor,
    Color textColor,
    Color? textSecondaryColor,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.1,
      children: [
        // Total Revenue
        _buildStatCard(
          surfaceColor,
          textColor,
          textSecondaryColor,
          icon: Icons.payments,
          iconColor: AppColors.primary,
          iconBg: AppColors.primary.withValues(alpha: 0.1),
          title: 'Total Revenue',
          value: currencyFormat.format(dashboard.totalRevenue),
        ),
        // Chats
        FutureBuilder<int>(
          future: sl<GetTotalUnreadCountUseCase>()
              .call(_adminId)
              .then((r) => r.getOrElse(() => 0)),
          builder: (context, snap) {
            final unread = snap.data ?? 0;
            final badgeText = unread > 9 ? '9+' : unread.toString();

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                await context.push('/admin/chats');
                if (mounted) setState(() {});
              },
              child: _buildStatCard(
                surfaceColor,
                textColor,
                textSecondaryColor,
                icon: Icons.chat_bubble_outline,
                iconColor: Colors.teal,
                iconBg: Colors.teal.withValues(alpha: 0.1),
                title: 'Chats',
                value: snap.connectionState == ConnectionState.waiting
                    ? '...'
                    : unread.toString(),
                subtext: 'Tap to view inbox',
                badge: unread > 0 ? badgeText : null,
              ),
            );
          },
        ),
        // New Orders Today
        _buildStatCard(
          surfaceColor,
          textColor,
          textSecondaryColor,
          icon: Icons.receipt_long,
          iconColor: Colors.orange,
          iconBg: Colors.orange.withValues(alpha: 0.1),
          title: 'New Orders',
          value: dashboard.todayNewOrders.toString(),
          subtext: 'Today',
          badge: dashboard.todayNewOrders > 0
              ? '${dashboard.todayNewOrders} New'
              : null,
        ),
        // Inventory
        _buildStatCard(
          surfaceColor,
          textColor,
          textSecondaryColor,
          icon: Icons.tire_repair,
          iconColor: Colors.blue,
          iconBg: Colors.blue.withValues(alpha: 0.1),
          title: 'Inventory',
          value: dashboard.totalProducts.toString(),
          subtext: dashboard.lowStockCount > 0
              ? '${dashboard.lowStockCount} low stock'
              : 'Tires in stock',
          badge: dashboard.lowStockCount > 0
              ? '${dashboard.lowStockCount} Alert'
              : null,
        ),
        // Customers
        _buildStatCard(
          surfaceColor,
          textColor,
          textSecondaryColor,
          icon: Icons.group,
          iconColor: Colors.purple,
          iconBg: Colors.purple.withValues(alpha: 0.1),
          title: 'Customers',
          value: dashboard.totalCustomers.toString(),
          subtext: 'Registered users',
          onTap: () => context.push('/admin/users'),
        ),
        // Monthly Revenue
        _buildStatCard(
          surfaceColor,
          textColor,
          textSecondaryColor,
          icon: Icons.trending_up,
          iconColor: Colors.green,
          iconBg: Colors.green.withValues(alpha: 0.1),
          title: 'Monthly Revenue',
          value: currencyFormat.format(dashboard.monthRevenue),
          subtext: 'This month',
        ),
      ],
    );
  }

  Widget _buildStatCard(
    Color surfaceColor,
    Color textColor,
    Color? textSecondaryColor, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    String? trend,
    bool trendUp = true,
    String? subtext,
    String? badge,
    VoidCallback? onTap,
  }) {
    final card = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: textSecondaryColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (trend != null)
                Row(
                  children: [
                    Icon(
                      trendUp ? Icons.trending_up : Icons.trending_down,
                      color: Colors.green,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trend,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              if (subtext != null)
                Text(
                  subtext,
                  style: TextStyle(
                    color: textSecondaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: card,
      );
    }

    return card;
  }

  Widget _buildWeeklySales(
    BuildContext context,
    List<DailyRevenue> weeklyRevenue,
    double todayRevenue,
    Color surfaceColor,
    Color textColor,
    Color? textSecondaryColor,
  ) {
    // Find max revenue for scaling
    double maxRevenue = weeklyRevenue.isEmpty
        ? 1.0
        : weeklyRevenue.map((e) => e.revenue).reduce((a, b) => a > b ? a : b);
    if (maxRevenue == 0) maxRevenue = 1.0;

    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
                    'Weekly Sales',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Last 7 days completed revenue',
                    style: TextStyle(
                      color: textSecondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              TextButton(onPressed: () {}, child: const Text('View Report')),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weeklyRevenue.asMap().entries.map((entry) {
                final index = entry.key;
                final daily = entry.value;
                final heightFactor = daily.revenue / maxRevenue;
                final isToday = index == weeklyRevenue.length - 1;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          daily.revenue > 0
                              ? currencyFormat.format(daily.revenue)
                              : '',
                          style: TextStyle(
                            color: isToday
                                ? AppColors.primary
                                : textSecondaryColor,
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Container(
                          height: max(140 * heightFactor.clamp(0.01, 1.0), 2),
                          width: 20,
                          decoration: BoxDecoration(
                            color: isToday
                                ? AppColors.primary
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: isToday
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          index < dayLabels.length ? dayLabels[index] : '',
                          style: TextStyle(
                            color: isToday
                                ? AppColors.primary
                                : textSecondaryColor,
                            fontSize: 10,
                            fontWeight: isToday
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities(
    BuildContext context,
    List<RecentOrder> recentOrders,
    Color surfaceColor,
    Color textColor,
    Color? textSecondaryColor,
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Orders',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/admin/orders'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: recentOrders.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: textSecondaryColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No orders yet',
                          style: TextStyle(
                            color: textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: recentOrders.asMap().entries.map((entry) {
                    final index = entry.key;
                    final order = entry.value;
                    final isLast = index == recentOrders.length - 1;

                    return InkWell(
                      onTap: () {
                        context.push('/admin/orders/${order.orderId}');
                      },
                      child: _buildOrderActivityItem(
                        orderId: order.orderId,
                        customerName: order.customerName,
                        status: order.status,
                        totalAmount: currencyFormat.format(order.totalAmount),
                        createdAt: _formatOrderTime(order.createdAt),
                        iconColor: _getStatusColor(order.status),
                        iconBg: _getStatusColor(
                          order.status,
                        ).withValues(alpha: 0.1),
                        isLast: isLast,
                        textColor: textColor,
                        textSecondaryColor: textSecondaryColor,
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'shipped':
        return Colors.purple;
      case 'confirmed':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _formatOrderTime(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(createdAt);
    }
  }

  Widget _buildOrderActivityItem({
    required int orderId,
    required String customerName,
    required String status,
    required String totalAmount,
    required String createdAt,
    required Color iconColor,
    required Color iconBg,
    required bool isLast,
    required Color textColor,
    required Color? textSecondaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Icon(Icons.shopping_bag, color: iconColor, size: 20),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 32,
                  color: Colors.grey[100],
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Order #$orderId',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      totalAmount,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  customerName,
                  style: TextStyle(color: textSecondaryColor, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: iconColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      createdAt,
                      style: TextStyle(
                        color: textSecondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (!isLast) const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
