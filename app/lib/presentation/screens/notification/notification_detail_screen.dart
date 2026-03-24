import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_bloc.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_event.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_state.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';

class NotificationDetailScreen extends StatefulWidget {
  final String? notificationId;
  final AppNotification? notification;

  const NotificationDetailScreen({
    super.key,
    this.notificationId,
    this.notification,
  });

  @override
  State<NotificationDetailScreen> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  AppNotification? _localNotification;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _resolveNotification();
  }

  void _resolveNotification() {
    // 1) Nếu được truyền trực tiếp → dùng luôn
    if (widget.notification != null) {
      _localNotification = widget.notification;
      _markAsReadIfNeeded(_localNotification!);
      return;
    }

    // 2) Nếu có ID, tìm trong bloc cache trước
    if (widget.notificationId != null) {
      final blocState = context.read<NotificationBloc>().state;
      if (blocState is NotificationLoaded) {
        final cached = blocState.notifications.where(
          (n) => n.id == widget.notificationId,
        ).toList();
        if (cached.isNotEmpty) {
          setState(() => _localNotification = cached.first);
          _markAsReadIfNeeded(cached.first);
          return;
        }
      }
    }

    // 3) Không tìm thấy trong cache → fetch từ DB
    if (widget.notificationId != null) {
      _loadFromDb();
    } else {
      setState(() => _error = 'No notification data available');
    }
  }

  Future<void> _loadFromDb() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    context.read<NotificationBloc>().add(
      GetNotificationDetailEvent(widget.notificationId!),
    );
  }

  void _markAsReadIfNeeded(AppNotification notification) {
    if (!notification.isRead) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<NotificationBloc>().add(MarkAsReadEvent(notification.id));
      });
    }
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Notification'),
        content: const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<NotificationBloc>().add(DeleteNotificationEvent(id));
              context.pop(true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationDetailLoaded &&
            state.notification.id == widget.notificationId) {
          setState(() {
            _localNotification = state.notification;
            _loading = false;
          });
        }
        if (state is NotificationError && _loading) {
          setState(() {
            _error = state.message;
            _loading = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: isDarkMode
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: HeaderBar(
          title: 'Notification',
          showBack: true,
          onBack: () => context.pop(true),
          actions: [
            if (_localNotification != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _confirmDelete(context, _localNotification!.id),
              ),
          ],
          backgroundColor: isDarkMode
              ? const Color(0xFF1a0c0c).withOpacity(0.95)
              : Colors.white.withOpacity(0.95),
        ),
        body: _buildBody(isDarkMode),
      ),
    );
  }

  Widget _buildBody(bool isDarkMode) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFromDb,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_localNotification == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return _buildContent(context, _localNotification!, isDarkMode);
  }

  Widget _buildContent(BuildContext context, AppNotification notification, bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                  ),
                ),
                child: const Icon(
                  Icons.notifications,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (notification.isRead)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'Read',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'Unread',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDateTime(notification.createdAt),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            notification.displayTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
              ),
            ),
            child: Text(
              notification.displayBody,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: isDarkMode ? Colors.grey[200] : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} at $hour:$minute $ampm';
  }
}
