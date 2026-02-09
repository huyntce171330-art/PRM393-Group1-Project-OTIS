import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_make.freezed.dart';

/// Domain entity representing a vehicle make in the system.
/// This entity contains business logic and is immutable.
@freezed
class VehicleMake with _$VehicleMake {
  const VehicleMake._(); // Private constructor for adding custom methods

  const factory VehicleMake({
    /// Unique identifier for the vehicle make
    required String id,

    /// Vehicle make name
    required String name,

    /// URL to vehicle make logo image
    required String logoUrl,
  }) = _VehicleMake;

  /// Check if the vehicle make has a logo
  bool get hasLogo => logoUrl.isNotEmpty;

  /// Get the vehicle make's display name (name or 'Unknown Make' if empty)
  String get displayName => name.isNotEmpty ? name : 'Unknown Make';

  /// Check if the vehicle make is valid (has non-empty name)
  bool get isValid => name.isNotEmpty;
}
