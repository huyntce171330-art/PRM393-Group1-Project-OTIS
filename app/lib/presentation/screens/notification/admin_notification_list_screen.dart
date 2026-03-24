import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_bloc.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_event.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_state.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_bloc.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_state.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';

class AdminNotificationListScreen extends StatefulWidget {
  final bool isInboxView;

  const AdminNotificationListScreen({
    super.key,
    this.isInboxView = false,
  });

  @override
  State<AdminNotificationListScreen> createState() => _AdminNotificationListScreenState();
}

class _AdminNotificationListScreenState extends State<AdminNotificationListScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Orders', 'Promotions', 'System'];

  NotificationFilter _buildFilter(int index) {
    NotificationType? type;
    if (index == 1) {
      type = NotificationType.order;
    } else if (index == 2) {
      type = NotificationType.promotion;
    } else if (index == 3) {
      type = NotificationType.system;
    }
    return NotificationFilter(type: type);
  }

  void _onFilterChanged(BuildContext context, int index) {
    setState(() => _selectedFilterIndex = index);
    context.read<NotificationBloc>().add(LoadNotificationsEvent(filter: _buildFilter(index)));
  }

  void _onDelete(BuildContext context, String id) {
    context.read<NotificationBloc>().add(DeleteNotificationEvent(id));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đã xóa thông báo'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () {
            context.read<NotificationBloc>().add(const UndoDeleteNotificationEvent());
          },
        ),
      ),
    );
  }

  void _onToggleRead(BuildContext context, AppNotification notification) {
    if (notification.isRead) {
      context.read<NotificationBloc>().add(MarkAsUnreadEvent(notification.id));
    } else {
      context.read<NotificationBloc>().add(MarkAsReadEvent(notification.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: HeaderBar(
        title: widget.isInboxView ? 'Thông báo' : 'Quản lý thông báo',
        showBack: true,
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationBloc>().add(const MarkAllAsReadEvent());
            },
            child: const Text(
              'Đánh dấu tất cả đã đọc',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
        backgroundColor: isDarkMode
            ? const Color(0xFF1a0c0c).withOpacity(0.95)
            : Colors.white.withOpacity(0.95),
      ),
      floatingActionButton: widget.isInboxView
          ? null
          : BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
              builder: (context, authState) {
                final isAdmin = authState is Authenticated &&
                    authState.user.role?.isAdmin == true;
                if (!isAdmin) return const SizedBox.shrink();
                return FloatingActionButton(
                  onPressed: () => context.push('/notifications/create'),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  child: const Icon(Icons.add),
                );
              },
            ),
      body: Column(
        children: [
          _buildFilterTabs(context),
          Expanded(
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is NotificationInitial) {
                  context.read<NotificationBloc>().add(
                    LoadNotificationsEvent(filter: _buildFilter(_selectedFilterIndex)),
                  );
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is NotificationLoading) {
                  return _buildLoadingSkeleton(isDarkMode);
                }

                if (state is NotificationError) {
                  return _buildErrorView(context, state.message, isDarkMode);
                }

                if (state is NotificationLoaded) {
                  if (state.notifications.isEmpty) {
                    return _buildEmptyState(isDarkMode);
                  }
                  return _buildNotificationList(context, state.notifications, isDarkMode);
                }

                return _buildLoadingSkeleton(isDarkMode);
              },
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
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 2),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_filters.length, (index) {
            final isSelected = _selectedFilterIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => _onFilterChanged(context, index),
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

  Widget _buildNotificationList(
    BuildContext context,
    List<AppNotification> notifications,
    bool isDarkMode,
  ) {
    final today = <AppNotification>[];
    final yesterday = <AppNotification>[];
    final earlier = <AppNotification>[];

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    for (final n in notifications) {
      if (n.createdAt.isAfter(todayStart)) {
        today.add(n);
      } else if (n.createdAt.isAfter(yesterdayStart)) {
        yesterday.add(n);
      } else {
        earlier.add(n);
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<NotificationBloc>().add(const RefreshNotificationsEvent());
      },
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (today.isNotEmpty) ...[
            _buildSectionHeader(context, 'Hôm nay'),
            ...today.map((n) => _buildDismissibleItem(context, n, isDarkMode)),
          ],
          if (yesterday.isNotEmpty) ...[
            _buildSectionHeader(context, 'Hôm qua'),
            ...yesterday.map((n) => _buildDismissibleItem(context, n, isDarkMode)),
          ],
          if (earlier.isNotEmpty) ...[
            _buildSectionHeader(context, 'Trước đó'),
            ...earlier.map((n) => _buildDismissibleItem(context, n, isDarkMode)),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildDismissibleItem(BuildContext context, AppNotification notification, bool isDarkMode) {
    // Admin: full swipe (left = delete, right = toggle read)
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _onToggleRead(context, notification);
          return false;
        } else {
          _onDelete(context, notification.id);
          return false;
        }
      },
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: Icon(
          notification.isRead ? Icons.email_outlined : Icons.mark_email_read,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onLongPress: () => _showActionSheet(context, notification),
        child: _buildNotificationItem(
          context,
          notification: notification,
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context, AppNotification notification) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Đánh dấu đã đọc'),
              onTap: () {
                Navigator.pop(ctx);
                context.read<NotificationBloc>().add(MarkAsReadEvent(notification.id));
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Đánh dấu chưa đọc'),
              onTap: () {
                Navigator.pop(ctx);
                context.read<NotificationBloc>().add(MarkAsUnreadEvent(notification.id));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Xóa', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                _onDelete(context, notification.id);
              },
            ),
          ],
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
    required AppNotification notification,
    required bool isDarkMode,
  }) {
    final icon = _getIconForNotification(notification);

    return InkWell(
      onTap: () {
        context.push('/admin/notifications/${notification.id}', extra: notification);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? (isDarkMode ? const Color(0xFF1a0c0c) : Colors.white)
              : (isDarkMode
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.05)),
          border: Border(
            bottom: BorderSide(
              color: isDarkMode
                  ? Colors.grey[800]!.withOpacity(0.5)
                  : Colors.grey[100]!.withOpacity(0.5),
              width: 1,
            ),
            left: notification.isRead
                ? BorderSide.none
                : const BorderSide(color: AppColors.primary, width: 4),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                color: notification.isRead
                    ? (isDarkMode ? Colors.grey[400] : Colors.grey[500])
                    : AppColors.primary,
                size: 24,
              ),
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
                          notification.displayTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: notification.isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.grey[900],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead)
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
                    notification.displayBody,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.w500,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.relativeTime,
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

  IconData _getIconForNotification(AppNotification notification) {
    return Icons.notifications;
  }

  Widget _buildLoadingSkeleton(bool isDarkMode) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 200,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 120,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorView(BuildContext context, String message, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<NotificationBloc>().add(
                LoadNotificationsEvent(filter: _buildFilter(_selectedFilterIndex)),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có thông báo nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isInboxView
                ? 'Bạn sẽ nhận được thông báo tại đây!'
                : 'Tạo thông báo mới bằng nút +',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
