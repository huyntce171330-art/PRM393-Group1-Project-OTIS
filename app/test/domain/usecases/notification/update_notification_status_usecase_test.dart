import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';
import 'package:frontend_otis/domain/usecases/notification/update_notification_status_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend_otis/domain/repositories/notification_repository.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late UpdateNotificationStatusUsecase usecase;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    usecase = UpdateNotificationStatusUsecase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const NotificationFilter());
  });

  group('UpdateNotificationStatusUsecase', () {
    const tId = '1';
    const tIsRead = true;

    test('should return Right(null) when update succeeds', () async {
      when(() => mockRepository.updateNotificationStatus(tId, tIsRead))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase.call(tId, tIsRead);

      expect(result, equals(const Right(null)));
      verify(() => mockRepository.updateNotificationStatus(tId, tIsRead)).called(1);
    });

    test('should return Left(ServerFailure) when update fails', () async {
      when(() => mockRepository.updateNotificationStatus(tId, tIsRead))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Update failed')));

      final result = await usecase.call(tId, tIsRead);

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, 'Update failed'),
        (_) => fail('Expected Left'),
      );
    });

    test('should return Left(NetworkFailure) on network error', () async {
      when(() => mockRepository.updateNotificationStatus(tId, tIsRead))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await usecase.call(tId, tIsRead);

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
