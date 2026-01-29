import 'package:equatable/equatable.dart';

class TireSpec extends Equatable {
  final int tireSpecId;
  final int width;
  final int aspectRatio;
  final int rimDiameter;

  const TireSpec({
    required this.tireSpecId,
    required this.width,
    required this.aspectRatio,
    required this.rimDiameter,
  });

  @override
  List<Object?> get props => [tireSpecId, width, aspectRatio, rimDiameter];
}
