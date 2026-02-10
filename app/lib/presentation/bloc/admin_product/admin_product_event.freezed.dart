// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_product_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AdminProductEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AdminProductFilter? filter) getProducts,
    required TResult Function(String? brandName) filterByBrand,
    required TResult Function(StockStatus status) filterByStockStatus,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(bool silent) refreshProducts,
    required TResult Function(String productId) deleteProduct,
    required TResult Function(String productId) getProductDetail,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AdminProductFilter? filter)? getProducts,
    TResult? Function(String? brandName)? filterByBrand,
    TResult? Function(StockStatus status)? filterByStockStatus,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(bool silent)? refreshProducts,
    TResult? Function(String productId)? deleteProduct,
    TResult? Function(String productId)? getProductDetail,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AdminProductFilter? filter)? getProducts,
    TResult Function(String? brandName)? filterByBrand,
    TResult Function(StockStatus status)? filterByStockStatus,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(bool silent)? refreshProducts,
    TResult Function(String productId)? deleteProduct,
    TResult Function(String productId)? getProductDetail,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetAdminProductsEvent value) getProducts,
    required TResult Function(FilterByBrandEvent value) filterByBrand,
    required TResult Function(FilterByStockStatusEvent value)
    filterByStockStatus,
    required TResult Function(SearchAdminProductsEvent value) searchProducts,
    required TResult Function(ClearAdminSearchEvent value) clearSearch,
    required TResult Function(RefreshAdminProductsEvent value) refreshProducts,
    required TResult Function(DeleteProductEvent value) deleteProduct,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetAdminProductsEvent value)? getProducts,
    TResult? Function(FilterByBrandEvent value)? filterByBrand,
    TResult? Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult? Function(SearchAdminProductsEvent value)? searchProducts,
    TResult? Function(ClearAdminSearchEvent value)? clearSearch,
    TResult? Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult? Function(DeleteProductEvent value)? deleteProduct,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetAdminProductsEvent value)? getProducts,
    TResult Function(FilterByBrandEvent value)? filterByBrand,
    TResult Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult Function(SearchAdminProductsEvent value)? searchProducts,
    TResult Function(ClearAdminSearchEvent value)? clearSearch,
    TResult Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult Function(DeleteProductEvent value)? deleteProduct,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminProductEventCopyWith<$Res> {
  factory $AdminProductEventCopyWith(
    AdminProductEvent value,
    $Res Function(AdminProductEvent) then,
  ) = _$AdminProductEventCopyWithImpl<$Res, AdminProductEvent>;
}

/// @nodoc
class _$AdminProductEventCopyWithImpl<$Res, $Val extends AdminProductEvent>
    implements $AdminProductEventCopyWith<$Res> {
  _$AdminProductEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GetAdminProductsEventImplCopyWith<$Res> {
  factory _$$GetAdminProductsEventImplCopyWith(
    _$GetAdminProductsEventImpl value,
    $Res Function(_$GetAdminProductsEventImpl) then,
  ) = __$$GetAdminProductsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AdminProductFilter? filter});
}

/// @nodoc
class __$$GetAdminProductsEventImplCopyWithImpl<$Res>
    extends _$AdminProductEventCopyWithImpl<$Res, _$GetAdminProductsEventImpl>
    implements _$$GetAdminProductsEventImplCopyWith<$Res> {
  __$$GetAdminProductsEventImplCopyWithImpl(
    _$GetAdminProductsEventImpl _value,
    $Res Function(_$GetAdminProductsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? filter = freezed}) {
    return _then(
      _$GetAdminProductsEventImpl(
        filter: freezed == filter
            ? _value.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as AdminProductFilter?,
      ),
    );
  }
}

/// @nodoc

class _$GetAdminProductsEventImpl implements GetAdminProductsEvent {
  const _$GetAdminProductsEventImpl({this.filter});

  @override
  final AdminProductFilter? filter;

  @override
  String toString() {
    return 'AdminProductEvent.getProducts(filter: $filter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetAdminProductsEventImpl &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filter);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetAdminProductsEventImplCopyWith<_$GetAdminProductsEventImpl>
  get copyWith =>
      __$$GetAdminProductsEventImplCopyWithImpl<_$GetAdminProductsEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AdminProductFilter? filter) getProducts,
    required TResult Function(String? brandName) filterByBrand,
    required TResult Function(StockStatus status) filterByStockStatus,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(bool silent) refreshProducts,
    required TResult Function(String productId) deleteProduct,
    required TResult Function(String productId) getProductDetail,
  }) {
    return getProducts(filter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AdminProductFilter? filter)? getProducts,
    TResult? Function(String? brandName)? filterByBrand,
    TResult? Function(StockStatus status)? filterByStockStatus,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(bool silent)? refreshProducts,
    TResult? Function(String productId)? deleteProduct,
    TResult? Function(String productId)? getProductDetail,
  }) {
    return getProducts?.call(filter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AdminProductFilter? filter)? getProducts,
    TResult Function(String? brandName)? filterByBrand,
    TResult Function(StockStatus status)? filterByStockStatus,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(bool silent)? refreshProducts,
    TResult Function(String productId)? deleteProduct,
    TResult Function(String productId)? getProductDetail,
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
    required TResult Function(GetAdminProductsEvent value) getProducts,
    required TResult Function(FilterByBrandEvent value) filterByBrand,
    required TResult Function(FilterByStockStatusEvent value)
    filterByStockStatus,
    required TResult Function(SearchAdminProductsEvent value) searchProducts,
    required TResult Function(ClearAdminSearchEvent value) clearSearch,
    required TResult Function(RefreshAdminProductsEvent value) refreshProducts,
    required TResult Function(DeleteProductEvent value) deleteProduct,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
  }) {
    return getProducts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetAdminProductsEvent value)? getProducts,
    TResult? Function(FilterByBrandEvent value)? filterByBrand,
    TResult? Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult? Function(SearchAdminProductsEvent value)? searchProducts,
    TResult? Function(ClearAdminSearchEvent value)? clearSearch,
    TResult? Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult? Function(DeleteProductEvent value)? deleteProduct,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
  }) {
    return getProducts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetAdminProductsEvent value)? getProducts,
    TResult Function(FilterByBrandEvent value)? filterByBrand,
    TResult Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult Function(SearchAdminProductsEvent value)? searchProducts,
    TResult Function(ClearAdminSearchEvent value)? clearSearch,
    TResult Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult Function(DeleteProductEvent value)? deleteProduct,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    required TResult orElse(),
  }) {
    if (getProducts != null) {
      return getProducts(this);
    }
    return orElse();
  }
}

abstract class GetAdminProductsEvent implements AdminProductEvent {
  const factory GetAdminProductsEvent({final AdminProductFilter? filter}) =
      _$GetAdminProductsEventImpl;

  AdminProductFilter? get filter;

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetAdminProductsEventImplCopyWith<_$GetAdminProductsEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FilterByBrandEventImplCopyWith<$Res> {
  factory _$$FilterByBrandEventImplCopyWith(
    _$FilterByBrandEventImpl value,
    $Res Function(_$FilterByBrandEventImpl) then,
  ) = __$$FilterByBrandEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? brandName});
}

/// @nodoc
class __$$FilterByBrandEventImplCopyWithImpl<$Res>
    extends _$AdminProductEventCopyWithImpl<$Res, _$FilterByBrandEventImpl>
    implements _$$FilterByBrandEventImplCopyWith<$Res> {
  __$$FilterByBrandEventImplCopyWithImpl(
    _$FilterByBrandEventImpl _value,
    $Res Function(_$FilterByBrandEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? brandName = freezed}) {
    return _then(
      _$FilterByBrandEventImpl(
        brandName: freezed == brandName
            ? _value.brandName
            : brandName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$FilterByBrandEventImpl implements FilterByBrandEvent {
  const _$FilterByBrandEventImpl({required this.brandName});

  @override
  final String? brandName;

  @override
  String toString() {
    return 'AdminProductEvent.filterByBrand(brandName: $brandName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterByBrandEventImpl &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, brandName);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterByBrandEventImplCopyWith<_$FilterByBrandEventImpl> get copyWith =>
      __$$FilterByBrandEventImplCopyWithImpl<_$FilterByBrandEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AdminProductFilter? filter) getProducts,
    required TResult Function(String? brandName) filterByBrand,
    required TResult Function(StockStatus status) filterByStockStatus,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(bool silent) refreshProducts,
    required TResult Function(String productId) deleteProduct,
    required TResult Function(String productId) getProductDetail,
  }) {
    return filterByBrand(brandName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AdminProductFilter? filter)? getProducts,
    TResult? Function(String? brandName)? filterByBrand,
    TResult? Function(StockStatus status)? filterByStockStatus,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(bool silent)? refreshProducts,
    TResult? Function(String productId)? deleteProduct,
    TResult? Function(String productId)? getProductDetail,
  }) {
    return filterByBrand?.call(brandName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AdminProductFilter? filter)? getProducts,
    TResult Function(String? brandName)? filterByBrand,
    TResult Function(StockStatus status)? filterByStockStatus,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(bool silent)? refreshProducts,
    TResult Function(String productId)? deleteProduct,
    TResult Function(String productId)? getProductDetail,
    required TResult orElse(),
  }) {
    if (filterByBrand != null) {
      return filterByBrand(brandName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetAdminProductsEvent value) getProducts,
    required TResult Function(FilterByBrandEvent value) filterByBrand,
    required TResult Function(FilterByStockStatusEvent value)
    filterByStockStatus,
    required TResult Function(SearchAdminProductsEvent value) searchProducts,
    required TResult Function(ClearAdminSearchEvent value) clearSearch,
    required TResult Function(RefreshAdminProductsEvent value) refreshProducts,
    required TResult Function(DeleteProductEvent value) deleteProduct,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
  }) {
    return filterByBrand(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetAdminProductsEvent value)? getProducts,
    TResult? Function(FilterByBrandEvent value)? filterByBrand,
    TResult? Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult? Function(SearchAdminProductsEvent value)? searchProducts,
    TResult? Function(ClearAdminSearchEvent value)? clearSearch,
    TResult? Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult? Function(DeleteProductEvent value)? deleteProduct,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
  }) {
    return filterByBrand?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetAdminProductsEvent value)? getProducts,
    TResult Function(FilterByBrandEvent value)? filterByBrand,
    TResult Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult Function(SearchAdminProductsEvent value)? searchProducts,
    TResult Function(ClearAdminSearchEvent value)? clearSearch,
    TResult Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult Function(DeleteProductEvent value)? deleteProduct,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    required TResult orElse(),
  }) {
    if (filterByBrand != null) {
      return filterByBrand(this);
    }
    return orElse();
  }
}

abstract class FilterByBrandEvent implements AdminProductEvent {
  const factory FilterByBrandEvent({required final String? brandName}) =
      _$FilterByBrandEventImpl;

  String? get brandName;

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterByBrandEventImplCopyWith<_$FilterByBrandEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FilterByStockStatusEventImplCopyWith<$Res> {
  factory _$$FilterByStockStatusEventImplCopyWith(
    _$FilterByStockStatusEventImpl value,
    $Res Function(_$FilterByStockStatusEventImpl) then,
  ) = __$$FilterByStockStatusEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({StockStatus status});
}

/// @nodoc
class __$$FilterByStockStatusEventImplCopyWithImpl<$Res>
    extends
        _$AdminProductEventCopyWithImpl<$Res, _$FilterByStockStatusEventImpl>
    implements _$$FilterByStockStatusEventImplCopyWith<$Res> {
  __$$FilterByStockStatusEventImplCopyWithImpl(
    _$FilterByStockStatusEventImpl _value,
    $Res Function(_$FilterByStockStatusEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      _$FilterByStockStatusEventImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as StockStatus,
      ),
    );
  }
}

/// @nodoc

class _$FilterByStockStatusEventImpl implements FilterByStockStatusEvent {
  const _$FilterByStockStatusEventImpl({required this.status});

  @override
  final StockStatus status;

  @override
  String toString() {
    return 'AdminProductEvent.filterByStockStatus(status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterByStockStatusEventImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterByStockStatusEventImplCopyWith<_$FilterByStockStatusEventImpl>
  get copyWith =>
      __$$FilterByStockStatusEventImplCopyWithImpl<
        _$FilterByStockStatusEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AdminProductFilter? filter) getProducts,
    required TResult Function(String? brandName) filterByBrand,
    required TResult Function(StockStatus status) filterByStockStatus,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(bool silent) refreshProducts,
    required TResult Function(String productId) deleteProduct,
    required TResult Function(String productId) getProductDetail,
  }) {
    return filterByStockStatus(status);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AdminProductFilter? filter)? getProducts,
    TResult? Function(String? brandName)? filterByBrand,
    TResult? Function(StockStatus status)? filterByStockStatus,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(bool silent)? refreshProducts,
    TResult? Function(String productId)? deleteProduct,
    TResult? Function(String productId)? getProductDetail,
  }) {
    return filterByStockStatus?.call(status);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AdminProductFilter? filter)? getProducts,
    TResult Function(String? brandName)? filterByBrand,
    TResult Function(StockStatus status)? filterByStockStatus,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(bool silent)? refreshProducts,
    TResult Function(String productId)? deleteProduct,
    TResult Function(String productId)? getProductDetail,
    required TResult orElse(),
  }) {
    if (filterByStockStatus != null) {
      return filterByStockStatus(status);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetAdminProductsEvent value) getProducts,
    required TResult Function(FilterByBrandEvent value) filterByBrand,
    required TResult Function(FilterByStockStatusEvent value)
    filterByStockStatus,
    required TResult Function(SearchAdminProductsEvent value) searchProducts,
    required TResult Function(ClearAdminSearchEvent value) clearSearch,
    required TResult Function(RefreshAdminProductsEvent value) refreshProducts,
    required TResult Function(DeleteProductEvent value) deleteProduct,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
  }) {
    return filterByStockStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetAdminProductsEvent value)? getProducts,
    TResult? Function(FilterByBrandEvent value)? filterByBrand,
    TResult? Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult? Function(SearchAdminProductsEvent value)? searchProducts,
    TResult? Function(ClearAdminSearchEvent value)? clearSearch,
    TResult? Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult? Function(DeleteProductEvent value)? deleteProduct,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
  }) {
    return filterByStockStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetAdminProductsEvent value)? getProducts,
    TResult Function(FilterByBrandEvent value)? filterByBrand,
    TResult Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult Function(SearchAdminProductsEvent value)? searchProducts,
    TResult Function(ClearAdminSearchEvent value)? clearSearch,
    TResult Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult Function(DeleteProductEvent value)? deleteProduct,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    required TResult orElse(),
  }) {
    if (filterByStockStatus != null) {
      return filterByStockStatus(this);
    }
    return orElse();
  }
}

abstract class FilterByStockStatusEvent implements AdminProductEvent {
  const factory FilterByStockStatusEvent({required final StockStatus status}) =
      _$FilterByStockStatusEventImpl;

  StockStatus get status;

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterByStockStatusEventImplCopyWith<_$FilterByStockStatusEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchAdminProductsEventImplCopyWith<$Res> {
  factory _$$SearchAdminProductsEventImplCopyWith(
    _$SearchAdminProductsEventImpl value,
    $Res Function(_$SearchAdminProductsEventImpl) then,
  ) = __$$SearchAdminProductsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String query});
}

/// @nodoc
class __$$SearchAdminProductsEventImplCopyWithImpl<$Res>
    extends
        _$AdminProductEventCopyWithImpl<$Res, _$SearchAdminProductsEventImpl>
    implements _$$SearchAdminProductsEventImplCopyWith<$Res> {
  __$$SearchAdminProductsEventImplCopyWithImpl(
    _$SearchAdminProductsEventImpl _value,
    $Res Function(_$SearchAdminProductsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? query = null}) {
    return _then(
      _$SearchAdminProductsEventImpl(
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SearchAdminProductsEventImpl implements SearchAdminProductsEvent {
  const _$SearchAdminProductsEventImpl({required this.query});

  @override
  final String query;

  @override
  String toString() {
    return 'AdminProductEvent.searchProducts(query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchAdminProductsEventImpl &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchAdminProductsEventImplCopyWith<_$SearchAdminProductsEventImpl>
  get copyWith =>
      __$$SearchAdminProductsEventImplCopyWithImpl<
        _$SearchAdminProductsEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AdminProductFilter? filter) getProducts,
    required TResult Function(String? brandName) filterByBrand,
    required TResult Function(StockStatus status) filterByStockStatus,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(bool silent) refreshProducts,
    required TResult Function(String productId) deleteProduct,
    required TResult Function(String productId) getProductDetail,
  }) {
    return searchProducts(query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AdminProductFilter? filter)? getProducts,
    TResult? Function(String? brandName)? filterByBrand,
    TResult? Function(StockStatus status)? filterByStockStatus,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(bool silent)? refreshProducts,
    TResult? Function(String productId)? deleteProduct,
    TResult? Function(String productId)? getProductDetail,
  }) {
    return searchProducts?.call(query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AdminProductFilter? filter)? getProducts,
    TResult Function(String? brandName)? filterByBrand,
    TResult Function(StockStatus status)? filterByStockStatus,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(bool silent)? refreshProducts,
    TResult Function(String productId)? deleteProduct,
    TResult Function(String productId)? getProductDetail,
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
    required TResult Function(GetAdminProductsEvent value) getProducts,
    required TResult Function(FilterByBrandEvent value) filterByBrand,
    required TResult Function(FilterByStockStatusEvent value)
    filterByStockStatus,
    required TResult Function(SearchAdminProductsEvent value) searchProducts,
    required TResult Function(ClearAdminSearchEvent value) clearSearch,
    required TResult Function(RefreshAdminProductsEvent value) refreshProducts,
    required TResult Function(DeleteProductEvent value) deleteProduct,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
  }) {
    return searchProducts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetAdminProductsEvent value)? getProducts,
    TResult? Function(FilterByBrandEvent value)? filterByBrand,
    TResult? Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult? Function(SearchAdminProductsEvent value)? searchProducts,
    TResult? Function(ClearAdminSearchEvent value)? clearSearch,
    TResult? Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult? Function(DeleteProductEvent value)? deleteProduct,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
  }) {
    return searchProducts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetAdminProductsEvent value)? getProducts,
    TResult Function(FilterByBrandEvent value)? filterByBrand,
    TResult Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult Function(SearchAdminProductsEvent value)? searchProducts,
    TResult Function(ClearAdminSearchEvent value)? clearSearch,
    TResult Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult Function(DeleteProductEvent value)? deleteProduct,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    required TResult orElse(),
  }) {
    if (searchProducts != null) {
      return searchProducts(this);
    }
    return orElse();
  }
}

abstract class SearchAdminProductsEvent implements AdminProductEvent {
  const factory SearchAdminProductsEvent({required final String query}) =
      _$SearchAdminProductsEventImpl;

  String get query;

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchAdminProductsEventImplCopyWith<_$SearchAdminProductsEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearAdminSearchEventImplCopyWith<$Res> {
  factory _$$ClearAdminSearchEventImplCopyWith(
    _$ClearAdminSearchEventImpl value,
    $Res Function(_$ClearAdminSearchEventImpl) then,
  ) = __$$ClearAdminSearchEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearAdminSearchEventImplCopyWithImpl<$Res>
    extends _$AdminProductEventCopyWithImpl<$Res, _$ClearAdminSearchEventImpl>
    implements _$$ClearAdminSearchEventImplCopyWith<$Res> {
  __$$ClearAdminSearchEventImplCopyWithImpl(
    _$ClearAdminSearchEventImpl _value,
    $Res Function(_$ClearAdminSearchEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearAdminSearchEventImpl implements ClearAdminSearchEvent {
  const _$ClearAdminSearchEventImpl();

  @override
  String toString() {
    return 'AdminProductEvent.clearSearch()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClearAdminSearchEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AdminProductFilter? filter) getProducts,
    required TResult Function(String? brandName) filterByBrand,
    required TResult Function(StockStatus status) filterByStockStatus,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(bool silent) refreshProducts,
    required TResult Function(String productId) deleteProduct,
    required TResult Function(String productId) getProductDetail,
  }) {
    return clearSearch();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AdminProductFilter? filter)? getProducts,
    TResult? Function(String? brandName)? filterByBrand,
    TResult? Function(StockStatus status)? filterByStockStatus,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(bool silent)? refreshProducts,
    TResult? Function(String productId)? deleteProduct,
    TResult? Function(String productId)? getProductDetail,
  }) {
    return clearSearch?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AdminProductFilter? filter)? getProducts,
    TResult Function(String? brandName)? filterByBrand,
    TResult Function(StockStatus status)? filterByStockStatus,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(bool silent)? refreshProducts,
    TResult Function(String productId)? deleteProduct,
    TResult Function(String productId)? getProductDetail,
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
    required TResult Function(GetAdminProductsEvent value) getProducts,
    required TResult Function(FilterByBrandEvent value) filterByBrand,
    required TResult Function(FilterByStockStatusEvent value)
    filterByStockStatus,
    required TResult Function(SearchAdminProductsEvent value) searchProducts,
    required TResult Function(ClearAdminSearchEvent value) clearSearch,
    required TResult Function(RefreshAdminProductsEvent value) refreshProducts,
    required TResult Function(DeleteProductEvent value) deleteProduct,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
  }) {
    return clearSearch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetAdminProductsEvent value)? getProducts,
    TResult? Function(FilterByBrandEvent value)? filterByBrand,
    TResult? Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult? Function(SearchAdminProductsEvent value)? searchProducts,
    TResult? Function(ClearAdminSearchEvent value)? clearSearch,
    TResult? Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult? Function(DeleteProductEvent value)? deleteProduct,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
  }) {
    return clearSearch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetAdminProductsEvent value)? getProducts,
    TResult Function(FilterByBrandEvent value)? filterByBrand,
    TResult Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult Function(SearchAdminProductsEvent value)? searchProducts,
    TResult Function(ClearAdminSearchEvent value)? clearSearch,
    TResult Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult Function(DeleteProductEvent value)? deleteProduct,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    required TResult orElse(),
  }) {
    if (clearSearch != null) {
      return clearSearch(this);
    }
    return orElse();
  }
}

abstract class ClearAdminSearchEvent implements AdminProductEvent {
  const factory ClearAdminSearchEvent() = _$ClearAdminSearchEventImpl;
}

/// @nodoc
abstract class _$$RefreshAdminProductsEventImplCopyWith<$Res> {
  factory _$$RefreshAdminProductsEventImplCopyWith(
    _$RefreshAdminProductsEventImpl value,
    $Res Function(_$RefreshAdminProductsEventImpl) then,
  ) = __$$RefreshAdminProductsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool silent});
}

/// @nodoc
class __$$RefreshAdminProductsEventImplCopyWithImpl<$Res>
    extends
        _$AdminProductEventCopyWithImpl<$Res, _$RefreshAdminProductsEventImpl>
    implements _$$RefreshAdminProductsEventImplCopyWith<$Res> {
  __$$RefreshAdminProductsEventImplCopyWithImpl(
    _$RefreshAdminProductsEventImpl _value,
    $Res Function(_$RefreshAdminProductsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? silent = null}) {
    return _then(
      _$RefreshAdminProductsEventImpl(
        silent: null == silent
            ? _value.silent
            : silent // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$RefreshAdminProductsEventImpl implements RefreshAdminProductsEvent {
  const _$RefreshAdminProductsEventImpl({this.silent = false});

  @override
  @JsonKey()
  final bool silent;

  @override
  String toString() {
    return 'AdminProductEvent.refreshProducts(silent: $silent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshAdminProductsEventImpl &&
            (identical(other.silent, silent) || other.silent == silent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, silent);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshAdminProductsEventImplCopyWith<_$RefreshAdminProductsEventImpl>
  get copyWith =>
      __$$RefreshAdminProductsEventImplCopyWithImpl<
        _$RefreshAdminProductsEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AdminProductFilter? filter) getProducts,
    required TResult Function(String? brandName) filterByBrand,
    required TResult Function(StockStatus status) filterByStockStatus,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(bool silent) refreshProducts,
    required TResult Function(String productId) deleteProduct,
    required TResult Function(String productId) getProductDetail,
  }) {
    return refreshProducts(silent);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AdminProductFilter? filter)? getProducts,
    TResult? Function(String? brandName)? filterByBrand,
    TResult? Function(StockStatus status)? filterByStockStatus,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(bool silent)? refreshProducts,
    TResult? Function(String productId)? deleteProduct,
    TResult? Function(String productId)? getProductDetail,
  }) {
    return refreshProducts?.call(silent);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AdminProductFilter? filter)? getProducts,
    TResult Function(String? brandName)? filterByBrand,
    TResult Function(StockStatus status)? filterByStockStatus,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(bool silent)? refreshProducts,
    TResult Function(String productId)? deleteProduct,
    TResult Function(String productId)? getProductDetail,
    required TResult orElse(),
  }) {
    if (refreshProducts != null) {
      return refreshProducts(silent);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetAdminProductsEvent value) getProducts,
    required TResult Function(FilterByBrandEvent value) filterByBrand,
    required TResult Function(FilterByStockStatusEvent value)
    filterByStockStatus,
    required TResult Function(SearchAdminProductsEvent value) searchProducts,
    required TResult Function(ClearAdminSearchEvent value) clearSearch,
    required TResult Function(RefreshAdminProductsEvent value) refreshProducts,
    required TResult Function(DeleteProductEvent value) deleteProduct,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
  }) {
    return refreshProducts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetAdminProductsEvent value)? getProducts,
    TResult? Function(FilterByBrandEvent value)? filterByBrand,
    TResult? Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult? Function(SearchAdminProductsEvent value)? searchProducts,
    TResult? Function(ClearAdminSearchEvent value)? clearSearch,
    TResult? Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult? Function(DeleteProductEvent value)? deleteProduct,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
  }) {
    return refreshProducts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetAdminProductsEvent value)? getProducts,
    TResult Function(FilterByBrandEvent value)? filterByBrand,
    TResult Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult Function(SearchAdminProductsEvent value)? searchProducts,
    TResult Function(ClearAdminSearchEvent value)? clearSearch,
    TResult Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult Function(DeleteProductEvent value)? deleteProduct,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    required TResult orElse(),
  }) {
    if (refreshProducts != null) {
      return refreshProducts(this);
    }
    return orElse();
  }
}

abstract class RefreshAdminProductsEvent implements AdminProductEvent {
  const factory RefreshAdminProductsEvent({final bool silent}) =
      _$RefreshAdminProductsEventImpl;

  bool get silent;

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshAdminProductsEventImplCopyWith<_$RefreshAdminProductsEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteProductEventImplCopyWith<$Res> {
  factory _$$DeleteProductEventImplCopyWith(
    _$DeleteProductEventImpl value,
    $Res Function(_$DeleteProductEventImpl) then,
  ) = __$$DeleteProductEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String productId});
}

/// @nodoc
class __$$DeleteProductEventImplCopyWithImpl<$Res>
    extends _$AdminProductEventCopyWithImpl<$Res, _$DeleteProductEventImpl>
    implements _$$DeleteProductEventImplCopyWith<$Res> {
  __$$DeleteProductEventImplCopyWithImpl(
    _$DeleteProductEventImpl _value,
    $Res Function(_$DeleteProductEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productId = null}) {
    return _then(
      _$DeleteProductEventImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DeleteProductEventImpl implements DeleteProductEvent {
  const _$DeleteProductEventImpl({required this.productId});

  @override
  final String productId;

  @override
  String toString() {
    return 'AdminProductEvent.deleteProduct(productId: $productId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteProductEventImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, productId);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteProductEventImplCopyWith<_$DeleteProductEventImpl> get copyWith =>
      __$$DeleteProductEventImplCopyWithImpl<_$DeleteProductEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AdminProductFilter? filter) getProducts,
    required TResult Function(String? brandName) filterByBrand,
    required TResult Function(StockStatus status) filterByStockStatus,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(bool silent) refreshProducts,
    required TResult Function(String productId) deleteProduct,
    required TResult Function(String productId) getProductDetail,
  }) {
    return deleteProduct(productId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AdminProductFilter? filter)? getProducts,
    TResult? Function(String? brandName)? filterByBrand,
    TResult? Function(StockStatus status)? filterByStockStatus,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(bool silent)? refreshProducts,
    TResult? Function(String productId)? deleteProduct,
    TResult? Function(String productId)? getProductDetail,
  }) {
    return deleteProduct?.call(productId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AdminProductFilter? filter)? getProducts,
    TResult Function(String? brandName)? filterByBrand,
    TResult Function(StockStatus status)? filterByStockStatus,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(bool silent)? refreshProducts,
    TResult Function(String productId)? deleteProduct,
    TResult Function(String productId)? getProductDetail,
    required TResult orElse(),
  }) {
    if (deleteProduct != null) {
      return deleteProduct(productId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetAdminProductsEvent value) getProducts,
    required TResult Function(FilterByBrandEvent value) filterByBrand,
    required TResult Function(FilterByStockStatusEvent value)
    filterByStockStatus,
    required TResult Function(SearchAdminProductsEvent value) searchProducts,
    required TResult Function(ClearAdminSearchEvent value) clearSearch,
    required TResult Function(RefreshAdminProductsEvent value) refreshProducts,
    required TResult Function(DeleteProductEvent value) deleteProduct,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
  }) {
    return deleteProduct(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetAdminProductsEvent value)? getProducts,
    TResult? Function(FilterByBrandEvent value)? filterByBrand,
    TResult? Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult? Function(SearchAdminProductsEvent value)? searchProducts,
    TResult? Function(ClearAdminSearchEvent value)? clearSearch,
    TResult? Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult? Function(DeleteProductEvent value)? deleteProduct,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
  }) {
    return deleteProduct?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetAdminProductsEvent value)? getProducts,
    TResult Function(FilterByBrandEvent value)? filterByBrand,
    TResult Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult Function(SearchAdminProductsEvent value)? searchProducts,
    TResult Function(ClearAdminSearchEvent value)? clearSearch,
    TResult Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult Function(DeleteProductEvent value)? deleteProduct,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    required TResult orElse(),
  }) {
    if (deleteProduct != null) {
      return deleteProduct(this);
    }
    return orElse();
  }
}

abstract class DeleteProductEvent implements AdminProductEvent {
  const factory DeleteProductEvent({required final String productId}) =
      _$DeleteProductEventImpl;

  String get productId;

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteProductEventImplCopyWith<_$DeleteProductEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetProductDetailEventImplCopyWith<$Res> {
  factory _$$GetProductDetailEventImplCopyWith(
    _$GetProductDetailEventImpl value,
    $Res Function(_$GetProductDetailEventImpl) then,
  ) = __$$GetProductDetailEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String productId});
}

/// @nodoc
class __$$GetProductDetailEventImplCopyWithImpl<$Res>
    extends _$AdminProductEventCopyWithImpl<$Res, _$GetProductDetailEventImpl>
    implements _$$GetProductDetailEventImplCopyWith<$Res> {
  __$$GetProductDetailEventImplCopyWithImpl(
    _$GetProductDetailEventImpl _value,
    $Res Function(_$GetProductDetailEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productId = null}) {
    return _then(
      _$GetProductDetailEventImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GetProductDetailEventImpl implements GetProductDetailEvent {
  const _$GetProductDetailEventImpl({required this.productId});

  @override
  final String productId;

  @override
  String toString() {
    return 'AdminProductEvent.getProductDetail(productId: $productId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetProductDetailEventImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, productId);

  /// Create a copy of AdminProductEvent
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
    required TResult Function(AdminProductFilter? filter) getProducts,
    required TResult Function(String? brandName) filterByBrand,
    required TResult Function(StockStatus status) filterByStockStatus,
    required TResult Function(String query) searchProducts,
    required TResult Function() clearSearch,
    required TResult Function(bool silent) refreshProducts,
    required TResult Function(String productId) deleteProduct,
    required TResult Function(String productId) getProductDetail,
  }) {
    return getProductDetail(productId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AdminProductFilter? filter)? getProducts,
    TResult? Function(String? brandName)? filterByBrand,
    TResult? Function(StockStatus status)? filterByStockStatus,
    TResult? Function(String query)? searchProducts,
    TResult? Function()? clearSearch,
    TResult? Function(bool silent)? refreshProducts,
    TResult? Function(String productId)? deleteProduct,
    TResult? Function(String productId)? getProductDetail,
  }) {
    return getProductDetail?.call(productId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AdminProductFilter? filter)? getProducts,
    TResult Function(String? brandName)? filterByBrand,
    TResult Function(StockStatus status)? filterByStockStatus,
    TResult Function(String query)? searchProducts,
    TResult Function()? clearSearch,
    TResult Function(bool silent)? refreshProducts,
    TResult Function(String productId)? deleteProduct,
    TResult Function(String productId)? getProductDetail,
    required TResult orElse(),
  }) {
    if (getProductDetail != null) {
      return getProductDetail(productId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetAdminProductsEvent value) getProducts,
    required TResult Function(FilterByBrandEvent value) filterByBrand,
    required TResult Function(FilterByStockStatusEvent value)
    filterByStockStatus,
    required TResult Function(SearchAdminProductsEvent value) searchProducts,
    required TResult Function(ClearAdminSearchEvent value) clearSearch,
    required TResult Function(RefreshAdminProductsEvent value) refreshProducts,
    required TResult Function(DeleteProductEvent value) deleteProduct,
    required TResult Function(GetProductDetailEvent value) getProductDetail,
  }) {
    return getProductDetail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetAdminProductsEvent value)? getProducts,
    TResult? Function(FilterByBrandEvent value)? filterByBrand,
    TResult? Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult? Function(SearchAdminProductsEvent value)? searchProducts,
    TResult? Function(ClearAdminSearchEvent value)? clearSearch,
    TResult? Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult? Function(DeleteProductEvent value)? deleteProduct,
    TResult? Function(GetProductDetailEvent value)? getProductDetail,
  }) {
    return getProductDetail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetAdminProductsEvent value)? getProducts,
    TResult Function(FilterByBrandEvent value)? filterByBrand,
    TResult Function(FilterByStockStatusEvent value)? filterByStockStatus,
    TResult Function(SearchAdminProductsEvent value)? searchProducts,
    TResult Function(ClearAdminSearchEvent value)? clearSearch,
    TResult Function(RefreshAdminProductsEvent value)? refreshProducts,
    TResult Function(DeleteProductEvent value)? deleteProduct,
    TResult Function(GetProductDetailEvent value)? getProductDetail,
    required TResult orElse(),
  }) {
    if (getProductDetail != null) {
      return getProductDetail(this);
    }
    return orElse();
  }
}

abstract class GetProductDetailEvent implements AdminProductEvent {
  const factory GetProductDetailEvent({required final String productId}) =
      _$GetProductDetailEventImpl;

  String get productId;

  /// Create a copy of AdminProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetProductDetailEventImplCopyWith<_$GetProductDetailEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}
