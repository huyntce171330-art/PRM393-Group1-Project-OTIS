import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';

part 'product_state.freezed.dart';

@freezed
class ProductState with _$ProductState {
  const ProductState._();

  const factory ProductState.initial() = ProductInitial;

  const factory ProductState.loading() = ProductLoading;

  const factory ProductState.loaded({
    required List<Product> products,
    required ProductFilter filter,
    required int currentPage,
    required int totalPages,
    required bool hasMore,
    required int totalCount,
    @Default(false) bool isLoadingMore,
  }) = ProductLoaded;

  const factory ProductState.detailLoaded({required Product product}) =
      ProductDetailLoaded;

  const factory ProductState.error({required String message}) = ProductError;

  bool get isInitial => this is ProductInitial;
  bool get isLoading => this is ProductLoading;
  bool get isLoaded => this is ProductLoaded;
  bool get isError => this is ProductError;

  List<Product>? get products {
    return whenOrNull(
      loaded: (p0, p1, p2, p3, p4, p5, p6) => p0,
    );
  }

  Product? get product {
    return whenOrNull(detailLoaded: (product) => product);
  }

  String? get errorMessage {
    return whenOrNull(error: (message) => message);
  }

  ProductFilter? get filter {
    return whenOrNull(loaded: (p0, p1, p2, p3, p4, p5, p6) => p1);
  }

  bool get isLoadingMore {
    return whenOrNull(
      loaded: (p0, p1, p2, p3, p4, p5, p6) => p6,
    ) ?? false;
  }

  bool get hasMore {
    return whenOrNull(
      loaded: (p0, p1, p2, p3, p4, p5, p6) => p4,
    ) ?? false;
  }

  int get currentPage {
    return whenOrNull(
      loaded: (p0, p1, p2, p3, p4, p5, p6) => p2,
    ) ?? 1;
  }

  int get totalCount {
    return whenOrNull(
      loaded: (p0, p1, p2, p3, p4, p5, p6) => p5,
    ) ?? 0;
  }

  int get totalPages {
    return whenOrNull(
      loaded: (p0, p1, p2, p3, p4, p5, p6) => p3,
    ) ?? 0;
  }
}
