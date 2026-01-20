class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});
}

class ProductDetail {
  final int productId;
  final String description;
  final String brand;
  final String origin;
  final int warrantyMonths;

  ProductDetail({
    required this.productId,
    required this.description,
    required this.brand,
    required this.origin,
    required this.warrantyMonths,
  });
}

class Product {
  final int id;
  final int categoryId;
  final String name;
  final double price;
  final String thumbnailUrl;
  final Category? category;
  final ProductDetail? productDetail;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.thumbnailUrl,
    this.category,
    this.productDetail,
  });
}
