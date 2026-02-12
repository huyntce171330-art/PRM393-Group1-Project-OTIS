import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Orders', 'Promotions', 'System'];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: HeaderBar(
        title: 'Notifications',
        showBack: true,
        actions: [
          TextButton(
            onPressed: () {
              // Mark all read logic
            },
            child: const Text(
              'Mark all as read',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
        backgroundColor: isDarkMode
            ? const Color(0xFF1a0c0c).withOpacity(0.95)
            : Colors.white.withOpacity(0.95),
      ),
      body: Column(
        children: [
          _buildFilterTabs(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionHeader(context, 'Today'),
                _buildNotificationItem(
                  context,
                  icon: Icons.shopping_bag,
                  title: 'Order #999 Confirmed',
                  content:
                      'Your order for Michelin Primacy 4 tires has been confirmed and is being processed.',
                  time: '2h ago',
                  isUnread: true,
                ),
                _buildNotificationItem(
                  context,
                  icon: Icons.local_offer,
                  title: 'Winter Sale Started!',
                  content:
                      'Get 20% off on all winter tires. Limited time offer ending soon. Don\'t miss out on these exclusive deals!',
                  time: '5h ago',
                  isUnread: true,
                ),
                const SizedBox(height: 16),
                _buildSectionHeader(context, 'Yesterday'),
                _buildNotificationItem(
                  context,
                  icon: Icons.settings_suggest,
                  title: 'System Maintenance',
                  content:
                      'Scheduled maintenance completed successfully. All systems are operational.',
                  time: '1d ago',
                  isUnread: false,
                ),
                _buildNotificationItem(
                  context,
                  icon: Icons.local_shipping,
                  title: 'Order #995 Delivered',
                  content: 'Your package has been delivered to the reception.',
                  time: '1d ago',
                  isUnread: false,
                ),
                _buildNotificationItem(
                  context,
                  icon: Icons.inventory_2,
                  title: 'Restock Alert',
                  content:
                      'Bridgestone Potenza S001 is back in stock. Order now before it runs out.',
                  time: '1d ago',
                  isUnread: false,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkMode ? const Color(0xFF1a0c0c) : Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_filters.length, (index) {
            final isSelected = _selectedFilterIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedFilterIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(9999),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDarkMode ? Colors.grey[800] : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    _filters[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDarkMode ? Colors.grey[300] : Colors.grey[600]),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[400],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required String time,
    required bool isUnread,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        // Handle tap
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isUnread
              ? (isDarkMode
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.05))
              : (isDarkMode ? const Color(0xFF1a0c0c) : Colors.white),
          border: Border(
            bottom: BorderSide(
              color: isDarkMode
                  ? Colors.grey[800]!.withOpacity(0.5)
                  : Colors.grey[100]!.withOpacity(0.5),
              width: 1,
            ),
            left: isUnread
                ? const BorderSide(color: AppColors.primary, width: 4)
                : BorderSide.none,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                ),
              ),
              child: Icon(
                icon,
                color: isUnread
                    ? AppColors.primary
                    : (isDarkMode ? Colors.grey[400] : Colors.grey[500]),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isUnread
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.grey[900],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isUnread
                          ? FontWeight.w500
                          : FontWeight.normal,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
