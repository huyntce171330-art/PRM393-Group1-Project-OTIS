import '../../domain/entities/brand.dart';

class BrandModel extends Brand {
  const BrandModel({
    required int brandId,
    required String name,
    String? logoUrl,
  }) : super(brandId: brandId, name: name, logoUrl: logoUrl);

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      brandId: json['brand_id'],
      name: json['name'],
      logoUrl: json['logo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'brand_id': brandId, 'name': name, 'logo_url': logoUrl};
  }
}
