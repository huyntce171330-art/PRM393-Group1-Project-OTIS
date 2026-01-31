import 'package:freezed_annotation/freezed_annotation.dart';

part 'tire_spec.freezed.dart';

/// Domain entity representing tire specifications in the system.
/// This entity contains business logic and is immutable.
@freezed
class TireSpec with _$TireSpec {
  const TireSpec._(); // Private constructor for adding custom methods

  const factory TireSpec({
    /// Unique identifier for the tire specification
    required String id,

    /// Tire width in millimeters
    required int width,

    /// Tire aspect ratio (height/width percentage)
    required int aspectRatio,

    /// Rim diameter in inches
    required int rimDiameter,
  }) = _TireSpec;

  /// Get the formatted display string for tire specifications
  /// Format: "width/aspectRatio RrimDiameter" (e.g., "205/55 R16")
  String get display => '$width/$aspectRatio R$rimDiameter';

  /// Check if the tire spec is valid (all dimensions are positive)
  bool get isValid => width > 0 && aspectRatio > 0 && rimDiameter > 0;

  /// Get tire width as string with unit
  String get widthString => '${width}mm';

  /// Get aspect ratio as string with percentage
  String get aspectRatioString => '$aspectRatio%';

  /// Get rim diameter as string with unit
  String get rimDiameterString => '${rimDiameter}"';
}