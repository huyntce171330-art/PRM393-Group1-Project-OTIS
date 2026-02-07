import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';
import 'package:frontend_otis/domain/usecases/product/get_products_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductsUsecase usecase;
  late MockProductRepository mockRepository;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(const ProductFilter(page: 1, limit: 10));
  });

  setUp(() {
    mockRepository = MockProductRepository();
    usecase = GetProductsUsecase(productRepository: mockRepository);
  });

  const tFilter = ProductFilter(page: 1, limit: 10);

  final tProduct1 = Product(
    id: '1',
    sku: 'SKU001',
    name: 'Michelin Primacy 4',
    imageUrl: 'https://example.com/tire1.jpg',
    price: 2450000.0,
    stockQuantity: 50,
    isActive: true,
    createdAt: DateTime(2024, 1, 15),
  );

  final tProduct2 = Product(
    id: '2',
    sku: 'SKU002',
    name: 'Bridgestone Turanza',
    imageUrl: 'https://example.com/tire2.jpg',
    price: 2100000.0,
    stockQuantity: 30,
    isActive: true,
    createdAt: DateTime(2024, 1, 14),
  );

  final tProducts = [tProduct1, tProduct2];

  group('GetProductsUsecase', () {
    test('should return products when repository succeeds', () async {
      // Arrange
      final tMetadata = (
        products: tProducts,
        totalCount: 2,
        totalPages: 1,
        hasMore: false,
      );
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right(tMetadata));

      // Act
      final result = await usecase(tFilter);

      // Assert
      expect(result.isRight(), true);
      expect(result.isLeft(), false);
      result.fold((failure) => fail('Should not return failure'), (metadata) {
        expect(metadata.products, equals(tProducts));
        expect(metadata.totalCount, equals(2));
        expect(metadata.totalPages, equals(1));
        expect(metadata.hasMore, equals(false));
      });
      verify(
        () => mockRepository.getProductsWithMetadata(
          filter: tFilter,
          page: tFilter.page,
          limit: tFilter.limit,
        ),
      ).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const tFailure = ServerFailure(message: 'Server error');
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await usecase(tFilter);

      // Assert
      expect(result.isLeft(), true);
      expect(result.isRight(), false);
      result.fold((failure) {
        expect(failure, equals(tFailure));
        expect(failure.message, equals('Server error'));
      }, (_) => fail('Should not return products'));
      verify(
        () => mockRepository.getProductsWithMetadata(
          filter: tFilter,
          page: tFilter.page,
          limit: tFilter.limit,
        ),
      ).called(1);
    });

    test('should pass correct filter to repository', () async {
      // Arrange
      const customFilter = ProductFilter(
        page: 2,
        limit: 20,
        searchQuery: 'Michelin',
        categoryId: 'cat1',
      );
      final tMetadata = (
        products: tProducts,
        totalCount: 2,
        totalPages: 1,
        hasMore: false,
      );
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right(tMetadata));

      // Act
      await usecase(customFilter);

      // Assert
      verify(
        () => mockRepository.getProductsWithMetadata(
          filter: customFilter,
          page: customFilter.page,
          limit: customFilter.limit,
        ),
      ).called(1);
    });

    test('should handle empty product list', () async {
      // Arrange
      final tEmptyMetadata = (
        products: <Product>[],
        totalCount: 0,
        totalPages: 1,
        hasMore: false,
      );
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right(tEmptyMetadata));

      // Act
      final result = await usecase(tFilter);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (metadata) {
        expect(metadata.products, isEmpty);
        expect(metadata.totalCount, equals(0));
      });
    });

    test('should return left when repository returns failure', () async {
      // Arrange
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Server error')),
      );

      // Act
      final result = await usecase(tFilter);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, equals('Server error'));
      }, (_) => fail('Should not return products'));
    });

    test('should return hasMore=true when products exceed limit', () async {
      // Arrange
      final manyProducts = List.generate(15, (index) => tProduct1);
      final tMetadata = (
        products: manyProducts,
        totalCount: 25,
        totalPages: 3,
        hasMore: true,
      );
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right(tMetadata));

      // Act
      final result = await usecase(tFilter);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (metadata) {
        expect(metadata.hasMore, isTrue);
        expect(metadata.totalPages, equals(3));
        expect(metadata.products.length, equals(15));
      });
    });
  });
}
