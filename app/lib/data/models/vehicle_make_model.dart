import '../../domain/entities/vehicle_make.dart';

class VehicleMakeModel extends VehicleMake {
  const VehicleMakeModel({
    required int makeId,
    required String name,
    String? logoUrl,
  }) : super(makeId: makeId, name: name, logoUrl: logoUrl);

  factory VehicleMakeModel.fromJson(Map<String, dynamic> json) {
    return VehicleMakeModel(
      makeId: json['make_id'],
      name: json['name'],
      logoUrl: json['logo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'make_id': makeId, 'name': name, 'logo_url': logoUrl};
  }
}
