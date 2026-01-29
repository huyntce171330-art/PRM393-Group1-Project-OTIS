import '../../domain/entities/tire_spec.dart';

class TireSpecModel extends TireSpec {
  const TireSpecModel({
    required int tireSpecId,
    required int width,
    required int aspectRatio,
    required int rimDiameter,
  }) : super(
         tireSpecId: tireSpecId,
         width: width,
         aspectRatio: aspectRatio,
         rimDiameter: rimDiameter,
       );

  factory TireSpecModel.fromJson(Map<String, dynamic> json) {
    return TireSpecModel(
      tireSpecId: json['tire_spec_id'],
      width: json['width'],
      aspectRatio: json['aspect_ratio'],
      rimDiameter: json['rim_diameter'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tire_spec_id': tireSpecId,
      'width': width,
      'aspect_ratio': aspectRatio,
      'rim_diameter': rimDiameter,
    };
  }
}
