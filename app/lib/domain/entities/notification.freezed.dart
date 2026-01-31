// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Notification {
  /// Unique identifier for the notification
  String get id => throw _privateConstructorUsedError;

  /// Notification title
  String get title => throw _privateConstructorUsedError;

  /// Notification body/content
  String get body => throw _privateConstructorUsedError;

  /// Whether the notification has been read
  bool get isRead => throw _privateConstructorUsedError;

  /// User ID this notification belongs to
  String get userId => throw _privateConstructorUsedError;

  /// When the notification was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Notification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationCopyWith<Notification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationCopyWith<$Res> {
  factory $NotificationCopyWith(
    Notification value,
    $Res Function(Notification) then,
  ) = _$NotificationCopyWithImpl<$Res, Notification>;
  @useResult
  $Res call({
    String id,
    String title,
    String body,
    bool isRead,
    String userId,
    DateTime createdAt,
  });
}

/// @nodoc
class _$NotificationCopyWithImpl<$Res, $Val extends Notification>
    implements $NotificationCopyWith<$Res> {
  _$NotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Notification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? isRead = null,
    Object? userId = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationImplCopyWith<$Res>
    implements $NotificationCopyWith<$Res> {
  factory _$$NotificationImplCopyWith(
    _$NotificationImpl value,
    $Res Function(_$NotificationImpl) then,
  ) = __$$NotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String body,
    bool isRead,
    String userId,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$NotificationImplCopyWithImpl<$Res>
    extends _$NotificationCopyWithImpl<$Res, _$NotificationImpl>
    implements _$$NotificationImplCopyWith<$Res> {
  __$$NotificationImplCopyWithImpl(
    _$NotificationImpl _value,
    $Res Function(_$NotificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Notification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? isRead = null,
    Object? userId = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$NotificationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$NotificationImpl extends _Notification {
  const _$NotificationImpl({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.userId,
    required this.createdAt,
  }) : super._();

  /// Unique identifier for the notification
  @override
  final String id;

  /// Notification title
  @override
  final String title;

  /// Notification body/content
  @override
  final String body;

  /// Whether the notification has been read
  @override
  final bool isRead;

  /// User ID this notification belongs to
  @override
  final String userId;

  /// When the notification was created
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Notification(id: $id, title: $title, body: $body, isRead: $isRead, userId: $userId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, body, isRead, userId, createdAt);

  /// Create a copy of Notification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationImplCopyWith<_$NotificationImpl> get copyWith =>
      __$$NotificationImplCopyWithImpl<_$NotificationImpl>(this, _$identity);
}

abstract class _Notification extends Notification {
  const factory _Notification({
    required final String id,
    required final String title,
    required final String body,
    required final bool isRead,
    required final String userId,
    required final DateTime createdAt,
  }) = _$NotificationImpl;
  const _Notification._() : super._();

  /// Unique identifier for the notification
  @override
  String get id;

  /// Notification title
  @override
  String get title;

  /// Notification body/content
  @override
  String get body;

  /// Whether the notification has been read
  @override
  bool get isRead;

  /// User ID this notification belongs to
  @override
  String get userId;

  /// When the notification was created
  @override
  DateTime get createdAt;

  /// Create a copy of Notification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationImplCopyWith<_$NotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
