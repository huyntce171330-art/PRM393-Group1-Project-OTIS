import 'package:equatable/equatable.dart';
import 'package:frontend_otis/domain/entities/shop_location.dart';

/// Base class for all Map states.
abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action.
class MapInitial extends MapState {
  const MapInitial();
}

/// State while loading data.
class MapLoading extends MapState {
  const MapLoading();
}

/// State when shop locations are loaded successfully.
class ShopLocationsLoaded extends MapState {
  final List<ShopLocation> shopLocations;

  const ShopLocationsLoaded({required this.shopLocations});

  @override
  List<Object?> get props => [shopLocations];
}

/// State when a single shop location is loaded.
class ShopLocationDetailLoaded extends MapState {
  final ShopLocation shopLocation;

  const ShopLocationDetailLoaded({required this.shopLocation});

  @override
  List<Object?> get props => [shopLocation];
}

/// State when a shop location is created successfully.
class ShopLocationCreated extends MapState {
  final ShopLocation shopLocation;

  const ShopLocationCreated({required this.shopLocation});

  @override
  List<Object?> get props => [shopLocation];
}

/// State when a shop location is updated successfully.
class ShopLocationUpdated extends MapState {
  final ShopLocation shopLocation;

  const ShopLocationUpdated({required this.shopLocation});

  @override
  List<Object?> get props => [shopLocation];
}

/// State when a shop location is deleted successfully.
class ShopLocationDeleted extends MapState {
  final String shopId;

  const ShopLocationDeleted({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

/// State when a shop location is restored successfully.
class ShopLocationRestored extends MapState {
  final String shopId;

  const ShopLocationRestored({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

/// State when current location is loaded.
class CurrentLocationLoaded extends MapState {
  final double latitude;
  final double longitude;

  const CurrentLocationLoaded({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

/// State when route is calculated.
class RouteCalculated extends MapState {
  final List<({double lat, double lng})> routePoints;

  const RouteCalculated({required this.routePoints});

  @override
  List<Object?> get props => [routePoints];
}

/// State when an error occurs.
class MapError extends MapState {
  final String message;

  const MapError({required this.message});

  @override
  List<Object?> get props => [message];
}
