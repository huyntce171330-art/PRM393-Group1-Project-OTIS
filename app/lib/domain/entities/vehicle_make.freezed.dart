// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_make.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$VehicleMake {
  /// Unique identifier for the vehicle make
  String get id => throw _privateConstructorUsedError;

  /// Vehicle make name
  String get name => throw _privateConstructorUsedError;

  /// URL to vehicle make logo image
  String get logoUrl => throw _privateConstructorUsedError;

  /// Create a copy of VehicleMake
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleMakeCopyWith<VehicleMake> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleMakeCopyWith<$Res> {
  factory $VehicleMakeCopyWith(
    VehicleMake value,
    $Res Function(VehicleMake) then,
  ) = _$VehicleMakeCopyWithImpl<$Res, VehicleMake>;
  @useResult
  $Res call({String id, String name, String logoUrl});
}

/// @nodoc
class _$VehicleMakeCopyWithImpl<$Res, $Val extends VehicleMake>
    implements $VehicleMakeCopyWith<$Res> {
  _$VehicleMakeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleMake
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? logoUrl = null}) {
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
            logoUrl: null == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleMakeImplCopyWith<$Res>
    implements $VehicleMakeCopyWith<$Res> {
  factory _$$VehicleMakeImplCopyWith(
    _$VehicleMakeImpl value,
    $Res Function(_$VehicleMakeImpl) then,
  ) = __$$VehicleMakeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String logoUrl});
}

/// @nodoc
class __$$VehicleMakeImplCopyWithImpl<$Res>
    extends _$VehicleMakeCopyWithImpl<$Res, _$VehicleMakeImpl>
    implements _$$VehicleMakeImplCopyWith<$Res> {
  __$$VehicleMakeImplCopyWithImpl(
    _$VehicleMakeImpl _value,
    $Res Function(_$VehicleMakeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VehicleMake
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? logoUrl = null}) {
    return _then(
      _$VehicleMakeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        logoUrl: null == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$VehicleMakeImpl extends _VehicleMake {
  const _$VehicleMakeImpl({
    required this.id,
    required this.name,
    required this.logoUrl,
  }) : super._();

  /// Unique identifier for the vehicle make
  @override
  final String id;

  /// Vehicle make name
  @override
  final String name;

  /// URL to vehicle make logo image
  @override
  final String logoUrl;

  @override
  String toString() {
    return 'VehicleMake(id: $id, name: $name, logoUrl: $logoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleMakeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, logoUrl);

  /// Create a copy of VehicleMake
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleMakeImplCopyWith<_$VehicleMakeImpl> get copyWith =>
      __$$VehicleMakeImplCopyWithImpl<_$VehicleMakeImpl>(this, _$identity);
}

abstract class _VehicleMake extends VehicleMake {
  const factory _VehicleMake({
    required final String id,
    required final String name,
    required final String logoUrl,
  }) = _$VehicleMakeImpl;
  const _VehicleMake._() : super._();

  /// Unique identifier for the vehicle make
  @override
  String get id;

  /// Vehicle make name
  @override
  String get name;

  /// URL to vehicle make logo image
  @override
  String get logoUrl;

  /// Create a copy of VehicleMake
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleMakeImplCopyWith<_$VehicleMakeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
