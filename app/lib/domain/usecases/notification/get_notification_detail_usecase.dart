import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/repositories/notification_repository.dart';

class GetNotificationDetailUsecase {
  final NotificationRepository repository;

  GetNotificationDetailUsecase(this.repository);

  Future<Either<Failure, AppNotification>> call(String id) {
    return repository.getNotificationDetail(id);
  }
}
