import 'package:equatable/equatable.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];

  bool get isInitial => this is ProductInitial;
  bool get isLoading => this is ProductLoading;
  bool get isLoaded => this is ProductLoaded;
  bool get isError => this is ProductError;

  List<Product>? get products =>
      this is ProductLoaded ? (this as ProductLoaded).products : null;
  Product? get product => this is ProductDetailLoaded
      ? (this as ProductDetailLoaded).product
      : null;
  String? get errorMessage =>
      this is ProductError ? (this as ProductError).message : null;
  ProductFilter? get filter =>
      this is ProductLoaded ? (this as ProductLoaded).filter : null;
  bool get isLoadingMore =>
      this is ProductLoaded ? (this as ProductLoaded).isLoadingMore : false;
  bool get hasMore =>
      this is ProductLoaded ? (this as ProductLoaded).hasMore : false;
  int get currentPage =>
      this is ProductLoaded ? (this as ProductLoaded).currentPage : 1;
  int get totalCount =>
      this is ProductLoaded ? (this as ProductLoaded).totalCount : 0;
  int get totalPages =>
      this is ProductLoaded ? (this as ProductLoaded).totalPages : 0;
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final ProductFilter filter;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final int totalCount;
  final bool isLoadingMore;

  const ProductLoaded({
    required this.products,
    required this.filter,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.totalCount,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
    products,
    filter,
    currentPage,
    totalPages,
    hasMore,
    totalCount,
    isLoadingMore,
  ];

  ProductLoaded copyWith({
    List<Product>? products,
    ProductFilter? filter,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    int? totalCount,
    bool? isLoadingMore,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      filter: filter ?? this.filter,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ProductDetailLoaded extends ProductState {
  final Product product;

  const ProductDetailLoaded({required this.product});

  @override
  List<Object?> get props => [product];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object?> get props => [message];
}
