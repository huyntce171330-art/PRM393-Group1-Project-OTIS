// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )
    loaded,
    required TResult Function(Product product) detailLoaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )?
    loaded,
    TResult? Function(Product product)? detailLoaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )?
    loaded,
    TResult Function(Product product)? detailLoaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProductInitial value) initial,
    required TResult Function(ProductLoading value) loading,
    required TResult Function(ProductLoaded value) loaded,
    required TResult Function(ProductDetailLoaded value) detailLoaded,
    required TResult Function(ProductError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductInitial value)? initial,
    TResult? Function(ProductLoading value)? loading,
    TResult? Function(ProductLoaded value)? loaded,
    TResult? Function(ProductDetailLoaded value)? detailLoaded,
    TResult? Function(ProductError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductInitial value)? initial,
    TResult Function(ProductLoading value)? loading,
    TResult Function(ProductLoaded value)? loaded,
    TResult Function(ProductDetailLoaded value)? detailLoaded,
    TResult Function(ProductError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductStateCopyWith<$Res> {
  factory $ProductStateCopyWith(
    ProductState value,
    $Res Function(ProductState) then,
  ) = _$ProductStateCopyWithImpl<$Res, ProductState>;
}

/// @nodoc
class _$ProductStateCopyWithImpl<$Res, $Val extends ProductState>
    implements $ProductStateCopyWith<$Res> {
  _$ProductStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ProductInitialImplCopyWith<$Res> {
  factory _$$ProductInitialImplCopyWith(
    _$ProductInitialImpl value,
    $Res Function(_$ProductInitialImpl) then,
  ) = __$$ProductInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProductInitialImplCopyWithImpl<$Res>
    extends _$ProductStateCopyWithImpl<$Res, _$ProductInitialImpl>
    implements _$$ProductInitialImplCopyWith<$Res> {
  __$$ProductInitialImplCopyWithImpl(
    _$ProductInitialImpl _value,
    $Res Function(_$ProductInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProductInitialImpl extends ProductInitial {
  const _$ProductInitialImpl() : super._();

  @override
  String toString() {
    return 'ProductState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProductInitialImpl);
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
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )
    loaded,
    required TResult Function(Product product) detailLoaded,
    required TResult Function(String message) error,
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
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )?
    loaded,
    TResult? Function(Product product)? detailLoaded,
    TResult? Function(String message)? error,
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
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )?
    loaded,
    TResult Function(Product product)? detailLoaded,
    TResult Function(String message)? error,
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
    required TResult Function(ProductInitial value) initial,
    required TResult Function(ProductLoading value) loading,
    required TResult Function(ProductLoaded value) loaded,
    required TResult Function(ProductDetailLoaded value) detailLoaded,
    required TResult Function(ProductError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductInitial value)? initial,
    TResult? Function(ProductLoading value)? loading,
    TResult? Function(ProductLoaded value)? loaded,
    TResult? Function(ProductDetailLoaded value)? detailLoaded,
    TResult? Function(ProductError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductInitial value)? initial,
    TResult Function(ProductLoading value)? loading,
    TResult Function(ProductLoaded value)? loaded,
    TResult Function(ProductDetailLoaded value)? detailLoaded,
    TResult Function(ProductError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ProductInitial extends ProductState {
  const factory ProductInitial() = _$ProductInitialImpl;
  const ProductInitial._() : super._();
}

/// @nodoc
abstract class _$$ProductLoadingImplCopyWith<$Res> {
  factory _$$ProductLoadingImplCopyWith(
    _$ProductLoadingImpl value,
    $Res Function(_$ProductLoadingImpl) then,
  ) = __$$ProductLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProductLoadingImplCopyWithImpl<$Res>
    extends _$ProductStateCopyWithImpl<$Res, _$ProductLoadingImpl>
    implements _$$ProductLoadingImplCopyWith<$Res> {
  __$$ProductLoadingImplCopyWithImpl(
    _$ProductLoadingImpl _value,
    $Res Function(_$ProductLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProductLoadingImpl extends ProductLoading {
  const _$ProductLoadingImpl() : super._();

  @override
  String toString() {
    return 'ProductState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProductLoadingImpl);
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
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )
    loaded,
    required TResult Function(Product product) detailLoaded,
    required TResult Function(String message) error,
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
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )?
    loaded,
    TResult? Function(Product product)? detailLoaded,
    TResult? Function(String message)? error,
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
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )?
    loaded,
    TResult Function(Product product)? detailLoaded,
    TResult Function(String message)? error,
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
    required TResult Function(ProductInitial value) initial,
    required TResult Function(ProductLoading value) loading,
    required TResult Function(ProductLoaded value) loaded,
    required TResult Function(ProductDetailLoaded value) detailLoaded,
    required TResult Function(ProductError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductInitial value)? initial,
    TResult? Function(ProductLoading value)? loading,
    TResult? Function(ProductLoaded value)? loaded,
    TResult? Function(ProductDetailLoaded value)? detailLoaded,
    TResult? Function(ProductError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductInitial value)? initial,
    TResult Function(ProductLoading value)? loading,
    TResult Function(ProductLoaded value)? loaded,
    TResult Function(ProductDetailLoaded value)? detailLoaded,
    TResult Function(ProductError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ProductLoading extends ProductState {
  const factory ProductLoading() = _$ProductLoadingImpl;
  const ProductLoading._() : super._();
}

/// @nodoc
abstract class _$$ProductLoadedImplCopyWith<$Res> {
  factory _$$ProductLoadedImplCopyWith(
    _$ProductLoadedImpl value,
    $Res Function(_$ProductLoadedImpl) then,
  ) = __$$ProductLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<Product> products,
    ProductFilter filter,
    int currentPage,
    int totalPages,
    bool hasMore,
    int totalCount,
    bool isLoadingMore,
  });
}

/// @nodoc
class __$$ProductLoadedImplCopyWithImpl<$Res>
    extends _$ProductStateCopyWithImpl<$Res, _$ProductLoadedImpl>
    implements _$$ProductLoadedImplCopyWith<$Res> {
  __$$ProductLoadedImplCopyWithImpl(
    _$ProductLoadedImpl _value,
    $Res Function(_$ProductLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? filter = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? hasMore = null,
    Object? totalCount = null,
    Object? isLoadingMore = null,
  }) {
    return _then(
      _$ProductLoadedImpl(
        products: null == products
            ? _value._products
            : products // ignore: cast_nullable_to_non_nullable
                  as List<Product>,
        filter: null == filter
            ? _value.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as ProductFilter,
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
      ),
    );
  }
}

/// @nodoc

class _$ProductLoadedImpl extends ProductLoaded {
  const _$ProductLoadedImpl({
    required final List<Product> products,
    required this.filter,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.totalCount,
    this.isLoadingMore = false,
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
  final ProductFilter filter;
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
  String toString() {
    return 'ProductState.loaded(products: $products, filter: $filter, currentPage: $currentPage, totalPages: $totalPages, hasMore: $hasMore, totalCount: $totalCount, isLoadingMore: $isLoadingMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductLoadedImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_products),
    filter,
    currentPage,
    totalPages,
    hasMore,
    totalCount,
    isLoadingMore,
  );

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductLoadedImplCopyWith<_$ProductLoadedImpl> get copyWith =>
      __$$ProductLoadedImplCopyWithImpl<_$ProductLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )
    loaded,
    required TResult Function(Product product) detailLoaded,
    required TResult Function(String message) error,
  }) {
    return loaded(
      products,
      filter,
      currentPage,
      totalPages,
      hasMore,
      totalCount,
      isLoadingMore,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )?
    loaded,
    TResult? Function(Product product)? detailLoaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(
      products,
      filter,
      currentPage,
      totalPages,
      hasMore,
      totalCount,
      isLoadingMore,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )?
    loaded,
    TResult Function(Product product)? detailLoaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
        products,
        filter,
        currentPage,
        totalPages,
        hasMore,
        totalCount,
        isLoadingMore,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProductInitial value) initial,
    required TResult Function(ProductLoading value) loading,
    required TResult Function(ProductLoaded value) loaded,
    required TResult Function(ProductDetailLoaded value) detailLoaded,
    required TResult Function(ProductError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductInitial value)? initial,
    TResult? Function(ProductLoading value)? loading,
    TResult? Function(ProductLoaded value)? loaded,
    TResult? Function(ProductDetailLoaded value)? detailLoaded,
    TResult? Function(ProductError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductInitial value)? initial,
    TResult Function(ProductLoading value)? loading,
    TResult Function(ProductLoaded value)? loaded,
    TResult Function(ProductDetailLoaded value)? detailLoaded,
    TResult Function(ProductError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ProductLoaded extends ProductState {
  const factory ProductLoaded({
    required final List<Product> products,
    required final ProductFilter filter,
    required final int currentPage,
    required final int totalPages,
    required final bool hasMore,
    required final int totalCount,
    final bool isLoadingMore,
  }) = _$ProductLoadedImpl;
  const ProductLoaded._() : super._();

  List<Product> get products;
  ProductFilter get filter;
  int get currentPage;
  int get totalPages;
  bool get hasMore;
  int get totalCount;
  bool get isLoadingMore;

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductLoadedImplCopyWith<_$ProductLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProductDetailLoadedImplCopyWith<$Res> {
  factory _$$ProductDetailLoadedImplCopyWith(
    _$ProductDetailLoadedImpl value,
    $Res Function(_$ProductDetailLoadedImpl) then,
  ) = __$$ProductDetailLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Product product});

  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class __$$ProductDetailLoadedImplCopyWithImpl<$Res>
    extends _$ProductStateCopyWithImpl<$Res, _$ProductDetailLoadedImpl>
    implements _$$ProductDetailLoadedImplCopyWith<$Res> {
  __$$ProductDetailLoadedImplCopyWithImpl(
    _$ProductDetailLoadedImpl _value,
    $Res Function(_$ProductDetailLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? product = null}) {
    return _then(
      _$ProductDetailLoadedImpl(
        product: null == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as Product,
      ),
    );
  }

  /// Create a copy of ProductState
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

class _$ProductDetailLoadedImpl extends ProductDetailLoaded {
  const _$ProductDetailLoadedImpl({required this.product}) : super._();

  @override
  final Product product;

  @override
  String toString() {
    return 'ProductState.detailLoaded(product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductDetailLoadedImpl &&
            (identical(other.product, product) || other.product == product));
  }

  @override
  int get hashCode => Object.hash(runtimeType, product);

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductDetailLoadedImplCopyWith<_$ProductDetailLoadedImpl> get copyWith =>
      __$$ProductDetailLoadedImplCopyWithImpl<_$ProductDetailLoadedImpl>(
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
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )
    loaded,
    required TResult Function(Product product) detailLoaded,
    required TResult Function(String message) error,
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
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )?
    loaded,
    TResult? Function(Product product)? detailLoaded,
    TResult? Function(String message)? error,
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
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )?
    loaded,
    TResult Function(Product product)? detailLoaded,
    TResult Function(String message)? error,
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
    required TResult Function(ProductInitial value) initial,
    required TResult Function(ProductLoading value) loading,
    required TResult Function(ProductLoaded value) loaded,
    required TResult Function(ProductDetailLoaded value) detailLoaded,
    required TResult Function(ProductError value) error,
  }) {
    return detailLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductInitial value)? initial,
    TResult? Function(ProductLoading value)? loading,
    TResult? Function(ProductLoaded value)? loaded,
    TResult? Function(ProductDetailLoaded value)? detailLoaded,
    TResult? Function(ProductError value)? error,
  }) {
    return detailLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductInitial value)? initial,
    TResult Function(ProductLoading value)? loading,
    TResult Function(ProductLoaded value)? loaded,
    TResult Function(ProductDetailLoaded value)? detailLoaded,
    TResult Function(ProductError value)? error,
    required TResult orElse(),
  }) {
    if (detailLoaded != null) {
      return detailLoaded(this);
    }
    return orElse();
  }
}

abstract class ProductDetailLoaded extends ProductState {
  const factory ProductDetailLoaded({required final Product product}) =
      _$ProductDetailLoadedImpl;
  const ProductDetailLoaded._() : super._();

  Product get product;

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductDetailLoadedImplCopyWith<_$ProductDetailLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProductErrorImplCopyWith<$Res> {
  factory _$$ProductErrorImplCopyWith(
    _$ProductErrorImpl value,
    $Res Function(_$ProductErrorImpl) then,
  ) = __$$ProductErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ProductErrorImplCopyWithImpl<$Res>
    extends _$ProductStateCopyWithImpl<$Res, _$ProductErrorImpl>
    implements _$$ProductErrorImplCopyWith<$Res> {
  __$$ProductErrorImplCopyWithImpl(
    _$ProductErrorImpl _value,
    $Res Function(_$ProductErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ProductErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ProductErrorImpl extends ProductError {
  const _$ProductErrorImpl({required this.message}) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'ProductState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductErrorImplCopyWith<_$ProductErrorImpl> get copyWith =>
      __$$ProductErrorImplCopyWithImpl<_$ProductErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )
    loaded,
    required TResult Function(Product product) detailLoaded,
    required TResult Function(String message) error,
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
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )?
    loaded,
    TResult? Function(Product product)? detailLoaded,
    TResult? Function(String message)? error,
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
      ProductFilter filter,
      int currentPage,
      int totalPages,
      bool hasMore,
      int totalCount,
      bool isLoadingMore,
    )?
    loaded,
    TResult Function(Product product)? detailLoaded,
    TResult Function(String message)? error,
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
    required TResult Function(ProductInitial value) initial,
    required TResult Function(ProductLoading value) loading,
    required TResult Function(ProductLoaded value) loaded,
    required TResult Function(ProductDetailLoaded value) detailLoaded,
    required TResult Function(ProductError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductInitial value)? initial,
    TResult? Function(ProductLoading value)? loading,
    TResult? Function(ProductLoaded value)? loaded,
    TResult? Function(ProductDetailLoaded value)? detailLoaded,
    TResult? Function(ProductError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductInitial value)? initial,
    TResult Function(ProductLoading value)? loading,
    TResult Function(ProductLoaded value)? loaded,
    TResult Function(ProductDetailLoaded value)? detailLoaded,
    TResult Function(ProductError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ProductError extends ProductState {
  const factory ProductError({required final String message}) =
      _$ProductErrorImpl;
  const ProductError._() : super._();

  String get message;

  /// Create a copy of ProductState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductErrorImplCopyWith<_$ProductErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
