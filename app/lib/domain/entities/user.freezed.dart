// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$User {
  /// Unique identifier for the user
  String get id => throw _privateConstructorUsedError;

  /// User's phone number
  String get phone => throw _privateConstructorUsedError;

  /// User's full name
  String get fullName => throw _privateConstructorUsedError;

  /// User's address
  String get address => throw _privateConstructorUsedError;

  /// User's shop name (if applicable)
  String get shopName => throw _privateConstructorUsedError;

  /// URL to user's avatar image
  String get avatarUrl => throw _privateConstructorUsedError;

  /// User's role in the system (nullable for dynamic roles from DB)
  UserRole? get role => throw _privateConstructorUsedError;

  /// User's current status
  enums.UserStatus get status => throw _privateConstructorUsedError;

  /// When the user was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    String id,
    String phone,
    String fullName,
    String address,
    String shopName,
    String avatarUrl,
    UserRole? role,
    enums.UserStatus status,
    DateTime createdAt,
  });

  $UserRoleCopyWith<$Res>? get role;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? fullName = null,
    Object? address = null,
    Object? shopName = null,
    Object? avatarUrl = null,
    Object? role = freezed,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            shopName: null == shopName
                ? _value.shopName
                : shopName // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarUrl: null == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            role: freezed == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as UserRole?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as enums.UserStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserRoleCopyWith<$Res>? get role {
    if (_value.role == null) {
      return null;
    }

    return $UserRoleCopyWith<$Res>(_value.role!, (value) {
      return _then(_value.copyWith(role: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String phone,
    String fullName,
    String address,
    String shopName,
    String avatarUrl,
    UserRole? role,
    enums.UserStatus status,
    DateTime createdAt,
  });

  @override
  $UserRoleCopyWith<$Res>? get role;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? fullName = null,
    Object? address = null,
    Object? shopName = null,
    Object? avatarUrl = null,
    Object? role = freezed,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$UserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        shopName: null == shopName
            ? _value.shopName
            : shopName // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: null == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        role: freezed == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as UserRole?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as enums.UserStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$UserImpl extends _User {
  const _$UserImpl({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.address,
    required this.shopName,
    required this.avatarUrl,
    this.role,
    required this.status,
    required this.createdAt,
  }) : super._();

  /// Unique identifier for the user
  @override
  final String id;

  /// User's phone number
  @override
  final String phone;

  /// User's full name
  @override
  final String fullName;

  /// User's address
  @override
  final String address;

  /// User's shop name (if applicable)
  @override
  final String shopName;

  /// URL to user's avatar image
  @override
  final String avatarUrl;

  /// User's role in the system (nullable for dynamic roles from DB)
  @override
  final UserRole? role;

  /// User's current status
  @override
  final enums.UserStatus status;

  /// When the user was created
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'User(id: $id, phone: $phone, fullName: $fullName, address: $address, shopName: $shopName, avatarUrl: $avatarUrl, role: $role, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.shopName, shopName) ||
                other.shopName == shopName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    phone,
    fullName,
    address,
    shopName,
    avatarUrl,
    role,
    status,
    createdAt,
  );

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);
}

abstract class _User extends User {
  const factory _User({
    required final String id,
    required final String phone,
    required final String fullName,
    required final String address,
    required final String shopName,
    required final String avatarUrl,
    final UserRole? role,
    required final enums.UserStatus status,
    required final DateTime createdAt,
  }) = _$UserImpl;
  const _User._() : super._();

  /// Unique identifier for the user
  @override
  String get id;

  /// User's phone number
  @override
  String get phone;

  /// User's full name
  @override
  String get fullName;

  /// User's address
  @override
  String get address;

  /// User's shop name (if applicable)
  @override
  String get shopName;

  /// URL to user's avatar image
  @override
  String get avatarUrl;

  /// User's role in the system (nullable for dynamic roles from DB)
  @override
  UserRole? get role;

  /// User's current status
  @override
  enums.UserStatus get status;

  /// When the user was created
  @override
  DateTime get createdAt;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
