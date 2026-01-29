import '../../domain/entities/notification.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required int notificationId,
    required int userId,
    required String title,
    required String body,
    required bool isRead,
    required DateTime createdAt,
  }) : super(
         notificationId: notificationId,
         userId: userId,
         title: title,
         body: body,
         isRead: isRead,
         createdAt: createdAt,
       );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notification_id'],
      userId: json['user_id'],
      title: json['title'],
      body: json['body'],
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'user_id': userId,
      'title': title,
      'body': body,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
