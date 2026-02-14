import 'package:equatable/equatable.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';
import 'package:frontend_otis/domain/entities/product.dart';

abstract class AdminProductState extends Equatable {
  const AdminProductState();

  @override
  List<Object?> get props => [];
}

class AdminProductInitial extends AdminProductState {
  const AdminProductInitial();
}

class AdminProductLoading extends AdminProductState {
  const AdminProductLoading();
}

class AdminProductLoaded extends AdminProductState {
  final List<Product> products;
  final AdminProductFilter filter;
  final String? selectedBrand;
  final StockStatus stockStatus;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final int totalCount;
  final bool isLoadingMore;
  final bool isRefreshing;

  const AdminProductLoaded({
    required this.products,
    required this.filter,
    required this.selectedBrand,
    required this.stockStatus,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.totalCount,
    this.isLoadingMore = false,
    this.isRefreshing = false,
  });

  AdminProductLoaded copyWith({
    List<Product>? products,
    AdminProductFilter? filter,
    String? selectedBrand,
    StockStatus? stockStatus,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    int? totalCount,
    bool? isLoadingMore,
    bool? isRefreshing,
  }) {
    return AdminProductLoaded(
      products: products ?? this.products,
      filter: filter ?? this.filter,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      stockStatus: stockStatus ?? this.stockStatus,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    products,
    filter,
    selectedBrand,
    stockStatus,
    currentPage,
    totalPages,
    hasMore,
    totalCount,
    isLoadingMore,
    isRefreshing,
  ];
}

class AdminProductError extends AdminProductState {
  final String message;

  const AdminProductError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AdminProductDeleting extends AdminProductState {
  final String productId;

  const AdminProductDeleting({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class AdminProductDeleted extends AdminProductState {
  final String productId;

  const AdminProductDeleted({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class AdminProductDetailLoading extends AdminProductState {
  const AdminProductDetailLoading();
}

class AdminProductDetailLoaded extends AdminProductState {
  final Product product;

  const AdminProductDetailLoaded({required this.product});

  @override
  List<Object?> get props => [product];
}

class AdminProductCreating extends AdminProductState {
  const AdminProductCreating();
}

class AdminProductCreateSuccess extends AdminProductState {
  final Product product;

  const AdminProductCreateSuccess({required this.product});

  @override
  List<Object?> get props => [product];
}

class AdminProductCreateError extends AdminProductState {
  final String message;

  const AdminProductCreateError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AdminProductUpdating extends AdminProductState {
  const AdminProductUpdating();
}

class AdminProductUpdateSuccess extends AdminProductState {
  final Product product;

  const AdminProductUpdateSuccess({required this.product});

  @override
  List<Object?> get props => [product];
}

class AdminProductUpdateError extends AdminProductState {
  final String message;

  const AdminProductUpdateError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AdminProductRestoring extends AdminProductState {
  final String productId;

  const AdminProductRestoring({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class AdminProductRestored extends AdminProductState {
  final String productId;

  const AdminProductRestored({required this.productId});

  @override
  List<Object?> get props => [productId];
}

// Extension to provide helper methods similar to the original Freezed version
extension AdminProductStateX on AdminProductState {
  bool get isInitial => this is AdminProductInitial;
  bool get isLoading => this is AdminProductLoading;
  bool get isLoaded => this is AdminProductLoaded;
  bool get isError => this is AdminProductError;
  bool get isDeleting => this is AdminProductDeleting;

  List<Product> get products {
    if (this is AdminProductLoaded) {
      return (this as AdminProductLoaded).products;
    }
    return [];
  }

  String? get errorMessage {
    if (this is AdminProductError) {
      return (this as AdminProductError).message;
    }
    return null;
  }

  AdminProductFilter? get filter {
    if (this is AdminProductLoaded) {
      return (this as AdminProductLoaded).filter;
    }
    return null;
  }

  int get currentPage {
    if (this is AdminProductLoaded) {
      return (this as AdminProductLoaded).currentPage;
    }
    return 1;
  }

  int get totalCount {
    if (this is AdminProductLoaded) {
      return (this as AdminProductLoaded).totalCount;
    }
    return 0;
  }

  bool get hasMore {
    if (this is AdminProductLoaded) {
      return (this as AdminProductLoaded).hasMore;
    }
    return false;
  }

  bool get isLoadingMore {
    if (this is AdminProductLoaded) {
      return (this as AdminProductLoaded).isLoadingMore;
    }
    return false;
  }

  bool get isRefreshing {
    if (this is AdminProductLoaded) {
      return (this as AdminProductLoaded).isRefreshing;
    }
    return false;
  }

  String? get selectedBrand {
    if (this is AdminProductLoaded) {
      return (this as AdminProductLoaded).selectedBrand;
    }
    return null;
  }

  StockStatus get stockStatus {
    if (this is AdminProductLoaded) {
      return (this as AdminProductLoaded).stockStatus;
    }
    return StockStatus.all;
  }

  bool get hasActiveFilters {
    if (this is AdminProductLoaded) {
      final state = this as AdminProductLoaded;
      return state.selectedBrand != null ||
          state.stockStatus != StockStatus.all;
    }
    return false;
  }

  bool get isDetailLoading => this is AdminProductDetailLoading;
  bool get isDetailLoaded => this is AdminProductDetailLoaded;

  Product? get detailProduct {
    if (this is AdminProductDetailLoaded) {
      return (this as AdminProductDetailLoaded).product;
    }
    return null;
  }

  bool get isCreating => this is AdminProductCreating;
  bool get isCreateSuccess => this is AdminProductCreateSuccess;
  bool get isCreateError => this is AdminProductCreateError;

  Product? get createdProduct {
    if (this is AdminProductCreateSuccess) {
      return (this as AdminProductCreateSuccess).product;
    }
    return null;
  }

  String? get createErrorMessage {
    if (this is AdminProductCreateError) {
      return (this as AdminProductCreateError).message;
    }
    return null;
  }

  bool get isUpdating => this is AdminProductUpdating;
  bool get isUpdateSuccess => this is AdminProductUpdateSuccess;
  bool get isUpdateError => this is AdminProductUpdateError;

  Product? get updatedProduct {
    if (this is AdminProductUpdateSuccess) {
      return (this as AdminProductUpdateSuccess).product;
    }
    return null;
  }

  String? get updateErrorMessage {
    if (this is AdminProductUpdateError) {
      return (this as AdminProductUpdateError).message;
    }
    return null;
  }

  bool get isRestoring => this is AdminProductRestoring;
  bool get isRestored => this is AdminProductRestored;
}
