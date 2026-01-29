import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int notificationId;
  final int userId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    notificationId,
    userId,
    title,
    body,
    isRead,
    createdAt,
  ];
}
