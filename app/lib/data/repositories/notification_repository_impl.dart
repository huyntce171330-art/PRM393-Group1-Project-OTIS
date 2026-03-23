import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/exceptions.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/data/datasources/notification/notification_remote_datasource.dart';
import 'package:frontend_otis/data/models/notification_model.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';
import 'package:frontend_otis/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource datasource;

  NotificationRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, ({List<AppNotification> notifications, bool hasMore, int total})>> getNotifications({NotificationFilter? filter}) async {
    try {
      final params = <String, dynamic>{};
      if (filter != null) {
        params['page'] = filter.page;
        params['limit'] = filter.limit;
        if (filter.type != null) params['type'] = filter.type.toString().split('.').last;
        if (filter.isRead != null) params['isRead'] = filter.isRead;
        if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
          params['searchQuery'] = filter.searchQuery;
        }
      }

      final models = await datasource.fetchNotifications(filterParams: params);
      final notifications = models.map((m) => m.toDomain()).toList();
      final hasMore = notifications.length == (filter?.limit ?? 20);

      return Right((notifications: notifications, hasMore: hasMore, total: notifications.length));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } on CacheException {
      return Left(CacheFailure());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppNotification>> getNotificationDetail(String id) async {
    try {
      final model = await datasource.fetchNotificationDetail(id);
      return Right(model.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } on CacheException {
      return Left(CacheFailure());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppNotification>> createNotification(AppNotification notification) async {
    try {
      final model = NotificationModel.fromDomain(notification);
      final created = await datasource.createNotification(model);
      return Right(created.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } on CacheException {
      return Left(CacheFailure());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateNotificationStatus(String id, bool isRead) async {
    try {
      await datasource.updateNotificationStatus(id, isRead);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } on CacheException {
      return Left(CacheFailure());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String id) async {
    try {
      await datasource.deleteNotification(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } on CacheException {
      return Left(CacheFailure());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppNotification>>> searchNotifications(String query) async {
    try {
      final models = await datasource.fetchNotifications(filterParams: {'searchQuery': query});
      return Right(models.map((m) => m.toDomain()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } on CacheException {
      return Left(CacheFailure());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await datasource.markAllAsRead();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } on CacheException {
      return Left(CacheFailure());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
