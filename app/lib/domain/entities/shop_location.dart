import 'package:equatable/equatable.dart';

/// Domain entity representing a shop location in the system.
/// This entity contains business logic and is immutable.
class ShopLocation extends Equatable {
  /// Unique identifier for the shop location
  final String id;

  /// Shop name
  final String name;

  /// Shop phone number
  final String phone;

  /// Full address (street, district, city)
  final String address;

  /// Latitude coordinate
  final double latitude;

  /// Longitude coordinate
  final double longitude;

  /// URL to shop storefront image
  final String? imageUrl;

  /// Whether the shop is active
  final bool isActive;

  /// When the shop was created
  final DateTime createdAt;

  /// When the shop was last updated
  final DateTime? updatedAt;

  const ShopLocation({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        address,
        latitude,
        longitude,
        imageUrl,
        isActive,
        createdAt,
        updatedAt,
      ];

  /// Create a copy of ShopLocation with modified fields
  ShopLocation copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    double? latitude,
    double? longitude,
    String? imageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShopLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if location is valid
  bool get isValid => latitude != 0.0 && longitude != 0.0;

  /// Get formatted coordinate string
  String get formattedCoordinates =>
      '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';

  /// Get formatted creation date
  String get formattedCreatedAt {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
  }
}
