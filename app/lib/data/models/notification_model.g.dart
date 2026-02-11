// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: safeStringFromJson(json['notification_id']),
      title: safeStringFromJson(json['title']),
      body: safeStringFromJson(json['body']),
      isRead: safeBoolFromJson(json['is_read']),
      userId: safeStringFromJson(json['user_id']),
      createdAt: safeDateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'notification_id': safeStringToJson(instance.id),
      'title': safeStringToJson(instance.title),
      'body': safeStringToJson(instance.body),
      'is_read': safeBoolToJson(instance.isRead),
      'user_id': safeStringToJson(instance.userId),
      'created_at': safeDateTimeToJson(instance.createdAt),
    };
