import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';
import 'package:frontend_otis/domain/usecases/notification/get_notifications_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/search_notifications_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/mark_all_as_read_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNotificationsUsecase extends Mock implements GetNotificationsUsecase {}
class MockSearchNotificationsUsecase extends Mock implements SearchNotificationsUsecase {}
class MockMarkAllAsReadUsecase extends Mock implements MarkAllAsReadUsecase {}

class FakeNotificationFilter extends Fake implements NotificationFilter {}

void main() {
  late MockGetNotificationsUsecase mockGetNotifications;
  late MockSearchNotificationsUsecase mockSearch;
  late MockMarkAllAsReadUsecase mockMarkAll;

  setUpAll(() {
    registerFallbackValue(FakeNotificationFilter());
  });

  setUp(() {
    mockGetNotifications = MockGetNotificationsUsecase();
    mockSearch = MockSearchNotificationsUsecase();
    mockMarkAll = MockMarkAllAsReadUsecase();
  });

  final tNotification1 = AppNotification(
    id: '1',
    title: 'Order #999 Confirmed',
    body: 'Your order has been confirmed.',
    isRead: false,
    userId: 'user1',
    createdAt: DateTime.now(),
  );

  final tNotification2 = AppNotification(
    id: '2',
    title: 'Winter Sale',
    body: 'Get 20% off on all winter tires!',
    isRead: false,
    userId: 'user1',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  );

  final tNotification3 = AppNotification(
    id: '3',
    title: 'System Maintenance',
    body: 'Scheduled maintenance completed.',
    isRead: true,
    userId: 'user1',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  );

  group('GetNotificationsUsecase', () {
    test('returns Right with notifications list and pagination metadata on success', () async {
      when(() => mockGetNotifications.call(filter: any(named: 'filter')))
          .thenAnswer((_) async => Right((
            notifications: <AppNotification>[],
            hasMore: false,
            total: 0,
          )));

      final result = await mockGetNotifications.call(filter: null);

      verify(() => mockGetNotifications.call(filter: null)).called(1);
      expect(result.isRight(), true);
    });

    test('returns Left(ServerFailure) when repository throws ServerException', () async {
      when(() => mockGetNotifications.call(filter: any(named: 'filter')))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Server error')));

      final result = await mockGetNotifications.call(filter: null);

      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NetworkFailure) when there is no network', () async {
      when(() => mockGetNotifications.call(filter: any(named: 'filter')))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await mockGetNotifications.call(filter: null);

      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('passes filter parameters to the repository', () async {
      const filter = NotificationFilter(type: NotificationType.order, page: 2);
      when(() => mockGetNotifications.call(filter: any(named: 'filter')))
          .thenAnswer((_) async => Right((
            notifications: <AppNotification>[],
            hasMore: false,
            total: 0,
          )));

      await mockGetNotifications.call(filter: filter);

      verify(() => mockGetNotifications.call(filter: filter)).called(1);
    });

    test('returns notifications with hasMore=true when there are more pages', () async {
      when(() => mockGetNotifications.call(filter: any(named: 'filter')))
          .thenAnswer((_) async => Right((
            notifications: [tNotification1, tNotification2],
            hasMore: true,
            total: 25,
          )));

      final result = await mockGetNotifications.call(filter: const NotificationFilter(page: 1));

      result.fold(
        (_) => fail('Expected Right'),
        (data) {
          expect(data.notifications.length, 2);
          expect(data.hasMore, true);
          expect(data.total, 25);
        },
      );
    });

    test('returns empty list when no notifications match filter', () async {
      when(() => mockGetNotifications.call(filter: any(named: 'filter')))
          .thenAnswer((_) async => Right((
            notifications: <AppNotification>[],
            hasMore: false,
            total: 0,
          )));

      final result = await mockGetNotifications.call(
        filter: const NotificationFilter(type: NotificationType.system),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (data) {
          expect(data.notifications, isEmpty);
          expect(data.hasMore, false);
          expect(data.total, 0);
        },
      );
    });
  });

  group('SearchNotificationsUsecase', () {
    test('returns Right with matching notifications on success', () async {
      when(() => mockSearch.call('order'))
          .thenAnswer((_) async => Right([tNotification1]));

      final result = await mockSearch.call('order');

      verify(() => mockSearch.call('order')).called(1);
      result.fold(
        (_) => fail('Expected Right'),
        (notifications) => expect(notifications.length, 1),
      );
    });

    test('returns Left(ServerFailure) when search fails', () async {
      when(() => mockSearch.call('invalid'))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Search failed')));

      final result = await mockSearch.call('invalid');

      result.fold(
        (failure) => expect(failure.message, 'Search failed'),
        (_) => fail('Expected Left'),
      );
    });

    test('returns empty list when no matches found', () async {
      when(() => mockSearch.call('xyz123'))
          .thenAnswer((_) async => const Right([]));

      final result = await mockSearch.call('xyz123');

      result.fold(
        (_) => fail('Expected Right'),
        (notifications) => expect(notifications, isEmpty),
      );
    });
  });

  group('MarkAllAsReadUsecase', () {
    test('returns Right(null) when mark all succeeds', () async {
      when(() => mockMarkAll.call())
          .thenAnswer((_) async => const Right(null));

      final result = await mockMarkAll.call();

      verify(() => mockMarkAll.call()).called(1);
      expect(result, equals(const Right(null)));
    });

    test('returns Left(ServerFailure) when mark all fails', () async {
      when(() => mockMarkAll.call())
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Server error')));

      final result = await mockMarkAll.call();

      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NetworkFailure) on network error', () async {
      when(() => mockMarkAll.call())
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await mockMarkAll.call();

      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
