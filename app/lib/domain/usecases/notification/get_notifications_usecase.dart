import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';
import 'package:frontend_otis/domain/repositories/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository repository;

  GetNotificationsUsecase(this.repository);

  Future<Either<Failure, ({List<AppNotification> notifications, bool hasMore, int total})>> call({NotificationFilter? filter}) {
    return repository.getNotifications(filter: filter);
  }
}
