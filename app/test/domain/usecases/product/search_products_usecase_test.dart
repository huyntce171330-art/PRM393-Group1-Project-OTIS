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
      final result = await usecase('');

      // Assert - Empty query should set null searchQuery
      expect(result.isRight(), isTrue);
      expect(capturedFilter, isNotNull);
      expect(capturedFilter!.searchQuery, isNull);
    });

    // ========== EDGE CASES - SPECIAL CHARACTERS AND UNICODE ==========

    test('should handle Vietnamese characters in search query', () async {
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

      // Act - Vietnamese query
      final result = await usecase('lốp xe Michelin');

      // Assert
      expect(result.isRight(), true);
      expect(capturedFilter, isNotNull);
      expect(capturedFilter!.searchQuery, equals('lốp xe Michelin'));
    });

    test('should handle tire size format in search query', () async {
      // Arrange
      final tMetadata = (
        products: [tProduct2],
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

      // Act - Search with tire size format
      final result = await usecase('205/55R16');

      // Assert
      expect(result.isRight(), true);
      expect(capturedFilter, isNotNull);
      expect(capturedFilter!.searchQuery, equals('205/55R16'));
    });

    test('should handle special characters in search query', () async {
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

      // Act - Special characters (should be sanitized by backend)
      final result = await usecase('test@domain.com');

      // Assert
      expect(result.isRight(), true);
      expect(capturedFilter, isNotNull);
      // The query should be passed as-is, backend handles sanitization
      expect(capturedFilter!.searchQuery, equals('test@domain.com'));
    });

    test('should handle SQL injection attempt in search query', () async {
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

      // Act - SQL injection attempt
      final result = await usecase("' OR '1'='1");

      // Assert
      expect(result.isRight(), true);
      expect(capturedFilter, isNotNull);
      // Query should be passed to repository, backend should handle sanitization
      expect(capturedFilter!.searchQuery, equals("' OR '1'='1"));
    });

    test('should handle very long search query', () async {
      // Arrange
      final longQuery = 'michelin ' * 100;
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

      // Act - Very long query
      final result = await usecase(longQuery);

      // Assert
      expect(result.isRight(), true);
      expect(capturedFilter, isNotNull);
      expect(capturedFilter!.searchQuery, equals(longQuery.trim()));
    });

    test('should handle case variations in search query', () async {
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

      // Act - Case variation
      final result = await usecase('MICHELIN');

      // Assert
      expect(result.isRight(), true);
      expect(capturedFilter, isNotNull);
      // Query should preserve case, backend handles case-insensitive search
      expect(capturedFilter!.searchQuery, equals('MICHELIN'));
    });

    test('should handle tab and newline characters in query', () async {
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

      // Act - Query with tab and newline
      final result = await usecase('michelin\tprimacy\n4');

      // Assert
      expect(result.isRight(), true);
      expect(capturedFilter, isNotNull);
      // Note: Only leading/trailing whitespace is trimmed, internal whitespace is preserved
      expect(capturedFilter!.searchQuery, equals('michelin\tprimacy\n4'));
    });

    test('should handle NetworkFailure gracefully', () async {
      // Arrange
      when(
        () => mockRepository.getProductsWithMetadata(
          filter: any(named: 'filter'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      // Act
      final result = await usecase('test');

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<NetworkFailure>());
        expect(failure.message, equals('No internet connection'));
      }, (_) => fail('Should not return products'));
    });

    test('should handle whitespace-only query as empty', () async {
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

      // Act - Whitespace only
      final result = await usecase('   \t\n  ');

      // Assert
      expect(result.isRight(), true);
      expect(capturedFilter, isNotNull);
      expect(capturedFilter!.searchQuery, isNull);
    });

    test('should handle query with leading zeros', () async {
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

      // Act - Query with leading zeros
      final result = await usecase('001');

      // Assert
      expect(result.isRight(), isTrue);

      // Assert
      expect(result.isRight(), true);
      expect(capturedFilter, isNotNull);
      expect(capturedFilter!.searchQuery, equals('001'));
    });
  });
}
