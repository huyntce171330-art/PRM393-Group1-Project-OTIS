import 'package:equatable/equatable.dart';

/// Domain entity representing tire specifications in the system.
/// This entity contains business logic and is immutable.
class TireSpec extends Equatable {
  /// Unique identifier for the tire specification
  final String id;

  /// Tire width in millimeters
  final int width;

  /// Tire aspect ratio (height/width percentage)
  final int aspectRatio;

  /// Rim diameter in inches
  final int rimDiameter;

  const TireSpec({
    required this.id,
    required this.width,
    required this.aspectRatio,
    required this.rimDiameter,
  });

  @override
  List<Object?> get props => [id, width, aspectRatio, rimDiameter];

  /// Create a copy of TireSpec with modified fields
  TireSpec copyWith({
    String? id,
    int? width,
    int? aspectRatio,
    int? rimDiameter,
  }) {
    return TireSpec(
      id: id ?? this.id,
      width: width ?? this.width,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      rimDiameter: rimDiameter ?? this.rimDiameter,
    );
  }

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
  String get rimDiameterString => '$rimDiameter"';
}
