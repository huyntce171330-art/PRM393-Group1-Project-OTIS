import 'package:frontend_otis/data/models/notification_model.dart';

abstract class NotificationRemoteDatasource {
  Future<List<NotificationModel>> fetchNotifications({Map<String, dynamic>? filterParams});
  Future<NotificationModel> fetchNotificationDetail(String id);
  Future<NotificationModel> createNotification(NotificationModel notification);
  Future<void> updateNotificationStatus(String id, bool isRead);
  Future<void> deleteNotification(String id);
  Future<void> markAllAsRead();
}
