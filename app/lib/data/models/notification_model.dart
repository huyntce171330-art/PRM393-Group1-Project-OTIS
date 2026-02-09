import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

/// Data model for Notification entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Includes custom boolean converter for is_read field (0/1 mapping).
@JsonSerializable()
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.userId,
    required this.createdAt,
  });

  /// Unique identifier for the notification
  final String id;

  /// Notification title
  final String title;

  /// Notification body/content
  final String body;

  /// Whether the notification has been read (mapped from 0/1)
  @BoolFromIntConverter()
  final bool isRead;

  /// User ID this notification belongs to
  final String userId;

  /// When the notification was created
  final DateTime createdAt;

  /// Factory constructor to create NotificationModel from JSON.
  /// Implements defensive parsing to handle null values and invalid data.
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: _parseNotificationId(json['notification_id']),
      title: _parseString(json['title'], defaultValue: ''),
      body: _parseString(json['body'], defaultValue: ''),
      isRead: _parseBoolFromInt(json['is_read'], defaultValue: false),
      userId: _parseUserId(json['user_id']),
      createdAt: _parseDateTime(json['created_at']),
    );
  }

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

  /// Parse notification_id from JSON to String with defensive handling.
  static String _parseNotificationId(dynamic value) {
    if (value == null) return '';

    if (value is int) {
      return value.toString();
    }

    if (value is String) {
      return value;
    }

    // Fallback for unexpected types
    return value.toString();
  }

  /// Parse user_id from JSON to String with defensive handling.
  static String _parseUserId(dynamic value) {
    if (value == null) return '';

    if (value is int) {
      return value.toString();
    }

    if (value is String) {
      return value;
    }

    // Fallback for unexpected types
    return value.toString();
  }

  /// Parse string values with null safety and default values.
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;

    if (value is String) {
      return value.trim();
    }

    // Convert other types to string
    return value.toString().trim();
  }

  /// Parse boolean from integer (0/1) with defensive handling.
  static bool _parseBoolFromInt(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;

    if (value is int) {
      return value == 1;
    }

    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == '1' || normalized == 'true') {
        return true;
      }
      if (normalized == '0' || normalized == 'false') {
        return false;
      }
    }

    // Default for unexpected types
    return defaultValue;
  }

  /// Parse created_at from JSON to DateTime with defensive handling.
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }

    // Fallback to current time for invalid date values
    return DateTime.now();
  }
}
