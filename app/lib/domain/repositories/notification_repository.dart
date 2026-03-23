import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';

abstract class NotificationRepository {
  Future<Either<Failure, ({List<AppNotification> notifications, bool hasMore, int total})>> getNotifications({NotificationFilter? filter});
  Future<Either<Failure, AppNotification>> getNotificationDetail(String id);
  Future<Either<Failure, AppNotification>> createNotification(AppNotification notification);
  Future<Either<Failure, void>> updateNotificationStatus(String id, bool isRead);
  Future<Either<Failure, void>> deleteNotification(String id);
  Future<Either<Failure, List<AppNotification>>> searchNotifications(String query);
  Future<Either<Failure, void>> markAllAsRead();
}
