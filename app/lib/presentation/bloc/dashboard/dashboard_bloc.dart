import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/dashboard/get_dashboard_statistics_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardStatisticsUseCase _getDashboardStatisticsUseCase;

  DashboardBloc({
    required GetDashboardStatisticsUseCase getDashboardUseCase,
  })  : _getDashboardStatisticsUseCase = getDashboardUseCase,
        super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final result = await _getDashboardStatisticsUseCase();

    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (dashboard) => emit(DashboardLoaded(dashboard)),
    );
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    // Keep showing current data while refreshing
    final result = await _getDashboardStatisticsUseCase();

    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (dashboard) => emit(DashboardLoaded(dashboard)),
    );
  }
}
