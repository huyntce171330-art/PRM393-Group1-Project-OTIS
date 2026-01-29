import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int messageId;
  final int roomId;
  final int senderId;
  final String? content;
  final String? imageUrl;
  final bool isRead;
  final DateTime createdAt;

  const Message({
    required this.messageId,
    required this.roomId,
    required this.senderId,
    this.content,
    this.imageUrl,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    messageId,
    roomId,
    senderId,
    content,
    imageUrl,
    isRead,
    createdAt,
  ];
}
