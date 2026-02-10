import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/data/models/tire_spec_model.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
import 'package:frontend_otis/domain/entities/brand.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/tire_spec.dart';
import 'package:frontend_otis/domain/entities/vehicle_make.dart';

void main() {
  group('ProductModel', () {
    group('fromJson - Defensive Parsing', () {
      // ========== ID PARSING TESTS ==========

      test('handles null product_id', () {
        final json = <String, dynamic>{
          'product_id': null,
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.id, equals(''));
      });

      test('handles int product_id (converts to String)', () {
        final json = <String, dynamic>{
          'product_id': 123,
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.id, equals('123'));
      });

      test('handles string product_id', () {
        final json = {
          'product_id': 'abc123',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.id, equals('abc123'));
      });

      test('handles unexpected product_id type (fallback to toString)', () {
        final json = {
          'product_id': 45.67,
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.id, equals('45.67'));
      });

      // ========== STRING PARSING TESTS ==========

      test('handles null sku', () {
        final json = {
          'product_id': '1',
          'sku': null,
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.sku, equals(''));
      });

      test('handles string sku and trims whitespace', () {
        final json = {
          'product_id': '1',
          'sku': '  SKU001  ',
          'name': '  Test Product  ',
          'image_url': '  https://example.com/image.jpg  ',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.sku, equals('SKU001'));
        expect(model.name, equals('Test Product'));
        expect(model.imageUrl, equals('https://example.com/image.jpg'));
      });

      test('handles non-string sku (converts to string)', () {
        final json = {
          'product_id': '1',
          'sku': 12345,
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.sku, equals('12345'));
      });

      // ========== INTEGER PARSING TESTS ==========

      test('handles null stock_quantity', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': null,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.stockQuantity, equals(0));
      });

      test('handles string stock_quantity', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': '50',
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.stockQuantity, equals(50));
      });

      test('handles invalid string stock_quantity (returns default)', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 'not-a-number',
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.stockQuantity, equals(0));
      });

      test('handles double stock_quantity (converts to int)', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 45.9,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.stockQuantity, equals(45));
      });

      // ========== DOUBLE PARSING TESTS ==========

      test('handles null price', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': null,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.price, equals(0.0));
      });

      test('handles string price', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': '2450000.0',
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.price, equals(2450000.0));
      });

      test('handles integer price (converts to double)', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 2450000,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.price, equals(2450000.0));
      });

      test('handles invalid string price (returns default)', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 'invalid-price',
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.price, equals(0.0));
      });

      // ========== BOOLEAN PARSING TESTS ==========

      test('handles null is_active', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': null,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.isActive, isTrue); // default value
      });

      test('parses is_active from integer 1 (true)', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.isActive, isTrue);
      });

      test('parses is_active from integer 0 (false)', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 0,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.isActive, isFalse);
      });

      test('parses is_active from string "true"', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 'true',
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.isActive, isTrue);
      });

      test('parses is_active from string "false"', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 'false',
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.isActive, isFalse);
      });

      test('parses is_active from string "1"', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': '1',
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.isActive, isTrue);
      });

      test('parses is_active from string "0"', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': '0',
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.isActive, isFalse);
      });

      // ========== DATETIME PARSING TESTS ==========

      test('handles null created_at', () {
        final json = <String, dynamic>{
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': null,
        };
        final model = ProductModel.fromJson(json);
        // Should return a valid DateTime when null (defaults to now)
        expect(model.createdAt.isBefore(DateTime.now().add(const Duration(seconds: 1))), isTrue);
      });

      test('handles valid ISO date string', () {
        final json = <String, dynamic>{
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T10:30:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.createdAt.year, equals(2024));
        expect(model.createdAt.month, equals(1));
        expect(model.createdAt.day, equals(15));
      });

      test('handles invalid date format (falls back to now)', () {
        final json = <String, dynamic>{
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{},
          'vehicle_make': <String, dynamic>{},
          'tire_spec': <String, dynamic>{},
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': 'not-a-date',
        };
        final model = ProductModel.fromJson(json);
        // Should return a valid DateTime when invalid (defaults to now)
        expect(model.createdAt.isBefore(DateTime.now().add(const Duration(seconds: 1))), isTrue);
      });

      // ========== NESTED OBJECT PARSING TESTS ==========

      test('handles null brand, vehicle_make, tire_spec', () {
        final json = {
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'brand': null,
          'vehicle_make': null,
          'tire_spec': null,
          'price': 1000000.0,
          'stock_quantity': 10,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.brand, isNotNull);
        expect(model.vehicleMake, isNotNull);
        expect(model.tireSpec, isNotNull);
        expect(model.brand.id, equals(''));
        expect(model.vehicleMake.id, equals(''));
        expect(model.tireSpec.id, equals(''));
      });

      test('handles missing fields with defaults', () {
        final json = <String, dynamic>{};
        final model = ProductModel.fromJson(json);
        expect(model.id, equals(''));
        expect(model.sku, equals(''));
        expect(model.name, equals(''));
        expect(model.price, equals(0.0));
        expect(model.stockQuantity, equals(0));
        expect(model.isActive, isTrue);
      });

      // ========== COMPLETE VALID JSON ==========

      test('parses complete valid JSON correctly', () {
        final json = {
          'product_id': 'prod-123',
          'sku': 'MP4-205-55-16',
          'name': 'Michelin Primacy 4',
          'image_url': 'https://example.com/michelin-primacy-4.jpg',
          'brand': <String, dynamic>{
            'brand_id': '1',
            'name': 'Michelin',
            'logo_url': 'https://example.com/michelin-logo.png',
          },
          'vehicle_make': <String, dynamic>{
            'make_id': '1',
            'name': 'Toyota',
            'logo_url': 'https://example.com/toyota-logo.png',
          },
          'tire_spec': <String, dynamic>{
            'tire_spec_id': '1',
            'width': 205,
            'aspect_ratio': 55,
            'rim_diameter': 16,
          },
          'price': 2450000.0,
          'stock_quantity': 50,
          'is_active': 1,
          'created_at': '2024-01-15T10:30:00Z',
        };
        final model = ProductModel.fromJson(json);
        expect(model.id, equals('prod-123'));
        expect(model.sku, equals('MP4-205-55-16'));
        expect(model.name, equals('Michelin Primacy 4'));
        expect(model.price, equals(2450000.0));
        expect(model.stockQuantity, equals(50));
        expect(model.isActive, isTrue);
        expect(model.brand.name, equals('Michelin'));
        expect(model.vehicleMake.name, equals('Toyota'));
        expect(model.tireSpec.width, equals(205));
        expect(model.tireSpec.aspectRatio, equals(55));
        expect(model.tireSpec.rimDiameter, equals(16));
      });
    });

    group('toJson', () {
      test('converts model to JSON correctly', () {
        final model = ProductModel(
          id: '1',
          sku: 'SKU001',
          name: 'Test Product',
          imageUrl: 'https://example.com/image.jpg',
          brand: const BrandModel(id: '1', name: 'Michelin', logoUrl: ''),
          vehicleMake: const VehicleMakeModel(id: '1', name: 'Toyota', logoUrl: ''),
          tireSpec: const TireSpecModel(id: '1', width: 205, aspectRatio: 55, rimDiameter: 16),
          price: 2450000.0,
          stockQuantity: 50,
          isActive: true,
          createdAt: DateTime(2024, 1, 15),
        );
        final json = model.toJson();
        // json_serializable generates camelCase keys
        expect(json['id'], equals('1'));
        expect(json['sku'], equals('SKU001'));
        expect(json['name'], equals('Test Product'));
        expect(json['price'], equals(2450000.0));
        expect(json['stockQuantity'], equals(50));
        // isActive is converted using BoolFromIntConverter
        expect(json['isActive'], equals(1));
      });
    });

    group('toDomain', () {
      test('converts model to Product entity correctly', () {
        final model = ProductModel(
          id: '1',
          sku: 'SKU001',
          name: 'Michelin Primacy 4',
          imageUrl: 'https://example.com/image.jpg',
          brand: const BrandModel(id: '1', name: 'Michelin', logoUrl: ''),
          vehicleMake: const VehicleMakeModel(id: '1', name: 'Toyota', logoUrl: ''),
          tireSpec: const TireSpecModel(id: '1', width: 205, aspectRatio: 55, rimDiameter: 16),
          price: 2450000.0,
          stockQuantity: 50,
          isActive: true,
          createdAt: DateTime(2024, 1, 15),
        );
        final product = model.toDomain();
        expect(product.id, equals('1'));
        expect(product.sku, equals('SKU001'));
        expect(product.name, equals('Michelin Primacy 4'));
        expect(product.price, equals(2450000.0));
        expect(product.stockQuantity, equals(50));
        expect(product.isActive, isTrue);
        expect(product.brand, isNotNull);
        expect(product.brand!.name, equals('Michelin'));
        expect(product.vehicleMake, isNotNull);
        expect(product.vehicleMake!.name, equals('Toyota'));
        expect(product.tireSpec, isNotNull);
        expect(product.tireSpec!.width, equals(205));
      });

      test('handles empty brand/vehicleMake/tireSpec', () {
        final model = ProductModel(
          id: '1',
          sku: 'SKU001',
          name: 'Test Product',
          imageUrl: 'https://example.com/image.jpg',
          brand: const BrandModel(id: '', name: '', logoUrl: ''),
          vehicleMake: const VehicleMakeModel(id: '', name: '', logoUrl: ''),
          tireSpec: const TireSpecModel(id: '', width: 0, aspectRatio: 0, rimDiameter: 0),
          price: 1000000.0,
          stockQuantity: 10,
          isActive: true,
          createdAt: DateTime(2024, 1, 15),
        );
        final product = model.toDomain();
        expect(product.brand, isNotNull);
        expect(product.vehicleMake, isNotNull);
        expect(product.tireSpec, isNotNull);
        expect(product.brand!.name, equals(''));
        expect(product.vehicleMake!.name, equals(''));
      });
    });

    group('fromDomain', () {
      test('creates model from Product entity correctly', () {
        final product = Product(
          id: '1',
          sku: 'SKU001',
          name: 'Michelin Primacy 4',
          imageUrl: 'https://example.com/image.jpg',
          brand: const Brand(id: '1', name: 'Michelin', logoUrl: ''),
          vehicleMake: const VehicleMake(id: '1', name: 'Toyota', logoUrl: ''),
          tireSpec: const TireSpec(id: '1', width: 205, aspectRatio: 55, rimDiameter: 16),
          price: 2450000.0,
          stockQuantity: 50,
          isActive: true,
          createdAt: DateTime(2024, 1, 15),
        );
        final model = ProductModel.fromDomain(product);
        expect(model.id, equals('1'));
        expect(model.sku, equals('SKU001'));
        expect(model.name, equals('Michelin Primacy 4'));
        expect(model.price, equals(2450000.0));
        expect(model.stockQuantity, equals(50));
        expect(model.isActive, isTrue);
        expect(model.brand.name, equals('Michelin'));
        expect(model.vehicleMake.name, equals('Toyota'));
      });

      test('handles null brand/vehicleMake/tireSpec in Product', () {
        final product = Product(
          id: '1',
          sku: 'SKU001',
          name: 'Test Product',
          imageUrl: 'https://example.com/image.jpg',
          price: 1000000.0,
          stockQuantity: 10,
          isActive: true,
          createdAt: DateTime(2024, 1, 15),
        );
        final model = ProductModel.fromDomain(product);
        expect(model.brand.id, equals(''));
        expect(model.brand.name, equals(''));
        expect(model.vehicleMake.id, equals(''));
        expect(model.vehicleMake.name, equals(''));
        expect(model.tireSpec.id, equals(''));
        expect(model.tireSpec.width, equals(0));
      });
    });

    group('roundtrip conversion', () {
      test('Product -> ProductModel -> Product preserves data', () {
        final originalProduct = Product(
          id: '1',
          sku: 'SKU001',
          name: 'Michelin Primacy 4',
          imageUrl: 'https://example.com/image.jpg',
          brand: const Brand(id: '1', name: 'Michelin', logoUrl: ''),
          vehicleMake: const VehicleMake(id: '1', name: 'Toyota', logoUrl: ''),
          tireSpec: const TireSpec(id: '1', width: 205, aspectRatio: 55, rimDiameter: 16),
          price: 2450000.0,
          stockQuantity: 50,
          isActive: true,
          createdAt: DateTime(2024, 1, 15),
        );
        final model = ProductModel.fromDomain(originalProduct);
        final convertedProduct = model.toDomain();
        expect(convertedProduct.id, equals(originalProduct.id));
        expect(convertedProduct.sku, equals(originalProduct.sku));
        expect(convertedProduct.name, equals(originalProduct.name));
        expect(convertedProduct.price, equals(originalProduct.price));
        expect(convertedProduct.stockQuantity, equals(originalProduct.stockQuantity));
        expect(convertedProduct.isActive, equals(originalProduct.isActive));
      });

      test('JSON -> ProductModel -> JSON preserves data', () {
        // Note: The custom fromJson expects snake_case keys like 'product_id'
        final originalJson = <String, dynamic>{
          'product_id': '1',
          'sku': 'SKU001',
          'name': 'Michelin Primacy 4',
          'image_url': 'https://example.com/image.jpg',
          'brand': <String, dynamic>{'brand_id': '1', 'name': 'Michelin', 'logo_url': ''},
          'vehicle_make': <String, dynamic>{'make_id': '1', 'name': 'Toyota', 'logo_url': ''},
          'tire_spec': <String, dynamic>{'tire_spec_id': '1', 'width': 205, 'aspect_ratio': 55, 'rim_diameter': 16},
          'price': 2450000.0,
          'stock_quantity': 50,
          'is_active': 1,
          'created_at': '2024-01-15T00:00:00Z',
        };
        final model = ProductModel.fromJson(originalJson);
        final convertedJson = model.toJson();
        // toJson generates camelCase keys
        expect(convertedJson['id'], equals('1'));
        expect(convertedJson['sku'], equals('SKU001'));
        expect(convertedJson['name'], equals('Michelin Primacy 4'));
        expect(convertedJson['price'], equals(2450000.0));
        expect(convertedJson['stockQuantity'], equals(50));
      });
    });
  });
}
