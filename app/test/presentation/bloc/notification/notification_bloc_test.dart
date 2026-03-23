import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';
import 'package:frontend_otis/domain/usecases/notification/create_notification_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/delete_notification_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/get_notification_detail_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/get_notifications_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/mark_all_as_read_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/search_notifications_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/update_notification_status_usecase.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_bloc.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_event.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNotificationsUsecase extends Mock implements GetNotificationsUsecase {}
class MockGetNotificationDetailUsecase extends Mock implements GetNotificationDetailUsecase {}
class MockUpdateNotificationStatusUsecase extends Mock implements UpdateNotificationStatusUsecase {}
class MockDeleteNotificationUsecase extends Mock implements DeleteNotificationUsecase {}
class MockSearchNotificationsUsecase extends Mock implements SearchNotificationsUsecase {}
class MockCreateNotificationUsecase extends Mock implements CreateNotificationUsecase {}
class MockMarkAllAsReadUsecase extends Mock implements MarkAllAsReadUsecase {}

class FakeNotificationFilter extends Fake implements NotificationFilter {}
class FakeNotification extends Fake implements AppNotification {}

final tNotification1 = AppNotification(
  id: '1',
  title: 'Order #999 Confirmed',
  body: 'Your order for Michelin Primacy 4 tires has been confirmed.',
  isRead: false,
  userId: 'user1',
  createdAt: DateTime.now(),
);

final tNotification2 = AppNotification(
  id: '2',
  title: 'Winter Sale Started!',
  body: 'Get 20% off on all winter tires. Limited time offer!',
  isRead: false,
  userId: 'user1',
  createdAt: DateTime.now().subtract(const Duration(days: 1)),
);

final tNotification3 = AppNotification(
  id: '3',
  title: 'System Maintenance',
  body: 'Scheduled maintenance completed successfully.',
  isRead: true,
  userId: 'user1',
  createdAt: DateTime.now().subtract(const Duration(days: 2)),
);

void main() {
  late NotificationBloc bloc;
  late MockGetNotificationsUsecase mockGetNotifications;
  late MockGetNotificationDetailUsecase mockGetDetail;
  late MockUpdateNotificationStatusUsecase mockUpdateStatus;
  late MockDeleteNotificationUsecase mockDelete;
  late MockSearchNotificationsUsecase mockSearch;
  late MockCreateNotificationUsecase mockCreate;
  late MockMarkAllAsReadUsecase mockMarkAll;

  setUpAll(() {
    registerFallbackValue(FakeNotificationFilter());
    registerFallbackValue(FakeNotification());
  });

  setUp(() {
    mockGetNotifications = MockGetNotificationsUsecase();
    mockGetDetail = MockGetNotificationDetailUsecase();
    mockUpdateStatus = MockUpdateNotificationStatusUsecase();
    mockDelete = MockDeleteNotificationUsecase();
    mockSearch = MockSearchNotificationsUsecase();
    mockCreate = MockCreateNotificationUsecase();
    mockMarkAll = MockMarkAllAsReadUsecase();

    bloc = NotificationBloc(
      getNotifications: mockGetNotifications,
      getNotificationDetail: mockGetDetail,
      updateNotificationStatus: mockUpdateStatus,
      deleteNotification: mockDelete,
      searchNotifications: mockSearch,
      createNotification: mockCreate,
      markAllAsRead: mockMarkAll,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('NotificationBloc', () {
    test('initial state should be NotificationInitial', () {
      expect(bloc.state, equals(const NotificationInitial()));
    });

    // ===== LOAD NOTIFICATIONS =====

    blocTest<NotificationBloc, NotificationState>(
      'emits [Loading, Loaded] when LoadNotificationsEvent succeeds',
      build: () {
        when(() => mockGetNotifications.call(filter: any(named: 'filter'))).thenAnswer(
          (_) async => Right((notifications: [tNotification1, tNotification2], hasMore: false, total: 2)),
        );
        return bloc;
      },
      act: (b) => b.add(const LoadNotificationsEvent()),
      expect: () => [
        const NotificationLoading(),
        isA<NotificationLoaded>()
            .having((s) => s.notifications.length, 'notifications count', 2)
            .having((s) => s.currentPage, 'currentPage', 1)
            .having((s) => s.hasMore, 'hasMore', false),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'emits [Loading, Error] when LoadNotificationsEvent fails',
      build: () {
        when(() => mockGetNotifications.call(filter: any(named: 'filter'))).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server error')),
        );
        return bloc;
      },
      act: (b) => b.add(const LoadNotificationsEvent()),
      expect: () => [
        const NotificationLoading(),
        const NotificationError('Server error'),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'emits [Loading, Loaded] with filter when LoadNotificationsEvent succeeds with filter',
      build: () {
        final filter = const NotificationFilter(type: NotificationType.order);
        when(() => mockGetNotifications.call(filter: any(named: 'filter'))).thenAnswer(
          (_) async => Right((notifications: [tNotification1], hasMore: false, total: 1)),
        );
        return bloc;
      },
      act: (b) => b.add(const LoadNotificationsEvent(filter: NotificationFilter(type: NotificationType.order))),
      expect: () => [
        const NotificationLoading(),
        isA<NotificationLoaded>()
            .having((s) => s.notifications.length, 'notifications count', 1)
            .having((s) => s.currentFilter?.type, 'filter type', NotificationType.order),
      ],
    );

    // ===== REFRESH =====

    blocTest<NotificationBloc, NotificationState>(
      'emits [Loaded] when RefreshNotificationsEvent succeeds',
      build: () {
        when(() => mockGetNotifications.call(filter: any(named: 'filter'))).thenAnswer(
          (_) async => Right((notifications: [tNotification1], hasMore: false, total: 1)),
        );
        return bloc;
      },
      act: (b) => b.add(const RefreshNotificationsEvent()),
      expect: () => [
        isA<NotificationLoaded>(),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'emits [Error] when RefreshNotificationsEvent fails',
      build: () {
        when(() => mockGetNotifications.call(filter: any(named: 'filter'))).thenAnswer(
          (_) async => const Left(NetworkFailure()),
        );
        return bloc;
      },
      act: (b) => b.add(const RefreshNotificationsEvent()),
      expect: () => [
        const NotificationError('Network Failure'),
      ],
    );

    // ===== MARK AS READ =====

    blocTest<NotificationBloc, NotificationState>(
      'emits [OperationSuccess, Loaded] when MarkAsReadEvent succeeds',
      build: () {
        final initialState = NotificationLoaded(
          notifications: [tNotification1],
          currentPage: 1,
          hasMore: false,
        );
        when(() => mockUpdateStatus.call('1', true)).thenAnswer(
          (_) async => const Right(null),
        );
        return bloc..emit(initialState);
      },
      seed: () => NotificationLoaded(
        notifications: [tNotification1],
        currentPage: 1,
        hasMore: false,
      ),
      act: (b) => b.add(const MarkAsReadEvent('1')),
      expect: () => [
        isA<NotificationOperationSuccess>()
            .having((s) => s.type, 'type', NotificationOperationType.markRead)
            .having((s) => s.message, 'message', 'Marked as read'),
        isA<NotificationLoaded>()
            .having((s) => s.notifications.first.isRead, 'isRead', true),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'emits [Error] when MarkAsReadEvent fails',
      build: () {
        when(() => mockUpdateStatus.call('1', true)).thenAnswer(
          (_) async => const Left(ServerFailure()),
        );
        return bloc;
      },
      seed: () => NotificationLoaded(
        notifications: [tNotification1],
        currentPage: 1,
        hasMore: false,
      ),
      act: (b) => b.add(const MarkAsReadEvent('1')),
      expect: () => [
        const NotificationError('Server Failure'),
      ],
    );

    // ===== MARK AS UNREAD =====

    blocTest<NotificationBloc, NotificationState>(
      'emits [OperationSuccess, Loaded] when MarkAsUnreadEvent succeeds',
      build: () {
        when(() => mockUpdateStatus.call('3', false)).thenAnswer(
          (_) async => const Right(null),
        );
        return bloc;
      },
      seed: () => NotificationLoaded(
        notifications: [tNotification3],
        currentPage: 1,
        hasMore: false,
      ),
      act: (b) => b.add(const MarkAsUnreadEvent('3')),
      expect: () => [
        isA<NotificationOperationSuccess>()
            .having((s) => s.type, 'type', NotificationOperationType.markUnread),
        isA<NotificationLoaded>()
            .having((s) => s.notifications.first.isRead, 'isRead', false),
      ],
    );

    // ===== MARK ALL AS READ =====

    blocTest<NotificationBloc, NotificationState>(
      'emits [OperationSuccess, Loaded] when MarkAllAsReadEvent succeeds',
      build: () {
        when(() => mockMarkAll.call()).thenAnswer(
          (_) async => const Right(null),
        );
        return bloc;
      },
      seed: () => NotificationLoaded(
        notifications: [tNotification1, tNotification2],
        currentPage: 1,
        hasMore: false,
      ),
      act: (b) => b.add(const MarkAllAsReadEvent()),
      expect: () => [
        isA<NotificationOperationSuccess>()
            .having((s) => s.type, 'type', NotificationOperationType.markAllRead),
        isA<NotificationLoaded>()
            .having((s) => s.notifications.every((n) => n.isRead), 'all marked read', true),
      ],
    );

    // ===== DELETE =====

    blocTest<NotificationBloc, NotificationState>(
      'emits [OperationSuccess, Loaded] when DeleteNotificationEvent succeeds',
      build: () {
        when(() => mockDelete.call('1')).thenAnswer(
          (_) async => const Right(null),
        );
        return bloc;
      },
      seed: () => NotificationLoaded(
        notifications: [tNotification1, tNotification2],
        currentPage: 1,
        hasMore: false,
      ),
      act: (b) => b.add(const DeleteNotificationEvent('1')),
      expect: () => [
        isA<NotificationOperationSuccess>()
            .having((s) => s.type, 'type', NotificationOperationType.delete),
        isA<NotificationLoaded>()
            .having((s) => s.notifications.length, 'count', 1)
            .having((s) => s.notifications.first.id, 'remaining id', '2'),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'emits [Error] when DeleteNotificationEvent fails',
      build: () {
        when(() => mockDelete.call('1')).thenAnswer(
          (_) async => const Left(ServerFailure()),
        );
        return bloc;
      },
      seed: () => NotificationLoaded(
        notifications: [tNotification1],
        currentPage: 1,
        hasMore: false,
      ),
      act: (b) => b.add(const DeleteNotificationEvent('1')),
      expect: () => [
        const NotificationError('Server Failure'),
      ],
    );

    // ===== SEARCH =====

    blocTest<NotificationBloc, NotificationState>(
      'emits [Loading, Loaded] when SearchNotificationsEvent succeeds',
      build: () {
        when(() => mockSearch.call('order')).thenAnswer(
          (_) async => Right([tNotification1]),
        );
        return bloc;
      },
      act: (b) => b.add(const SearchNotificationsEvent('order')),
      expect: () => [
        const NotificationLoading(),
        isA<NotificationLoaded>()
            .having((s) => s.notifications.length, 'count', 1)
            .having((s) => s.hasMore, 'hasMore', false),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'emits [Loading, Error] when SearchNotificationsEvent fails',
      build: () {
        when(() => mockSearch.call('test')).thenAnswer(
          (_) async => const Left(ServerFailure()),
        );
        return bloc;
      },
      act: (b) => b.add(const SearchNotificationsEvent('test')),
      expect: () => [
        const NotificationLoading(),
        const NotificationError('Server Failure'),
      ],
    );

    // ===== GET DETAIL =====

    blocTest<NotificationBloc, NotificationState>(
      'emits [Loading, DetailLoaded] when GetNotificationDetailEvent succeeds',
      build: () {
        when(() => mockGetDetail.call('1')).thenAnswer(
          (_) async => Right(tNotification1),
        );
        return bloc;
      },
      act: (b) => b.add(const GetNotificationDetailEvent('1')),
      expect: () => [
        const NotificationLoading(),
        isA<NotificationDetailLoaded>()
            .having((s) => s.notification.id, 'id', '1'),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'emits [Loading, Error] when GetNotificationDetailEvent fails',
      build: () {
        when(() => mockGetDetail.call('999')).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Not found')),
        );
        return bloc;
      },
      act: (b) => b.add(const GetNotificationDetailEvent('999')),
      expect: () => [
        const NotificationLoading(),
        const NotificationError('Not found'),
      ],
    );

    // ===== CREATE =====

    blocTest<NotificationBloc, NotificationState>(
      'emits [OperationSuccess, Loaded] when CreateNotificationEvent succeeds',
      build: () {
        final newNotification = AppNotification(
          id: '4',
          title: 'New Notification',
          body: 'New body',
          isRead: false,
          userId: 'user1',
          createdAt: DateTime.now(),
        );
        when(() => mockCreate.call(any())).thenAnswer(
          (_) async => Right(newNotification),
        );
        return bloc;
      },
      seed: () => NotificationLoaded(
        notifications: [tNotification1],
        currentPage: 1,
        hasMore: false,
      ),
      act: (b) => b.add(CreateNotificationEvent(AppNotification(
        id: '4',
        title: 'New Notification',
        body: 'New body',
        isRead: false,
        userId: 'user1',
        createdAt: DateTime.now(),
      ))),
      expect: () => [
        isA<NotificationOperationSuccess>()
            .having((s) => s.type, 'type', NotificationOperationType.create),
        isA<NotificationLoaded>()
            .having((s) => s.notifications.length, 'count', 2),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'emits [Error] when CreateNotificationEvent fails',
      build: () {
        when(() => mockCreate.call(any())).thenAnswer(
          (_) async => const Left(ServerFailure()),
        );
        return bloc;
      },
      act: (b) => b.add(CreateNotificationEvent(AppNotification(
        id: '4',
        title: 'New Notification',
        body: 'New body',
        isRead: false,
        userId: 'user1',
        createdAt: DateTime.now(),
      ))),
      expect: () => [
        const NotificationError('Server Failure'),
      ],
    );
  });
}
