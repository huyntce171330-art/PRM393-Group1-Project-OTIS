// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tire_spec.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TireSpec {
  /// Unique identifier for the tire specification
  String get id => throw _privateConstructorUsedError;

  /// Tire width in millimeters
  @Assert('width > 0', 'Width must be greater than 0')
  int get width => throw _privateConstructorUsedError;

  /// Tire aspect ratio (height/width percentage)
  @Assert('aspectRatio > 0', 'Aspect ratio must be greater than 0')
  int get aspectRatio => throw _privateConstructorUsedError;

  /// Rim diameter in inches
  @Assert('rimDiameter > 0', 'Rim diameter must be greater than 0')
  int get rimDiameter => throw _privateConstructorUsedError;

  /// Create a copy of TireSpec
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TireSpecCopyWith<TireSpec> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TireSpecCopyWith<$Res> {
  factory $TireSpecCopyWith(TireSpec value, $Res Function(TireSpec) then) =
      _$TireSpecCopyWithImpl<$Res, TireSpec>;
  @useResult
  $Res call({
    String id,
    @Assert('width > 0', 'Width must be greater than 0') int width,
    @Assert('aspectRatio > 0', 'Aspect ratio must be greater than 0')
    int aspectRatio,
    @Assert('rimDiameter > 0', 'Rim diameter must be greater than 0')
    int rimDiameter,
  });
}

/// @nodoc
class _$TireSpecCopyWithImpl<$Res, $Val extends TireSpec>
    implements $TireSpecCopyWith<$Res> {
  _$TireSpecCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TireSpec
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? width = null,
    Object? aspectRatio = null,
    Object? rimDiameter = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            width: null == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as int,
            aspectRatio: null == aspectRatio
                ? _value.aspectRatio
                : aspectRatio // ignore: cast_nullable_to_non_nullable
                      as int,
            rimDiameter: null == rimDiameter
                ? _value.rimDiameter
                : rimDiameter // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TireSpecImplCopyWith<$Res>
    implements $TireSpecCopyWith<$Res> {
  factory _$$TireSpecImplCopyWith(
    _$TireSpecImpl value,
    $Res Function(_$TireSpecImpl) then,
  ) = __$$TireSpecImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @Assert('width > 0', 'Width must be greater than 0') int width,
    @Assert('aspectRatio > 0', 'Aspect ratio must be greater than 0')
    int aspectRatio,
    @Assert('rimDiameter > 0', 'Rim diameter must be greater than 0')
    int rimDiameter,
  });
}

/// @nodoc
class __$$TireSpecImplCopyWithImpl<$Res>
    extends _$TireSpecCopyWithImpl<$Res, _$TireSpecImpl>
    implements _$$TireSpecImplCopyWith<$Res> {
  __$$TireSpecImplCopyWithImpl(
    _$TireSpecImpl _value,
    $Res Function(_$TireSpecImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TireSpec
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? width = null,
    Object? aspectRatio = null,
    Object? rimDiameter = null,
  }) {
    return _then(
      _$TireSpecImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        width: null == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int,
        aspectRatio: null == aspectRatio
            ? _value.aspectRatio
            : aspectRatio // ignore: cast_nullable_to_non_nullable
                  as int,
        rimDiameter: null == rimDiameter
            ? _value.rimDiameter
            : rimDiameter // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$TireSpecImpl extends _TireSpec {
  const _$TireSpecImpl({
    required this.id,
    @Assert('width > 0', 'Width must be greater than 0') required this.width,
    @Assert('aspectRatio > 0', 'Aspect ratio must be greater than 0')
    required this.aspectRatio,
    @Assert('rimDiameter > 0', 'Rim diameter must be greater than 0')
    required this.rimDiameter,
  }) : super._();

  /// Unique identifier for the tire specification
  @override
  final String id;

  /// Tire width in millimeters
  @override
  @Assert('width > 0', 'Width must be greater than 0')
  final int width;

  /// Tire aspect ratio (height/width percentage)
  @override
  @Assert('aspectRatio > 0', 'Aspect ratio must be greater than 0')
  final int aspectRatio;

  /// Rim diameter in inches
  @override
  @Assert('rimDiameter > 0', 'Rim diameter must be greater than 0')
  final int rimDiameter;

  @override
  String toString() {
    return 'TireSpec(id: $id, width: $width, aspectRatio: $aspectRatio, rimDiameter: $rimDiameter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TireSpecImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.aspectRatio, aspectRatio) ||
                other.aspectRatio == aspectRatio) &&
            (identical(other.rimDiameter, rimDiameter) ||
                other.rimDiameter == rimDiameter));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, width, aspectRatio, rimDiameter);

  /// Create a copy of TireSpec
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TireSpecImplCopyWith<_$TireSpecImpl> get copyWith =>
      __$$TireSpecImplCopyWithImpl<_$TireSpecImpl>(this, _$identity);
}

abstract class _TireSpec extends TireSpec {
  const factory _TireSpec({
    required final String id,
    @Assert('width > 0', 'Width must be greater than 0')
    required final int width,
    @Assert('aspectRatio > 0', 'Aspect ratio must be greater than 0')
    required final int aspectRatio,
    @Assert('rimDiameter > 0', 'Rim diameter must be greater than 0')
    required final int rimDiameter,
  }) = _$TireSpecImpl;
  const _TireSpec._() : super._();

  /// Unique identifier for the tire specification
  @override
  String get id;

  /// Tire width in millimeters
  @override
  @Assert('width > 0', 'Width must be greater than 0')
  int get width;

  /// Tire aspect ratio (height/width percentage)
  @override
  @Assert('aspectRatio > 0', 'Aspect ratio must be greater than 0')
  int get aspectRatio;

  /// Rim diameter in inches
  @override
  @Assert('rimDiameter > 0', 'Rim diameter must be greater than 0')
  int get rimDiameter;

  /// Create a copy of TireSpec
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TireSpecImplCopyWith<_$TireSpecImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
