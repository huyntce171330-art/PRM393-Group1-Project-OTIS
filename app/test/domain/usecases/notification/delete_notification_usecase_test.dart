import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';
import 'package:frontend_otis/domain/usecases/notification/delete_notification_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend_otis/domain/repositories/notification_repository.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late DeleteNotificationUsecase usecase;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    usecase = DeleteNotificationUsecase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const NotificationFilter());
  });

  group('DeleteNotificationUsecase', () {
    const tId = '1';

    test('should return Right(null) when delete succeeds', () async {
      when(() => mockRepository.deleteNotification(tId))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase.call(tId);

      expect(result, equals(const Right(null)));
      verify(() => mockRepository.deleteNotification(tId)).called(1);
    });

    test('should return Left(ServerFailure) when delete fails', () async {
      when(() => mockRepository.deleteNotification(tId))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Delete failed')));

      final result = await usecase.call(tId);

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, 'Delete failed'),
        (_) => fail('Expected Left'),
      );
    });

    test('should return Left(NetworkFailure) on network error', () async {
      when(() => mockRepository.deleteNotification(tId))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await usecase.call(tId);

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
