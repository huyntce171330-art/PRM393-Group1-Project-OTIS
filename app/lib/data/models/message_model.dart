import 'package:frontend_otis/domain/entities/message.dart';
import 'package:frontend_otis/domain/entities/chat_room.dart';
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

/// Data model for Message entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
/// Includes custom boolean converter and nullable image_url handling.
@JsonSerializable()
class MessageModel {
  const MessageModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    this.imageUrl,
    required this.isRead,
    required this.createdAt,
  });

  /// Unique identifier for the message
  final String id;

  /// Chat room ID this message belongs to
  final String roomId;

  /// User ID of the message sender
  final String senderId;

  /// Message content (text)
  final String content;

  /// Optional image URL for image messages (can be null for text-only messages)
  final String? imageUrl;

  /// Whether the message has been read by the recipient (mapped from 0/1)
  @BoolFromIntConverter()
  final bool isRead;

  /// When the message was created
  final DateTime createdAt;

  /// Factory constructor to create MessageModel from JSON.
  /// Implements defensive parsing to handle null values and invalid data.
  /// Special handling for nullable image_url field.
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: _parseMessageId(json['message_id']),
      roomId: _parseRoomId(json['room_id']),
      senderId: _parseSenderId(json['sender_id']),
      content: _parseString(json['content'], defaultValue: ''),
      imageUrl: _parseNullableString(json['image_url']),
      isRead: _parseBoolFromInt(json['is_read'], defaultValue: false),
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  /// Convert MessageModel to JSON for API requests.
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  /// Convert MessageModel to domain Message entity.
  Message toDomain() {
    return Message(
      id: id,
      roomId: roomId,
      senderId: senderId,
      content: content,
      imageUrl: imageUrl,
      isRead: isRead,
      createdAt: createdAt,
    );
  }

  /// Create MessageModel from domain Message entity.
  factory MessageModel.fromDomain(Message message) {
    return MessageModel(
      id: message.id,
      roomId: message.roomId,
      senderId: message.senderId,
      content: message.content,
      imageUrl: message.imageUrl,
      isRead: message.isRead,
      createdAt: message.createdAt,
    );
  }

  /// Parse message_id from JSON to String with defensive handling.
  static String _parseMessageId(dynamic value) {
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

  /// Parse room_id from JSON to String with defensive handling.
  static String _parseRoomId(dynamic value) {
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

  /// Parse sender_id from JSON to String with defensive handling.
  static String _parseSenderId(dynamic value) {
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

  /// Parse nullable string values (returns null if value is null or empty).
  static String? _parseNullableString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    // Convert other types to string, but return null if result is empty
    final stringValue = value.toString().trim();
    return stringValue.isEmpty ? null : stringValue;
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

/// Data model for ChatRoom entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
@JsonSerializable()
class ChatRoomModel {
  const ChatRoomModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Unique identifier for the chat room
  final String id;

  /// User ID associated with this chat room
  final String userId;

  /// Current status of the chat room
  final String status;

  /// When the chat room was created
  final DateTime createdAt;

  /// When the chat room was last updated
  final DateTime updatedAt;

  /// Factory constructor to create ChatRoomModel from JSON.
  /// Implements defensive parsing to handle null values and invalid data.
  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: _parseRoomId(json['room_id']),
      userId: _parseUserId(json['user_id']),
      status: _parseString(json['status'], defaultValue: 'open'),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  /// Convert ChatRoomModel to JSON for API requests.
  Map<String, dynamic> toJson() => _$ChatRoomModelToJson(this);

  /// Convert ChatRoomModel to domain ChatRoom entity.
  ChatRoom toDomain() {
    return ChatRoom(
      id: id,
      userId: userId,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create ChatRoomModel from domain ChatRoom entity.
  factory ChatRoomModel.fromDomain(ChatRoom chatRoom) {
    return ChatRoomModel(
      id: chatRoom.id,
      userId: chatRoom.userId,
      status: chatRoom.status,
      createdAt: chatRoom.createdAt,
      updatedAt: chatRoom.updatedAt,
    );
  }

  /// Parse room_id from JSON to String with defensive handling.
  static String _parseRoomId(dynamic value) {
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

/// Shared BoolFromIntConverter is now in lib/core/utils/json_converters.dart