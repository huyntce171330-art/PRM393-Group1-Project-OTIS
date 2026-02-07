import 'package:dartz/dartz.dart';
import 'package:frontend_otis/core/error/exceptions.dart';
import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/core/network/network_info.dart';
import 'package:frontend_otis/data/datasources/product/product_remote_datasource.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

// Implementation of Product Repository.
//
// Steps:
// 1. Implement ProductRepository.
// 2. Use ProductRemoteDatasource to fetch data.
// 3. Return Either<Failure, T>.
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource productRemoteDatasource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.productRemoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ({List<Product> products, int totalCount, int totalPages, bool hasMore})>>
      getProductsWithMetadata({
    required ProductFilter filter,
    required int page,
    required int limit,
  }) async {
    // Check network connectivity
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }

    try {
      // Fetch paginated products from data source with filter
      final productList = await productRemoteDatasource.getProducts(
        page: page,
        limit: limit,
        filter: filter,
      );

      // Convert ProductModel list to Product domain entities
      final products = productList.products.map((model) {
        return Product(
          id: model.id,
          sku: model.sku,
          name: model.name,
          imageUrl: model.imageUrl,
          price: model.price,
          stockQuantity: model.stockQuantity,
          brand: model.brand.toDomain(),
          vehicleMake: model.vehicleMake.toDomain(),
          tireSpec: model.tireSpec.toDomain(),
          isActive: model.isActive,
          createdAt: model.createdAt,
        );
      }).toList();

      // Return products WITH pagination metadata
      return Right((
        products: products,
        totalCount: productList.total,
        totalPages: productList.totalPages,
        hasMore: productList.hasMore,
      ));
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    required ProductFilter filter,
    required int page,
    required int limit,
  }) async {
    // Delegate to getProductsWithMetadata
    final result = await getProductsWithMetadata(
      filter: filter,
      page: page,
      limit: limit,
    );

    return result.fold(
      (failure) => Left(failure),
      (metadata) => Right(metadata.products),
    );
  }

  @override
  Future<Either<Failure, Product>> getProductDetail({required String productId}) async {
    // Check network connectivity
    if (!(await networkInfo.isConnected)) {
      return Left(NetworkFailure());
    }

    try {
      // Fetch product detail from data source
      final result = await productRemoteDatasource.getProductDetail(productId: productId);

      if (result.products.isEmpty) {
        return Left(ServerFailure(message: 'Product not found'));
      }

      final productModel = result.products.first;
      final product = Product(
        id: productModel.id,
        sku: productModel.sku,
        name: productModel.name,
        imageUrl: productModel.imageUrl,
        price: productModel.price,
        stockQuantity: productModel.stockQuantity,
        brand: productModel.brand.toDomain(),
        vehicleMake: productModel.vehicleMake.toDomain(),
        tireSpec: productModel.tireSpec.toDomain(),
        isActive: productModel.isActive,
        createdAt: productModel.createdAt,
      );

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
