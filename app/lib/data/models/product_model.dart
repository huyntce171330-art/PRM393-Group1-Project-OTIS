import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required int productId,
    required String sku,
    required String name,
    String? imageUrl,
    required int brandId,
    int? makeId,
    required int tireSpecId,
    required double price,
    required int stockQuantity,
    required bool isActive,
    required DateTime createdAt,
  }) : super(
         productId: productId,
         sku: sku,
         name: name,
         imageUrl: imageUrl,
         brandId: brandId,
         makeId: makeId,
         tireSpecId: tireSpecId,
         price: price,
         stockQuantity: stockQuantity,
         isActive: isActive,
         createdAt: createdAt,
       );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'],
      sku: json['sku'],
      name: json['name'],
      imageUrl: json['image_url'],
      brandId: json['brand_id'],
      makeId: json['make_id'],
      tireSpecId: json['tire_spec_id'],
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stock_quantity'],
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'sku': sku,
      'name': name,
      'image_url': imageUrl,
      'brand_id': brandId,
      'make_id': makeId,
      'tire_spec_id': tireSpecId,
      'price': price,
      'stock_quantity': stockQuantity,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
