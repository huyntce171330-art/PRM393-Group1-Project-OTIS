import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend_otis/domain/entities/brand.dart';
import 'package:frontend_otis/domain/entities/vehicle_make.dart';
import 'package:frontend_otis/domain/entities/tire_spec.dart';

part 'product.freezed.dart';

/// Domain entity representing a product in the system.
/// This entity contains business logic and is immutable.
@freezed
class Product with _$Product {
  const Product._(); // Private constructor for adding custom methods

  const factory Product({
    /// Unique identifier for the product
    required String id,

    /// Product SKU (Stock Keeping Unit)
    required String sku,

    /// Product name
    required String name,

    /// URL to product image
    required String imageUrl,

    /// Product brand
    required Brand brand,

    /// Vehicle make compatibility
    required VehicleMake vehicleMake,

    /// Tire specifications
    required TireSpec tireSpec,

    /// Product price
    required double price,

    /// Available stock quantity
    required int stockQuantity,

    /// Whether the product is active/available
    required bool isActive,

    /// When the product was created
    required DateTime createdAt,
  }) = _Product;

  /// Check if the product is in stock
  bool get isInStock => stockQuantity > 0;

  /// Check if the product is available (active and in stock)
  bool get isAvailable => isActive && isInStock;

  /// Get formatted price with VND currency
  String get formattedPrice {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )} VND';
  }

  /// Get the product's display name (includes tire spec)
  String get displayName => '$name (${tireSpec.display})';

  /// Get the product's full specification string
  String get fullSpecification {
    return '${brand.name} ${tireSpec.display} for ${vehicleMake.name}';
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