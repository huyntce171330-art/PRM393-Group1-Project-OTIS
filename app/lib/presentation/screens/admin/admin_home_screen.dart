import 'package:flutter/material.dart';

import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/presentation/widgets/admin/admin_header.dart';
import 'package:frontend_otis/presentation/widgets/admin/admin_nav_bar.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

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
      body: SafeArea(
        child: Column(
          children: [
            const AdminHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildRevenueCard(
                      context,
                      surfaceColor,
                      textColor,
                      textSecondaryColor,
                    ),
                    const SizedBox(height: 24),
                    _buildStatsGrid(
                      context,
                      surfaceColor,
                      textColor,
                      textSecondaryColor,
                    ),
                    const SizedBox(height: 24),
                    _buildWeeklySales(
                      context,
                      surfaceColor,
                      textColor,
                      textSecondaryColor,
                    ),
                    const SizedBox(height: 24),
                    _buildRecentActivities(
                      context,
                      surfaceColor,
                      textColor,
                      textSecondaryColor,
                    ),
                    const SizedBox(height: 80), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminNavBar(currentIndex: 0),
    );
  }

  Widget _buildRevenueCard(
    BuildContext context,
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
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
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '₫',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: '8,450,000',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
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
                  'Live Updates • 1 min ago',
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
      childAspectRatio: 1.1, // Adjust based on content
      children: [
        _buildStatCard(
          surfaceColor,
          textColor,
          textSecondaryColor,
          icon: Icons.payments,
          iconColor: AppColors.primary,
          iconBg: Colors.red.withValues(alpha: 0.1),
          title: 'Total Revenue',
          value: '฿45,200',
          trend: '+12.5%',
          trendUp: true,
        ),
        _buildStatCard(
          surfaceColor,
          textColor,
          textSecondaryColor,
          icon: Icons.receipt_long,
          iconColor: Colors.orange,
          iconBg: Colors.orange.withValues(alpha: 0.1),
          title: 'New Orders',
          value: '12',
          subtext: 'Pending processing',
          badge: '3 New',
        ),
        _buildStatCard(
          surfaceColor,
          textColor,
          textSecondaryColor,
          icon: Icons.tire_repair,
          iconColor: Colors.blue,
          iconBg: Colors.blue.withValues(alpha: 0.1),
          title: 'Inventory',
          value: '340',
          subtext: 'Tires in stock',
        ),
        _buildStatCard(
          surfaceColor,
          textColor,
          textSecondaryColor,
          icon: Icons.group,
          iconColor: Colors.purple,
          iconBg: Colors.purple.withValues(alpha: 0.1),
          title: 'Customers',
          value: '1,205',
          trend: '+4',
          trendUp: true,
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
  }) {
    return Container(
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
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
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
  }

  Widget _buildWeeklySales(
    BuildContext context,
    Color surfaceColor,
    Color textColor,
    Color? textSecondaryColor,
  ) {
    final data = [
      {'day': 'Mon', 'val': 0.45, 'label': '22k'},
      {'day': 'Tue', 'val': 0.30, 'label': '15k'},
      {'day': 'Wed', 'val': 0.60, 'label': '35k'},
      {'day': 'Thu', 'val': 0.45, 'label': '24k'},
      {'day': 'Fri', 'val': 0.85, 'label': '45k', 'active': true},
      {'day': 'Sat', 'val': 0.70, 'label': '38k'},
      {'day': 'Sun', 'val': 0.25, 'label': '10k'},
    ];

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
                    'Last 7 days revenue',
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
              children: data.map((d) {
                final heightFactor = d['val'] as double;
                final active = d['active'] == true;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 150 * heightFactor,
                        width: 24,
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: active
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
                      const SizedBox(height: 8),
                      Text(
                        d['day'] as String,
                        style: TextStyle(
                          color: active
                              ? AppColors.primary
                              : textSecondaryColor,
                          fontSize: 11,
                          fontWeight: active
                              ? FontWeight.bold
                              : FontWeight.w600,
                        ),
                      ),
                    ],
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
    Color surfaceColor,
    Color textColor,
    Color? textSecondaryColor,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activities',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
              _buildActivityItem(
                title: 'New order from Tuan',
                time: '5m ago',
                desc: 'Order #2201 - 4x Michelin Primacy 4',
                icon: Icons.shopping_bag,
                iconColor: Colors.green,
                iconBg: Colors.green.withValues(alpha: 0.1),
                isLast: false,
              ),
              _buildActivityItem(
                title: 'Product Stock Updated',
                time: '2h ago',
                desc: 'Michelin Pilot Sport 5 added (+50 units)',
                icon: Icons.inventory,
                iconColor: Colors.blue,
                iconBg: Colors.blue.withValues(alpha: 0.1),
                isLast: false,
              ),
              _buildActivityItem(
                title: 'New Customer Registered',
                time: '4h ago',
                desc: 'User ID: #8832 via Mobile App',
                icon: Icons.person_add,
                iconColor: Colors.purple,
                iconBg: Colors.purple.withValues(alpha: 0.1),
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String time,
    required String desc,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required bool isLast,
  }) {
    return Row(
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
              child: Icon(icon, color: iconColor, size: 20),
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
