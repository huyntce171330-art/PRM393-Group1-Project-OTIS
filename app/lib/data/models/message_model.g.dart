// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  id: safeStringFromJson(json['message_id']),
  roomId: safeStringFromJson(json['room_id']),
  senderId: safeStringFromJson(json['sender_id']),
  content: safeStringFromJson(json['content']),
  imageUrl: nullableSafeStringFromJson(json['image_url']),
  isRead: safeBoolFromJson(json['is_read']),
  createdAt: safeDateTimeFromJson(json['created_at']),
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'message_id': safeStringToJson(instance.id),
      'room_id': safeStringToJson(instance.roomId),
      'sender_id': safeStringToJson(instance.senderId),
      'content': safeStringToJson(instance.content),
      if (nullableSafeStringToJson(instance.imageUrl) case final value?)
        'image_url': value,
      'is_read': safeBoolToJson(instance.isRead),
      'created_at': safeDateTimeToJson(instance.createdAt),
    };

ChatRoomModel _$ChatRoomModelFromJson(Map<String, dynamic> json) =>
    ChatRoomModel(
      id: safeStringFromJson(json['room_id']),
      userId: safeStringFromJson(json['user_id']),
      status: safeStringFromJson(json['status']),
      createdAt: safeDateTimeFromJson(json['created_at']),
      updatedAt: safeDateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$ChatRoomModelToJson(ChatRoomModel instance) =>
    <String, dynamic>{
      'room_id': safeStringToJson(instance.id),
      'user_id': safeStringToJson(instance.userId),
      'status': safeStringToJson(instance.status),
      'created_at': safeDateTimeToJson(instance.createdAt),
      'updated_at': safeDateTimeToJson(instance.updatedAt),
    };
