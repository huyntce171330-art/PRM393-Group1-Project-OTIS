import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/domain/usecases/chat/get_total_unread_count_usecase.dart';
import 'package:frontend_otis/domain/usecases/profile/count_customers_usecase.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  static const int _adminId = 1;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF101622) : const Color(0xFFF8F9FB);
    final surfaceColor = isDarkMode ? const Color(0xFF1A2230) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF333333);
    final textSecondaryColor =
        isDarkMode ? (Colors.grey[400] ?? Colors.grey) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                   FutureBuilder<int>(
                    future: sl<GetTotalUnreadCountUseCase>()(_adminId).then((res) => res.getOrElse(() => 0)),
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
                   FutureBuilder<int>(
                    future: sl<CountCustomersUseCase>()().then((res) => res.getOrElse(() => 0)),
                    builder: (context, snap) {
                      final count = snap.data ?? 0;

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => context.push('/admin/users'),
                        child: _buildStatCard(
                          surfaceColor,
                          textColor,
                          textSecondaryColor,
                          icon: Icons.group,
                          iconColor: Colors.purple,
                          iconBg: Colors.purple.withValues(alpha: 0.1),
                          title: 'Customers',
                          value: snap.connectionState == ConnectionState.waiting
                              ? '...'
                              : count.toString(),
                          subtext: 'Total registered',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    Color surfaceColor,
    Color textColor,
    Color textSecondaryColor, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    required String subtext,
    String? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                value,
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  color: textSecondaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}