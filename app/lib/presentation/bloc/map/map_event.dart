import 'package:equatable/equatable.dart';
import 'package:frontend_otis/domain/entities/shop_location.dart';

/// Base class for all Map events.
abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all shop locations.
class LoadShopLocationsEvent extends MapEvent {
  const LoadShopLocationsEvent();
}

/// Event to load a single shop location by ID.
class LoadShopLocationByIdEvent extends MapEvent {
  final String shopId;

  const LoadShopLocationByIdEvent({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

/// Event to create a new shop location.
class CreateShopLocationEvent extends MapEvent {
  final ShopLocation shopLocation;

  const CreateShopLocationEvent({required this.shopLocation});

  @override
  List<Object?> get props => [shopLocation];
}

/// Event to update an existing shop location.
class UpdateShopLocationEvent extends MapEvent {
  final String shopId;
  final ShopLocation shopLocation;

  const UpdateShopLocationEvent({
    required this.shopId,
    required this.shopLocation,
  });

  @override
  List<Object?> get props => [shopId, shopLocation];
}

/// Event to delete a shop location (soft delete).
class DeleteShopLocationEvent extends MapEvent {
  final String shopId;

  const DeleteShopLocationEvent({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

/// Event to restore a deleted shop location.
class RestoreShopLocationEvent extends MapEvent {
  final String shopId;

  const RestoreShopLocationEvent({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

/// Event to permanently delete a shop location.
class PermanentDeleteShopLocationEvent extends MapEvent {
  final String shopId;

  const PermanentDeleteShopLocationEvent({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

/// Event to load current device location.
class LoadCurrentLocationEvent extends MapEvent {
  const LoadCurrentLocationEvent();
}

/// Event to calculate route between two points.
class CalculateRouteEvent extends MapEvent {
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;

  const CalculateRouteEvent({
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
  });

  @override
  List<Object?> get props => [startLat, startLng, endLat, endLng];
}
