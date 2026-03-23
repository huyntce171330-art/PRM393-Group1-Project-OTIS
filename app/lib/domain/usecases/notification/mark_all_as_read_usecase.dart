import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/repositories/notification_repository.dart';

class MarkAllAsReadUsecase {
  final NotificationRepository repository;

  MarkAllAsReadUsecase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.markAllAsRead();
  }
}
