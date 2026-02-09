import 'package:equatable/equatable.dart';

/// Domain entity representing a vehicle make in the system.
/// This entity contains business logic and is immutable.
class VehicleMake extends Equatable {
  /// Unique identifier for the vehicle make
  final String id;

  /// Vehicle make name
  final String name;

  /// URL to vehicle make logo image
  final String logoUrl;

  const VehicleMake({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  @override
  List<Object?> get props => [id, name, logoUrl];

  /// Create a copy of VehicleMake with modified fields
  VehicleMake copyWith({String? id, String? name, String? logoUrl}) {
    return VehicleMake(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  /// Check if the vehicle make has a logo
  bool get hasLogo => logoUrl.isNotEmpty;

  /// Get the vehicle make's display name (name or 'Unknown Make' if empty)
  String get displayName => name.isNotEmpty ? name : 'Unknown Make';

  /// Check if the vehicle make is valid (has non-empty name)
  bool get isValid => name.isNotEmpty;
}
