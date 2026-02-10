// Unit tests for AdminProductBloc
//
// Tests cover:
// - Happy paths (successful API responses)
// - Failure paths (API errors, network failures)
// - Edge cases (empty lists, null fields, rapid taps)
//
// Based on:
// - UC-01: Admin View List Products
// - UC-03: Admin Search Product
// - UC-04: Admin Filter Product
// - UC-07: Admin Delete Product

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/domain/usecases/product/delete_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_admin_products_usecase.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_event.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAdminProductsUsecase extends Mock implements GetAdminProductsUsecase {}

class MockDeleteProductUsecase extends Mock implements DeleteProductUsecase {}

class MockGetProductDetailUsecase extends Mock implements GetProductDetailUsecase {}

class FakeProductFilter extends Fake implements ProductFilter {}

class FakeAdminProductFilter extends Fake implements AdminProductFilter {}

void main() {
  registerFallbackValue(FakeProductFilter());
  registerFallbackValue(FakeAdminProductFilter());

  late AdminProductBloc bloc;
  late MockGetAdminProductsUsecase mockGetAdminProductsUsecase;
  late MockDeleteProductUsecase mockDeleteProductUsecase;
  late MockGetProductDetailUsecase mockGetProductDetailUsecase;

  // Test data
  final tProduct1 = Product(
    id: '1',
    name: 'Michelin Pilot Sport 4S',
    sku: 'MICH-PS4S-20555R16',
    price: 1500000.0,
    stockQuantity: 50,
    imageUrl: 'https://example.com/michelin-ps4s.jpg',
    isActive: true,
    createdAt: DateTime(2024, 1, 15),
  );

  final tProduct2 = Product(
    id: '2',
    name: 'Bridgestone Potenza S001',
    sku: 'BRID-POT-S001-22545R17',
    price: 1800000.0,
    stockQuantity: 5, // Low stock
    imageUrl: 'https://example.com/bridgestone-s001.jpg',
    isActive: true,
    createdAt: DateTime(2024, 2, 20),
  );

  final tProduct3 = Product(
    id: '3',
    name: 'Pirelli P Zero',
    sku: 'PIRE-PZERO-24540R18',
    price: 2500000.0,
    stockQuantity: 0, // Out of stock
    imageUrl: 'https://example.com/pirelli-pzero.jpg',
    isActive: true,
    createdAt: DateTime(2024, 3, 10),
  );

  final tProductList = [tProduct1, tProduct2, tProduct3];

  setUp(() {
    mockGetAdminProductsUsecase = MockGetAdminProductsUsecase();
    mockDeleteProductUsecase = MockDeleteProductUsecase();
    mockGetProductDetailUsecase = MockGetProductDetailUsecase();
    bloc = AdminProductBloc(
      getAdminProductsUsecase: mockGetAdminProductsUsecase,
      getProductDetailUsecase: mockGetProductDetailUsecase,
      deleteProductUsecase: mockDeleteProductUsecase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  // ===========================================================================
  // GROUP 1: INITIAL STATE TESTS
  // ===========================================================================

  group('AdminProductBloc - Initial State', () {
    test('initial state should be AdminProductInitial', () {
      expect(bloc.state, isA<AdminProductInitial>());
    });

    test('should have correct default values', () {
      expect(bloc.state.isInitial, isTrue);
      expect(bloc.state.isLoading, isFalse);
      expect(bloc.state.isLoaded, isFalse);
      expect(bloc.state.isError, isFalse);
      expect(bloc.state.products, isEmpty);
    });

    test('should have correct default helper values', () {
      expect(bloc.state.currentPage, equals(1));
      expect(bloc.state.totalCount, equals(0));
      expect(bloc.state.hasMore, isFalse);
      expect(bloc.state.stockStatus, equals(StockStatus.all));
    });
  });

  // ===========================================================================
  // GROUP 2: UC-01 - GET ADMIN PRODUCTS
  // ===========================================================================

  group('UC-01: GetAdminProductsEvent', () {
    blocTest(
      'should emit [Loading, Loaded] with products when API succeeds',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: tProductList,
                  totalCount: tProductList.length,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetAdminProductsEvent(filter: null)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>((state) =>
            state.products.length == 3 && state.hasMore == false),
      ],
      verify: (_) {
        verify(() => mockGetAdminProductsUsecase.call(any())).called(1);
      },
    );

    blocTest(
      'should emit [Loading, Loaded] with empty list when no products exist',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: <Product>[],
                  totalCount: 0,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetAdminProductsEvent(filter: null)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
            (state) => state.products.isEmpty && state.totalCount == 0),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when API fails with ServerFailure',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Left(ServerFailure(message: '500 Internal Server Error')));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetAdminProductsEvent(filter: null)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductError>((state) => state.message.contains('500')),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when API fails with NetworkFailure',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Left(NetworkFailure(message: 'No internet connection')));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetAdminProductsEvent(filter: null)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductError>((state) => state.message.contains('internet')),
      ],
    );

    blocTest(
      'should emit correct pagination metadata',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: tProductList,
                  totalCount: 25,
                  totalPages: 3,
                  hasMore: true,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetAdminProductsEvent(filter: null)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>((state) =>
            state.totalCount == 25 &&
            state.totalPages == 3 &&
            state.hasMore == true &&
            state.currentPage == 1),
      ],
    );
  });

  // ===========================================================================
  // GROUP 3: UC-03 - SEARCH PRODUCTS
  // ===========================================================================

  group('UC-03: SearchAdminProductsEvent', () {
    blocTest(
      'should emit loaded state with filtered products when search succeeds',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: [tProduct1],
                  totalCount: 1,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) =>
          bloc.add(const SearchAdminProductsEvent(query: 'Michelin')),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>((state) =>
            state.products.length == 1 && state.currentPage == 1),
      ],
      verify: (_) {
        verify(() => mockGetAdminProductsUsecase.call(any())).called(1);
      },
    );

    blocTest(
      'should emit empty list when search returns no results',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: <Product>[],
                  totalCount: 0,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) =>
          bloc.add(const SearchAdminProductsEvent(query: 'NonExistentProduct')),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>((state) => state.products.isEmpty),
      ],
    );

    blocTest(
      'should handle search with empty query as clear search',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: tProductList,
                  totalCount: tProductList.length,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) => bloc.add(const SearchAdminProductsEvent(query: '')),
      expect: () => [
        isA<AdminProductLoading>(),
        isA<AdminProductLoaded>(),
      ],
    );
  });

  // ===========================================================================
  // GROUP 4: UC-04 - FILTER BY BRAND
  // ===========================================================================

  group('UC-04: FilterByBrandEvent', () {
    blocTest(
      'should emit loaded state with filtered products when brand filter is applied',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: [tProduct1],
                  totalCount: 1,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) =>
          bloc.add(const FilterByBrandEvent(brandName: 'Michelin')),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
            (state) => state.selectedBrand == 'Michelin'),
      ],
    );

    blocTest(
      'should emit loaded state with all products when brand is null (All brands)',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: tProductList,
                  totalCount: tProductList.length,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) => bloc.add(const FilterByBrandEvent(brandName: null)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>((state) => state.selectedBrand == null),
      ],
    );

    blocTest(
      'should reset to page 1 when filtering by brand',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: [tProduct1],
                  totalCount: 1,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) =>
          bloc.add(const FilterByBrandEvent(brandName: 'Bridgestone')),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>((state) => state.currentPage == 1),
      ],
    );
  });

  // ===========================================================================
  // GROUP 5: UC-04 - FILTER BY STOCK STATUS
  // ===========================================================================

  group('UC-04: FilterByStockStatusEvent', () {
    blocTest(
      'should emit loaded state with low stock filter applied',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: [tProduct2],
                  totalCount: 1,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) => bloc
          .add(const FilterByStockStatusEvent(status: StockStatus.lowStock)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
            (state) => state.stockStatus == StockStatus.lowStock),
      ],
    );

    blocTest(
      'should emit loaded state with out of stock filter applied',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: [tProduct3],
                  totalCount: 1,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) => bloc.add(
          const FilterByStockStatusEvent(status: StockStatus.outOfStock)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>((state) =>
            state.stockStatus == StockStatus.outOfStock),
      ],
    );

    blocTest(
      'should emit loaded state with all stock status when reset',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: tProductList,
                  totalCount: tProductList.length,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) =>
          bloc.add(const FilterByStockStatusEvent(status: StockStatus.all)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
            (state) => state.stockStatus == StockStatus.all),
      ],
    );
  });

  // ===========================================================================
  // GROUP 6: UC-07 - DELETE PRODUCT
  // ===========================================================================

  group('UC-07: DeleteProductEvent', () {
    blocTest(
      'should emit [Deleting, Deleted, Loading, Loaded] and reload when delete succeeds',
      setUp: () {
        when(() => mockDeleteProductUsecase.call('1'))
            .thenAnswer((_) async => const Right(true));
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: [tProduct2, tProduct3],
                  totalCount: 2,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) => bloc.add(const DeleteProductEvent(productId: '1')),
      expect: () => [
        predicate<AdminProductDeleting>((state) => state.productId == '1'),
        predicate<AdminProductDeleted>((state) => state.productId == '1'),
        isA<AdminProductLoading>(),
        isA<AdminProductLoaded>()
            .having((state) => state.products.length, 'products after delete', 2),
      ],
      verify: (_) {
        verify(() => mockDeleteProductUsecase.call('1')).called(1);
      },
    );

    blocTest(
      'should emit [Deleting, Error] when delete fails',
      setUp: () {
        when(() => mockDeleteProductUsecase.call('1'))
            .thenAnswer((_) async => Left(ServerFailure(message: 'Failed to delete')));
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: tProductList,
                  totalCount: tProductList.length,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) => bloc.add(const DeleteProductEvent(productId: '1')),
      expect: () => [
        predicate<AdminProductDeleting>((state) => state.productId == '1'),
        predicate<AdminProductError>((state) => state.message.contains('delete')),
      ],
    );
  });

  // ===========================================================================
  // GROUP 7: REFRESH PRODUCTS
  // ===========================================================================

  group('RefreshAdminProductsEvent', () {
    blocTest(
      'should reload products and emit loaded state on refresh',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: tProductList,
                  totalCount: tProductList.length,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) => bloc.add(const RefreshAdminProductsEvent()),
      expect: () => [
        isA<AdminProductLoading>(),
        isA<AdminProductLoaded>(),
      ],
      verify: (_) {
        verify(() => mockGetAdminProductsUsecase.call(any())).called(1);
      },
    );
  });

  // ===========================================================================
  // GROUP 8: EDGE CASES
  // ===========================================================================

  group('Edge Cases & Boundary Conditions', () {
    blocTest(
      'should handle API response with null fields in product',
      setUp: () {
        final productWithNulls = Product(
          id: '4',
          name: 'Product With Nulls',
          sku: 'NULL-001',
          price: 0.0,
          stockQuantity: 0,
          imageUrl: '',
          isActive: true,
          createdAt: DateTime(2024, 1, 1),
        );
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: [productWithNulls],
                  totalCount: 1,
                  totalPages: 1,
                  hasMore: false,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetAdminProductsEvent(filter: null)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>((state) =>
            state.products.first.name == 'Product With Nulls'),
      ],
    );

    blocTest(
      'should handle pagination with load more',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => Right((
                  products: [tProduct1],
                  totalCount: 3,
                  totalPages: 2,
                  hasMore: true,
                )));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
      ),
      act: (bloc) {
        bloc.add(const GetAdminProductsEvent(filter: null));
      },
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>((state) =>
            state.products.length == 1 && state.hasMore == true),
      ],
    );
  });

  // ===========================================================================
  // GROUP 9: BLOC HELPER METHODS
  // ===========================================================================

  group('Bloc Helper Methods', () {
    test('should return correct currentFilter when initialized', () {
      expect(bloc.currentFilter, isA<AdminProductFilter>());
      expect(bloc.currentFilter.page, equals(1));
    });

    test('should return null for currentSearchQuery when not searching', () {
      expect(bloc.currentSearchQuery, isNull);
    });

    test('should return false for isSearching when not searching', () {
      expect(bloc.isSearching, isFalse);
    });

    test('should return false for hasFilters when no filters applied', () {
      expect(bloc.hasFilters, isFalse);
    });
  });
}
