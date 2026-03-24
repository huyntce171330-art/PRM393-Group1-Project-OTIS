import 'package:dartz/dartz.dart';

import '../entities/dashboard_entity.dart';
import '../../../core/error/failures.dart';

/// Repository interface for dashboard operations.
abstract class DashboardRepository {
  /// Fetches aggregated dashboard statistics from the data source.
  Future<Either<Failure, DashboardEntity>> getDashboardStatistics();
}
