// Unit tests for GetProductDetailUsecase.
//
// Tests the use case for fetching a single product by ID.
// Follows the testing guidelines from the Cursor Rules.

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';
import 'package:frontend_otis/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/failures.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductDetailUsecase usecase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    usecase = GetProductDetailUsecase(productRepository: mockRepository);
  });

  const tProductId = '1';
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

  test('should return product when repository succeeds', () async {
    // Arrange
    when(() => mockRepository.getProductDetail(productId: tProductId))
        .thenAnswer((_) async => Right(tProduct));

    // Act
    final result = await usecase(tProductId);

    // Assert
    expect(result, Right(tProduct));
    verify(() => mockRepository.getProductDetail(productId: tProductId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails with ServerFailure', () async {
    // Arrange
    when(() => mockRepository.getProductDetail(productId: tProductId))
        .thenAnswer((_) async => Left(ServerFailure(message: 'Server error')));

    // Act
    final result = await usecase(tProductId);

    // Assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'Server error');
      },
      (product) => fail('Should return failure'),
    );
    verify(() => mockRepository.getProductDetail(productId: tProductId));
  });

  test('should return failure when product not found', () async {
    // Arrange
    when(() => mockRepository.getProductDetail(productId: tProductId))
        .thenAnswer((_) async => Left(ServerFailure(message: 'Product not found')));

    // Act
    final result = await usecase(tProductId);

    // Assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure.message, 'Product not found'),
      (product) => fail('Should return failure'),
    );
  });

  test('should return failure when network is unavailable', () async {
    // Arrange
    when(() => mockRepository.getProductDetail(productId: tProductId))
        .thenAnswer((_) async => Left(NetworkFailure()));

    // Act
    final result = await usecase(tProductId);

    // Assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<NetworkFailure>());
      },
      (product) => fail('Should return failure'),
    );
  });

  test('should call repository with correct productId', () async {
    // Arrange
    const anotherProductId = '123';
    when(() => mockRepository.getProductDetail(productId: anotherProductId))
        .thenAnswer((_) async => Right(tProduct));

    // Act
    await usecase(anotherProductId);

    // Assert
    verify(() => mockRepository.getProductDetail(productId: anotherProductId));
  });
}
