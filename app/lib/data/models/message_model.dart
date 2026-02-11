import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/utils/json_converters.dart';
import 'package:frontend_otis/domain/entities/chat_room.dart';
import 'package:frontend_otis/domain/entities/message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

/// Data model for Message entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
@JsonSerializable(includeIfNull: false)
class MessageModel extends Equatable {
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
  @JsonKey(name: 'message_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String id;

  /// Chat room ID this message belongs to
  @JsonKey(name: 'room_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String roomId;

  /// User ID of the message sender
  @JsonKey(name: 'sender_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String senderId;

  /// Message content (text)
  @JsonKey(fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String content;

  /// Optional image URL for image messages (can be null for text-only messages)
  @JsonKey(name: 'image_url', fromJson: nullableSafeStringFromJson, toJson: nullableSafeStringToJson)
  final String? imageUrl;

  /// Whether the message has been read by the recipient (mapped from 0/1)
  @JsonKey(name: 'is_read', fromJson: safeBoolFromJson, toJson: safeBoolToJson)
  final bool isRead;

  /// When the message was created
  @JsonKey(name: 'created_at', fromJson: safeDateTimeFromJson, toJson: safeDateTimeToJson)
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        roomId,
        senderId,
        content,
        imageUrl,
        isRead,
        createdAt,
      ];

  /// Factory constructor using generated code from json_annotation
  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

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
}

/// Data model for ChatRoom entity with JSON serialization support.
/// Handles conversion between JSON API responses and domain entities.
@JsonSerializable(includeIfNull: false)
class ChatRoomModel extends Equatable {
  const ChatRoomModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Unique identifier for the chat room
  @JsonKey(name: 'room_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String id;

  /// User ID associated with this chat room
  @JsonKey(name: 'user_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String userId;

  /// Current status of the chat room
  @JsonKey(fromJson: safeStringFromJson, toJson: safeStringToJson)
  final String status;

  /// When the chat room was created
  @JsonKey(name: 'created_at', fromJson: safeDateTimeFromJson, toJson: safeDateTimeToJson)
  final DateTime createdAt;

  /// When the chat room was last updated
  @JsonKey(name: 'updated_at', fromJson: safeDateTimeFromJson, toJson: safeDateTimeToJson)
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        id,
        userId,
        status,
        createdAt,
        updatedAt,
      ];

  /// Factory constructor using generated code from json_annotation
  factory ChatRoomModel.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomModelFromJson(json);

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
}
