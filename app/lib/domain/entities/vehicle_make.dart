import 'package:equatable/equatable.dart';

class VehicleMake extends Equatable {
  final int makeId;
  final String name;
  final String? logoUrl;

  const VehicleMake({required this.makeId, required this.name, this.logoUrl});

  @override
  List<Object?> get props => [makeId, name, logoUrl];
}
