// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Order {
  /// Unique identifier for the order
  String get id => throw _privateConstructorUsedError;

  /// Order code (human-readable identifier)
  String get code => throw _privateConstructorUsedError;

  /// Total amount of the order
  double get totalAmount => throw _privateConstructorUsedError;

  /// Current status of the order
  OrderStatus get status => throw _privateConstructorUsedError;

  /// Shipping address for the order
  String get shippingAddress => throw _privateConstructorUsedError;

  /// When the order was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// List of order items
  List<OrderItem> get items => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call({
    String id,
    String code,
    double totalAmount,
    OrderStatus status,
    String shippingAddress,
    DateTime createdAt,
    List<OrderItem> items,
  });
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? shippingAddress = null,
    Object? createdAt = null,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            shippingAddress: null == shippingAddress
                ? _value.shippingAddress
                : shippingAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
    _$OrderImpl value,
    $Res Function(_$OrderImpl) then,
  ) = __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String code,
    double totalAmount,
    OrderStatus status,
    String shippingAddress,
    DateTime createdAt,
    List<OrderItem> items,
  });
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
    _$OrderImpl _value,
    $Res Function(_$OrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? shippingAddress = null,
    Object? createdAt = null,
    Object? items = null,
  }) {
    return _then(
      _$OrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        shippingAddress: null == shippingAddress
            ? _value.shippingAddress
            : shippingAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItem>,
      ),
    );
  }
}

/// @nodoc

class _$OrderImpl extends _Order {
  const _$OrderImpl({
    required this.id,
    required this.code,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.createdAt,
    required final List<OrderItem> items,
  }) : _items = items,
       super._();

  /// Unique identifier for the order
  @override
  final String id;

  /// Order code (human-readable identifier)
  @override
  final String code;

  /// Total amount of the order
  @override
  final double totalAmount;

  /// Current status of the order
  @override
  final OrderStatus status;

  /// Shipping address for the order
  @override
  final String shippingAddress;

  /// When the order was created
  @override
  final DateTime createdAt;

  /// List of order items
  final List<OrderItem> _items;

  /// List of order items
  @override
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'Order(id: $id, code: $code, totalAmount: $totalAmount, status: $status, shippingAddress: $shippingAddress, createdAt: $createdAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    totalAmount,
    status,
    shippingAddress,
    createdAt,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);
}

abstract class _Order extends Order {
  const factory _Order({
    required final String id,
    required final String code,
    required final double totalAmount,
    required final OrderStatus status,
    required final String shippingAddress,
    required final DateTime createdAt,
    required final List<OrderItem> items,
  }) = _$OrderImpl;
  const _Order._() : super._();

  /// Unique identifier for the order
  @override
  String get id;

  /// Order code (human-readable identifier)
  @override
  String get code;

  /// Total amount of the order
  @override
  double get totalAmount;

  /// Current status of the order
  @override
  OrderStatus get status;

  /// Shipping address for the order
  @override
  String get shippingAddress;

  /// When the order was created
  @override
  DateTime get createdAt;

  /// List of order items
  @override
  List<OrderItem> get items;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
