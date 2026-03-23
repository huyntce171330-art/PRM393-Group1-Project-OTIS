import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/repositories/notification_repository.dart';

class DeleteNotificationUsecase {
  final NotificationRepository repository;

  DeleteNotificationUsecase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteNotification(id);
  }
}
