import 'package:equatable/equatable.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';

abstract class AdminProductEvent extends Equatable {
  const AdminProductEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch a paginated list of products with admin filters
class GetAdminProductsEvent extends AdminProductEvent {
  final AdminProductFilter? filter;
  final bool? showInactive;

  const GetAdminProductsEvent({this.filter, this.showInactive});

  @override
  List<Object?> get props => [filter, showInactive];
}

/// Event to filter products by brand name
class FilterByBrandEvent extends AdminProductEvent {
  final String? brandName;

  const FilterByBrandEvent({required this.brandName});

  @override
  List<Object?> get props => [brandName];
}

/// Event to filter products by stock status
class FilterByStockStatusEvent extends AdminProductEvent {
  final StockStatus status;

  const FilterByStockStatusEvent({required this.status});

  @override
  List<Object?> get props => [status];
}

/// Event to search products by query
class SearchAdminProductsEvent extends AdminProductEvent {
  final String query;

  const SearchAdminProductsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Event to clear search query
class ClearAdminSearchEvent extends AdminProductEvent {
  const ClearAdminSearchEvent();
}

/// Event to refresh the product list
class RefreshAdminProductsEvent extends AdminProductEvent {
  final bool silent;

  const RefreshAdminProductsEvent({this.silent = false});

  @override
  List<Object?> get props => [silent];
}

/// Event to delete a product by ID
class DeleteProductEvent extends AdminProductEvent {
  final String productId;

  const DeleteProductEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/// Event to get product details by ID
class GetProductDetailEvent extends AdminProductEvent {
  final String productId;

  const GetProductDetailEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/// Event to create a new product
class CreateProductEvent extends AdminProductEvent {
  final ProductModel product;

  const CreateProductEvent({required this.product});

  @override
  List<Object?> get props => [product];
}

/// Event to get trash products (deleted/inactive products)
class GetTrashProductsEvent extends AdminProductEvent {
  const GetTrashProductsEvent();
}

/// Event to restore a deleted product
class RestoreProductEvent extends AdminProductEvent {
  final String productId;

  const RestoreProductEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/// Event to permanently delete a product
class PermanentDeleteProductEvent extends AdminProductEvent {
  final String productId;

  const PermanentDeleteProductEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}
