// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ProductFilter filter) getProducts,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(String id) getProductDetail,
    required TResult Function() refreshProducts,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ProductFilter filter)? getProducts,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(String id)? getProductDetail,
    TResult? Function()? refreshProducts,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ProductFilter filter)? getProducts,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(String id)? getProductDetail,
    TResult Function()? refreshProducts,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetProductsEvent value) getProducts,
    required TResult Function(SearchProductsEvent value) searchProducts,
    required TResult Function(ClearSearchEvent value) clearSearch,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
    required TResult Function(RefreshProductsEvent value) refreshProducts,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetProductsEvent value)? getProducts,
    TResult? Function(SearchProductsEvent value)? searchProducts,
    TResult? Function(ClearSearchEvent value)? clearSearch,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
    TResult? Function(RefreshProductsEvent value)? refreshProducts,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetProductsEvent value)? getProducts,
    TResult Function(SearchProductsEvent value)? searchProducts,
    TResult Function(ClearSearchEvent value)? clearSearch,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    TResult Function(RefreshProductsEvent value)? refreshProducts,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductEventCopyWith<$Res> {
  factory $ProductEventCopyWith(
    ProductEvent value,
    $Res Function(ProductEvent) then,
  ) = _$ProductEventCopyWithImpl<$Res, ProductEvent>;
}

/// @nodoc
class _$ProductEventCopyWithImpl<$Res, $Val extends ProductEvent>
    implements $ProductEventCopyWith<$Res> {
  _$ProductEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GetProductsEventImplCopyWith<$Res> {
  factory _$$GetProductsEventImplCopyWith(
    _$GetProductsEventImpl value,
    $Res Function(_$GetProductsEventImpl) then,
  ) = __$$GetProductsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ProductFilter filter});
}

/// @nodoc
class __$$GetProductsEventImplCopyWithImpl<$Res>
    extends _$ProductEventCopyWithImpl<$Res, _$GetProductsEventImpl>
    implements _$$GetProductsEventImplCopyWith<$Res> {
  __$$GetProductsEventImplCopyWithImpl(
    _$GetProductsEventImpl _value,
    $Res Function(_$GetProductsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? filter = null}) {
    return _then(
      _$GetProductsEventImpl(
        filter: null == filter
            ? _value.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as ProductFilter,
      ),
    );
  }
}

/// @nodoc

class _$GetProductsEventImpl implements GetProductsEvent {
  const _$GetProductsEventImpl({required this.filter});

  @override
  final ProductFilter filter;

  @override
  String toString() {
    return 'ProductEvent.getProducts(filter: $filter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetProductsEventImpl &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filter);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetProductsEventImplCopyWith<_$GetProductsEventImpl> get copyWith =>
      __$$GetProductsEventImplCopyWithImpl<_$GetProductsEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ProductFilter filter) getProducts,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(String id) getProductDetail,
    required TResult Function() refreshProducts,
  }) {
    return getProducts(filter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ProductFilter filter)? getProducts,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(String id)? getProductDetail,
    TResult? Function()? refreshProducts,
  }) {
    return getProducts?.call(filter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ProductFilter filter)? getProducts,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(String id)? getProductDetail,
    TResult Function()? refreshProducts,
    required TResult orElse(),
  }) {
    if (getProducts != null) {
      return getProducts(filter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetProductsEvent value) getProducts,
    required TResult Function(SearchProductsEvent value) searchProducts,
    required TResult Function(ClearSearchEvent value) clearSearch,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
    required TResult Function(RefreshProductsEvent value) refreshProducts,
  }) {
    return getProducts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetProductsEvent value)? getProducts,
    TResult? Function(SearchProductsEvent value)? searchProducts,
    TResult? Function(ClearSearchEvent value)? clearSearch,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
    TResult? Function(RefreshProductsEvent value)? refreshProducts,
  }) {
    return getProducts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetProductsEvent value)? getProducts,
    TResult Function(SearchProductsEvent value)? searchProducts,
    TResult Function(ClearSearchEvent value)? clearSearch,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    TResult Function(RefreshProductsEvent value)? refreshProducts,
    required TResult orElse(),
  }) {
    if (getProducts != null) {
      return getProducts(this);
    }
    return orElse();
  }
}

abstract class GetProductsEvent implements ProductEvent {
  const factory GetProductsEvent({required final ProductFilter filter}) =
      _$GetProductsEventImpl;

  ProductFilter get filter;

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetProductsEventImplCopyWith<_$GetProductsEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchProductsEventImplCopyWith<$Res> {
  factory _$$SearchProductsEventImplCopyWith(
    _$SearchProductsEventImpl value,
    $Res Function(_$SearchProductsEventImpl) then,
  ) = __$$SearchProductsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String query});
}

/// @nodoc
class __$$SearchProductsEventImplCopyWithImpl<$Res>
    extends _$ProductEventCopyWithImpl<$Res, _$SearchProductsEventImpl>
    implements _$$SearchProductsEventImplCopyWith<$Res> {
  __$$SearchProductsEventImplCopyWithImpl(
    _$SearchProductsEventImpl _value,
    $Res Function(_$SearchProductsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? query = null}) {
    return _then(
      _$SearchProductsEventImpl(
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SearchProductsEventImpl implements SearchProductsEvent {
  const _$SearchProductsEventImpl({required this.query});

  @override
  final String query;

  @override
  String toString() {
    return 'ProductEvent.searchProducts(query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchProductsEventImpl &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchProductsEventImplCopyWith<_$SearchProductsEventImpl> get copyWith =>
      __$$SearchProductsEventImplCopyWithImpl<_$SearchProductsEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ProductFilter filter) getProducts,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(String id) getProductDetail,
    required TResult Function() refreshProducts,
  }) {
    return searchProducts(query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ProductFilter filter)? getProducts,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(String id)? getProductDetail,
    TResult? Function()? refreshProducts,
  }) {
    return searchProducts?.call(query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ProductFilter filter)? getProducts,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(String id)? getProductDetail,
    TResult Function()? refreshProducts,
    required TResult orElse(),
  }) {
    if (searchProducts != null) {
      return searchProducts(query);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetProductsEvent value) getProducts,
    required TResult Function(SearchProductsEvent value) searchProducts,
    required TResult Function(ClearSearchEvent value) clearSearch,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
    required TResult Function(RefreshProductsEvent value) refreshProducts,
  }) {
    return searchProducts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetProductsEvent value)? getProducts,
    TResult? Function(SearchProductsEvent value)? searchProducts,
    TResult? Function(ClearSearchEvent value)? clearSearch,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
    TResult? Function(RefreshProductsEvent value)? refreshProducts,
  }) {
    return searchProducts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetProductsEvent value)? getProducts,
    TResult Function(SearchProductsEvent value)? searchProducts,
    TResult Function(ClearSearchEvent value)? clearSearch,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    TResult Function(RefreshProductsEvent value)? refreshProducts,
    required TResult orElse(),
  }) {
    if (searchProducts != null) {
      return searchProducts(this);
    }
    return orElse();
  }
}

abstract class SearchProductsEvent implements ProductEvent {
  const factory SearchProductsEvent({required final String query}) =
      _$SearchProductsEventImpl;

  String get query;

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchProductsEventImplCopyWith<_$SearchProductsEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearSearchEventImplCopyWith<$Res> {
  factory _$$ClearSearchEventImplCopyWith(
    _$ClearSearchEventImpl value,
    $Res Function(_$ClearSearchEventImpl) then,
  ) = __$$ClearSearchEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearSearchEventImplCopyWithImpl<$Res>
    extends _$ProductEventCopyWithImpl<$Res, _$ClearSearchEventImpl>
    implements _$$ClearSearchEventImplCopyWith<$Res> {
  __$$ClearSearchEventImplCopyWithImpl(
    _$ClearSearchEventImpl _value,
    $Res Function(_$ClearSearchEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearSearchEventImpl implements ClearSearchEvent {
  const _$ClearSearchEventImpl();

  @override
  String toString() {
    return 'ProductEvent.clearSearch()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearSearchEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ProductFilter filter) getProducts,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(String id) getProductDetail,
    required TResult Function() refreshProducts,
  }) {
    return clearSearch();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ProductFilter filter)? getProducts,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(String id)? getProductDetail,
    TResult? Function()? refreshProducts,
  }) {
    return clearSearch?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ProductFilter filter)? getProducts,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(String id)? getProductDetail,
    TResult Function()? refreshProducts,
    required TResult orElse(),
  }) {
    if (clearSearch != null) {
      return clearSearch();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetProductsEvent value) getProducts,
    required TResult Function(SearchProductsEvent value) searchProducts,
    required TResult Function(ClearSearchEvent value) clearSearch,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
    required TResult Function(RefreshProductsEvent value) refreshProducts,
  }) {
    return clearSearch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetProductsEvent value)? getProducts,
    TResult? Function(SearchProductsEvent value)? searchProducts,
    TResult? Function(ClearSearchEvent value)? clearSearch,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
    TResult? Function(RefreshProductsEvent value)? refreshProducts,
  }) {
    return clearSearch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetProductsEvent value)? getProducts,
    TResult Function(SearchProductsEvent value)? searchProducts,
    TResult Function(ClearSearchEvent value)? clearSearch,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    TResult Function(RefreshProductsEvent value)? refreshProducts,
    required TResult orElse(),
  }) {
    if (clearSearch != null) {
      return clearSearch(this);
    }
    return orElse();
  }
}

abstract class ClearSearchEvent implements ProductEvent {
  const factory ClearSearchEvent() = _$ClearSearchEventImpl;
}

/// @nodoc
abstract class _$$GetProductDetailEventImplCopyWith<$Res> {
  factory _$$GetProductDetailEventImplCopyWith(
    _$GetProductDetailEventImpl value,
    $Res Function(_$GetProductDetailEventImpl) then,
  ) = __$$GetProductDetailEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$GetProductDetailEventImplCopyWithImpl<$Res>
    extends _$ProductEventCopyWithImpl<$Res, _$GetProductDetailEventImpl>
    implements _$$GetProductDetailEventImplCopyWith<$Res> {
  __$$GetProductDetailEventImplCopyWithImpl(
    _$GetProductDetailEventImpl _value,
    $Res Function(_$GetProductDetailEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _$GetProductDetailEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GetProductDetailEventImpl implements GetProductDetailEvent {
  const _$GetProductDetailEventImpl({required this.id});

  @override
  final String id;

  @override
  String toString() {
    return 'ProductEvent.getProductDetail(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetProductDetailEventImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetProductDetailEventImplCopyWith<_$GetProductDetailEventImpl>
  get copyWith =>
      __$$GetProductDetailEventImplCopyWithImpl<_$GetProductDetailEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ProductFilter filter) getProducts,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(String id) getProductDetail,
    required TResult Function() refreshProducts,
  }) {
    return getProductDetail(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ProductFilter filter)? getProducts,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(String id)? getProductDetail,
    TResult? Function()? refreshProducts,
  }) {
    return getProductDetail?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ProductFilter filter)? getProducts,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(String id)? getProductDetail,
    TResult Function()? refreshProducts,
    required TResult orElse(),
  }) {
    if (getProductDetail != null) {
      return getProductDetail(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetProductsEvent value) getProducts,
    required TResult Function(SearchProductsEvent value) searchProducts,
    required TResult Function(ClearSearchEvent value) clearSearch,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
    required TResult Function(RefreshProductsEvent value) refreshProducts,
  }) {
    return getProductDetail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetProductsEvent value)? getProducts,
    TResult? Function(SearchProductsEvent value)? searchProducts,
    TResult? Function(ClearSearchEvent value)? clearSearch,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
    TResult? Function(RefreshProductsEvent value)? refreshProducts,
  }) {
    return getProductDetail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetProductsEvent value)? getProducts,
    TResult Function(SearchProductsEvent value)? searchProducts,
    TResult Function(ClearSearchEvent value)? clearSearch,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    TResult Function(RefreshProductsEvent value)? refreshProducts,
    required TResult orElse(),
  }) {
    if (getProductDetail != null) {
      return getProductDetail(this);
    }
    return orElse();
  }
}

abstract class GetProductDetailEvent implements ProductEvent {
  const factory GetProductDetailEvent({required final String id}) =
      _$GetProductDetailEventImpl;

  String get id;

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetProductDetailEventImplCopyWith<_$GetProductDetailEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RefreshProductsEventImplCopyWith<$Res> {
  factory _$$RefreshProductsEventImplCopyWith(
    _$RefreshProductsEventImpl value,
    $Res Function(_$RefreshProductsEventImpl) then,
  ) = __$$RefreshProductsEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshProductsEventImplCopyWithImpl<$Res>
    extends _$ProductEventCopyWithImpl<$Res, _$RefreshProductsEventImpl>
    implements _$$RefreshProductsEventImplCopyWith<$Res> {
  __$$RefreshProductsEventImplCopyWithImpl(
    _$RefreshProductsEventImpl _value,
    $Res Function(_$RefreshProductsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RefreshProductsEventImpl implements RefreshProductsEvent {
  const _$RefreshProductsEventImpl();

  @override
  String toString() {
    return 'ProductEvent.refreshProducts()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshProductsEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ProductFilter filter) getProducts,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(String id) getProductDetail,
    required TResult Function() refreshProducts,
  }) {
    return refreshProducts();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ProductFilter filter)? getProducts,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(String id)? getProductDetail,
    TResult? Function()? refreshProducts,
  }) {
    return refreshProducts?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ProductFilter filter)? getProducts,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(String id)? getProductDetail,
    TResult Function()? refreshProducts,
    required TResult orElse(),
  }) {
    if (refreshProducts != null) {
      return refreshProducts();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetProductsEvent value) getProducts,
    required TResult Function(SearchProductsEvent value) searchProducts,
    required TResult Function(ClearSearchEvent value) clearSearch,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
    required TResult Function(RefreshProductsEvent value) refreshProducts,
  }) {
    return refreshProducts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetProductsEvent value)? getProducts,
    TResult? Function(SearchProductsEvent value)? searchProducts,
    TResult? Function(ClearSearchEvent value)? clearSearch,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
    TResult? Function(RefreshProductsEvent value)? refreshProducts,
  }) {
    return refreshProducts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetProductsEvent value)? getProducts,
    TResult Function(SearchProductsEvent value)? searchProducts,
    TResult Function(ClearSearchEvent value)? clearSearch,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    TResult Function(RefreshProductsEvent value)? refreshProducts,
    required TResult orElse(),
  }) {
    if (refreshProducts != null) {
      return refreshProducts(this);
    }
    return orElse();
  }
}

abstract class RefreshProductsEvent implements ProductEvent {
  const factory RefreshProductsEvent() = _$RefreshProductsEventImpl;
}
