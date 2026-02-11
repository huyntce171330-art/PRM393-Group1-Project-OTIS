// Unit tests for CreateProductUsecase.
//
// Tests the use case for creating a new product.
// Follows the testing guidelines from the Cursor Rules.

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/data/models/tire_spec_model.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';
import 'package:frontend_otis/domain/usecases/product/create_product_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late CreateProductUsecase usecase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    usecase = CreateProductUsecase(productRepository: mockRepository);
  });

  // Test data
  final tProductModel = ProductModel(
    id: '',
    sku: 'TEST-SKU-001',
    name: 'Test Product',
    imageUrl: 'https://example.com/tire.jpg',
    brand: const BrandModel(id: '1', name: 'Michelin', logoUrl: ''),
    vehicleMake: const VehicleMakeModel(id: '', name: '', logoUrl: ''),
    tireSpec: const TireSpecModel(
      id: '',
      width: 205,
      aspectRatio: 55,
      rimDiameter: 16,
    ),
    price: 2450000.0,
    stockQuantity: 50,
    isActive: true,
    createdAt: DateTime.now(),
  );

  final tProduct = Product(
    id: '100',
    sku: 'TEST-SKU-001',
    name: 'Test Product',
    imageUrl: 'https://example.com/tire.jpg',
    brand: const BrandModel(id: '1', name: 'Michelin', logoUrl: '').toDomain(),
    vehicleMake: const VehicleMakeModel(id: '', name: '', logoUrl: '').toDomain(),
    tireSpec: const TireSpecModel(
      id: '',
      width: 205,
      aspectRatio: 55,
      rimDiameter: 16,
    ).toDomain(),
    price: 2450000.0,
    stockQuantity: 50,
    isActive: true,
    createdAt: DateTime.now(),
  );

  group('CreateProductUsecase', () {
    test('should return product when repository succeeds', () async {
      // Arrange
      when(() => mockRepository.createProduct(product: tProductModel))
          .thenAnswer((_) async => Right(tProduct));

      // Act
      final result = await usecase(CreateProductParams(product: tProductModel));

      // Assert
      expect(result, Right(tProduct));
      verify(() => mockRepository.createProduct(product: tProductModel));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails with ServerFailure', () async {
      // Arrange
      when(() => mockRepository.createProduct(product: tProductModel))
          .thenAnswer((_) async => Left(ServerFailure(message: 'Server error')));

      // Act
      final result = await usecase(CreateProductParams(product: tProductModel));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server error');
        },
        (product) => fail('Should return failure'),
      );
      verify(() => mockRepository.createProduct(product: tProductModel));
    });

    test('should return failure when repository fails with NetworkFailure', () async {
      // Arrange
      when(() => mockRepository.createProduct(product: tProductModel))
          .thenAnswer((_) async => Left(NetworkFailure()));

      // Act
      final result = await usecase(CreateProductParams(product: tProductModel));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
        },
        (product) => fail('Should return failure'),
      );
      verify(() => mockRepository.createProduct(product: tProductModel));
    });

    test('should return ValidationFailure when SKU already exists', () async {
      // Arrange
      when(() => mockRepository.createProduct(product: tProductModel))
          .thenAnswer((_) async => Left(
                ValidationFailure(message: 'SKU "TEST-SKU-001" đã tồn tại. Vui lòng sử dụng SKU khác.'),
              ));

      // Act
      final result = await usecase(CreateProductParams(product: tProductModel));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('đã tồn tại'));
        },
        (product) => fail('Should return failure'),
      );
      verify(() => mockRepository.createProduct(product: tProductModel));
    });

    test('should return ValidationFailure when validation fails for empty SKU', () async {
      // Arrange
      final invalidProduct = ProductModel(
        id: '',
        sku: '',  // Empty SKU
        name: 'Test Product',
        imageUrl: 'https://example.com/tire.jpg',
        brand: const BrandModel(id: '1', name: 'Michelin', logoUrl: ''),
        vehicleMake: const VehicleMakeModel(id: '', name: '', logoUrl: ''),
        tireSpec: const TireSpecModel(
          id: '',
          width: 205,
          aspectRatio: 55,
          rimDiameter: 16,
        ),
        price: 2450000.0,
        stockQuantity: 50,
        isActive: true,
        createdAt: DateTime.now(),
      );
      when(() => mockRepository.createProduct(product: invalidProduct))
          .thenAnswer((_) async => Left(
                ValidationFailure(message: 'SKU is required'),
              ));

      // Act
      final result = await usecase(CreateProductParams(product: invalidProduct));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'SKU is required');
        },
        (product) => fail('Should return failure'),
      );
    });

    test('should return ValidationFailure when name is too short', () async {
      // Arrange
      final invalidProduct = ProductModel(
        id: '',
        sku: 'TEST-SKU-001',
        name: 'A',  // Too short name
        imageUrl: 'https://example.com/tire.jpg',
        brand: const BrandModel(id: '1', name: 'Michelin', logoUrl: ''),
        vehicleMake: const VehicleMakeModel(id: '', name: '', logoUrl: ''),
        tireSpec: const TireSpecModel(
          id: '',
          width: 205,
          aspectRatio: 55,
          rimDiameter: 16,
        ),
        price: 2450000.0,
        stockQuantity: 50,
        isActive: true,
        createdAt: DateTime.now(),
      );
      when(() => mockRepository.createProduct(product: invalidProduct))
          .thenAnswer((_) async => Left(
                ValidationFailure(message: 'Name must be 2-200 characters'),
              ));

      // Act
      final result = await usecase(CreateProductParams(product: invalidProduct));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Name must be 2-200 characters');
        },
        (product) => fail('Should return failure'),
      );
    });

    test('should return ValidationFailure when price is zero or negative', () async {
      // Arrange
      final invalidProduct = ProductModel(
        id: '',
        sku: 'TEST-SKU-001',
        name: 'Test Product',
        imageUrl: 'https://example.com/tire.jpg',
        brand: const BrandModel(id: '1', name: 'Michelin', logoUrl: ''),
        vehicleMake: const VehicleMakeModel(id: '', name: '', logoUrl: ''),
        tireSpec: const TireSpecModel(
          id: '',
          width: 205,
          aspectRatio: 55,
          rimDiameter: 16,
        ),
        price: 0.0,  // Zero price
        stockQuantity: 50,
        isActive: true,
        createdAt: DateTime.now(),
      );
      when(() => mockRepository.createProduct(product: invalidProduct))
          .thenAnswer((_) async => Left(
                ValidationFailure(message: 'Price must be greater than 0'),
              ));

      // Act
      final result = await usecase(CreateProductParams(product: invalidProduct));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Price must be greater than 0');
        },
        (product) => fail('Should return failure'),
      );
    });

    test('should return failure when repository fails with CacheFailure', () async {
      // Arrange
      when(() => mockRepository.createProduct(product: tProductModel))
          .thenAnswer((_) async => Left(CacheFailure(message: 'Failed to save product data')));

      // Act
      final result = await usecase(CreateProductParams(product: tProductModel));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, 'Failed to save product data');
        },
        (product) => fail('Should return failure'),
      );
      verify(() => mockRepository.createProduct(product: tProductModel));
    });
  });
}
