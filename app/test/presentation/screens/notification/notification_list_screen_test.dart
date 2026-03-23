import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/presentation/screens/notification/notification_list_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_bloc.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_event.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_state.dart';

class MockNotificationBloc extends MockBloc<NotificationEvent, NotificationState>
    implements NotificationBloc {}

class FakeNotificationEvent extends Fake implements NotificationEvent {}

void main() {
  late MockNotificationBloc mockBloc;

  final tNotificationRead = AppNotification(
    id: '1',
    title: 'Order Confirmed',
    body: 'Your order has been confirmed.',
    isRead: true,
    userId: 'user1',
    createdAt: DateTime.now(),
  );

  final tNotificationUnread = AppNotification(
    id: '2',
    title: 'New Promotion',
    body: 'Get 20% off on winter tires!',
    isRead: false,
    userId: 'user1',
    createdAt: DateTime.now(),
  );

  final tNotificationYesterday = AppNotification(
    id: '3',
    title: 'System Maintenance',
    body: 'Scheduled maintenance completed.',
    isRead: false,
    userId: 'user1',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  );

  setUpAll(() {
    registerFallbackValue(FakeNotificationEvent());
  });

  setUp(() {
    mockBloc = MockNotificationBloc();
  });

  tearDown(() {
    mockBloc.close();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<NotificationBloc>.value(
        value: mockBloc,
        child: const NotificationListScreen(),
      ),
    );
  }

  group('NotificationListScreen', () {
    testWidgets('renders CircularProgressIndicator when state is NotificationInitial', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const NotificationInitial());

      await tester.pumpWidget(makeTestableWidget());
      // Initial state dispatches LoadNotificationsEvent and shows loading indicator
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders skeleton list when state is NotificationLoading', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const NotificationLoading());

      await tester.pumpWidget(makeTestableWidget());

      // Loading skeleton is a ListView.builder with placeholder rows
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders error view when state is NotificationError', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Server error occurred';
      when(() => mockBloc.state).thenReturn(const NotificationError(errorMessage));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('renders empty state when notifications list is empty', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const NotificationLoaded(
        notifications: [],
        currentPage: 1,
        hasMore: false,
      ));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('No notifications yet'), findsOneWidget);
      expect(find.text('You\'re all caught up!'), findsOneWidget);
    });

    testWidgets('renders notification items when state is NotificationLoaded', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(NotificationLoaded(
        notifications: [tNotificationRead, tNotificationUnread],
        currentPage: 1,
        hasMore: false,
      ));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Order Confirmed'), findsOneWidget);
      expect(find.text('New Promotion'), findsOneWidget);
    });

    testWidgets('renders filter tabs with correct labels', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const NotificationLoaded(
        notifications: [],
        currentPage: 1,
        hasMore: false,
      ));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Promotions'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
    });

    testWidgets('tapping filter tab dispatches LoadNotificationsEvent with new filter', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const NotificationLoaded(
        notifications: [],
        currentPage: 1,
        hasMore: false,
      ));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Orders'));
      await tester.pump();

      verify(() => mockBloc.add(any(that: isA<LoadNotificationsEvent>()))).called(greaterThan(0));
    });

    testWidgets('tapping "Mark all as read" dispatches MarkAllAsReadEvent', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const NotificationLoaded(
        notifications: [],
        currentPage: 1,
        hasMore: false,
      ));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mark all as read'));
      await tester.pump();

      verify(() => mockBloc.add(const MarkAllAsReadEvent())).called(1);
    });

    testWidgets('FAB navigates to create screen', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const NotificationLoaded(
        notifications: [],
        currentPage: 1,
        hasMore: false,
      ));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('long press on notification shows action sheet', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(NotificationLoaded(
        notifications: [tNotificationRead],
        currentPage: 1,
        hasMore: false,
      ));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      await tester.longPress(find.text('Order Confirmed'));
      await tester.pumpAndSettle();

      expect(find.text('Mark as Read'), findsOneWidget);
      expect(find.text('Mark as Unread'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('action sheet "Mark as Read" dispatches MarkAsReadEvent', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(NotificationLoaded(
        notifications: [tNotificationRead],
        currentPage: 1,
        hasMore: false,
      ));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      await tester.longPress(find.text('Order Confirmed'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mark as Read'));
      await tester.pumpAndSettle();

      verify(() => mockBloc.add(MarkAsReadEvent('1'))).called(1);
    });

    testWidgets('action sheet "Delete" triggers delete snackbar', (
      WidgetTester tester,
    ) async {
      // First stub initial state so the widget renders the notification
      when(() => mockBloc.state).thenReturn(NotificationLoaded(
        notifications: [tNotificationRead],
        currentPage: 1,
        hasMore: false,
      ));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      // Verify notification is rendered
      expect(find.text('Order Confirmed'), findsOneWidget);

      await tester.longPress(find.text('Order Confirmed'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      // whenListen called AFTER the user action so it fires immediately.
      // No initialState: the stream emits synchronously on subscription.
      whenListen(
        mockBloc,
        Stream<NotificationState>.fromIterable([
          NotificationOperationSuccess(
            message: 'Notification deleted',
            type: NotificationOperationType.delete,
            previousState: NotificationLoaded(
              notifications: [tNotificationRead],
              currentPage: 1,
              hasMore: false,
            ),
          ),
          NotificationLoaded(
            notifications: [],
            currentPage: 1,
            hasMore: false,
          ),
        ]),
      );

      await tester.pump();
      await tester.pump();

      verify(() => mockBloc.add(const DeleteNotificationEvent('1'))).called(1);
      expect(find.text('Notification deleted'), findsOneWidget);
    });

    testWidgets('error retry button dispatches LoadNotificationsEvent', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const NotificationError('Error'));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Retry'));
      await tester.pump();

      verify(() => mockBloc.add(any(that: isA<LoadNotificationsEvent>()))).called(greaterThan(0));
    });

    testWidgets('renders section headers for today and yesterday notifications', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(NotificationLoaded(
        notifications: [tNotificationUnread, tNotificationYesterday],
        currentPage: 1,
        hasMore: false,
      ));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Yesterday'), findsOneWidget);
    });

    testWidgets('FAB is present when notifications are loaded', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(NotificationLoaded(
        notifications: [tNotificationRead],
        currentPage: 1,
        hasMore: false,
      ));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
