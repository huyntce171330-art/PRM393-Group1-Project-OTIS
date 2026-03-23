import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/presentation/screens/notification/notification_detail_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_bloc.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_event.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_state.dart';

class MockNotificationBloc extends MockBloc<NotificationEvent, NotificationState>
    implements NotificationBloc {}

class FakeNotificationEvent extends Fake implements NotificationEvent {}
class FakeAppNotification extends Fake implements AppNotification {}

void main() {
  late MockNotificationBloc mockBloc;

  final tNotificationRead = AppNotification(
    id: '1',
    title: 'Order Confirmed',
    body: 'Your order for Michelin Primacy 4 tires has been confirmed and is being processed.',
    isRead: true,
    userId: 'user1',
    createdAt: DateTime(2024, 3, 15, 10, 30),
  );

  final tNotificationUnread = AppNotification(
    id: '2',
    title: 'New Promotion',
    body: 'Get 20% off on all winter tires. Limited time offer ends soon!',
    isRead: false,
    userId: 'user1',
    createdAt: DateTime(2024, 3, 14, 8, 0),
  );

  setUpAll(() {
    registerFallbackValue(FakeNotificationEvent());
    registerFallbackValue(FakeAppNotification());
  });

  setUp(() {
    mockBloc = MockNotificationBloc();
    when(() => mockBloc.state).thenReturn(const NotificationInitial());
  });

  tearDown(() {
    mockBloc.close();
  });

  Widget makeTestableWidget({
    String? notificationId,
    AppNotification? notification,
  }) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => BlocProvider<NotificationBloc>.value(
              value: mockBloc,
              child: NotificationDetailScreen(
                notificationId: notificationId,
                notification: notification,
              ),
            ),
          ),
        ],
      ),
    );
  }

  group('NotificationDetailScreen', () {
    testWidgets('renders CircularProgressIndicator when notification is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(notificationId: '1'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders notification title and body when notification is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(notification: tNotificationRead));
      await tester.pump();

      expect(find.text('Order Confirmed'), findsOneWidget);
      expect(
        find.text('Your order for Michelin Primacy 4 tires has been confirmed and is being processed.'),
        findsOneWidget,
      );
    });

    testWidgets('renders Read badge when notification isRead is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(notification: tNotificationRead));
      await tester.pump();

      expect(find.text('Read'), findsOneWidget);
    });

    testWidgets('renders Unread badge when notification isRead is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(notification: tNotificationUnread));
      await tester.pump();

      expect(find.text('Unread'), findsOneWidget);
    });

    testWidgets('auto-dispatches MarkAsReadEvent when notification is unread', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(notification: tNotificationUnread));
      await tester.pump();

      verify(() => mockBloc.add(MarkAsReadEvent('2'))).called(1);
    });

    testWidgets('does NOT auto-dispatch MarkAsReadEvent when notification is already read', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(notification: tNotificationRead));
      await tester.pump();

      verifyNever(() => mockBloc.add(any(that: isA<MarkAsReadEvent>())));
    });

    testWidgets('renders formatted date', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(notification: tNotificationRead));
      await tester.pump();

      expect(find.text('March 15, 2024 at 10:30 AM'), findsOneWidget);
    });

    testWidgets('renders delete icon button when notification is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(notification: tNotificationRead));
      await tester.pump();

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('delete icon button shows confirmation dialog', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(notification: tNotificationRead));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('Delete Notification'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this notification?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('cancel button dismisses confirmation dialog', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(notification: tNotificationRead));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Notification'), findsNothing);
    });

    testWidgets('delete button shows dialog with Delete action', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(notification: tNotificationRead));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('Delete Notification'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('renders notification icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(notification: tNotificationRead));
      await tester.pump();

      expect(find.byIcon(Icons.notifications), findsOneWidget);
    });
  });
}
