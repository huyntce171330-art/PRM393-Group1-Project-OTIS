import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';
import 'package:frontend_otis/domain/usecases/product/search_products_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late SearchProductsUsecase usecase;
  late MockProductRepository mockRepository;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(const ProductFilter());
  });

  setUp(() {
    mockRepository = MockProductRepository();
    usecase = SearchProductsUsecase(productRepository: mockRepository);
  });

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
    sku: 'MP4-205-55-16',
    name: 'Michelin Primacy 4 205/55R16',
    imageUrl: 'https://example.com/tire2.jpg',
    price: 2550000.0,
    stockQuantity: 30,
    isActive: true,
    createdAt: DateTime(2024, 1, 16),
  );

  group('SearchProductsUsecase', () {
    test('should return products when repository succeeds', () async {
      // Arrange
      final tProducts = [tProduct1, tProduct2];
      final tMetadata = (
        products: tProducts,
        totalCount: 2,
        totalPages: 1,
        hasMore: false,
      );

      ProductFilter? capturedFilter;
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((invocation) async {
        capturedFilter = invocation.namedArguments[#filter];
        return Right(tMetadata);
      });

      // Act
      final result = await usecase('michelin');

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (products) {
        expect(products.length, equals(2));
        expect(products[0].name, equals('Michelin Primacy 4'));
      });

      // Verify search query was passed correctly
      expect(capturedFilter, isNotNull);
      expect(capturedFilter!.searchQuery, equals('michelin'));
      expect(capturedFilter!.page, equals(1));
      expect(capturedFilter!.limit, equals(20));
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
      final result = await usecase('test');

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure.message, equals('Server error'));
      }, (_) => fail('Should not return products'));
    });

    test('should trim whitespace from query', () async {
      // Arrange
      final tMetadata = (
        products: <Product>[],
        totalCount: 0,
        totalPages: 0,
        hasMore: false,
      );

      ProductFilter? capturedFilter;
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((invocation) async {
        capturedFilter = invocation.namedArguments[#filter];
        return Right(tMetadata);
      });

      // Act
      await usecase('  michelin  ');

      // Assert
      expect(capturedFilter, isNotNull);
      expect(capturedFilter!.searchQuery, equals('michelin'));
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
      final result = await usecase('xyznotfound');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (products) => expect(products, isEmpty),
      );
    });

    test('should set page=1 and limit=20 for search', () async {
      // Arrange
      final tMetadata = (
        products: [tProduct1],
        totalCount: 1,
        totalPages: 1,
        hasMore: false,
      );

      ProductFilter? capturedFilter;
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((invocation) async {
        capturedFilter = invocation.namedArguments[#filter];
        return Right(tMetadata);
      });

      // Act
      await usecase('michelin');

      // Assert - Verify pagination parameters
      expect(capturedFilter, isNotNull);
      expect(capturedFilter!.page, equals(1));
      expect(capturedFilter!.limit, equals(20));
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
        (_) async => const Left(ServerFailure(message: 'Network error')),
      );

      // Act
      final result = await usecase('test');

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, equals('Network error'));
      }, (_) => fail('Should not return products'));
    });

    test('should search by name OR SKU', () async {
      // Arrange - Products match by name OR SKU
      final tProducts = [tProduct2]; // Matches SKU: MP4-205-55-16
      final tMetadata = (
        products: tProducts,
        totalCount: 1,
        totalPages: 1,
        hasMore: false,
      );

      ProductFilter? capturedFilter;
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((invocation) async {
        capturedFilter = invocation.namedArguments[#filter];
        return Right(tMetadata);
      });

      // Act - Search by SKU
      final result = await usecase('MP4');

      // Assert
      expect(result.isRight(), true);
      expect(capturedFilter, isNotNull);
      expect(capturedFilter!.searchQuery, equals('MP4'));
    });

    test('should handle empty query gracefully', () async {
      // Arrange
      final tMetadata = (
        products: <Product>[],
        totalCount: 0,
        totalPages: 0,
        hasMore: false,
      );

      ProductFilter? capturedFilter;
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((invocation) async {
        capturedFilter = invocation.namedArguments[#filter];
        return Right(tMetadata);
      });

      // Act - Empty query
      // final result = await usecase('');

      // Assert - Empty query should set null searchQuery
      expect(capturedFilter, isNotNull);
      expect(capturedFilter!.searchQuery, isNull);
    });
  });
}
