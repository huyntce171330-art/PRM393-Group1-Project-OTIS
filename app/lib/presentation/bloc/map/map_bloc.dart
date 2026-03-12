import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/domain/repositories/map_repository.dart';
import 'package:frontend_otis/presentation/bloc/map/map_event.dart';
import 'package:frontend_otis/presentation/bloc/map/map_state.dart';

/// BLoC for handling map and shop location operations.
class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository repository;

  MapBloc({required this.repository}) : super(const MapInitial()) {
    on<LoadShopLocationsEvent>(_onLoadShopLocations);
    on<LoadShopLocationByIdEvent>(_onLoadShopLocationById);
    on<CreateShopLocationEvent>(_onCreateShopLocation);
    on<UpdateShopLocationEvent>(_onUpdateShopLocation);
    on<DeleteShopLocationEvent>(_onDeleteShopLocation);
    on<RestoreShopLocationEvent>(_onRestoreShopLocation);
    on<LoadCurrentLocationEvent>(_onLoadCurrentLocation);
    on<CalculateRouteEvent>(_onCalculateRoute);
  }

  Future<void> _onLoadShopLocations(
    LoadShopLocationsEvent event,
    Emitter<MapState> emit,
  ) async {
    emit(const MapLoading());
    final result = await repository.getShopLocations();
    result.fold(
      (failure) => emit(MapError(message: failure.message)),
      (shopLocations) => emit(ShopLocationsLoaded(shopLocations: shopLocations)),
    );
  }

  Future<void> _onLoadShopLocationById(
    LoadShopLocationByIdEvent event,
    Emitter<MapState> emit,
  ) async {
    emit(const MapLoading());
    final result = await repository.getShopLocationById(shopId: event.shopId);
    result.fold(
      (failure) => emit(MapError(message: failure.message)),
      (shopLocation) => emit(ShopLocationDetailLoaded(shopLocation: shopLocation)),
    );
  }

  Future<void> _onCreateShopLocation(
    CreateShopLocationEvent event,
    Emitter<MapState> emit,
  ) async {
    emit(const MapLoading());
    final result = await repository.createShopLocation(shopLocation: event.shopLocation);
    result.fold(
      (failure) => emit(MapError(message: failure.message)),
      (shopLocation) => emit(ShopLocationCreated(shopLocation: shopLocation)),
    );
  }

  Future<void> _onUpdateShopLocation(
    UpdateShopLocationEvent event,
    Emitter<MapState> emit,
  ) async {
    emit(const MapLoading());
    final result = await repository.updateShopLocation(
      shopId: event.shopId,
      shopLocation: event.shopLocation,
    );
    result.fold(
      (failure) => emit(MapError(message: failure.message)),
      (shopLocation) => emit(ShopLocationUpdated(shopLocation: shopLocation)),
    );
  }

  Future<void> _onDeleteShopLocation(
    DeleteShopLocationEvent event,
    Emitter<MapState> emit,
  ) async {
    emit(const MapLoading());
    final result = await repository.deleteShopLocation(shopId: event.shopId);
    result.fold(
      (failure) => emit(MapError(message: failure.message)),
      (_) => emit(ShopLocationDeleted(shopId: event.shopId)),
    );
  }

  Future<void> _onRestoreShopLocation(
    RestoreShopLocationEvent event,
    Emitter<MapState> emit,
  ) async {
    emit(const MapLoading());
    final result = await repository.restoreShopLocation(shopId: event.shopId);
    result.fold(
      (failure) => emit(MapError(message: failure.message)),
      (_) => emit(ShopLocationRestored(shopId: event.shopId)),
    );
  }

  Future<void> _onLoadCurrentLocation(
    LoadCurrentLocationEvent event,
    Emitter<MapState> emit,
  ) async {
    emit(const MapLoading());
    final result = await repository.getCurrentLocation();
    result.fold(
      (failure) => emit(MapError(message: failure.message)),
      (location) => emit(CurrentLocationLoaded(
        latitude: location.latitude,
        longitude: location.longitude,
      )),
    );
  }

  Future<void> _onCalculateRoute(
    CalculateRouteEvent event,
    Emitter<MapState> emit,
  ) async {
    emit(const MapLoading());
    final result = await repository.getRoute(
      startLat: event.startLat,
      startLng: event.startLng,
      endLat: event.endLat,
      endLng: event.endLng,
    );
    result.fold(
      (failure) => emit(MapError(message: failure.message)),
      (routePoints) => emit(RouteCalculated(routePoints: routePoints)),
    );
  }
}
