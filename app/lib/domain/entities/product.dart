import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int productId;
  final String sku;
  final String name;
  final String? imageUrl;
  final int brandId;
  final int? makeId;
  final int tireSpecId;
  final double price;
  final int stockQuantity;
  final bool isActive;
  final DateTime createdAt;

  const Product({
    required this.productId,
    required this.sku,
    required this.name,
    this.imageUrl,
    required this.brandId,
    this.makeId,
    required this.tireSpecId,
    required this.price,
    required this.stockQuantity,
    required this.isActive,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    productId,
    sku,
    name,
    imageUrl,
    brandId,
    makeId,
    tireSpecId,
    price,
    stockQuantity,
    isActive,
    createdAt,
  ];
}
