// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_product_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AdminProductState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )
    loaded,
    required TResult Function(String message) error,
    required TResult Function(String productId) deleting,
    required TResult Function(String productId) deleted,
    required TResult Function() detailLoading,
    required TResult Function(Product product) detailLoaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult? Function(String message)? error,
    TResult? Function(String productId)? deleting,
    TResult? Function(String productId)? deleted,
    TResult? Function()? detailLoading,
    TResult? Function(Product product)? detailLoaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult Function(String message)? error,
    TResult Function(String productId)? deleting,
    TResult Function(String productId)? deleted,
    TResult Function()? detailLoading,
    TResult Function(Product product)? detailLoaded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminProductInitial value) initial,
    required TResult Function(AdminProductLoading value) loading,
    required TResult Function(AdminProductLoaded value) loaded,
    required TResult Function(AdminProductError value) error,
    required TResult Function(AdminProductDeleting value) deleting,
    required TResult Function(AdminProductDeleted value) deleted,
    required TResult Function(AdminProductDetailLoading value) detailLoading,
    required TResult Function(AdminProductDetailLoaded value) detailLoaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminProductInitial value)? initial,
    TResult? Function(AdminProductLoading value)? loading,
    TResult? Function(AdminProductLoaded value)? loaded,
    TResult? Function(AdminProductError value)? error,
    TResult? Function(AdminProductDeleting value)? deleting,
    TResult? Function(AdminProductDeleted value)? deleted,
    TResult? Function(AdminProductDetailLoading value)? detailLoading,
    TResult? Function(AdminProductDetailLoaded value)? detailLoaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminProductInitial value)? initial,
    TResult Function(AdminProductLoading value)? loading,
    TResult Function(AdminProductLoaded value)? loaded,
    TResult Function(AdminProductError value)? error,
    TResult Function(AdminProductDeleting value)? deleting,
    TResult Function(AdminProductDeleted value)? deleted,
    TResult Function(AdminProductDetailLoading value)? detailLoading,
    TResult Function(AdminProductDetailLoaded value)? detailLoaded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminProductStateCopyWith<$Res> {
  factory $AdminProductStateCopyWith(
    AdminProductState value,
    $Res Function(AdminProductState) then,
  ) = _$AdminProductStateCopyWithImpl<$Res, AdminProductState>;
}

/// @nodoc
class _$AdminProductStateCopyWithImpl<$Res, $Val extends AdminProductState>
    implements $AdminProductStateCopyWith<$Res> {
  _$AdminProductStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AdminProductInitialImplCopyWith<$Res> {
  factory _$$AdminProductInitialImplCopyWith(
    _$AdminProductInitialImpl value,
    $Res Function(_$AdminProductInitialImpl) then,
  ) = __$$AdminProductInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AdminProductInitialImplCopyWithImpl<$Res>
    extends _$AdminProductStateCopyWithImpl<$Res, _$AdminProductInitialImpl>
    implements _$$AdminProductInitialImplCopyWith<$Res> {
  __$$AdminProductInitialImplCopyWithImpl(
    _$AdminProductInitialImpl _value,
    $Res Function(_$AdminProductInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AdminProductInitialImpl extends AdminProductInitial {
  const _$AdminProductInitialImpl() : super._();

  @override
  String toString() {
    return 'AdminProductState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminProductInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )
    loaded,
    required TResult Function(String message) error,
    required TResult Function(String productId) deleting,
    required TResult Function(String productId) deleted,
    required TResult Function() detailLoading,
    required TResult Function(Product product) detailLoaded,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult? Function(String message)? error,
    TResult? Function(String productId)? deleting,
    TResult? Function(String productId)? deleted,
    TResult? Function()? detailLoading,
    TResult? Function(Product product)? detailLoaded,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult Function(String message)? error,
    TResult Function(String productId)? deleting,
    TResult Function(String productId)? deleted,
    TResult Function()? detailLoading,
    TResult Function(Product product)? detailLoaded,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminProductInitial value) initial,
    required TResult Function(AdminProductLoading value) loading,
    required TResult Function(AdminProductLoaded value) loaded,
    required TResult Function(AdminProductError value) error,
    required TResult Function(AdminProductDeleting value) deleting,
    required TResult Function(AdminProductDeleted value) deleted,
    required TResult Function(AdminProductDetailLoading value) detailLoading,
    required TResult Function(AdminProductDetailLoaded value) detailLoaded,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminProductInitial value)? initial,
    TResult? Function(AdminProductLoading value)? loading,
    TResult? Function(AdminProductLoaded value)? loaded,
    TResult? Function(AdminProductError value)? error,
    TResult? Function(AdminProductDeleting value)? deleting,
    TResult? Function(AdminProductDeleted value)? deleted,
    TResult? Function(AdminProductDetailLoading value)? detailLoading,
    TResult? Function(AdminProductDetailLoaded value)? detailLoaded,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminProductInitial value)? initial,
    TResult Function(AdminProductLoading value)? loading,
    TResult Function(AdminProductLoaded value)? loaded,
    TResult Function(AdminProductError value)? error,
    TResult Function(AdminProductDeleting value)? deleting,
    TResult Function(AdminProductDeleted value)? deleted,
    TResult Function(AdminProductDetailLoading value)? detailLoading,
    TResult Function(AdminProductDetailLoaded value)? detailLoaded,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class AdminProductInitial extends AdminProductState {
  const factory AdminProductInitial() = _$AdminProductInitialImpl;
  const AdminProductInitial._() : super._();
}

/// @nodoc
abstract class _$$AdminProductLoadingImplCopyWith<$Res> {
  factory _$$AdminProductLoadingImplCopyWith(
    _$AdminProductLoadingImpl value,
    $Res Function(_$AdminProductLoadingImpl) then,
  ) = __$$AdminProductLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AdminProductLoadingImplCopyWithImpl<$Res>
    extends _$AdminProductStateCopyWithImpl<$Res, _$AdminProductLoadingImpl>
    implements _$$AdminProductLoadingImplCopyWith<$Res> {
  __$$AdminProductLoadingImplCopyWithImpl(
    _$AdminProductLoadingImpl _value,
    $Res Function(_$AdminProductLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AdminProductLoadingImpl extends AdminProductLoading {
  const _$AdminProductLoadingImpl() : super._();

  @override
  String toString() {
    return 'AdminProductState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminProductLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )
    loaded,
    required TResult Function(String message) error,
    required TResult Function(String productId) deleting,
    required TResult Function(String productId) deleted,
    required TResult Function() detailLoading,
    required TResult Function(Product product) detailLoaded,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult? Function(String message)? error,
    TResult? Function(String productId)? deleting,
    TResult? Function(String productId)? deleted,
    TResult? Function()? detailLoading,
    TResult? Function(Product product)? detailLoaded,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult Function(String message)? error,
    TResult Function(String productId)? deleting,
    TResult Function(String productId)? deleted,
    TResult Function()? detailLoading,
    TResult Function(Product product)? detailLoaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminProductInitial value) initial,
    required TResult Function(AdminProductLoading value) loading,
    required TResult Function(AdminProductLoaded value) loaded,
    required TResult Function(AdminProductError value) error,
    required TResult Function(AdminProductDeleting value) deleting,
    required TResult Function(AdminProductDeleted value) deleted,
    required TResult Function(AdminProductDetailLoading value) detailLoading,
    required TResult Function(AdminProductDetailLoaded value) detailLoaded,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminProductInitial value)? initial,
    TResult? Function(AdminProductLoading value)? loading,
    TResult? Function(AdminProductLoaded value)? loaded,
    TResult? Function(AdminProductError value)? error,
    TResult? Function(AdminProductDeleting value)? deleting,
    TResult? Function(AdminProductDeleted value)? deleted,
    TResult? Function(AdminProductDetailLoading value)? detailLoading,
    TResult? Function(AdminProductDetailLoaded value)? detailLoaded,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminProductInitial value)? initial,
    TResult Function(AdminProductLoading value)? loading,
    TResult Function(AdminProductLoaded value)? loaded,
    TResult Function(AdminProductError value)? error,
    TResult Function(AdminProductDeleting value)? deleting,
    TResult Function(AdminProductDeleted value)? deleted,
    TResult Function(AdminProductDetailLoading value)? detailLoading,
    TResult Function(AdminProductDetailLoaded value)? detailLoaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class AdminProductLoading extends AdminProductState {
  const factory AdminProductLoading() = _$AdminProductLoadingImpl;
  const AdminProductLoading._() : super._();
}

/// @nodoc
abstract class _$$AdminProductLoadedImplCopyWith<$Res> {
  factory _$$AdminProductLoadedImplCopyWith(
    _$AdminProductLoadedImpl value,
    $Res Function(_$AdminProductLoadedImpl) then,
  ) = __$$AdminProductLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<Product> products,
    AdminProductFilter filter,
    String? selectedBrand,
    StockStatus stockStatus,
    int currentPage,
    int totalPages,
    bool hasMore,
    int totalCount,
    bool isLoadingMore,
    bool isRefreshing,
  });
}

/// @nodoc
class __$$AdminProductLoadedImplCopyWithImpl<$Res>
    extends _$AdminProductStateCopyWithImpl<$Res, _$AdminProductLoadedImpl>
    implements _$$AdminProductLoadedImplCopyWith<$Res> {
  __$$AdminProductLoadedImplCopyWithImpl(
    _$AdminProductLoadedImpl _value,
    $Res Function(_$AdminProductLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? filter = null,
    Object? selectedBrand = freezed,
    Object? stockStatus = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? hasMore = null,
    Object? totalCount = null,
    Object? isLoadingMore = null,
    Object? isRefreshing = null,
  }) {
    return _then(
      _$AdminProductLoadedImpl(
        products: null == products
            ? _value._products
            : products // ignore: cast_nullable_to_non_nullable
                  as List<Product>,
        filter: null == filter
            ? _value.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as AdminProductFilter,
        selectedBrand: freezed == selectedBrand
            ? _value.selectedBrand
            : selectedBrand // ignore: cast_nullable_to_non_nullable
                  as String?,
        stockStatus: null == stockStatus
            ? _value.stockStatus
            : stockStatus // ignore: cast_nullable_to_non_nullable
                  as StockStatus,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isLoadingMore: null == isLoadingMore
            ? _value.isLoadingMore
            : isLoadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        isRefreshing: null == isRefreshing
            ? _value.isRefreshing
            : isRefreshing // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AdminProductLoadedImpl extends AdminProductLoaded {
  const _$AdminProductLoadedImpl({
    required final List<Product> products,
    required this.filter,
    required this.selectedBrand,
    required this.stockStatus,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.totalCount,
    this.isLoadingMore = false,
    this.isRefreshing = false,
  }) : _products = products,
       super._();

  final List<Product> _products;
  @override
  List<Product> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  final AdminProductFilter filter;
  @override
  final String? selectedBrand;
  @override
  final StockStatus stockStatus;
  @override
  final int currentPage;
  @override
  final int totalPages;
  @override
  final bool hasMore;
  @override
  final int totalCount;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final bool isRefreshing;

  @override
  String toString() {
    return 'AdminProductState.loaded(products: $products, filter: $filter, selectedBrand: $selectedBrand, stockStatus: $stockStatus, currentPage: $currentPage, totalPages: $totalPages, hasMore: $hasMore, totalCount: $totalCount, isLoadingMore: $isLoadingMore, isRefreshing: $isRefreshing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminProductLoadedImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.selectedBrand, selectedBrand) ||
                other.selectedBrand == selectedBrand) &&
            (identical(other.stockStatus, stockStatus) ||
                other.stockStatus == stockStatus) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_products),
    filter,
    selectedBrand,
    stockStatus,
    currentPage,
    totalPages,
    hasMore,
    totalCount,
    isLoadingMore,
    isRefreshing,
  );

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminProductLoadedImplCopyWith<_$AdminProductLoadedImpl> get copyWith =>
      __$$AdminProductLoadedImplCopyWithImpl<_$AdminProductLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )
    loaded,
    required TResult Function(String message) error,
    required TResult Function(String productId) deleting,
    required TResult Function(String productId) deleted,
    required TResult Function() detailLoading,
    required TResult Function(Product product) detailLoaded,
  }) {
    return loaded(
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
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult? Function(String message)? error,
    TResult? Function(String productId)? deleting,
    TResult? Function(String productId)? deleted,
    TResult? Function()? detailLoading,
    TResult? Function(Product product)? detailLoaded,
  }) {
    return loaded?.call(
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
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult Function(String message)? error,
    TResult Function(String productId)? deleting,
    TResult Function(String productId)? deleted,
    TResult Function()? detailLoading,
    TResult Function(Product product)? detailLoaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
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
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminProductInitial value) initial,
    required TResult Function(AdminProductLoading value) loading,
    required TResult Function(AdminProductLoaded value) loaded,
    required TResult Function(AdminProductError value) error,
    required TResult Function(AdminProductDeleting value) deleting,
    required TResult Function(AdminProductDeleted value) deleted,
    required TResult Function(AdminProductDetailLoading value) detailLoading,
    required TResult Function(AdminProductDetailLoaded value) detailLoaded,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminProductInitial value)? initial,
    TResult? Function(AdminProductLoading value)? loading,
    TResult? Function(AdminProductLoaded value)? loaded,
    TResult? Function(AdminProductError value)? error,
    TResult? Function(AdminProductDeleting value)? deleting,
    TResult? Function(AdminProductDeleted value)? deleted,
    TResult? Function(AdminProductDetailLoading value)? detailLoading,
    TResult? Function(AdminProductDetailLoaded value)? detailLoaded,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminProductInitial value)? initial,
    TResult Function(AdminProductLoading value)? loading,
    TResult Function(AdminProductLoaded value)? loaded,
    TResult Function(AdminProductError value)? error,
    TResult Function(AdminProductDeleting value)? deleting,
    TResult Function(AdminProductDeleted value)? deleted,
    TResult Function(AdminProductDetailLoading value)? detailLoading,
    TResult Function(AdminProductDetailLoaded value)? detailLoaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class AdminProductLoaded extends AdminProductState {
  const factory AdminProductLoaded({
    required final List<Product> products,
    required final AdminProductFilter filter,
    required final String? selectedBrand,
    required final StockStatus stockStatus,
    required final int currentPage,
    required final int totalPages,
    required final bool hasMore,
    required final int totalCount,
    final bool isLoadingMore,
    final bool isRefreshing,
  }) = _$AdminProductLoadedImpl;
  const AdminProductLoaded._() : super._();

  List<Product> get products;
  AdminProductFilter get filter;
  String? get selectedBrand;
  StockStatus get stockStatus;
  int get currentPage;
  int get totalPages;
  bool get hasMore;
  int get totalCount;
  bool get isLoadingMore;
  bool get isRefreshing;

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminProductLoadedImplCopyWith<_$AdminProductLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AdminProductErrorImplCopyWith<$Res> {
  factory _$$AdminProductErrorImplCopyWith(
    _$AdminProductErrorImpl value,
    $Res Function(_$AdminProductErrorImpl) then,
  ) = __$$AdminProductErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AdminProductErrorImplCopyWithImpl<$Res>
    extends _$AdminProductStateCopyWithImpl<$Res, _$AdminProductErrorImpl>
    implements _$$AdminProductErrorImplCopyWith<$Res> {
  __$$AdminProductErrorImplCopyWithImpl(
    _$AdminProductErrorImpl _value,
    $Res Function(_$AdminProductErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$AdminProductErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AdminProductErrorImpl extends AdminProductError {
  const _$AdminProductErrorImpl({required this.message}) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'AdminProductState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminProductErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminProductErrorImplCopyWith<_$AdminProductErrorImpl> get copyWith =>
      __$$AdminProductErrorImplCopyWithImpl<_$AdminProductErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )
    loaded,
    required TResult Function(String message) error,
    required TResult Function(String productId) deleting,
    required TResult Function(String productId) deleted,
    required TResult Function() detailLoading,
    required TResult Function(Product product) detailLoaded,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult? Function(String message)? error,
    TResult? Function(String productId)? deleting,
    TResult? Function(String productId)? deleted,
    TResult? Function()? detailLoading,
    TResult? Function(Product product)? detailLoaded,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult Function(String message)? error,
    TResult Function(String productId)? deleting,
    TResult Function(String productId)? deleted,
    TResult Function()? detailLoading,
    TResult Function(Product product)? detailLoaded,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminProductInitial value) initial,
    required TResult Function(AdminProductLoading value) loading,
    required TResult Function(AdminProductLoaded value) loaded,
    required TResult Function(AdminProductError value) error,
    required TResult Function(AdminProductDeleting value) deleting,
    required TResult Function(AdminProductDeleted value) deleted,
    required TResult Function(AdminProductDetailLoading value) detailLoading,
    required TResult Function(AdminProductDetailLoaded value) detailLoaded,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminProductInitial value)? initial,
    TResult? Function(AdminProductLoading value)? loading,
    TResult? Function(AdminProductLoaded value)? loaded,
    TResult? Function(AdminProductError value)? error,
    TResult? Function(AdminProductDeleting value)? deleting,
    TResult? Function(AdminProductDeleted value)? deleted,
    TResult? Function(AdminProductDetailLoading value)? detailLoading,
    TResult? Function(AdminProductDetailLoaded value)? detailLoaded,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminProductInitial value)? initial,
    TResult Function(AdminProductLoading value)? loading,
    TResult Function(AdminProductLoaded value)? loaded,
    TResult Function(AdminProductError value)? error,
    TResult Function(AdminProductDeleting value)? deleting,
    TResult Function(AdminProductDeleted value)? deleted,
    TResult Function(AdminProductDetailLoading value)? detailLoading,
    TResult Function(AdminProductDetailLoaded value)? detailLoaded,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AdminProductError extends AdminProductState {
  const factory AdminProductError({required final String message}) =
      _$AdminProductErrorImpl;
  const AdminProductError._() : super._();

  String get message;

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminProductErrorImplCopyWith<_$AdminProductErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AdminProductDeletingImplCopyWith<$Res> {
  factory _$$AdminProductDeletingImplCopyWith(
    _$AdminProductDeletingImpl value,
    $Res Function(_$AdminProductDeletingImpl) then,
  ) = __$$AdminProductDeletingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String productId});
}

/// @nodoc
class __$$AdminProductDeletingImplCopyWithImpl<$Res>
    extends _$AdminProductStateCopyWithImpl<$Res, _$AdminProductDeletingImpl>
    implements _$$AdminProductDeletingImplCopyWith<$Res> {
  __$$AdminProductDeletingImplCopyWithImpl(
    _$AdminProductDeletingImpl _value,
    $Res Function(_$AdminProductDeletingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productId = null}) {
    return _then(
      _$AdminProductDeletingImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AdminProductDeletingImpl extends AdminProductDeleting {
  const _$AdminProductDeletingImpl({required this.productId}) : super._();

  @override
  final String productId;

  @override
  String toString() {
    return 'AdminProductState.deleting(productId: $productId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminProductDeletingImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, productId);

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminProductDeletingImplCopyWith<_$AdminProductDeletingImpl>
  get copyWith =>
      __$$AdminProductDeletingImplCopyWithImpl<_$AdminProductDeletingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )
    loaded,
    required TResult Function(String message) error,
    required TResult Function(String productId) deleting,
    required TResult Function(String productId) deleted,
    required TResult Function() detailLoading,
    required TResult Function(Product product) detailLoaded,
  }) {
    return deleting(productId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult? Function(String message)? error,
    TResult? Function(String productId)? deleting,
    TResult? Function(String productId)? deleted,
    TResult? Function()? detailLoading,
    TResult? Function(Product product)? detailLoaded,
  }) {
    return deleting?.call(productId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult Function(String message)? error,
    TResult Function(String productId)? deleting,
    TResult Function(String productId)? deleted,
    TResult Function()? detailLoading,
    TResult Function(Product product)? detailLoaded,
    required TResult orElse(),
  }) {
    if (deleting != null) {
      return deleting(productId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminProductInitial value) initial,
    required TResult Function(AdminProductLoading value) loading,
    required TResult Function(AdminProductLoaded value) loaded,
    required TResult Function(AdminProductError value) error,
    required TResult Function(AdminProductDeleting value) deleting,
    required TResult Function(AdminProductDeleted value) deleted,
    required TResult Function(AdminProductDetailLoading value) detailLoading,
    required TResult Function(AdminProductDetailLoaded value) detailLoaded,
  }) {
    return deleting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminProductInitial value)? initial,
    TResult? Function(AdminProductLoading value)? loading,
    TResult? Function(AdminProductLoaded value)? loaded,
    TResult? Function(AdminProductError value)? error,
    TResult? Function(AdminProductDeleting value)? deleting,
    TResult? Function(AdminProductDeleted value)? deleted,
    TResult? Function(AdminProductDetailLoading value)? detailLoading,
    TResult? Function(AdminProductDetailLoaded value)? detailLoaded,
  }) {
    return deleting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminProductInitial value)? initial,
    TResult Function(AdminProductLoading value)? loading,
    TResult Function(AdminProductLoaded value)? loaded,
    TResult Function(AdminProductError value)? error,
    TResult Function(AdminProductDeleting value)? deleting,
    TResult Function(AdminProductDeleted value)? deleted,
    TResult Function(AdminProductDetailLoading value)? detailLoading,
    TResult Function(AdminProductDetailLoaded value)? detailLoaded,
    required TResult orElse(),
  }) {
    if (deleting != null) {
      return deleting(this);
    }
    return orElse();
  }
}

abstract class AdminProductDeleting extends AdminProductState {
  const factory AdminProductDeleting({required final String productId}) =
      _$AdminProductDeletingImpl;
  const AdminProductDeleting._() : super._();

  String get productId;

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminProductDeletingImplCopyWith<_$AdminProductDeletingImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AdminProductDeletedImplCopyWith<$Res> {
  factory _$$AdminProductDeletedImplCopyWith(
    _$AdminProductDeletedImpl value,
    $Res Function(_$AdminProductDeletedImpl) then,
  ) = __$$AdminProductDeletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String productId});
}

/// @nodoc
class __$$AdminProductDeletedImplCopyWithImpl<$Res>
    extends _$AdminProductStateCopyWithImpl<$Res, _$AdminProductDeletedImpl>
    implements _$$AdminProductDeletedImplCopyWith<$Res> {
  __$$AdminProductDeletedImplCopyWithImpl(
    _$AdminProductDeletedImpl _value,
    $Res Function(_$AdminProductDeletedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productId = null}) {
    return _then(
      _$AdminProductDeletedImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AdminProductDeletedImpl extends AdminProductDeleted {
  const _$AdminProductDeletedImpl({required this.productId}) : super._();

  @override
  final String productId;

  @override
  String toString() {
    return 'AdminProductState.deleted(productId: $productId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminProductDeletedImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, productId);

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminProductDeletedImplCopyWith<_$AdminProductDeletedImpl> get copyWith =>
      __$$AdminProductDeletedImplCopyWithImpl<_$AdminProductDeletedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )
    loaded,
    required TResult Function(String message) error,
    required TResult Function(String productId) deleting,
    required TResult Function(String productId) deleted,
    required TResult Function() detailLoading,
    required TResult Function(Product product) detailLoaded,
  }) {
    return deleted(productId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult? Function(String message)? error,
    TResult? Function(String productId)? deleting,
    TResult? Function(String productId)? deleted,
    TResult? Function()? detailLoading,
    TResult? Function(Product product)? detailLoaded,
  }) {
    return deleted?.call(productId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult Function(String message)? error,
    TResult Function(String productId)? deleting,
    TResult Function(String productId)? deleted,
    TResult Function()? detailLoading,
    TResult Function(Product product)? detailLoaded,
    required TResult orElse(),
  }) {
    if (deleted != null) {
      return deleted(productId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminProductInitial value) initial,
    required TResult Function(AdminProductLoading value) loading,
    required TResult Function(AdminProductLoaded value) loaded,
    required TResult Function(AdminProductError value) error,
    required TResult Function(AdminProductDeleting value) deleting,
    required TResult Function(AdminProductDeleted value) deleted,
    required TResult Function(AdminProductDetailLoading value) detailLoading,
    required TResult Function(AdminProductDetailLoaded value) detailLoaded,
  }) {
    return deleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminProductInitial value)? initial,
    TResult? Function(AdminProductLoading value)? loading,
    TResult? Function(AdminProductLoaded value)? loaded,
    TResult? Function(AdminProductError value)? error,
    TResult? Function(AdminProductDeleting value)? deleting,
    TResult? Function(AdminProductDeleted value)? deleted,
    TResult? Function(AdminProductDetailLoading value)? detailLoading,
    TResult? Function(AdminProductDetailLoaded value)? detailLoaded,
  }) {
    return deleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminProductInitial value)? initial,
    TResult Function(AdminProductLoading value)? loading,
    TResult Function(AdminProductLoaded value)? loaded,
    TResult Function(AdminProductError value)? error,
    TResult Function(AdminProductDeleting value)? deleting,
    TResult Function(AdminProductDeleted value)? deleted,
    TResult Function(AdminProductDetailLoading value)? detailLoading,
    TResult Function(AdminProductDetailLoaded value)? detailLoaded,
    required TResult orElse(),
  }) {
    if (deleted != null) {
      return deleted(this);
    }
    return orElse();
  }
}

abstract class AdminProductDeleted extends AdminProductState {
  const factory AdminProductDeleted({required final String productId}) =
      _$AdminProductDeletedImpl;
  const AdminProductDeleted._() : super._();

  String get productId;

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminProductDeletedImplCopyWith<_$AdminProductDeletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AdminProductDetailLoadingImplCopyWith<$Res> {
  factory _$$AdminProductDetailLoadingImplCopyWith(
    _$AdminProductDetailLoadingImpl value,
    $Res Function(_$AdminProductDetailLoadingImpl) then,
  ) = __$$AdminProductDetailLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AdminProductDetailLoadingImplCopyWithImpl<$Res>
    extends
        _$AdminProductStateCopyWithImpl<$Res, _$AdminProductDetailLoadingImpl>
    implements _$$AdminProductDetailLoadingImplCopyWith<$Res> {
  __$$AdminProductDetailLoadingImplCopyWithImpl(
    _$AdminProductDetailLoadingImpl _value,
    $Res Function(_$AdminProductDetailLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AdminProductDetailLoadingImpl extends AdminProductDetailLoading {
  const _$AdminProductDetailLoadingImpl() : super._();

  @override
  String toString() {
    return 'AdminProductState.detailLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminProductDetailLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )
    loaded,
    required TResult Function(String message) error,
    required TResult Function(String productId) deleting,
    required TResult Function(String productId) deleted,
    required TResult Function() detailLoading,
    required TResult Function(Product product) detailLoaded,
  }) {
    return detailLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult? Function(String message)? error,
    TResult? Function(String productId)? deleting,
    TResult? Function(String productId)? deleted,
    TResult? Function()? detailLoading,
    TResult? Function(Product product)? detailLoaded,
  }) {
    return detailLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult Function(String message)? error,
    TResult Function(String productId)? deleting,
    TResult Function(String productId)? deleted,
    TResult Function()? detailLoading,
    TResult Function(Product product)? detailLoaded,
    required TResult orElse(),
  }) {
    if (detailLoading != null) {
      return detailLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminProductInitial value) initial,
    required TResult Function(AdminProductLoading value) loading,
    required TResult Function(AdminProductLoaded value) loaded,
    required TResult Function(AdminProductError value) error,
    required TResult Function(AdminProductDeleting value) deleting,
    required TResult Function(AdminProductDeleted value) deleted,
    required TResult Function(AdminProductDetailLoading value) detailLoading,
    required TResult Function(AdminProductDetailLoaded value) detailLoaded,
  }) {
    return detailLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminProductInitial value)? initial,
    TResult? Function(AdminProductLoading value)? loading,
    TResult? Function(AdminProductLoaded value)? loaded,
    TResult? Function(AdminProductError value)? error,
    TResult? Function(AdminProductDeleting value)? deleting,
    TResult? Function(AdminProductDeleted value)? deleted,
    TResult? Function(AdminProductDetailLoading value)? detailLoading,
    TResult? Function(AdminProductDetailLoaded value)? detailLoaded,
  }) {
    return detailLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminProductInitial value)? initial,
    TResult Function(AdminProductLoading value)? loading,
    TResult Function(AdminProductLoaded value)? loaded,
    TResult Function(AdminProductError value)? error,
    TResult Function(AdminProductDeleting value)? deleting,
    TResult Function(AdminProductDeleted value)? deleted,
    TResult Function(AdminProductDetailLoading value)? detailLoading,
    TResult Function(AdminProductDetailLoaded value)? detailLoaded,
    required TResult orElse(),
  }) {
    if (detailLoading != null) {
      return detailLoading(this);
    }
    return orElse();
  }
}

abstract class AdminProductDetailLoading extends AdminProductState {
  const factory AdminProductDetailLoading() = _$AdminProductDetailLoadingImpl;
  const AdminProductDetailLoading._() : super._();
}

/// @nodoc
abstract class _$$AdminProductDetailLoadedImplCopyWith<$Res> {
  factory _$$AdminProductDetailLoadedImplCopyWith(
    _$AdminProductDetailLoadedImpl value,
    $Res Function(_$AdminProductDetailLoadedImpl) then,
  ) = __$$AdminProductDetailLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Product product});

  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class __$$AdminProductDetailLoadedImplCopyWithImpl<$Res>
    extends
        _$AdminProductStateCopyWithImpl<$Res, _$AdminProductDetailLoadedImpl>
    implements _$$AdminProductDetailLoadedImplCopyWith<$Res> {
  __$$AdminProductDetailLoadedImplCopyWithImpl(
    _$AdminProductDetailLoadedImpl _value,
    $Res Function(_$AdminProductDetailLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? product = null}) {
    return _then(
      _$AdminProductDetailLoadedImpl(
        product: null == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as Product,
      ),
    );
  }

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res> get product {
    return $ProductCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value));
    });
  }
}

/// @nodoc

class _$AdminProductDetailLoadedImpl extends AdminProductDetailLoaded {
  const _$AdminProductDetailLoadedImpl({required this.product}) : super._();

  @override
  final Product product;

  @override
  String toString() {
    return 'AdminProductState.detailLoaded(product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminProductDetailLoadedImpl &&
            (identical(other.product, product) || other.product == product));
  }

  @override
  int get hashCode => Object.hash(runtimeType, product);

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminProductDetailLoadedImplCopyWith<_$AdminProductDetailLoadedImpl>
  get copyWith =>
      __$$AdminProductDetailLoadedImplCopyWithImpl<
        _$AdminProductDetailLoadedImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )
    loaded,
    required TResult Function(String message) error,
    required TResult Function(String productId) deleting,
    required TResult Function(String productId) deleted,
    required TResult Function() detailLoading,
    required TResult Function(Product product) detailLoaded,
  }) {
    return detailLoaded(product);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult? Function(String message)? error,
    TResult? Function(String productId)? deleting,
    TResult? Function(String productId)? deleted,
    TResult? Function()? detailLoading,
    TResult? Function(Product product)? detailLoaded,
  }) {
    return detailLoaded?.call(product);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      AdminProductFilter filter,
      String? selectedBrand,
      StockStatus stockStatus,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
      bool isRefreshing,
    )?
    loaded,
    TResult Function(String message)? error,
    TResult Function(String productId)? deleting,
    TResult Function(String productId)? deleted,
    TResult Function()? detailLoading,
    TResult Function(Product product)? detailLoaded,
    required TResult orElse(),
  }) {
    if (detailLoaded != null) {
      return detailLoaded(product);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminProductInitial value) initial,
    required TResult Function(AdminProductLoading value) loading,
    required TResult Function(AdminProductLoaded value) loaded,
    required TResult Function(AdminProductError value) error,
    required TResult Function(AdminProductDeleting value) deleting,
    required TResult Function(AdminProductDeleted value) deleted,
    required TResult Function(AdminProductDetailLoading value) detailLoading,
    required TResult Function(AdminProductDetailLoaded value) detailLoaded,
  }) {
    return detailLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminProductInitial value)? initial,
    TResult? Function(AdminProductLoading value)? loading,
    TResult? Function(AdminProductLoaded value)? loaded,
    TResult? Function(AdminProductError value)? error,
    TResult? Function(AdminProductDeleting value)? deleting,
    TResult? Function(AdminProductDeleted value)? deleted,
    TResult? Function(AdminProductDetailLoading value)? detailLoading,
    TResult? Function(AdminProductDetailLoaded value)? detailLoaded,
  }) {
    return detailLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminProductInitial value)? initial,
    TResult Function(AdminProductLoading value)? loading,
    TResult Function(AdminProductLoaded value)? loaded,
    TResult Function(AdminProductError value)? error,
    TResult Function(AdminProductDeleting value)? deleting,
    TResult Function(AdminProductDeleted value)? deleted,
    TResult Function(AdminProductDetailLoading value)? detailLoading,
    TResult Function(AdminProductDetailLoaded value)? detailLoaded,
    required TResult orElse(),
  }) {
    if (detailLoaded != null) {
      return detailLoaded(this);
    }
    return orElse();
  }
}

abstract class AdminProductDetailLoaded extends AdminProductState {
  const factory AdminProductDetailLoaded({required final Product product}) =
      _$AdminProductDetailLoadedImpl;
  const AdminProductDetailLoaded._() : super._();

  Product get product;

  /// Create a copy of AdminProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminProductDetailLoadedImplCopyWith<_$AdminProductDetailLoadedImpl>
  get copyWith => throw _privateConstructorUsedError;
}
