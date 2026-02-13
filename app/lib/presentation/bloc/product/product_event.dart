import 'package:equatable/equatable.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';

/// Events that can occur in the Product feature.
///
/// These events trigger state changes in the ProductBloc.
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch a paginated list of products
/// Use this for initial load, pagination, and applying filters
class GetProductsEvent extends ProductEvent {
  final ProductFilter filter;

  const GetProductsEvent({required this.filter});

  @override
  List<Object?> get props => [filter];
}

/// Event to search products by query
/// Automatically resets to page 1 and applies search query
class SearchProductsEvent extends ProductEvent {
  final String query;

  const SearchProductsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Event to clear search and reset to default filter
class ClearSearchEvent extends ProductEvent {
  const ClearSearchEvent();
}

/// Event to fetch a single product by ID
class GetProductDetailEvent extends ProductEvent {
  final String id;

  const GetProductDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to refresh the product list
/// Resets to page 1 and reloads data
class RefreshProductsEvent extends ProductEvent {
  const RefreshProductsEvent();
}

/// Event to restore the previous product list state
/// Use when returning from detail view to preserve scroll position/list
class RestoreProductListEvent extends ProductEvent {
  const RestoreProductListEvent();
}
