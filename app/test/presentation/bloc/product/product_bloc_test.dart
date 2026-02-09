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
    test('initial state should be ProductInitial', () {
      expect(productBloc.state, equals(const ProductInitial()));
    });

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
        const ProductError(message: 'No internet connection'),
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
        when(() => mockGetProductDetailUsecase(productId)).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Not found')),
        );
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
          (_) async => const Left(ServerFailure(message: 'Product not found')),
        );
        bloc.add(const GetProductDetailEvent(id: productId));
      },
      expect: () => [
        const ProductLoading(),
        const ProductError(message: 'Product not found'),
      ],
    );
  });
}
