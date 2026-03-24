import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/repositories/notification_repository.dart';

class CreateNotificationUsecase {
  final NotificationRepository repository;

  CreateNotificationUsecase(this.repository);

  Future<Either<Failure, AppNotification>> call(AppNotification notification) {
    return repository.createNotification(notification);
  }
}
