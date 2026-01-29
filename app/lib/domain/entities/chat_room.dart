import 'package:equatable/equatable.dart';

class ChatRoom extends Equatable {
  final int roomId;
  final int userId;
  final String status;
  final DateTime updatedAt;

  const ChatRoom({
    required this.roomId,
    required this.userId,
    required this.status,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [roomId, userId, status, updatedAt];
}
