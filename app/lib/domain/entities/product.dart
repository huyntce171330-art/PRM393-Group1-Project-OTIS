import 'package:equatable/equatable.dart';
import 'package:frontend_otis/domain/entities/brand.dart';
import 'package:frontend_otis/domain/entities/vehicle_make.dart';
import 'package:frontend_otis/domain/entities/tire_spec.dart';

/// Domain entity representing a product in the system.
/// This entity contains business logic and is immutable.
class Product extends Equatable {
  /// Unique identifier for the product
  final String id;

  /// Product SKU (Stock Keeping Unit)
  final String sku;

  /// Product name
  final String name;

  /// URL to product image
  final String imageUrl;

  /// Product brand (nullable)
  final Brand? brand;

  /// Vehicle make compatibility (nullable)
  final VehicleMake? vehicleMake;

  /// Tire specifications (nullable)
  final TireSpec? tireSpec;

  /// Product price
  final double price;

  /// Available stock quantity
  final int stockQuantity;

  /// Whether the product is active/available
  final bool isActive;

  /// When the product was created
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.imageUrl,
    this.brand,
    this.vehicleMake,
    this.tireSpec,
    required this.price,
    required this.stockQuantity,
    required this.isActive,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    sku,
    name,
    imageUrl,
    brand,
    vehicleMake,
    tireSpec,
    price,
    stockQuantity,
    isActive,
    createdAt,
  ];

  /// Create a copy of Product with modified fields
  Product copyWith({
    String? id,
    String? sku,
    String? name,
    String? imageUrl,
    Brand? brand,
    VehicleMake? vehicleMake,
    TireSpec? tireSpec,
    double? price,
    int? stockQuantity,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      brand: brand ?? this.brand,
      vehicleMake: vehicleMake ?? this.vehicleMake,
      tireSpec: tireSpec ?? this.tireSpec,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if the product is in stock
  bool get isInStock => stockQuantity > 0;

  /// Check if the product is available (active and in stock)
  bool get isAvailable => isActive && isInStock;

  /// Get formatted price with Vietnamese Dong currency
  String get formattedPrice {
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ';
  }

  /// Get the product's display name (includes tire spec)
  String get displayName =>
      tireSpec != null ? '$name (${tireSpec!.display})' : name;

  /// Get the product's full specification string
  String get fullSpecification {
    final brandName = brand?.name ?? 'Unknown Brand';
    final vehicleName = vehicleMake?.name ?? 'Unknown Vehicle';
    final specDisplay = tireSpec?.display ?? '';
    return '$brandName $specDisplay for $vehicleName'.trim();
  }

  /// Check if the product is low on stock (less than 10 units)
  bool get isLowStock => stockQuantity < 10 && stockQuantity > 0;

  /// Check if the product is out of stock
  bool get isOutOfStock => stockQuantity == 0;

  /// Get stock status as string
  String get stockStatus {
    if (isOutOfStock) return 'Out of Stock';
    if (isLowStock) return 'Low Stock ($stockQuantity)';
    return 'In Stock ($stockQuantity)';
  }

  /// Get formatted creation date
  String get formattedCreatedAt {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
  }
}
