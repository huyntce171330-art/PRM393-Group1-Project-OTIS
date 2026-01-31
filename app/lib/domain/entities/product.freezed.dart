// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Product {
  /// Unique identifier for the product
  String get id => throw _privateConstructorUsedError;

  /// Product SKU (Stock Keeping Unit)
  String get sku => throw _privateConstructorUsedError;

  /// Product name
  String get name => throw _privateConstructorUsedError;

  /// URL to product image
  String get imageUrl => throw _privateConstructorUsedError;

  /// Product brand
  Brand get brand => throw _privateConstructorUsedError;

  /// Vehicle make compatibility
  VehicleMake get vehicleMake => throw _privateConstructorUsedError;

  /// Tire specifications
  TireSpec get tireSpec => throw _privateConstructorUsedError;

  /// Product price
  double get price => throw _privateConstructorUsedError;

  /// Available stock quantity
  int get stockQuantity => throw _privateConstructorUsedError;

  /// Whether the product is active/available
  bool get isActive => throw _privateConstructorUsedError;

  /// When the product was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call({
    String id,
    String sku,
    String name,
    String imageUrl,
    Brand brand,
    VehicleMake vehicleMake,
    TireSpec tireSpec,
    double price,
    int stockQuantity,
    bool isActive,
    DateTime createdAt,
  });

  $BrandCopyWith<$Res> get brand;
  $VehicleMakeCopyWith<$Res> get vehicleMake;
  $TireSpecCopyWith<$Res> get tireSpec;
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sku = null,
    Object? name = null,
    Object? imageUrl = null,
    Object? brand = null,
    Object? vehicleMake = null,
    Object? tireSpec = null,
    Object? price = null,
    Object? stockQuantity = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            sku: null == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            brand: null == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as Brand,
            vehicleMake: null == vehicleMake
                ? _value.vehicleMake
                : vehicleMake // ignore: cast_nullable_to_non_nullable
                      as VehicleMake,
            tireSpec: null == tireSpec
                ? _value.tireSpec
                : tireSpec // ignore: cast_nullable_to_non_nullable
                      as TireSpec,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            stockQuantity: null == stockQuantity
                ? _value.stockQuantity
                : stockQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BrandCopyWith<$Res> get brand {
    return $BrandCopyWith<$Res>(_value.brand, (value) {
      return _then(_value.copyWith(brand: value) as $Val);
    });
  }

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VehicleMakeCopyWith<$Res> get vehicleMake {
    return $VehicleMakeCopyWith<$Res>(_value.vehicleMake, (value) {
      return _then(_value.copyWith(vehicleMake: value) as $Val);
    });
  }

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TireSpecCopyWith<$Res> get tireSpec {
    return $TireSpecCopyWith<$Res>(_value.tireSpec, (value) {
      return _then(_value.copyWith(tireSpec: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
    _$ProductImpl value,
    $Res Function(_$ProductImpl) then,
  ) = __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String sku,
    String name,
    String imageUrl,
    Brand brand,
    VehicleMake vehicleMake,
    TireSpec tireSpec,
    double price,
    int stockQuantity,
    bool isActive,
    DateTime createdAt,
  });

  @override
  $BrandCopyWith<$Res> get brand;
  @override
  $VehicleMakeCopyWith<$Res> get vehicleMake;
  @override
  $TireSpecCopyWith<$Res> get tireSpec;
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
    _$ProductImpl _value,
    $Res Function(_$ProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sku = null,
    Object? name = null,
    Object? imageUrl = null,
    Object? brand = null,
    Object? vehicleMake = null,
    Object? tireSpec = null,
    Object? price = null,
    Object? stockQuantity = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$ProductImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sku: null == sku
            ? _value.sku
            : sku // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        brand: null == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as Brand,
        vehicleMake: null == vehicleMake
            ? _value.vehicleMake
            : vehicleMake // ignore: cast_nullable_to_non_nullable
                  as VehicleMake,
        tireSpec: null == tireSpec
            ? _value.tireSpec
            : tireSpec // ignore: cast_nullable_to_non_nullable
                  as TireSpec,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        stockQuantity: null == stockQuantity
            ? _value.stockQuantity
            : stockQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$ProductImpl extends _Product {
  const _$ProductImpl({
    required this.id,
    required this.sku,
    required this.name,
    required this.imageUrl,
    required this.brand,
    required this.vehicleMake,
    required this.tireSpec,
    required this.price,
    required this.stockQuantity,
    required this.isActive,
    required this.createdAt,
  }) : super._();

  /// Unique identifier for the product
  @override
  final String id;

  /// Product SKU (Stock Keeping Unit)
  @override
  final String sku;

  /// Product name
  @override
  final String name;

  /// URL to product image
  @override
  final String imageUrl;

  /// Product brand
  @override
  final Brand brand;

  /// Vehicle make compatibility
  @override
  final VehicleMake vehicleMake;

  /// Tire specifications
  @override
  final TireSpec tireSpec;

  /// Product price
  @override
  final double price;

  /// Available stock quantity
  @override
  final int stockQuantity;

  /// Whether the product is active/available
  @override
  final bool isActive;

  /// When the product was created
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Product(id: $id, sku: $sku, name: $name, imageUrl: $imageUrl, brand: $brand, vehicleMake: $vehicleMake, tireSpec: $tireSpec, price: $price, stockQuantity: $stockQuantity, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.vehicleMake, vehicleMake) ||
                other.vehicleMake == vehicleMake) &&
            (identical(other.tireSpec, tireSpec) ||
                other.tireSpec == tireSpec) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sku,
    name,
    imageUrl,
    brand,
    vehicleMake,
    tireSpec,
    price,
    stockQuantity,
    isActive,
    createdAt,
  );

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);
}

abstract class _Product extends Product {
  const factory _Product({
    required final String id,
    required final String sku,
    required final String name,
    required final String imageUrl,
    required final Brand brand,
    required final VehicleMake vehicleMake,
    required final TireSpec tireSpec,
    required final double price,
    required final int stockQuantity,
    required final bool isActive,
    required final DateTime createdAt,
  }) = _$ProductImpl;
  const _Product._() : super._();

  /// Unique identifier for the product
  @override
  String get id;

  /// Product SKU (Stock Keeping Unit)
  @override
  String get sku;

  /// Product name
  @override
  String get name;

  /// URL to product image
  @override
  String get imageUrl;

  /// Product brand
  @override
  Brand get brand;

  /// Vehicle make compatibility
  @override
  VehicleMake get vehicleMake;

  /// Tire specifications
  @override
  TireSpec get tireSpec;

  /// Product price
  @override
  double get price;

  /// Available stock quantity
  @override
  int get stockQuantity;

  /// Whether the product is active/available
  @override
  bool get isActive;

  /// When the product was created
  @override
  DateTime get createdAt;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
