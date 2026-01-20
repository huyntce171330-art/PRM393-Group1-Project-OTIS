import '../../domain/entities/product.dart';

class CategoryModel extends Category {
  CategoryModel({required super.id, required super.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name']);
  }
}

class ProductDetailModel extends ProductDetail {
  ProductDetailModel({
    required super.productId,
    required super.description,
    required super.brand,
    required super.origin,
    required super.warrantyMonths,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      productId: json['product_id'],
      description: json['description'],
      brand: json['brand'] ?? '',
      origin: json['origin'] ?? '',
      warrantyMonths: json['warranty_months'] ?? 0,
    );
  }
}

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.categoryId,
    required super.name,
    required super.price,
    required super.thumbnailUrl,
    super.category,
    super.productDetail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      thumbnailUrl: json['thumbnail_url'] ?? '',
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      productDetail: json['product_detail'] != null
          ? ProductDetailModel.fromJson(json['product_detail'])
          : null,
    );
  }
}
