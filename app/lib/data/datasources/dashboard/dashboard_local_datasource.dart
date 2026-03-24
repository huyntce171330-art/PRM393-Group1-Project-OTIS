import '../../models/dashboard_model.dart';

/// Abstract data source for fetching dashboard statistics from the local SQLite database.
abstract class DashboardLocalDataSource {
  /// Fetches all dashboard statistics aggregated from existing database tables.
  Future<DashboardModel> getDashboardStatistics();
}
