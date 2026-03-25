import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/dashboard_entity.dart';
import '../../repositories/dashboard_repository.dart';

/// Use case to fetch dashboard statistics.
class GetDashboardStatisticsUseCase {
  final DashboardRepository _repository;

  GetDashboardStatisticsUseCase(this._repository);

  /// Executes the use case to retrieve dashboard statistics.
  Future<Either<Failure, DashboardEntity>> call() {
    return _repository.getDashboardStatistics();
  }
}
