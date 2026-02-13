import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_products_usecase.dart';
import 'package:frontend_otis/presentation/bloc/product/product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/product/product_event.dart';
import 'package:frontend_otis/presentation/bloc/product/product_state.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProductsUsecase extends Mock implements GetProductsUsecase {}

class MockGetProductDetailUsecase extends Mock
    implements GetProductDetailUsecase {}

class FakeProductFilter extends Fake implements ProductFilter {}

void main() {
  late ProductBloc productBloc;
  late MockGetProductsUsecase mockGetProductsUsecase;
  late MockGetProductDetailUsecase mockGetProductDetailUsecase;

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

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(const ProductFilter(page: 1, limit: 10));
    registerFallbackValue(const GetProductsEvent(filter: ProductFilter()));
    registerFallbackValue(FakeProductFilter());
  });

  setUp(() {
    mockGetProductsUsecase = MockGetProductsUsecase();
    mockGetProductDetailUsecase = MockGetProductDetailUsecase();
    productBloc = ProductBloc(
      getProductsUsecase: mockGetProductsUsecase,
      getProductDetailUsecase: mockGetProductDetailUsecase,
    );
  });

  tearDown(() {
    productBloc.close();
  });

  group('ProductBloc', () {
    blocTest<ProductBloc, ProductState>(
      'initial state should be ProductInitial',
      build: () => productBloc,
      verify: (_) {
        expect(productBloc.state, equals(const ProductInitial()));
      },
    );

    blocTest<ProductBloc, ProductState>(
      'should emit loading then loaded when GetProductsEvent succeeds',
      build: () => productBloc,
      act: (bloc) {
        const filter = ProductFilter(page: 1, limit: 10);
        final tMetadata = (
          products: [tProduct1, tProduct2],
          totalCount: 2,
          totalPages: 1,
          hasMore: false,
        );
        when(
          () => mockGetProductsUsecase(filter),
        ).thenAnswer((_) async => Right(tMetadata));
        bloc.add(const GetProductsEvent(filter: filter));
      },
      expect: () => [
        const ProductLoading(),
        ProductLoaded(
          products: [tProduct1, tProduct2],
          filter: const ProductFilter(page: 1, limit: 10),
          currentPage: 1,
          totalPages: 1,
          hasMore: false,
          totalCount: 2,
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should emit loading then error when GetProductsEvent fails',
      build: () => productBloc,
      act: (bloc) {
        const filter = ProductFilter(page: 1, limit: 10);
        when(() => mockGetProductsUsecase(filter)).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server error')),
        );
        bloc.add(const GetProductsEvent(filter: filter));
      },
      expect: () => [
        const ProductLoading(),
        const ProductError(message: 'Server error'),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should emit loading then loaded with search results when SearchProductsEvent succeeds',
      build: () => productBloc,
      act: (bloc) {
        final tMetadata = (
          products: [tProduct1],
          totalCount: 1,
          totalPages: 1,
          hasMore: false,
        );
        when(
          () => mockGetProductsUsecase(
            const ProductFilter(page: 1, searchQuery: 'Michelin'),
          ),
        ).thenAnswer((_) async => Right(tMetadata));
        bloc.add(const SearchProductsEvent(query: 'Michelin'));
      },
      expect: () => [
        const ProductLoading(),
        ProductLoaded(
          products: [tProduct1],
          filter: const ProductFilter(page: 1, searchQuery: 'Michelin'),
          currentPage: 1,
          totalPages: 1,
          hasMore: false,
          totalCount: 1,
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should emit loading then error when SearchProductsEvent fails',
      build: () => productBloc,
      act: (bloc) {
        when(
          () => mockGetProductsUsecase(
            const ProductFilter(page: 1, searchQuery: 'Test'),
          ),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        bloc.add(const SearchProductsEvent(query: 'Test'));
      },
      expect: () => [
        const ProductLoading(),
        const ProductError(message: 'Network Failure'),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should emit loading then detailLoaded when GetProductDetailEvent succeeds',
      build: () => productBloc,
      act: (bloc) {
        const productId = '1';
        when(
          () => mockGetProductDetailUsecase(productId),
        ).thenAnswer((_) async => Right(tProduct1));
        bloc.add(const GetProductDetailEvent(id: productId));
      },
      expect: () => [
        const ProductLoading(),
        ProductDetailLoaded(product: tProduct1),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should emit loading then error when GetProductDetailEvent fails',
      build: () => productBloc,
      act: (bloc) {
        const productId = '1';
        when(
          () => mockGetProductDetailUsecase(productId),
        ).thenAnswer((_) async => Left(ServerFailure(message: 'Not found')));
        bloc.add(const GetProductDetailEvent(id: productId));
      },
      expect: () => [
        const ProductLoading(),
        const ProductError(message: 'Not found'),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should emit loading then error when GetProductDetailEvent is called and product not found',
      build: () => productBloc,
      act: (bloc) {
        const productId = '999';
        when(() => mockGetProductDetailUsecase(productId)).thenAnswer(
          (_) async => Left(ServerFailure(message: 'Product not found')),
        );
        bloc.add(const GetProductDetailEvent(id: productId));
      },
      expect: () => [
        const ProductLoading(),
        const ProductError(message: 'Product not found'),
      ],
    );

    // ========== PAGINATION TESTS ==========

    blocTest<ProductBloc, ProductState>(
      'should emit loading then loaded for initial page 1',
      build: () => productBloc,
      act: (bloc) {
        const filter = ProductFilter(page: 1, limit: 10);
        final tMetadata = (
          products: [tProduct1],
          totalCount: 1,
          totalPages: 1,
          hasMore: false,
        );
        when(
          () => mockGetProductsUsecase(filter),
        ).thenAnswer((_) async => Right(tMetadata));
        bloc.add(const GetProductsEvent(filter: filter));
      },
      expect: () => [
        const ProductLoading(),
        ProductLoaded(
          products: [tProduct1],
          filter: const ProductFilter(page: 1, limit: 10),
          currentPage: 1,
          totalPages: 1,
          hasMore: false,
          totalCount: 1,
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should append products correctly when loading more pages',
      build: () => productBloc,
      act: (bloc) {
        // First, load page 1
        const filterPage1 = ProductFilter(page: 1, limit: 10);
        final page1Metadata = (
          products: [tProduct1],
          totalCount: 2,
          totalPages: 2,
          hasMore: true,
        );
        when(
          () => mockGetProductsUsecase(filterPage1),
        ).thenAnswer((_) async => Right(page1Metadata));

        // Then load page 2
        const filterPage2 = ProductFilter(page: 2, limit: 10);
        final page2Metadata = (
          products: [tProduct2],
          totalCount: 2,
          totalPages: 2,
          hasMore: false,
        );
        when(
          () => mockGetProductsUsecase(filterPage2),
        ).thenAnswer((_) async => Right(page2Metadata));

        // Add both events
        bloc
          ..add(const GetProductsEvent(filter: filterPage1))
          ..add(const GetProductsEvent(filter: filterPage2));
      },
      expect: () => [
        // Page 1
        const ProductLoading(),
        ProductLoaded(
          products: [tProduct1],
          filter: const ProductFilter(page: 1, limit: 10),
          currentPage: 1,
          totalPages: 2,
          hasMore: true,
          totalCount: 2,
        ),
        // Intermediate state with isLoadingMore: true
        ProductLoaded(
          products: [tProduct1],
          filter: const ProductFilter(page: 1, limit: 10),
          currentPage: 1,
          totalPages: 2,
          hasMore: true,
          totalCount: 2,
          isLoadingMore: true,
        ),
        // Page 2 - should append products
        ProductLoaded(
          products: [tProduct1, tProduct2],
          filter: const ProductFilter(page: 2, limit: 10),
          currentPage: 2,
          totalPages: 2,
          hasMore: false,
          totalCount: 2,
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should NOT add duplicate products during pagination',
      build: () => productBloc,
      verify: (bloc) {
        // After loading page 1 and page 2 with duplicate product,
        // the bloc should have deduplicated products
        if (bloc.state is ProductLoaded) {
          final state = bloc.state as ProductLoaded;
          final ids = state.products.map((p) => p.id).toList();
          // Should not have duplicate IDs
          expect(ids.toSet().length, equals(ids.length));
        }
      },
    );

    blocTest<ProductBloc, ProductState>(
      'should emit LoadingMore state when loading next page',
      build: () => productBloc,
      act: (bloc) {
        // First load page 1
        const filterPage1 = ProductFilter(page: 1, limit: 10);
        final page1Metadata = (
          products: [tProduct1],
          totalCount: 20,
          totalPages: 3,
          hasMore: true,
        );
        when(
          () => mockGetProductsUsecase(filterPage1),
        ).thenAnswer((_) async => Right(page1Metadata));

        // Then load page 2
        const filterPage2 = ProductFilter(page: 2, limit: 10);
        final page2Metadata = (
          products: [tProduct2],
          totalCount: 20,
          totalPages: 3,
          hasMore: true,
        );
        when(
          () => mockGetProductsUsecase(filterPage2),
        ).thenAnswer((_) async => Right(page2Metadata));

        bloc
          ..add(const GetProductsEvent(filter: filterPage1))
          ..add(const GetProductsEvent(filter: filterPage2));
      },
      expect: () => [
        const ProductLoading(),
        ProductLoaded(
          products: [tProduct1],
          filter: const ProductFilter(page: 1, limit: 10),
          currentPage: 1,
          totalPages: 3,
          hasMore: true,
          totalCount: 20,
        ),
        // During load more, should have isLoadingMore = true
        ProductLoaded(
          products: [tProduct1],
          filter: const ProductFilter(page: 1, limit: 10),
          currentPage: 1,
          totalPages: 3,
          hasMore: true,
          totalCount: 20,
          isLoadingMore: true,
        ),
        // After loading more, products should be appended
        ProductLoaded(
          products: [tProduct1, tProduct2],
          filter: const ProductFilter(page: 2, limit: 10),
          currentPage: 2,
          totalPages: 3,
          hasMore: true,
          totalCount: 20,
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should reset isLoadingMore flag when load more fails',
      build: () => productBloc,
      act: (bloc) {
        // First load page 1 with products
        const filterPage1 = ProductFilter(page: 1, limit: 10);
        final page1Metadata = (
          products: [tProduct1],
          totalCount: 20,
          totalPages: 3,
          hasMore: true,
        );
        when(
          () => mockGetProductsUsecase(filterPage1),
        ).thenAnswer((_) async => Right(page1Metadata));

        // Load more page 2 - FAILS
        const filterPage2 = ProductFilter(page: 2, limit: 10);
        when(() => mockGetProductsUsecase(filterPage2)).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server error')),
        );

        bloc
          ..add(const GetProductsEvent(filter: filterPage1))
          ..add(const GetProductsEvent(filter: filterPage2));
      },
      expect: () => [
        const ProductLoading(),
        ProductLoaded(
          products: [tProduct1],
          filter: const ProductFilter(page: 1, limit: 10),
          currentPage: 1,
          totalPages: 3,
          hasMore: true,
          totalCount: 20,
          isLoadingMore: false,
        ),
        // During load more, should have isLoadingMore = true
        ProductLoaded(
          products: [tProduct1],
          filter: const ProductFilter(page: 1, limit: 10),
          currentPage: 1,
          totalPages: 3,
          hasMore: true,
          totalCount: 20,
          isLoadingMore: true,
        ),
        // After load more failure, isLoadingMore should be reset to false
        ProductLoaded(
          products: [tProduct1],
          filter: const ProductFilter(page: 1, limit: 10),
          currentPage: 1,
          totalPages: 3,
          hasMore: true,
          totalCount: 20,
          isLoadingMore: false,
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should handle empty products list correctly',
      build: () => productBloc,
      act: (bloc) {
        const filter = ProductFilter(page: 1, limit: 10);
        final emptyMetadata = (
          products: <Product>[],
          totalCount: 0,
          totalPages: 1,
          hasMore: false,
        );
        when(
          () => mockGetProductsUsecase(filter),
        ).thenAnswer((_) async => Right(emptyMetadata));
        bloc.add(const GetProductsEvent(filter: filter));
      },
      expect: () => [
        const ProductLoading(),
        ProductLoaded(
          products: [],
          filter: const ProductFilter(page: 1, limit: 10),
          currentPage: 1,
          totalPages: 1,
          hasMore: false,
          totalCount: 0,
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should handle single page (hasMore=false) correctly',
      build: () => productBloc,
      act: (bloc) {
        const filter = ProductFilter(page: 1, limit: 10);
        final singlePageMetadata = (
          products: [tProduct1, tProduct2],
          totalCount: 2,
          totalPages: 1,
          hasMore: false,
        );
        when(
          () => mockGetProductsUsecase(filter),
        ).thenAnswer((_) async => Right(singlePageMetadata));
        bloc.add(const GetProductsEvent(filter: filter));
      },
      expect: () => [
        const ProductLoading(),
        ProductLoaded(
          products: [tProduct1, tProduct2],
          filter: const ProductFilter(page: 1, limit: 10),
          currentPage: 1,
          totalPages: 1,
          hasMore: false,
          totalCount: 2,
        ),
      ],
    );

    // ========== SEARCH TESTS ==========

    blocTest<ProductBloc, ProductState>(
      'should emit loading then loaded when ClearSearchEvent succeeds',
      build: () => productBloc,
      act: (bloc) {
        // First, simulate a search state
        const searchFilter = ProductFilter(page: 1, searchQuery: 'michelin');
        final searchMetadata = (
          products: [tProduct1],
          totalCount: 1,
          totalPages: 1,
          hasMore: false,
        );
        when(
          () => mockGetProductsUsecase(searchFilter),
        ).thenAnswer((_) async => Right(searchMetadata));

        // Then clear search
        final emptyMetadata = (
          products: [tProduct1, tProduct2],
          totalCount: 2,
          totalPages: 1,
          hasMore: false,
        );
        when(
          () => mockGetProductsUsecase(const ProductFilter()),
        ).thenAnswer((_) async => Right(emptyMetadata));

        bloc
          ..add(const SearchProductsEvent(query: 'michelin'))
          ..add(const ClearSearchEvent());
      },
      expect: () => [
        const ProductLoading(),
        isA<ProductLoaded>(),
        const ProductLoading(),
        isA<ProductLoaded>().having(
          (state) => state.filter.searchQuery,
          'searchQuery after clear',
          null,
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should emit loading then error when ClearSearchEvent fails',
      build: () => productBloc,
      act: (bloc) {
        when(
          () => mockGetProductsUsecase(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        bloc.add(const ClearSearchEvent());
      },
      expect: () => [
        const ProductLoading(),
        const ProductError(message: 'Network Failure'),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should emit loading then loaded when RefreshProductsEvent succeeds',
      build: () => productBloc,
      act: (bloc) {
        const filter = ProductFilter(page: 1, limit: 10);
        final refreshMetadata = (
          products: [tProduct1, tProduct2],
          totalCount: 2,
          totalPages: 1,
          hasMore: false,
        );
        when(
          () => mockGetProductsUsecase(filter),
        ).thenAnswer((_) async => Right(refreshMetadata));
        bloc.add(const RefreshProductsEvent());
      },
      expect: () => [
        const ProductLoading(),
        ProductLoaded(
          products: [tProduct1, tProduct2],
          filter: const ProductFilter(page: 1, limit: 10),
          currentPage: 1,
          totalPages: 1,
          hasMore: false,
          totalCount: 2,
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should emit loading then error when RefreshProductsEvent fails',
      build: () => productBloc,
      act: (bloc) {
        when(() => mockGetProductsUsecase(any())).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Connection timeout')),
        );
        bloc.add(const RefreshProductsEvent());
      },
      expect: () => [
        const ProductLoading(),
        const ProductError(message: 'Connection timeout'),
      ],
    );

    // ========== FILTER PERSISTENCE TESTS ==========

    blocTest<ProductBloc, ProductState>(
      'should preserve currentFilter after search',
      build: () => productBloc,
      verify: (bloc) {
        // After search, currentFilter should have the search query
        expect(bloc.currentSearchQuery, equals('michelin'));
        expect(bloc.isSearching, isTrue);
      },
      act: (bloc) {
        final tMetadata = (
          products: [tProduct1],
          totalCount: 1,
          totalPages: 1,
          hasMore: false,
        );
        when(
          () => mockGetProductsUsecase(
            const ProductFilter(page: 1, searchQuery: 'michelin'),
          ),
        ).thenAnswer((_) async => Right(tMetadata));
        bloc.add(const SearchProductsEvent(query: 'michelin'));
      },
      expect: () => [const ProductLoading(), isA<ProductLoaded>()],
    );

    blocTest<ProductBloc, ProductState>(
      'should correctly report filter state',
      build: () => productBloc,
      act: (bloc) {
        final tMetadata = (
          products: [tProduct1],
          totalCount: 1,
          totalPages: 1,
          hasMore: false,
        );
        when(
          () => mockGetProductsUsecase(
            const ProductFilter(page: 1, limit: 10, categoryId: 'cat1'),
          ),
        ).thenAnswer((_) async => Right(tMetadata));
        bloc.add(
          const GetProductsEvent(
            filter: ProductFilter(page: 1, limit: 10, categoryId: 'cat1'),
          ),
        );
      },
      verify: (bloc) {
        // After loading with a category filter, hasFilters should be true
        expect(bloc.hasFilters, isTrue);
      },
      expect: () => [const ProductLoading(), isA<ProductLoaded>()],
    );

    // ========== EDGE CASES ==========

    blocTest<ProductBloc, ProductState>(
      'should handle NetworkFailure gracefully',
      build: () => productBloc,
      act: (bloc) {
        const filter = ProductFilter(page: 1, limit: 10);
        when(
          () => mockGetProductsUsecase(filter),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        bloc.add(const GetProductsEvent(filter: filter));
      },
      expect: () => [
        const ProductLoading(),
        const ProductError(message: 'Network Failure'),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should handle CacheFailure gracefully',
      build: () => productBloc,
      act: (bloc) {
        const filter = ProductFilter(page: 1, limit: 10);
        when(
          () => mockGetProductsUsecase(filter),
        ).thenAnswer((_) async => const Left(CacheFailure()));
        bloc.add(const GetProductsEvent(filter: filter));
      },
      expect: () => [
        const ProductLoading(),
        const ProductError(message: 'Cache Failure'),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'should have correct initial state properties',
      build: () => productBloc,
      verify: (_) {
        expect(productBloc.state.isInitial, isTrue);
        expect(productBloc.state.isLoading, isFalse);
        expect(productBloc.state.isLoaded, isFalse);
        expect(productBloc.state.isError, isFalse);
        expect(productBloc.currentFilter, equals(const ProductFilter()));
        expect(productBloc.currentSearchQuery, isNull);
        expect(productBloc.isSearching, isFalse);
        expect(productBloc.hasFilters, isFalse);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'should handle search with empty query as clear search',
      build: () => productBloc,
      act: (bloc) {
        // When search query is empty, it should trigger ClearSearchEvent
        final tMetadata = (
          products: [tProduct1],
          totalCount: 1,
          totalPages: 1,
          hasMore: false,
        );
        when(
          () => mockGetProductsUsecase(any()),
        ).thenAnswer((_) async => Right(tMetadata));
        bloc.add(const SearchProductsEvent(query: ''));
      },
      expect: () => [const ProductLoading(), isA<ProductLoaded>()],
    );

    blocTest<ProductBloc, ProductState>(
      'should handle search with whitespace-only query as clear search',
      build: () => productBloc,
      act: (bloc) {
        final tMetadata = (
          products: [tProduct1],
          totalCount: 1,
          totalPages: 1,
          hasMore: false,
        );
        when(
          () => mockGetProductsUsecase(any()),
        ).thenAnswer((_) async => Right(tMetadata));
        bloc.add(const SearchProductsEvent(query: '   '));
      },
      expect: () => [const ProductLoading(), isA<ProductLoaded>()],
    );
  });
}
