import '../../domain/entities/chat_room.dart';

class ChatRoomModel extends ChatRoom {
  const ChatRoomModel({
    required int roomId,
    required int userId,
    required String status,
    required DateTime updatedAt,
  }) : super(
         roomId: roomId,
         userId: userId,
         status: status,
         updatedAt: updatedAt,
       );

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      roomId: json['room_id'],
      userId: json['user_id'],
      status: json['status'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'user_id': userId,
      'status': status,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
