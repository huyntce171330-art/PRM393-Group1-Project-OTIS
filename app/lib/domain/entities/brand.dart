import 'package:equatable/equatable.dart';

class Brand extends Equatable {
  final int brandId;
  final String name;
  final String? logoUrl;

  const Brand({required this.brandId, required this.name, this.logoUrl});

  @override
  List<Object?> get props => [brandId, name, logoUrl];
}
