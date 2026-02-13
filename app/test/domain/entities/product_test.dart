import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/domain/entities/brand.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/tire_spec.dart';
import 'package:frontend_otis/domain/entities/vehicle_make.dart';

void main() {
  group('Product Entity', () {
    final tProduct = Product(
      id: '1',
      sku: 'SKU001',
      name: 'Michelin Primacy 4',
      imageUrl: 'https://example.com/tire.jpg',
      price: 2450000.0,
      stockQuantity: 50,
      isActive: true,
      createdAt: DateTime(2024, 1, 15),
    );

    group('stock getters', () {
      test('isInStock returns true when stockQuantity > 0', () {
        expect(tProduct.isInStock, isTrue);
      });

      test('isInStock returns false when stockQuantity = 0', () {
        expect(
          tProduct.copyWith(stockQuantity: 0).isInStock,
          isFalse,
        );
      });

      test('isInStock returns false when stockQuantity < 0', () {
        expect(
          tProduct.copyWith(stockQuantity: -1).isInStock,
          isFalse,
        );
      });

      test('isLowStock returns true when stockQuantity < 10', () {
        expect(
          tProduct.copyWith(stockQuantity: 5).isLowStock,
          isTrue,
        );
      });

      test('isLowStock returns true when stockQuantity = 9', () {
        expect(
          tProduct.copyWith(stockQuantity: 9).isLowStock,
          isTrue,
        );
      });

      test('isLowStock returns false when stockQuantity >= 10', () {
        expect(
          tProduct.copyWith(stockQuantity: 10).isLowStock,
          isFalse,
        );
      });

      test('isLowStock returns false when stockQuantity > 10', () {
        expect(
          tProduct.copyWith(stockQuantity: 15).isLowStock,
          isFalse,
        );
      });

      test('isOutOfStock returns true when stockQuantity = 0', () {
        expect(
          tProduct.copyWith(stockQuantity: 0).isOutOfStock,
          isTrue,
        );
      });

      test('isOutOfStock returns false when stockQuantity > 0', () {
        expect(tProduct.isOutOfStock, isFalse);
      });

      test('isAvailable returns true when active and in stock', () {
        expect(tProduct.isAvailable, isTrue);
      });

      test('isAvailable returns false when inactive', () {
        expect(
          tProduct.copyWith(isActive: false).isAvailable,
          isFalse,
        );
      });

      test('isAvailable returns false when out of stock', () {
        expect(
          tProduct.copyWith(stockQuantity: 0).isAvailable,
          isFalse,
        );
      });

      test('isAvailable returns false when inactive and out of stock', () {
        expect(
          tProduct.copyWith(isActive: false, stockQuantity: 0).isAvailable,
          isFalse,
        );
      });
    });

    group('formattedPrice', () {
      test('formats Vietnamese Dong correctly', () {
        expect(tProduct.formattedPrice, equals('2.450.000 đ'));
      });

      test('handles large numbers', () {
        expect(
          tProduct.copyWith(price: 5000000.0).formattedPrice,
          equals('5.000.000 đ'),
        );
      });

      test('handles small numbers', () {
        expect(
          tProduct.copyWith(price: 500000.0).formattedPrice,
          equals('500.000 đ'),
        );
      });

      test('handles very large numbers', () {
        expect(
          tProduct.copyWith(price: 50000000.0).formattedPrice,
          equals('50.000.000 đ'),
        );
      });

      test('handles decimal prices', () {
        // Note: toStringAsFixed(0) rounds the value, so 2450000.50 -> 2450001
        expect(
          tProduct.copyWith(price: 2450000.50).formattedPrice,
          equals('2.450.001 đ'),
        );
      });

      test('handles price with trailing zeros', () {
        expect(
          tProduct.copyWith(price: 1000000.00).formattedPrice,
          equals('1.000.000 đ'),
        );
      });
    });

    group('displayName', () {
      test('returns name when tireSpec is null', () {
        expect(tProduct.displayName, equals('Michelin Primacy 4'));
      });

      test('includes tire spec when available', () {
        final productWithSpec = tProduct.copyWith(
          tireSpec: const TireSpec(
            id: '1',
            width: 205,
            aspectRatio: 55,
            rimDiameter: 16,
          ),
        );
        // TireSpec.display format is "width/aspectRatio RrimDiameter" (e.g., "205/55 R16")
        expect(productWithSpec.displayName, contains('205/55 R16'));
      });

      test('displayName format with tireSpec', () {
        final productWithSpec = tProduct.copyWith(
          tireSpec: const TireSpec(
            id: '1',
            width: 205,
            aspectRatio: 55,
            rimDiameter: 16,
          ),
        );
        // TireSpec.display format is "width/aspectRatio RrimDiameter"
        expect(
          productWithSpec.displayName,
          equals('Michelin Primacy 4 (205/55 R16)'),
        );
      });

      test('handles tireSpec with different dimensions', () {
        final productWithSpec = tProduct.copyWith(
          tireSpec: const TireSpec(
            id: '1',
            width: 225,
            aspectRatio: 45,
            rimDiameter: 17,
          ),
        );
        expect(
          productWithSpec.displayName,
          equals('Michelin Primacy 4 (225/45 R17)'),
        );
      });
    });

    group('fullSpecification', () {
      test('returns Unknown Brand when brand is null', () {
        expect(tProduct.fullSpecification, contains('Unknown Brand'));
      });

      test('returns Unknown Vehicle when vehicleMake is null', () {
        expect(tProduct.fullSpecification, contains('Unknown Vehicle'));
      });

      test('includes brand and vehicle when available', () {
        final productWithDetails = tProduct.copyWith(
          brand: const Brand(id: '1', name: 'Michelin', logoUrl: ''),
          vehicleMake: const VehicleMake(id: '1', name: 'Toyota', logoUrl: ''),
          tireSpec: const TireSpec(
            id: '1',
            width: 205,
            aspectRatio: 55,
            rimDiameter: 16,
          ),
        );
        expect(productWithDetails.fullSpecification, contains('Michelin'));
        expect(productWithDetails.fullSpecification, contains('Toyota'));
      });

      test('fullSpecification format', () {
        final productWithDetails = tProduct.copyWith(
          brand: const Brand(id: '1', name: 'Michelin', logoUrl: ''),
          vehicleMake: const VehicleMake(id: '1', name: 'Toyota', logoUrl: ''),
          tireSpec: const TireSpec(
            id: '1',
            width: 205,
            aspectRatio: 55,
            rimDiameter: 16,
          ),
        );
        // TireSpec.display format is "width/aspectRatio RrimDiameter"
        expect(
          productWithDetails.fullSpecification,
          equals('Michelin 205/55 R16 for Toyota'),
        );
      });
    });

    group('stockStatus', () {
      test('returns correct string for in stock', () {
        expect(tProduct.stockStatus, equals('In Stock (50)'));
      });

      test('returns correct string for low stock', () {
        expect(
          tProduct.copyWith(stockQuantity: 5).stockStatus,
          equals('Low Stock (5)'),
        );
      });

      test('returns correct string for out of stock', () {
        expect(
          tProduct.copyWith(stockQuantity: 0).stockStatus,
          equals('Out of Stock'),
        );
      });

      test('handles single item in stock', () {
        // Note: stockQuantity = 1 is considered "Low Stock" because threshold is < 10
        expect(
          tProduct.copyWith(stockQuantity: 1).stockStatus,
          equals('Low Stock (1)'),
        );
      });
    });

    group('formattedCreatedAt', () {
      test('formats date correctly', () {
        expect(tProduct.formattedCreatedAt, equals('2024-01-15'));
      });

      test('handles single digit day and month', () {
        final product = tProduct.copyWith(
          createdAt: DateTime(2024, 5, 3),
        );
        expect(product.formattedCreatedAt, equals('2024-05-03'));
      });
    });

    group('copyWith', () {
      test('creates new product with modified fields', () {
        final modifiedProduct = tProduct.copyWith(
          name: 'Modified Product',
          price: 3000000.0,
        );
        expect(modifiedProduct.name, equals('Modified Product'));
        expect(modifiedProduct.price, equals(3000000.0));
        expect(modifiedProduct.id, equals('1'));
        expect(modifiedProduct.sku, equals('SKU001'));
      });

      test('preserves unspecified fields', () {
        final modifiedProduct = tProduct.copyWith(
          name: 'Modified Product',
        );
        expect(modifiedProduct.id, equals(tProduct.id));
        expect(modifiedProduct.sku, equals(tProduct.sku));
        expect(modifiedProduct.price, equals(tProduct.price));
      });

      test('can modify nullable fields', () {
        final modifiedProduct = tProduct.copyWith(
          brand: const Brand(id: '1', name: 'Michelin', logoUrl: ''),
        );
        expect(modifiedProduct.brand, isNotNull);
        expect(modifiedProduct.brand!.name, equals('Michelin'));
      });
    });

    group('equality', () {
      test('two products with same values are equal', () {
        final product1 = Product(
          id: '1',
          sku: 'SKU001',
          name: 'Test Product',
          imageUrl: 'https://example.com/image.jpg',
          price: 1000000.0,
          stockQuantity: 10,
          isActive: true,
          createdAt: DateTime(2024, 1, 15),
        );
        final product2 = Product(
          id: '1',
          sku: 'SKU001',
          name: 'Test Product',
          imageUrl: 'https://example.com/image.jpg',
          price: 1000000.0,
          stockQuantity: 10,
          isActive: true,
          createdAt: DateTime(2024, 1, 15),
        );
        expect(product1, equals(product2));
      });

      test('products with different ids are not equal', () {
        final product1 = tProduct;
        final product2 = tProduct.copyWith(id: '2');
        expect(product1, isNot(equals(product2)));
      });

      test('products with different names are not equal', () {
        final product1 = tProduct;
        final product2 = tProduct.copyWith(name: 'Different Product');
        expect(product1, isNot(equals(product2)));
      });
    });

    group('edge cases', () {
      test('handles zero price', () {
        expect(
          tProduct.copyWith(price: 0.0).formattedPrice,
          equals('0 đ'),
        );
      });

      test('handles negative stock quantity edge case', () {
        final product = tProduct.copyWith(stockQuantity: -1);
        expect(product.isInStock, isFalse);
        expect(product.isOutOfStock, isFalse);
        expect(product.isLowStock, isFalse);
      });

      test('handles very high stock quantity', () {
        final product = tProduct.copyWith(stockQuantity: 10000);
        expect(product.isInStock, isTrue);
        expect(product.isLowStock, isFalse);
        expect(product.stockStatus, contains('10000'));
      });

      test('handles product with all null optional fields', () {
        final product = Product(
          id: '1',
          sku: 'SKU001',
          name: 'Basic Product',
          imageUrl: 'https://example.com/image.jpg',
          price: 1000000.0,
          stockQuantity: 10,
          isActive: true,
          createdAt: DateTime(2024, 1, 15),
        );
        expect(product.brand, isNull);
        expect(product.vehicleMake, isNull);
        expect(product.tireSpec, isNull);
      });
    });
  });
}
