import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/core/error/exceptions.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/core/network/network_info.dart';
import 'package:frontend_otis/data/datasources/product/product_remote_datasource.dart';
import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/data/models/product_list_model.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/data/models/tire_spec_model.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
import 'package:frontend_otis/data/repositories/product_repository_impl.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRemoteDatasource extends Mock
    implements ProductRemoteDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDatasource mockDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(const ProductFilter(page: 1, limit: 10));
  });

  setUp(() {
    mockDatasource = MockProductRemoteDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      productRemoteDatasource: mockDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tFilter = ProductFilter(page: 1, limit: 10);

  final tProductModel = ProductModel(
    id: '1',
    sku: 'SKU001',
    name: 'Michelin Primacy 4',
    imageUrl: 'https://example.com/tire1.jpg',
    brand: const BrandModel(id: '1', name: 'Michelin', logoUrl: ''),
    vehicleMake: const VehicleMakeModel(id: '1', name: 'Toyota', logoUrl: ''),
    tireSpec: const TireSpecModel(id: '1', width: 205, aspectRatio: 55, rimDiameter: 16),
    price: 2450000.0,
    stockQuantity: 50,
    isActive: true,
    createdAt: DateTime(2024, 1, 15),
  );

  final tProductListModel = ProductListModel(
    products: [tProductModel],
    total: 1,
    page: 1,
    limit: 10,
    totalPages: 1,
    hasMore: false,
  );

  group('ProductRepositoryImpl', () {
    group('getProductsWithMetadata', () {
      test(
        'should return right when network is available and datasource succeeds',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(page: 1, limit: 10, filter: any(named: 'filter')))
              .thenAnswer((_) async => tProductListModel);

          // Act
          final result = await repository.getProductsWithMetadata(
            filter: tFilter,
            page: tFilter.page,
            limit: tFilter.limit,
          );

          // Assert
          expect(result.isRight(), true);
          expect(result.isLeft(), false);
          result.fold(
            (failure) => fail('Should not return failure'),
            (metadata) {
              expect(metadata.products, hasLength(1));
              expect(metadata.totalCount, equals(1));
              expect(metadata.totalPages, equals(1));
              expect(metadata.hasMore, equals(false));
            },
          );
          verify(() => mockDatasource.getProducts(page: 1, limit: 10, filter: tFilter)).called(1);
        },
      );

      test(
        'should return left with NetworkFailure when no network',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

          // Act
          final result = await repository.getProductsWithMetadata(
            filter: tFilter,
            page: tFilter.page,
            limit: tFilter.limit,
          );

          // Assert
          expect(result.isLeft(), true);
          expect(result.isRight(), false);
          result.fold(
            (failure) {
              expect(failure, isA<NetworkFailure>());
            },
            (_) => fail('Should not return products'),
          );
          verifyNever(() => mockDatasource.getProducts(page: 1, limit: 10, filter: any(named: 'filter')));
        },
      );

      test(
        'should return left with ServerFailure on ServerException',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(page: 1, limit: 10, filter: any(named: 'filter')))
              .thenThrow(ServerException());

          // Act
          final result = await repository.getProductsWithMetadata(
            filter: tFilter,
            page: tFilter.page,
            limit: tFilter.limit,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
            },
            (_) => fail('Should not return products'),
          );
        },
      );

      test(
        'should return left with CacheFailure on CacheException',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(page: 1, limit: 10, filter: any(named: 'filter')))
              .thenThrow(CacheException());

          // Act
          final result = await repository.getProductsWithMetadata(
            filter: tFilter,
            page: tFilter.page,
            limit: tFilter.limit,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<CacheFailure>());
            },
            (_) => fail('Should not return products'),
          );
        },
      );

      test(
        'should convert models to domain entities correctly',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(page: 1, limit: 10, filter: any(named: 'filter')))
              .thenAnswer((_) async => tProductListModel);

          // Act
          final result = await repository.getProductsWithMetadata(
            filter: tFilter,
            page: tFilter.page,
            limit: tFilter.limit,
          );

          // Assert
          result.fold(
            (failure) => fail('Should not return failure'),
            (metadata) {
              expect(metadata.products[0].id, equals('1'));
              expect(metadata.products[0].sku, equals('SKU001'));
              expect(metadata.products[0].name, equals('Michelin Primacy 4'));
              expect(metadata.products[0].price, equals(2450000.0));
              expect(metadata.products[0].stockQuantity, equals(50));
              expect(metadata.products[0].isActive, isTrue);
            },
          );
        },
      );

      test(
        'should handle pagination correctly',
        () async {
          // Arrange
          final paginatedModel = ProductListModel(
            products: [tProductModel],
            total: 25,
            page: 2,
            limit: 10,
            totalPages: 3,
            hasMore: true,
          );
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(page: 2, limit: 10, filter: any(named: 'filter')))
              .thenAnswer((_) async => paginatedModel);

          // Act
          final result = await repository.getProductsWithMetadata(
            filter: const ProductFilter(page: 2, limit: 10),
            page: 2,
            limit: 10,
          );

          // Assert
          result.fold(
            (failure) => fail('Should not return failure'),
            (metadata) {
              expect(metadata.hasMore, isTrue);
              expect(metadata.totalCount, equals(25));
              expect(metadata.totalPages, equals(3));
            },
          );
        },
      );

      // ========== EDGE CASES AND ADDITIONAL TESTS ==========

      test(
        'should handle empty product list',
        () async {
          // Arrange
          final emptyModel = ProductListModel(
            products: [],
            total: 0,
            page: 1,
            limit: 10,
            totalPages: 1,
            hasMore: false,
          );
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(page: 1, limit: 10, filter: any(named: 'filter')))
              .thenAnswer((_) async => emptyModel);

          // Act
          final result = await repository.getProductsWithMetadata(
            filter: tFilter,
            page: 1,
            limit: 10,
          );

          // Assert
          expect(result.isRight(), true);
          result.fold(
            (failure) => fail('Should not return failure'),
            (metadata) {
              expect(metadata.products, isEmpty);
              expect(metadata.totalCount, equals(0));
              expect(metadata.hasMore, isFalse);
            },
          );
        },
      );

      test(
        'should handle datasource returning null response',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(page: 1, limit: 10, filter: any(named: 'filter')))
              .thenThrow(Exception('Datasource returned null'));

          // Act
          final result = await repository.getProductsWithMetadata(
            filter: tFilter,
            page: 1,
            limit: 10,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
            },
            (_) => fail('Should not return products'),
          );
        },
      );

      test(
        'should handle unexpected exception from datasource',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(page: 1, limit: 10, filter: any(named: 'filter')))
              .thenThrow(Exception('Unexpected error'));

          // Act
          final result = await repository.getProductsWithMetadata(
            filter: tFilter,
            page: 1,
            limit: 10,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
            },
            (_) => fail('Should not return products'),
          );
        },
      );

      test(
        'should handle timeout exception',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(page: 1, limit: 10, filter: any(named: 'filter')))
              .thenThrow(Exception('Connection timeout'));

          // Act
          final result = await repository.getProductsWithMetadata(
            filter: tFilter,
            page: 1,
            limit: 10,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
            },
            (_) => fail('Should not return products'),
          );
        },
      );

      test(
        'should pass correct pagination parameters to datasource',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(
            page: 3,
            limit: 25,
            filter: any(named: 'filter'),
          )).thenAnswer((_) async => tProductListModel);

          // Act
          final result = await repository.getProductsWithMetadata(
            filter: const ProductFilter(page: 3, limit: 25),
            page: 3,
            limit: 25,
          );

          // Assert
          expect(result.isRight(), true);
          verify(() => mockDatasource.getProducts(
            page: 3,
            limit: 25,
            filter: const ProductFilter(page: 3, limit: 25),
          )).called(1);
        },
      );

      test(
        'should forward filter to datasource',
        () async {
          // Arrange
          const filterWithSearch = ProductFilter(
            page: 1,
            limit: 10,
            searchQuery: 'michelin',
          );
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(
            page: 1,
            limit: 10,
            filter: any(named: 'filter'),
          )).thenAnswer((_) async => tProductListModel);

          // Act
          final result = await repository.getProductsWithMetadata(
            filter: filterWithSearch,
            page: 1,
            limit: 10,
          );

          // Assert
          expect(result.isRight(), true);
          verify(() => mockDatasource.getProducts(
            page: 1,
            limit: 10,
            filter: filterWithSearch,
          )).called(1);
        },
      );
    });

    group('getProducts', () {
      test(
        'should return right with products list',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(page: 1, limit: 10, filter: any(named: 'filter')))
              .thenAnswer((_) async => tProductListModel);

          // Act
          final result = await repository.getProducts(
            filter: tFilter,
            page: tFilter.page,
            limit: tFilter.limit,
          );

          // Assert
          expect(result.isRight(), true);
          result.fold(
            (failure) => fail('Should not return failure'),
            (products) {
              expect(products, hasLength(1));
            },
          );
        },
      );

      test(
        'should forward failure from getProductsWithMetadata',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

          // Act
          final result = await repository.getProducts(
            filter: tFilter,
            page: tFilter.page,
            limit: tFilter.limit,
          );

          // Assert
          expect(result.isLeft(), true);
        },
      );

      test(
        'should handle empty product list',
        () async {
          // Arrange
          final emptyModel = ProductListModel(
            products: [],
            total: 0,
            page: 1,
            limit: 10,
            totalPages: 1,
            hasMore: false,
          );
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(page: 1, limit: 10, filter: any(named: 'filter')))
              .thenAnswer((_) async => emptyModel);

          // Act
          final result = await repository.getProducts(
            filter: tFilter,
            page: tFilter.page,
            limit: tFilter.limit,
          );

          // Assert
          expect(result.isRight(), true);
          result.fold(
            (failure) => fail('Should not return failure'),
            (products) {
              expect(products, isEmpty);
            },
          );
        },
      );

      test(
        'should forward network failure to caller',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.getProducts(page: 1, limit: 10, filter: any(named: 'filter')))
              .thenThrow(const SocketException('No internet'));

          // Act
          final result = await repository.getProducts(
            filter: tFilter,
            page: tFilter.page,
            limit: tFilter.limit,
          );

          // Assert
          expect(result.isLeft(), true);
        },
      );
    });

    group('createProduct', () {
      test(
        'should return product when datasource succeeds',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockDatasource.createProduct(product: tProductModel))
              .thenAnswer((_) async => tProductModel);

          // Act
          final result = await repository.createProduct(product: tProductModel);

          // Assert
          expect(result.isRight(), true);
          result.fold(
            (failure) => fail('Should not return failure'),
            (product) {
              expect(product.sku, equals(tProductModel.sku));
              expect(product.name, equals(tProductModel.name));
            },
          );
          verify(() => mockDatasource.createProduct(product: tProductModel)).called(1);
        },
      );

      test(
        'should return left with NetworkFailure when no network',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

          // Act
          final result = await repository.createProduct(product: tProductModel);

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<NetworkFailure>());
            },
            (_) => fail('Should not return product'),
          );
        },
      );
    });
  });
}
