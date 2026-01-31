import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand.freezed.dart';

/// Domain entity representing a brand in the system.
/// This entity contains business logic and is immutable.
@freezed
class Brand with _$Brand {
  const Brand._(); // Private constructor for adding custom methods

  const factory Brand({
    /// Unique identifier for the brand
    required String id,

    /// Brand name
    required String name,

    /// URL to brand logo image
    required String logoUrl,
  }) = _Brand;

  /// Check if the brand has a logo
  bool get hasLogo => logoUrl.isNotEmpty;

  /// Get the brand's display name (name or 'Unknown Brand' if empty)
  String get displayName => name.isNotEmpty ? name : 'Unknown Brand';

  /// Check if the brand is valid (has non-empty name)
  bool get isValid => name.isNotEmpty;
}