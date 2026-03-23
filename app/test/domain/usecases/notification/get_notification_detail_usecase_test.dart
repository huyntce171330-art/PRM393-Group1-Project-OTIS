import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/usecases/notification/get_notification_detail_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend_otis/domain/repositories/notification_repository.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

class FakeAppNotification extends Fake implements AppNotification {}

void main() {
  late GetNotificationDetailUsecase usecase;
  late MockNotificationRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeAppNotification());
  });

  setUp(() {
    mockRepository = MockNotificationRepository();
    usecase = GetNotificationDetailUsecase(mockRepository);
  });

  group('GetNotificationDetailUsecase', () {
    final tNotification = AppNotification(
      id: '1',
      title: 'Order Confirmed',
      body: 'Your order has been confirmed.',
      isRead: false,
      userId: 'user1',
      createdAt: DateTime(2024, 3, 15, 10, 30),
    );

    test('should return Right(AppNotification) when detail fetch succeeds', () async {
      when(() => mockRepository.getNotificationDetail('1'))
          .thenAnswer((_) async => Right(tNotification));

      final result = await usecase.call('1');

      expect(result, equals(Right(tNotification)));
      verify(() => mockRepository.getNotificationDetail('1')).called(1);
    });

    test('should return Left(ServerFailure) when detail fetch fails', () async {
      when(() => mockRepository.getNotificationDetail('999'))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Not found')));

      final result = await usecase.call('999');

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, 'Not found'),
        (_) => fail('Expected Left'),
      );
    });

    test('should return Left(NetworkFailure) on network error', () async {
      when(() => mockRepository.getNotificationDetail('1'))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await usecase.call('1');

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('should call repository with correct notification id', () async {
      when(() => mockRepository.getNotificationDetail('custom-id'))
          .thenAnswer((_) async => Right(tNotification));

      await usecase.call('custom-id');

      verify(() => mockRepository.getNotificationDetail('custom-id')).called(1);
    });
  });
}
