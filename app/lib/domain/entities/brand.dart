import 'package:equatable/equatable.dart';

/// Domain entity representing a brand in the system.
/// This entity contains business logic and is immutable.
class Brand extends Equatable {
  /// Unique identifier for the brand
  final String id;

  /// Brand name
  final String name;

  /// URL to brand logo image
  final String logoUrl;

  const Brand({required this.id, required this.name, required this.logoUrl});

  @override
  List<Object?> get props => [id, name, logoUrl];

  /// Create a copy of Brand with modified fields
  Brand copyWith({String? id, String? name, String? logoUrl}) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  /// Check if the brand has a logo
  bool get hasLogo => logoUrl.isNotEmpty;

  /// Get the brand's display name (name or 'Unknown Brand' if empty)
  String get displayName => name.isNotEmpty ? name : 'Unknown Brand';

  /// Check if the brand is valid (has non-empty name)
  bool get isValid => name.isNotEmpty;
}
