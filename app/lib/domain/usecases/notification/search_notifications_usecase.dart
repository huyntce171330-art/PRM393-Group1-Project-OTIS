import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/repositories/notification_repository.dart';

class SearchNotificationsUsecase {
  final NotificationRepository repository;

  SearchNotificationsUsecase(this.repository);

  Future<Either<Failure, List<AppNotification>>> call(String query) {
    return repository.searchNotifications(query);
  }
}
