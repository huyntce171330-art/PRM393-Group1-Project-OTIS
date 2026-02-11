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
import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/data/models/tire_spec_model.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/domain/usecases/product/create_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/delete_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_admin_products_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_event.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAdminProductsUsecase extends Mock
    implements GetAdminProductsUsecase {}

class MockDeleteProductUsecase extends Mock implements DeleteProductUsecase {}

class MockGetProductDetailUsecase extends Mock
    implements GetProductDetailUsecase {}

class MockCreateProductUsecase extends Mock implements CreateProductUsecase {}

class FakeProductFilter extends Fake implements ProductFilter {}

class FakeAdminProductFilter extends Fake implements AdminProductFilter {}

class FakeCreateProductParams extends Fake implements CreateProductParams {}

void main() {
  registerFallbackValue(FakeProductFilter());
  registerFallbackValue(FakeAdminProductFilter());
  registerFallbackValue(FakeCreateProductParams());

  late AdminProductBloc bloc;
  late MockGetAdminProductsUsecase mockGetAdminProductsUsecase;
  late MockDeleteProductUsecase mockDeleteProductUsecase;
  late MockGetProductDetailUsecase mockGetProductDetailUsecase;
  late MockCreateProductUsecase mockCreateProductUsecase;

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

  // UC-05: Test data for CreateProduct
  final tProductModel = ProductModel(
    id: '',
    sku: 'TEST-SKU-001',
    name: 'Test Product',
    imageUrl: 'https://example.com/image.jpg',
    brand: BrandModel(id: '1', name: 'Michelin', logoUrl: ''),
    vehicleMake: VehicleMakeModel(id: '1', name: 'Toyota', logoUrl: ''),
    tireSpec: TireSpecModel(
      id: '',
      width: 205,
      aspectRatio: 55,
      rimDiameter: 16,
    ),
    price: 1500000.0,
    stockQuantity: 100,
    isActive: true,
    createdAt: DateTime(2024, 1, 15),
  );

  final tCreatedProduct = Product(
    id: '100',
    sku: 'TEST-SKU-001',
    name: 'Test Product',
    imageUrl: 'https://example.com/image.jpg',
    price: 1500000.0,
    stockQuantity: 100,
    isActive: true,
    createdAt: DateTime(2024, 1, 15),
  );

  setUp(() {
    mockGetAdminProductsUsecase = MockGetAdminProductsUsecase();
    mockDeleteProductUsecase = MockDeleteProductUsecase();
    mockGetProductDetailUsecase = MockGetProductDetailUsecase();
    mockCreateProductUsecase = MockCreateProductUsecase();
    bloc = AdminProductBloc(
      getAdminProductsUsecase: mockGetAdminProductsUsecase,
      getProductDetailUsecase: mockGetProductDetailUsecase,
      deleteProductUsecase: mockDeleteProductUsecase,
      createProductUsecase: mockCreateProductUsecase,
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
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: tProductList,
            totalCount: tProductList.length,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetAdminProductsEvent(filter: null)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
          (state) => state.products.length == 3 && state.hasMore == false,
        ),
      ],
      verify: (_) {
        verify(() => mockGetAdminProductsUsecase.call(any())).called(1);
      },
    );

    blocTest(
      'should emit [Loading, Loaded] with empty list when no products exist',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: <Product>[],
            totalCount: 0,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetAdminProductsEvent(filter: null)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
          (state) => state.products.isEmpty && state.totalCount == 0,
        ),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when API fails with ServerFailure',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async =>
              Left(ServerFailure(message: '500 Internal Server Error')),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
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
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Left(NetworkFailure(message: 'No internet connection')),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetAdminProductsEvent(filter: null)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductError>(
          (state) => state.message.contains('internet'),
        ),
      ],
    );

    blocTest(
      'should emit correct pagination metadata',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: tProductList,
            totalCount: 25,
            totalPages: 3,
            hasMore: true,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetAdminProductsEvent(filter: null)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
          (state) =>
              state.totalCount == 25 &&
              state.totalPages == 3 &&
              state.hasMore == true &&
              state.currentPage == 1,
        ),
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
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: [tProduct1],
            totalCount: 1,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) =>
          bloc.add(const SearchAdminProductsEvent(query: 'Michelin')),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
          (state) => state.products.length == 1 && state.currentPage == 1,
        ),
      ],
      verify: (_) {
        verify(() => mockGetAdminProductsUsecase.call(any())).called(1);
      },
    );

    blocTest(
      'should emit empty list when search returns no results',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: <Product>[],
            totalCount: 0,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
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
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: tProductList,
            totalCount: tProductList.length,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const SearchAdminProductsEvent(query: '')),
      expect: () => [isA<AdminProductLoading>(), isA<AdminProductLoaded>()],
    );
  });

  // ===========================================================================
  // GROUP 4: UC-04 - FILTER BY BRAND
  // ===========================================================================

  group('UC-04: FilterByBrandEvent', () {
    blocTest(
      'should emit loaded state with filtered products when brand filter is applied',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: [tProduct1],
            totalCount: 1,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const FilterByBrandEvent(brandName: 'Michelin')),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
          (state) => state.selectedBrand == 'Michelin',
        ),
      ],
    );

    blocTest(
      'should emit loaded state with all products when brand is null (All brands)',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: tProductList,
            totalCount: tProductList.length,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
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
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: [tProduct1],
            totalCount: 1,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
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
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: [tProduct2],
            totalCount: 1,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(
        const FilterByStockStatusEvent(status: StockStatus.lowStock),
      ),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
          (state) => state.stockStatus == StockStatus.lowStock,
        ),
      ],
    );

    blocTest(
      'should emit loaded state with out of stock filter applied',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: [tProduct3],
            totalCount: 1,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(
        const FilterByStockStatusEvent(status: StockStatus.outOfStock),
      ),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
          (state) => state.stockStatus == StockStatus.outOfStock,
        ),
      ],
    );

    blocTest(
      'should emit loaded state with all stock status when reset',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: tProductList,
            totalCount: tProductList.length,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) =>
          bloc.add(const FilterByStockStatusEvent(status: StockStatus.all)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
          (state) => state.stockStatus == StockStatus.all,
        ),
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
        when(
          () => mockDeleteProductUsecase.call('1'),
        ).thenAnswer((_) async => const Right(true));
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: [tProduct2, tProduct3],
            totalCount: 2,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const DeleteProductEvent(productId: '1')),
      expect: () => [
        predicate<AdminProductDeleting>((state) => state.productId == '1'),
        predicate<AdminProductDeleted>((state) => state.productId == '1'),
        isA<AdminProductLoading>(),
        isA<AdminProductLoaded>().having(
          (state) => state.products.length,
          'products after delete',
          2,
        ),
      ],
      verify: (_) {
        verify(() => mockDeleteProductUsecase.call('1')).called(1);
      },
    );

    blocTest(
      'should emit [Deleting, Error] when delete fails',
      setUp: () {
        when(() => mockDeleteProductUsecase.call('1')).thenAnswer(
          (_) async => Left(ServerFailure(message: 'Failed to delete')),
        );
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: tProductList,
            totalCount: tProductList.length,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const DeleteProductEvent(productId: '1')),
      expect: () => [
        predicate<AdminProductDeleting>((state) => state.productId == '1'),
        predicate<AdminProductError>(
          (state) => state.message.contains('delete'),
        ),
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
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: tProductList,
            totalCount: tProductList.length,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const RefreshAdminProductsEvent()),
      expect: () => [isA<AdminProductLoading>(), isA<AdminProductLoaded>()],
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
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: [productWithNulls],
            totalCount: 1,
            totalPages: 1,
            hasMore: false,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetAdminProductsEvent(filter: null)),
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
          (state) => state.products.first.name == 'Product With Nulls',
        ),
      ],
    );

    blocTest(
      'should handle pagination with load more',
      setUp: () {
        when(() => mockGetAdminProductsUsecase.call(any())).thenAnswer(
          (_) async => Right((
            products: [tProduct1],
            totalCount: 3,
            totalPages: 2,
            hasMore: true,
          )),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) {
        bloc.add(const GetAdminProductsEvent(filter: null));
      },
      expect: () => [
        isA<AdminProductLoading>(),
        predicate<AdminProductLoaded>(
          (state) => state.products.length == 1 && state.hasMore == true,
        ),
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

  // ===========================================================================
  // GROUP 10: UC-05 - CREATE PRODUCT - HAPPY PATH
  // ===========================================================================

  group('UC-05: CreateProductEvent - Happy Path', () {
    blocTest(
      'should emit [Creating, CreateSuccess] when product creation succeeds',
      setUp: () {
        when(
          () => mockCreateProductUsecase.call(any()),
        ).thenAnswer((_) async => Right(tCreatedProduct));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(CreateProductEvent(product: tProductModel)),
      expect: () => [
        isA<AdminProductCreating>(),
        predicate<AdminProductCreateSuccess>(
          (state) =>
              state.product.id == '100' && state.product.sku == 'TEST-SKU-001',
        ),
      ],
      verify: (_) {
        verify(() => mockCreateProductUsecase.call(any())).called(1);
      },
    );

    blocTest(
      'should emit correct create success state with full product data',
      setUp: () {
        when(
          () => mockCreateProductUsecase.call(any()),
        ).thenAnswer((_) async => Right(tCreatedProduct));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(CreateProductEvent(product: tProductModel)),
      expect: () => [
        isA<AdminProductCreating>(),
        predicate<AdminProductCreateSuccess>(
          (state) =>
              state.product.name == 'Test Product' &&
              state.product.price == 1500000.0,
        ),
      ],
    );
  });

  // ===========================================================================
  // GROUP 11: UC-05 - CREATE PRODUCT - FAILURE PATHS
  // ===========================================================================

  group('UC-05: CreateProductEvent - Failure Paths', () {
    blocTest(
      'should emit [Creating, CreateError] when ServerFailure (500)',
      setUp: () {
        when(() => mockCreateProductUsecase.call(any())).thenAnswer(
          (_) async =>
              Left(ServerFailure(message: '500 Internal Server Error')),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(CreateProductEvent(product: tProductModel)),
      expect: () => [
        isA<AdminProductCreating>(),
        predicate<AdminProductCreateError>(
          (state) => state.message.contains('500'),
        ),
      ],
    );

    blocTest(
      'should emit [Creating, CreateError] when NetworkFailure',
      setUp: () {
        when(() => mockCreateProductUsecase.call(any())).thenAnswer(
          (_) async => Left(NetworkFailure(message: 'No internet connection')),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(CreateProductEvent(product: tProductModel)),
      expect: () => [
        isA<AdminProductCreating>(),
        predicate<AdminProductCreateError>(
          (state) => state.message.contains('internet'),
        ),
      ],
    );

    blocTest(
      'should emit [Creating, CreateError] when Duplicate SKU',
      setUp: () {
        when(() => mockCreateProductUsecase.call(any())).thenAnswer(
          (_) async => Left(
            ServerFailure(
              message: 'SKU already exists. Please use a different SKU',
            ),
          ),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(CreateProductEvent(product: tProductModel)),
      expect: () => [
        isA<AdminProductCreating>(),
        predicate<AdminProductCreateError>(
          (state) => state.message.contains('SKU'),
        ),
      ],
    );

    blocTest(
      'should emit [Creating, CreateError] when Validation Error',
      setUp: () {
        when(() => mockCreateProductUsecase.call(any())).thenAnswer(
          (_) async => Left(
            ServerFailure(
              message: 'Validation failed: Name must be 2-200 characters',
            ),
          ),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(CreateProductEvent(product: tProductModel)),
      expect: () => [
        isA<AdminProductCreating>(),
        predicate<AdminProductCreateError>(
          (state) => state.message.contains('Validation'),
        ),
      ],
    );

    blocTest(
      'should emit [Creating, CreateError] when Cache Failure',
      setUp: () {
        when(() => mockCreateProductUsecase.call(any())).thenAnswer(
          (_) async =>
              Left(CacheFailure(message: 'Failed to save product data')),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(CreateProductEvent(product: tProductModel)),
      expect: () => [
        isA<AdminProductCreating>(),
        predicate<AdminProductCreateError>(
          (state) => state.message.contains('Failed to save'),
        ),
      ],
    );
  });

  // ===========================================================================
  // GROUP 12: UC-05 - CREATE PRODUCT - EDGE CASES
  // ===========================================================================

  group('UC-05: CreateProductEvent - Edge Cases', () {
    blocTest(
      'should handle product with minimal required fields',
      setUp: () {
        final minimalProduct = ProductModel(
          id: '',
          sku: 'MIN-001',
          name: 'Minimal',
          imageUrl: '',
          brand: BrandModel(id: '', name: '', logoUrl: ''),
          vehicleMake: VehicleMakeModel(id: '', name: '', logoUrl: ''),
          tireSpec: TireSpecModel(
            id: '',
            width: 0,
            aspectRatio: 0,
            rimDiameter: 0,
          ),
          price: 0.0,
          stockQuantity: 0,
          isActive: false,
          createdAt: DateTime.now(),
        );
        final minimalCreated = Product(
          id: '101',
          sku: 'MIN-001',
          name: 'Minimal',
          imageUrl: '',
          price: 0.0,
          stockQuantity: 0,
          isActive: false,
          createdAt: DateTime.now(),
        );
        when(
          () => mockCreateProductUsecase.call(any()),
        ).thenAnswer((_) async => Right(minimalCreated));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) {
        final minimalProduct = ProductModel(
          id: '',
          sku: 'MIN-001',
          name: 'Minimal',
          imageUrl: '',
          brand: BrandModel(id: '', name: '', logoUrl: ''),
          vehicleMake: VehicleMakeModel(id: '', name: '', logoUrl: ''),
          tireSpec: TireSpecModel(
            id: '',
            width: 0,
            aspectRatio: 0,
            rimDiameter: 0,
          ),
          price: 0.0,
          stockQuantity: 0,
          isActive: false,
          createdAt: DateTime.now(),
        );
        bloc.add(CreateProductEvent(product: minimalProduct));
      },
      expect: () => [
        isA<AdminProductCreating>(),
        isA<AdminProductCreateSuccess>(),
      ],
    );

    blocTest(
      'should handle product with zero price',
      setUp: () {
        final zeroPriceProduct = ProductModel(
          id: '',
          sku: 'ZERO-001',
          name: 'Free Product',
          imageUrl: '',
          brand: BrandModel(id: '1', name: 'Brand', logoUrl: ''),
          vehicleMake: VehicleMakeModel(id: '1', name: 'Make', logoUrl: ''),
          tireSpec: TireSpecModel(
            id: '',
            width: 205,
            aspectRatio: 55,
            rimDiameter: 16,
          ),
          price: 0.0,
          stockQuantity: 10,
          isActive: true,
          createdAt: DateTime.now(),
        );
        when(() => mockCreateProductUsecase.call(any())).thenAnswer(
          (_) async =>
              Left(ServerFailure(message: 'Price must be greater than 0')),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) {
        final zeroPriceProduct = ProductModel(
          id: '',
          sku: 'ZERO-001',
          name: 'Free Product',
          imageUrl: '',
          brand: BrandModel(id: '1', name: 'Brand', logoUrl: ''),
          vehicleMake: VehicleMakeModel(id: '1', name: 'Make', logoUrl: ''),
          tireSpec: TireSpecModel(
            id: '',
            width: 205,
            aspectRatio: 55,
            rimDiameter: 16,
          ),
          price: 0.0,
          stockQuantity: 10,
          isActive: true,
          createdAt: DateTime.now(),
        );
        bloc.add(CreateProductEvent(product: zeroPriceProduct));
      },
      expect: () => [
        isA<AdminProductCreating>(),
        predicate<AdminProductCreateError>(
          (state) => state.message.contains('Price'),
        ),
      ],
    );

    blocTest(
      'should handle product with empty SKU',
      setUp: () {
        when(() => mockCreateProductUsecase.call(any())).thenAnswer(
          (_) async => Left(ServerFailure(message: 'SKU is required')),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) {
        final emptySkuProduct = ProductModel(
          id: '',
          sku: '',
          name: 'No SKU Product',
          imageUrl: '',
          brand: BrandModel(id: '1', name: 'Brand', logoUrl: ''),
          vehicleMake: VehicleMakeModel(id: '1', name: 'Make', logoUrl: ''),
          tireSpec: TireSpecModel(
            id: '',
            width: 205,
            aspectRatio: 55,
            rimDiameter: 16,
          ),
          price: 1000.0,
          stockQuantity: 5,
          isActive: true,
          createdAt: DateTime.now(),
        );
        bloc.add(CreateProductEvent(product: emptySkuProduct));
      },
      expect: () => [
        isA<AdminProductCreating>(),
        predicate<AdminProductCreateError>(
          (state) => state.message.contains('SKU'),
        ),
      ],
    );

    blocTest(
      'should handle product with very long name (200 chars)',
      setUp: () {
        when(() => mockCreateProductUsecase.call(any())).thenAnswer(
          (_) async =>
              Left(ServerFailure(message: 'Name must be 2-200 characters')),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) {
        final longName = 'A' * 201; // 201 characters
        final longNameProduct = ProductModel(
          id: '',
          sku: 'LONG-001',
          name: longName,
          imageUrl: '',
          brand: BrandModel(id: '1', name: 'Brand', logoUrl: ''),
          vehicleMake: VehicleMakeModel(id: '1', name: 'Make', logoUrl: ''),
          tireSpec: TireSpecModel(
            id: '',
            width: 205,
            aspectRatio: 55,
            rimDiameter: 16,
          ),
          price: 1000.0,
          stockQuantity: 5,
          isActive: true,
          createdAt: DateTime.now(),
        );
        bloc.add(CreateProductEvent(product: longNameProduct));
      },
      expect: () => [
        isA<AdminProductCreating>(),
        predicate<AdminProductCreateError>(
          (state) => state.message.contains('Name'),
        ),
      ],
    );

    blocTest(
      'should handle product with negative stock quantity',
      setUp: () {
        when(() => mockCreateProductUsecase.call(any())).thenAnswer(
          (_) async =>
              Left(ServerFailure(message: 'Stock quantity cannot be negative')),
        );
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) {
        final negativeStockProduct = ProductModel(
          id: '',
          sku: 'NEG-001',
          name: 'Negative Stock',
          imageUrl: '',
          brand: BrandModel(id: '1', name: 'Brand', logoUrl: ''),
          vehicleMake: VehicleMakeModel(id: '1', name: 'Make', logoUrl: ''),
          tireSpec: TireSpecModel(
            id: '',
            width: 205,
            aspectRatio: 55,
            rimDiameter: 16,
          ),
          price: 1000.0,
          stockQuantity: -5,
          isActive: true,
          createdAt: DateTime.now(),
        );
        bloc.add(CreateProductEvent(product: negativeStockProduct));
      },
      expect: () => [
        isA<AdminProductCreating>(),
        predicate<AdminProductCreateError>(
          (state) => state.message.contains('Stock'),
        ),
      ],
    );
  });
}
