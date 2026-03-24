import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';
import 'package:frontend_otis/domain/usecases/notification/create_notification_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend_otis/domain/repositories/notification_repository.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}
class FakeAppNotification extends Fake implements AppNotification {}

void main() {
  late CreateNotificationUsecase usecase;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    usecase = CreateNotificationUsecase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const NotificationFilter());
    registerFallbackValue(FakeAppNotification());
  });

  group('CreateNotificationUsecase', () {
    final tNotification = AppNotification(
      id: '1',
      title: 'Test Notification',
      body: 'Test body content',
      isRead: false,
      userId: 'user1',
      createdAt: DateTime.now(),
    );

    test('should return Right(AppNotification) when create succeeds', () async {
      when(() => mockRepository.createNotification(tNotification))
          .thenAnswer((_) async => Right(tNotification));

      final result = await usecase.call(tNotification);

      expect(result, equals(Right(tNotification)));
      verify(() => mockRepository.createNotification(tNotification)).called(1);
    });

    test('should return Left(ServerFailure) when create fails', () async {
      when(() => mockRepository.createNotification(tNotification))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Create failed')));

      final result = await usecase.call(tNotification);

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, 'Create failed'),
        (_) => fail('Expected Left'),
      );
    });

    test('should return Left(ValidationFailure) on validation error', () async {
      when(() => mockRepository.createNotification(tNotification))
          .thenAnswer((_) async => const Left(ValidationFailure(message: 'Invalid data')));

      final result = await usecase.call(tNotification);

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
