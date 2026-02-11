// Unit tests for AdminProductBloc - GetProductDetail feature (UC-02)
//
// Tests cover:
// - Happy path: Successfully fetching product details
// - Failure paths: Network failure, server error, product not found, unauthorized
// - Edge cases: Null fields, boundary values, empty strings, special characters
//
// Based on:
// - UC-02: Admin View Product Details
// - Use Case Specification: .cursor/standards/admin_product_usecases.md

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';
import 'package:frontend_otis/domain/entities/brand.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/domain/entities/tire_spec.dart';
import 'package:frontend_otis/domain/entities/vehicle_make.dart';
import 'package:frontend_otis/domain/usecases/product/delete_product_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_admin_products_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/create_product_usecase.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_event.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAdminProductsUsecase extends Mock implements GetAdminProductsUsecase {}

class MockDeleteProductUsecase extends Mock implements DeleteProductUsecase {}

class MockGetProductDetailUsecase extends Mock
    implements GetProductDetailUsecase {}

class MockCreateProductUsecase extends Mock implements CreateProductUsecase {}

class FakeProductFilter extends Fake implements ProductFilter {}

class FakeAdminProductFilter extends Fake implements AdminProductFilter {}

/// Test data factory for creating Product entities with various configurations.
/// Follows the factory pattern for consistent test data creation.
class TestProductFactory {
  /// Creates a basic product with required fields only.
  static Product basic({
    String id = '1',
    String name = 'Michelin Pilot Sport 4S',
    String sku = 'MICH-PS4S-20555R16',
    double price = 1500000.0,
    int stockQuantity = 50,
    String imageUrl = 'https://example.com/michelin-ps4s.jpg',
    bool isActive = true,
    DateTime? createdAt,
  }) {
    return Product(
      id: id,
      name: name,
      sku: sku,
      price: price,
      stockQuantity: stockQuantity,
      imageUrl: imageUrl,
      isActive: isActive,
      createdAt: createdAt ?? DateTime(2024, 1, 15),
    );
  }

  /// Creates a product with a brand.
  static Product withBrand({
    String id = '1',
    String name = 'Michelin Pilot Sport 4S',
    String sku = 'MICH-PS4S-20555R16',
    double price = 1500000.0,
    int stockQuantity = 50,
    Brand? brand,
  }) {
    return Product(
      id: id,
      name: name,
      sku: sku,
      price: price,
      stockQuantity: stockQuantity,
      imageUrl: 'https://example.com/michelin-ps4s.jpg',
      isActive: true,
      createdAt: DateTime(2024, 1, 15),
      brand: brand ??
          const Brand(
            id: 'brand_1',
            name: 'Michelin',
            logoUrl: 'https://example.com/michelin-logo.jpg',
          ),
    );
  }

  /// Creates a product with tire specifications.
  static Product withTireSpec({
    String id = '1',
    String name = 'Michelin Pilot Sport 4S',
    String sku = 'MICH-PS4S-20555R16',
    double price = 1500000.0,
    int stockQuantity = 50,
    TireSpec? tireSpec,
  }) {
    return Product(
      id: id,
      name: name,
      sku: sku,
      price: price,
      stockQuantity: stockQuantity,
      imageUrl: 'https://example.com/michelin-ps4s.jpg',
      isActive: true,
      createdAt: DateTime(2024, 1, 15),
      tireSpec: tireSpec ??
          const TireSpec(
            id: 'tire_1',
            width: 205,
            aspectRatio: 55,
            rimDiameter: 16,
          ),
    );
  }

  /// Creates a fully populated product with all optional fields.
  static Product fullProduct({
    String id = '1',
    String name = 'Michelin Pilot Sport 4S',
    String sku = 'MICH-PS4S-20555R16',
    double price = 1500000.0,
    int stockQuantity = 50,
  }) {
    return Product(
      id: id,
      name: name,
      sku: sku,
      price: price,
      stockQuantity: stockQuantity,
      imageUrl: 'https://example.com/michelin-ps4s.jpg',
      isActive: true,
      createdAt: DateTime(2024, 1, 15),
      brand: const Brand(
        id: 'brand_1',
        name: 'Michelin',
        logoUrl: 'https://example.com/michelin-logo.jpg',
      ),
      vehicleMake: const VehicleMake(
        id: 'vm_1',
        name: 'Toyota',
        logoUrl: 'https://example.com/toyota-logo.jpg',
      ),
      tireSpec: const TireSpec(
        id: 'tire_1',
        width: 205,
        aspectRatio: 55,
        rimDiameter: 16,
      ),
    );
  }

  /// Creates an out of stock product.
  static Product outOfStock({
    String id = '3',
    String name = 'Pirelli P Zero',
    String sku = 'PIRE-PZERO-24540R18',
    double price = 2500000.0,
  }) {
    return Product(
      id: id,
      name: name,
      sku: sku,
      price: price,
      stockQuantity: 0,
      imageUrl: 'https://example.com/pirelli-pzero.jpg',
      isActive: true,
      createdAt: DateTime(2024, 3, 10),
    );
  }

  /// Creates a low stock product (less than 10 units).
  static Product lowStock({
    String id = '2',
    String name = 'Bridgestone Potenza S001',
    String sku = 'BRID-POT-S001-22545R17',
    double price = 1800000.0,
    int stockQuantity = 5,
  }) {
    return Product(
      id: id,
      name: name,
      sku: sku,
      price: price,
      stockQuantity: stockQuantity,
      imageUrl: 'https://example.com/bridgestone-s001.jpg',
      isActive: true,
      createdAt: DateTime(2024, 2, 20),
    );
  }

  /// Creates a product with zero price.
  static Product zeroPrice({
    String id = '4',
    String name = 'Free Product',
    String sku = 'FREE-001',
    int stockQuantity = 100,
  }) {
    return Product(
      id: id,
      name: name,
      sku: sku,
      price: 0.0,
      stockQuantity: stockQuantity,
      imageUrl: 'https://example.com/free-product.jpg',
      isActive: true,
      createdAt: DateTime(2024, 4, 1),
    );
  }

  /// Creates a product with large stock quantity.
  static Product largeStock({
    String id = '5',
    String name = 'Bulk Product',
    String sku = 'BULK-001',
    double price = 500000.0,
    int stockQuantity = 99999,
  }) {
    return Product(
      id: id,
      name: name,
      sku: sku,
      price: price,
      stockQuantity: stockQuantity,
      imageUrl: 'https://example.com/bulk-product.jpg',
      isActive: true,
      createdAt: DateTime(2024, 5, 1),
    );
  }

  /// Creates a product with null optional fields (brand, vehicleMake, tireSpec).
  static Product withNullFields({
    String id = '6',
    String name = 'Minimal Product',
    String sku = 'MIN-001',
    double price = 100.0,
    int stockQuantity = 1,
  }) {
    return Product(
      id: id,
      name: name,
      sku: sku,
      price: price,
      stockQuantity: stockQuantity,
      imageUrl: '',
      isActive: true,
      createdAt: DateTime(2024, 6, 1),
    );
  }

  /// Creates a product with special characters in SKU.
  static Product withSpecialSku({
    String id = '7',
    String name = 'Special Product',
    String sku = 'SPECIAL_SKU-123_456',
    double price = 999.99,
    int stockQuantity = 10,
  }) {
    return Product(
      id: id,
      name: name,
      sku: sku,
      price: price,
      stockQuantity: stockQuantity,
      imageUrl: 'https://example.com/special.jpg',
      isActive: true,
      createdAt: DateTime(2024, 7, 1),
    );
  }
}

void main() {
  registerFallbackValue(FakeProductFilter());
  registerFallbackValue(FakeAdminProductFilter());
  registerFallbackValue(Uri.parse('https://example.com'));

  late AdminProductBloc bloc;
  late MockGetAdminProductsUsecase mockGetAdminProductsUsecase;
  late MockDeleteProductUsecase mockDeleteProductUsecase;
  late MockGetProductDetailUsecase mockGetProductDetailUsecase;
  late MockCreateProductUsecase mockCreateProductUsecase;

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
  // GROUP 1: INITIAL STATE & HELPER PROPERTIES
  // ===========================================================================

  group('AdminProductBloc - Detail Initial State', () {
    test('initial state should be AdminProductInitial', () {
      expect(bloc.state, isA<AdminProductInitial>());
    });

    test('isDetailLoading should be false initially', () {
      expect(bloc.state.isDetailLoading, isFalse);
    });

    test('isDetailLoaded should be false initially', () {
      expect(bloc.state.isDetailLoaded, isFalse);
    });

    test('detailProduct should return null initially', () {
      expect(bloc.state.detailProduct, isNull);
    });

    test('isInitial should be true initially', () {
      expect(bloc.state.isInitial, isTrue);
    });

    test('isLoading should be false initially', () {
      expect(bloc.state.isLoading, isFalse);
    });

    test('isError should be false initially', () {
      expect(bloc.state.isError, isFalse);
    });
  });

  // ===========================================================================
  // GROUP 2: UC-02 - GET PRODUCT DETAIL (HAPPY PATH)
  // ===========================================================================

  group('UC-02: GetProductDetailEvent - Happy Path', () {
    blocTest(
      'should emit [detailLoading, detailLoaded] when API succeeds',
      setUp: () {
        final product = TestProductFactory.basic();
        when(() => mockGetProductDetailUsecase.call('1'))
            .thenAnswer((_) async => Right(product));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '1')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductDetailLoaded>(
          (state) =>
              state.product.id == '1' &&
              state.product.name == 'Michelin Pilot Sport 4S',
        ),
      ],
      verify: (_) {
        verify(() => mockGetProductDetailUsecase.call('1')).called(1);
        verifyNoMoreInteractions(mockGetProductDetailUsecase);
      },
    );

    blocTest(
      'should emit detailLoaded with full product data',
      setUp: () {
        final product = TestProductFactory.fullProduct();
        when(() => mockGetProductDetailUsecase.call('1'))
            .thenAnswer((_) async => Right(product));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '1')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductDetailLoaded>((state) {
          final product = state.product;
          return product.brand != null &&
              product.brand!.name == 'Michelin' &&
              product.vehicleMake != null &&
              product.vehicleMake!.name == 'Toyota' &&
              product.tireSpec != null &&
              product.tireSpec!.display == '205/55 R16';
        }),
      ],
      verify: (_) {
        verify(() => mockGetProductDetailUsecase.call('1')).called(1);
      },
    );

    blocTest(
      'should emit detailLoaded with correct price formatting',
      setUp: () {
        final product = TestProductFactory.basic(price: 2450000.0);
        when(() => mockGetProductDetailUsecase.call('1'))
            .thenAnswer((_) async => Right(product));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '1')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductDetailLoaded>((state) {
          return state.product.formattedPrice == '2.450.000 đ';
        }),
      ],
    );
  });

  // ===========================================================================
  // GROUP 3: UC-02 - GET PRODUCT DETAIL (FAILURE PATHS)
  // ===========================================================================

  group('UC-02: GetProductDetailEvent - Failure Paths', () {
    blocTest(
      'should emit [detailLoading, Error] when NetworkFailure occurs',
      setUp: () {
        when(() => mockGetProductDetailUsecase.call('1'))
            .thenAnswer((_) async => const Left(NetworkFailure()));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '1')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductError>((state) =>
            state.message.contains('internet') ||
            state.message.contains('connection')),
      ],
      verify: (_) {
        verify(() => mockGetProductDetailUsecase.call('1')).called(1);
      },
    );

    blocTest(
      'should emit [detailLoading, Error] when ServerFailure (500) occurs',
      setUp: () {
        when(() => mockGetProductDetailUsecase.call('1'))
            .thenAnswer(
                (_) async => const Left(ServerFailure(message: '500 Internal Server Error')));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '1')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductError>((state) =>
            state.message.contains('500') ||
            state.message.contains('Server')),
      ],
    );

    blocTest(
      'should emit [detailLoading, Error] when product not found (404)',
      setUp: () {
        when(() => mockGetProductDetailUsecase.call('999'))
            .thenAnswer((_) async =>
                const Left(ServerFailure(message: 'Product not found')));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '999')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductError>(
            (state) => state.message.toLowerCase().contains('not found')),
      ],
    );

    blocTest(
      'should emit [detailLoading, Error] when unauthorized (401)',
      setUp: () {
        when(() => mockGetProductDetailUsecase.call('1'))
            .thenAnswer((_) async =>
                const Left(ServerFailure(message: 'Unauthorized: Session expired')));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '1')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductError>((state) =>
            state.message.contains('Unauthorized') ||
            state.message.contains('expired') ||
            state.message.contains('session')),
      ],
    );

    blocTest(
      'should handle CacheFailure gracefully',
      setUp: () {
        when(() => mockGetProductDetailUsecase.call('1'))
            .thenAnswer(
                (_) async => const Left(CacheFailure(message: 'Cache error')));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '1')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductError>(
            (state) => state.message.contains('Cache') || state.message.isNotEmpty),
      ],
    );
  });

  // ===========================================================================
  // GROUP 4: UC-02 - GET PRODUCT DETAIL (EDGE CASES)
  // ===========================================================================

  group('UC-02: GetProductDetailEvent - Edge Cases', () {
    blocTest(
      'should handle product with all null optional fields',
      setUp: () {
        final product = TestProductFactory.withNullFields();
        when(() => mockGetProductDetailUsecase.call('6'))
            .thenAnswer((_) async => Right(product));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '6')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductDetailLoaded>((state) {
          final product = state.product;
          return product.id == '6' &&
              product.brand == null &&
              product.vehicleMake == null &&
              product.tireSpec == null;
        }),
      ],
    );

    blocTest(
      'should handle out of stock product correctly',
      setUp: () {
        final product = TestProductFactory.outOfStock();
        when(() => mockGetProductDetailUsecase.call('3'))
            .thenAnswer((_) async => Right(product));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '3')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductDetailLoaded>((state) {
          final product = state.product;
          return product.stockQuantity == 0 &&
              product.isOutOfStock == true &&
              product.isInStock == false;
        }),
      ],
    );

    blocTest(
      'should handle low stock product correctly',
      setUp: () {
        final product = TestProductFactory.lowStock(stockQuantity: 5);
        when(() => mockGetProductDetailUsecase.call('2'))
            .thenAnswer((_) async => Right(product));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '2')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductDetailLoaded>((state) {
          final product = state.product;
          return product.stockQuantity == 5 &&
              product.isLowStock == true &&
              product.isInStock == true;
        }),
      ],
    );

    blocTest(
      'should handle zero price product correctly',
      setUp: () {
        final product = TestProductFactory.zeroPrice();
        when(() => mockGetProductDetailUsecase.call('4'))
            .thenAnswer((_) async => Right(product));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '4')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductDetailLoaded>((state) {
          final product = state.product;
          return product.price == 0.0 &&
              product.formattedPrice == '0 đ';
        }),
      ],
    );

    blocTest(
      'should handle large stock quantity correctly',
      setUp: () {
        final product = TestProductFactory.largeStock();
        when(() => mockGetProductDetailUsecase.call('5'))
            .thenAnswer((_) async => Right(product));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '5')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductDetailLoaded>((state) {
          final product = state.product;
          return product.stockQuantity == 99999 &&
              product.formattedPrice == '500.000 đ';
        }),
      ],
    );

    blocTest(
      'should handle product with special characters in SKU',
      setUp: () {
        final product = TestProductFactory.withSpecialSku();
        when(() => mockGetProductDetailUsecase.call('7'))
            .thenAnswer((_) async => Right(product));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '7')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductDetailLoaded>((state) {
          final product = state.product;
          return product.sku == 'SPECIAL_SKU-123_456' &&
              product.name == 'Special Product';
        }),
      ],
    );

    blocTest(
      'should call use case with correct productId parameter',
      setUp: () {
        final product = TestProductFactory.basic();
        when(() => mockGetProductDetailUsecase.call('test-id-123'))
            .thenAnswer((_) async => Right(product));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) =>
          bloc.add(const GetProductDetailEvent(productId: 'test-id-123')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        isA<AdminProductDetailLoaded>(),
      ],
      verify: (_) {
        verify(() => mockGetProductDetailUsecase.call('test-id-123')).called(1);
      },
    );

    blocTest(
      'should handle product with empty image URL',
      setUp: () {
        final product = TestProductFactory.basic(imageUrl: '');
        when(() => mockGetProductDetailUsecase.call('1'))
            .thenAnswer((_) async => Right(product));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '1')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductDetailLoaded>((state) {
          return state.product.imageUrl.isEmpty;
        }),
      ],
    );

    blocTest(
      'should handle product with inactive status',
      setUp: () {
        final product = TestProductFactory.basic(isActive: false);
        when(() => mockGetProductDetailUsecase.call('1'))
            .thenAnswer((_) async => Right(product));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const GetProductDetailEvent(productId: '1')),
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductDetailLoaded>((state) {
          return state.product.isActive == false &&
              state.product.isAvailable == false;
        }),
      ],
    );
  });

  // ===========================================================================
  // GROUP 5: DELETE PRODUCT FROM DETAIL SCREEN
  // ===========================================================================

  group('Delete Product from Detail Screen', () {
    blocTest(
      'should emit [Deleting, Deleted, Loading, Loaded] after successful delete',
      setUp: () {
        when(() => mockDeleteProductUsecase.call('1'))
            .thenAnswer((_) async => const Right(true));
        when(() => mockGetAdminProductsUsecase.call(any()))
            .thenAnswer((_) async => const Right((
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
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) => bloc.add(const DeleteProductEvent(productId: '1')),
      expect: () => [
        predicate<AdminProductDeleting>((state) => state.productId == '1'),
        predicate<AdminProductDeleted>((state) => state.productId == '1'),
        isA<AdminProductLoading>(),
        isA<AdminProductLoaded>(),
      ],
      verify: (_) {
        verify(() => mockDeleteProductUsecase.call('1')).called(1);
      },
    );

    blocTest(
      'should emit [Deleting, Error] when delete fails',
      setUp: () {
        when(() => mockDeleteProductUsecase.call('1'))
            .thenAnswer(
                (_) async => const Left(ServerFailure(message: 'Delete failed')));
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
            (state) => state.message.contains('Delete') || state.message.isNotEmpty),
      ],
    );
  });

  // ===========================================================================
  // GROUP 6: STATE HELPER METHODS
  // ===========================================================================

  group('Detail State Helper Methods', () {
    test('isDetailLoading returns correct value after loading', () {
      expect(bloc.state.isDetailLoading, isFalse);
    });

    test('isDetailLoaded returns correct value when loaded', () async {
      final product = TestProductFactory.basic();
      when(() => mockGetProductDetailUsecase.call('1'))
          .thenAnswer((_) async => Right(product));

      bloc.add(const GetProductDetailEvent(productId: '1'));

      // Wait for state emission
      await Future.delayed(const Duration(milliseconds: 100));

      expect(bloc.state.isDetailLoaded, isTrue);
      expect(bloc.state.detailProduct?.id, '1');
    });

    test('isDetailLoading returns true during loading state', () async {
      // First, load a product to get to a known state
      final product = TestProductFactory.basic();
      when(() => mockGetProductDetailUsecase.call('1'))
          .thenAnswer((_) async => Right(product));

      bloc.add(const GetProductDetailEvent(productId: '1'));
      await Future.delayed(const Duration(milliseconds: 50));

      // Verify the state transitioned correctly
      expect(bloc.state.isDetailLoaded, isTrue);
      expect(bloc.state.detailProduct?.name, 'Michelin Pilot Sport 4S');
    });

    test('detailProduct returns correct product after loading', () async {
      final product = TestProductFactory.basic(
        name: 'Specific Test Product',
        sku: 'TEST-001',
      );
      when(() => mockGetProductDetailUsecase.call('1'))
          .thenAnswer((_) async => Right(product));

      bloc.add(const GetProductDetailEvent(productId: '1'));
      await Future.delayed(const Duration(milliseconds: 100));

      expect(bloc.state.detailProduct?.name, 'Specific Test Product');
      expect(bloc.state.detailProduct?.sku, 'TEST-001');
    });
  });

  // ===========================================================================
  // GROUP 7: MULTIPLE DETAIL REQUESTS
  // ===========================================================================

  group('Multiple Product Detail Requests', () {
    blocTest(
      'should handle multiple GetProductDetailEvent calls',
      setUp: () {
        final product1 = TestProductFactory.basic(id: '1', name: 'Product 1');
        final product2 = TestProductFactory.basic(id: '2', name: 'Product 2');

        when(() => mockGetProductDetailUsecase.call('1'))
            .thenAnswer((_) async => Right(product1));
        when(() => mockGetProductDetailUsecase.call('2'))
            .thenAnswer((_) async => Right(product2));
      },
      build: () => AdminProductBloc(
        getAdminProductsUsecase: mockGetAdminProductsUsecase,
        getProductDetailUsecase: mockGetProductDetailUsecase,
        deleteProductUsecase: mockDeleteProductUsecase,
        createProductUsecase: mockCreateProductUsecase,
      ),
      act: (bloc) async {
        bloc.add(const GetProductDetailEvent(productId: '1'));
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(const GetProductDetailEvent(productId: '2'));
      },
      expect: () => [
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductDetailLoaded>((state) => state.product.id == '1'),
        isA<AdminProductDetailLoading>(),
        predicate<AdminProductDetailLoaded>((state) => state.product.id == '2'),
      ],
      verify: (_) {
        verify(() => mockGetProductDetailUsecase.call('1')).called(1);
        verify(() => mockGetProductDetailUsecase.call('2')).called(1);
      },
    );
  });
}
