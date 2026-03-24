import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard/dashboard_local_datasource.dart';

/// Implementation of [DashboardRepository].
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource _localDataSource;

  DashboardRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, DashboardEntity>> getDashboardStatistics() async {
    try {
      final model = await _localDataSource.getDashboardStatistics();
      return Right(model.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Unknown server error'));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load dashboard: $e'));
    }
  }
}
