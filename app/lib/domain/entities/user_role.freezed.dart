// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_role.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserRole {
  /// Unique identifier for the role
  @Assert('id.isNotEmpty', 'Role ID cannot be empty')
  String get id => throw _privateConstructorUsedError;

  /// Role name (e.g., 'admin', 'customer')
  @Assert('name.isNotEmpty', 'Role name cannot be empty')
  String get name => throw _privateConstructorUsedError;

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRoleCopyWith<UserRole> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRoleCopyWith<$Res> {
  factory $UserRoleCopyWith(UserRole value, $Res Function(UserRole) then) =
      _$UserRoleCopyWithImpl<$Res, UserRole>;
  @useResult
  $Res call({
    @Assert('id.isNotEmpty', 'Role ID cannot be empty') String id,
    @Assert('name.isNotEmpty', 'Role name cannot be empty') String name,
  });
}

/// @nodoc
class _$UserRoleCopyWithImpl<$Res, $Val extends UserRole>
    implements $UserRoleCopyWith<$Res> {
  _$UserRoleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserRoleImplCopyWith<$Res>
    implements $UserRoleCopyWith<$Res> {
  factory _$$UserRoleImplCopyWith(
    _$UserRoleImpl value,
    $Res Function(_$UserRoleImpl) then,
  ) = __$$UserRoleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @Assert('id.isNotEmpty', 'Role ID cannot be empty') String id,
    @Assert('name.isNotEmpty', 'Role name cannot be empty') String name,
  });
}

/// @nodoc
class __$$UserRoleImplCopyWithImpl<$Res>
    extends _$UserRoleCopyWithImpl<$Res, _$UserRoleImpl>
    implements _$$UserRoleImplCopyWith<$Res> {
  __$$UserRoleImplCopyWithImpl(
    _$UserRoleImpl _value,
    $Res Function(_$UserRoleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$UserRoleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UserRoleImpl extends _UserRole {
  const _$UserRoleImpl({
    @Assert('id.isNotEmpty', 'Role ID cannot be empty') required this.id,
    @Assert('name.isNotEmpty', 'Role name cannot be empty') required this.name,
  }) : super._();

  /// Unique identifier for the role
  @override
  @Assert('id.isNotEmpty', 'Role ID cannot be empty')
  final String id;

  /// Role name (e.g., 'admin', 'customer')
  @override
  @Assert('name.isNotEmpty', 'Role name cannot be empty')
  final String name;

  @override
  String toString() {
    return 'UserRole(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRoleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRoleImplCopyWith<_$UserRoleImpl> get copyWith =>
      __$$UserRoleImplCopyWithImpl<_$UserRoleImpl>(this, _$identity);
}

abstract class _UserRole extends UserRole {
  const factory _UserRole({
    @Assert('id.isNotEmpty', 'Role ID cannot be empty')
    required final String id,
    @Assert('name.isNotEmpty', 'Role name cannot be empty')
    required final String name,
  }) = _$UserRoleImpl;
  const _UserRole._() : super._();

  /// Unique identifier for the role
  @override
  @Assert('id.isNotEmpty', 'Role ID cannot be empty')
  String get id;

  /// Role name (e.g., 'admin', 'customer')
  @override
  @Assert('name.isNotEmpty', 'Role name cannot be empty')
  String get name;

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRoleImplCopyWith<_$UserRoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
