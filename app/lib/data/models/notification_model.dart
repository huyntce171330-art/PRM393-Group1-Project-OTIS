import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

/// Data model for Notification entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
@JsonSerializable(includeIfNull: false)
class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.userId,
    required this.createdAt,
  });

  /// Unique identifier for the notification
  @JsonKey(name: 'notification_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String id;

  /// Notification title
  @JsonKey(fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String title;

  /// Notification body/content
  @JsonKey(fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String body;

  /// Whether the notification has been read (mapped from 0/1)
  @JsonKey(name: 'is_read', fromJson: safeBoolFromJson, toJson: safeBoolToJson)
  final bool isRead;

  /// User ID this notification belongs to
  @JsonKey(name: 'user_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String userId;

  /// When the notification was created
  @JsonKey(name: 'created_at', fromJson: safeDateTimeFromJson, toJson: safeDateTimeToJson)
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, title, body, isRead, userId, createdAt];

  /// Factory constructor using generated code from json_annotation
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  /// Convert NotificationModel to JSON for API requests.
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  /// Convert NotificationModel to domain Notification entity.
  Notification toDomain() {
    return Notification(
      id: id,
      title: title,
      body: body,
      isRead: isRead,
      userId: userId,
      createdAt: createdAt,
    );
  }

  /// Create NotificationModel from domain Notification entity.
  factory NotificationModel.fromDomain(Notification notification) {
    return NotificationModel(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      isRead: notification.isRead,
      userId: notification.userId,
      createdAt: notification.createdAt,
    );
  }
}
