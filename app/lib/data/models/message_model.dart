import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required int messageId,
    required int roomId,
    required int senderId,
    String? content,
    String? imageUrl,
    required bool isRead,
    required DateTime createdAt,
  }) : super(
         messageId: messageId,
         roomId: roomId,
         senderId: senderId,
         content: content,
         imageUrl: imageUrl,
         isRead: isRead,
         createdAt: createdAt,
       );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['message_id'],
      roomId: json['room_id'],
      senderId: json['sender_id'],
      content: json['content'],
      imageUrl: json['image_url'],
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'room_id': roomId,
      'sender_id': senderId,
      'content': content,
      'image_url': imageUrl,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
