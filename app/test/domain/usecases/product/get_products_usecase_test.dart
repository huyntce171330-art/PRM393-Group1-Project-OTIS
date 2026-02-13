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
      final tFailure = ServerFailure(message: 'Server error');
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

    // ========== EDGE CASES AND ADDITIONAL TESTS ==========

    test('should handle filter with price range', () async {
      // Arrange
      const priceFilter = ProductFilter(
        page: 1,
        limit: 10,
        minPrice: 1000000,
        maxPrice: 3000000,
      );
      final tMetadata = (
        products: [tProduct1],
        totalCount: 1,
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
      final result = await usecase(priceFilter);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (metadata) {
          expect(metadata.products, hasLength(1));
          expect(metadata.totalCount, equals(1));
        },
      );
      verify(
        () => mockRepository.getProductsWithMetadata(
          filter: priceFilter,
          page: priceFilter.page,
          limit: priceFilter.limit,
        ),
      ).called(1);
    });

    test('should handle filter with vehicle make id', () async {
      // Arrange
      const vehicleFilter = ProductFilter(
        page: 1,
        limit: 10,
        vehicleMakeId: 'toyota',
      );
      final tMetadata = (
        products: [tProduct1],
        totalCount: 1,
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
      final result = await usecase(vehicleFilter);

      // Assert
      expect(result.isRight(), true);
      verify(
        () => mockRepository.getProductsWithMetadata(
          filter: vehicleFilter,
          page: vehicleFilter.page,
          limit: vehicleFilter.limit,
        ),
      ).called(1);
    });

    test('should handle filter with sort parameters', () async {
      // Arrange
      const sortFilter = ProductFilter(
        page: 1,
        limit: 10,
        sortBy: 'price',
        sortAscending: false,
      );
      final tMetadata = (
        products: [tProduct2, tProduct1], // Sorted by price descending
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
      final result = await usecase(sortFilter);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (metadata) {
          expect(metadata.products.length, equals(2));
        },
      );
    });

    test('should handle large dataset with many products', () async {
      // Arrange
      final largeProductList = List.generate(
        100,
        (index) => tProduct1.copyWith(id: 'product_$index'),
      );
      final tMetadata = (
        products: largeProductList,
        totalCount: 1000,
        totalPages: 10,
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
      result.fold(
        (failure) => fail('Should not return failure'),
        (metadata) {
          expect(metadata.products, hasLength(100));
          expect(metadata.totalCount, equals(1000));
          expect(metadata.totalPages, equals(10));
          expect(metadata.hasMore, isTrue);
        },
      );
    });

    test('should handle zero products on subsequent pages', () async {
      // Arrange
      const filterPage2 = ProductFilter(page: 2, limit: 10);
      final tMetadata = (
        products: <Product>[],
        totalCount: 10,
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
      final result = await usecase(filterPage2);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (metadata) {
          expect(metadata.products, isEmpty);
          expect(metadata.totalCount, equals(10));
          expect(metadata.hasMore, isFalse);
        },
      );
    });

    test('should return NetworkFailure when no internet', () async {
      // Arrange
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );

      // Act
      final result = await usecase(tFilter);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, equals('No internet connection'));
        },
        (_) => fail('Should not return products'),
      );
    });

    test('should return CacheFailure when cache error occurs', () async {
      // Arrange
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => const Left(CacheFailure()),
      );

      // Act
      final result = await usecase(tFilter);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
        },
        (_) => fail('Should not return products'),
      );
    });

    test('should call repository only once per request', () async {
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
      await usecase(tFilter);

      // Assert
      verify(
        () => mockRepository.getProductsWithMetadata(
          filter: tFilter,
          page: tFilter.page,
          limit: tFilter.limit,
        ),
      ).called(1);
    });

    test('should preserve filter parameters from input to repository', () async {
      // Arrange
      const complexFilter = ProductFilter(
        page: 3,
        limit: 25,
        searchQuery: 'winter',
        categoryId: 'tires',
        brandId: 'michelin',
        vehicleMakeId: 'honda',
        minPrice: 1500000,
        maxPrice: 4000000,
        sortBy: 'price',
        sortAscending: true,
      );
      final tMetadata = (
        products: [tProduct1],
        totalCount: 1,
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
      final result = await usecase(complexFilter);

      // Assert
      expect(result.isRight(), true);
      verify(
        () => mockRepository.getProductsWithMetadata(
          filter: complexFilter,
          page: complexFilter.page,
          limit: complexFilter.limit,
        ),
      ).called(1);
    });
  });
}
