import 'package:equatable/equatable.dart';

/// Base class for all dashboard events.
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load dashboard statistics for the first time.
class LoadDashboardEvent extends DashboardEvent {
  const LoadDashboardEvent();
}

/// Event to refresh dashboard statistics (pull-to-refresh).
class RefreshDashboardEvent extends DashboardEvent {
  const RefreshDashboardEvent();
}
