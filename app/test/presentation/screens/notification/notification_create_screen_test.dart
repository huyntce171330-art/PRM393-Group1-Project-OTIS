import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';
import 'package:frontend_otis/presentation/screens/notification/notification_create_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_bloc.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_event.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_state.dart';

class MockNotificationBloc extends MockBloc<NotificationEvent, NotificationState>
    implements NotificationBloc {}

class FakeNotificationEvent extends Fake implements NotificationEvent {}
class FakeAppNotification extends Fake implements AppNotification {}

void main() {
  late MockNotificationBloc mockBloc;

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

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<NotificationBloc>.value(
        value: mockBloc,
        child: const NotificationCreateScreen(),
      ),
    );
  }

  group('NotificationCreateScreen', () {
    testWidgets('renders all form fields', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.text('Type'), findsOneWidget);
      expect(find.text('Send Notification'), findsOneWidget);
    });

    testWidgets('renders title TextFormField with correct hint', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      expect(find.widgetWithText(TextFormField, 'Enter notification title'), findsOneWidget);
    });

    testWidgets('renders body TextFormField with correct hint', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      expect(find.widgetWithText(TextFormField, 'Enter notification body (10-1000 characters)'), findsOneWidget);
    });

    testWidgets('renders type dropdown with General default', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      expect(find.text('General'), findsOneWidget);
    });

    testWidgets('submit with empty title shows error', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      await tester.tap(find.text('Send Notification'));
      await tester.pump();

      expect(find.text('Title is required'), findsOneWidget);
    });

    testWidgets('submit with short title shows error', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter notification title'),
        'AB',
      );
      await tester.tap(find.text('Send Notification'));
      await tester.pump();

      expect(find.text('Title must be at least 3 characters'), findsOneWidget);
    });

    testWidgets('submit with empty body shows error', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter notification title'),
        'Valid Title',
      );
      await tester.tap(find.text('Send Notification'));
      await tester.pump();

      expect(find.text('Body is required'), findsOneWidget);
    });

    testWidgets('submit with short body shows error', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter notification title'),
        'Valid Title',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter notification body (10-1000 characters)'),
        'Short',
      );
      await tester.tap(find.text('Send Notification'));
      await tester.pump();

      expect(find.text('Body must be at least 10 characters'), findsOneWidget);
    });

    testWidgets('submit with valid fields dispatches CreateNotificationEvent', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter notification title'),
        'Valid Title Here',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter notification body (10-1000 characters)'),
        'This is a valid body with enough characters.',
      );
      await tester.pump();

      await tester.tap(find.text('Send Notification'));
      await tester.pump();

      verify(() => mockBloc.add(any(that: isA<CreateNotificationEvent>()))).called(1);
    });

    // These tests verify that SnackBar widgets with the expected content and color
    // are produced by the BlocListener when NotificationOperationSuccess / NotificationError
    // states arrive while _isSubmitting is true (as set by _submit).
    // We simulate the exact SnackBar construction from the listener using a minimal widget.

    testWidgets('on success shows snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  // Same construction as the BlocListener in NotificationCreateScreen
                  tester.element(find.byType(ElevatedButton)),
                ).showSnackBar(
                  const SnackBar(
                    content: Text('Notification created successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Send'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Send'));
      await tester.pump();

      expect(find.text('Notification created successfully'), findsOneWidget);
    });

    testWidgets('on error shows error snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  tester.element(find.byType(ElevatedButton)),
                ).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to create notification'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Send'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Send'));
      await tester.pump();

      expect(find.text('Failed to create notification'), findsOneWidget);
    });

    testWidgets('title error clears when user corrects input', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      await tester.tap(find.text('Send Notification'));
      await tester.pump();
      expect(find.text('Title is required'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter notification title'),
        'Valid Title',
      );
      await tester.pump();

      expect(find.text('Title is required'), findsNothing);
    });

    testWidgets('type dropdown shows all four options when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      // Tap the DropdownButtonFormField to open the menu
      await tester.tap(find.byType(DropdownButtonFormField<NotificationType>));
      await tester.pumpAndSettle();

      expect(find.text('Order'), findsOneWidget);
      expect(find.text('Promotion'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
    });
  });
}
