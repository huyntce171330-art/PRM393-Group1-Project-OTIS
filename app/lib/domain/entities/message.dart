import 'package:equatable/equatable.dart';

/// Domain entity representing a message in a chat room.
/// This entity contains business logic and is immutable.
class Message extends Equatable {
  /// Unique identifier for the message
  final String id;

  /// Chat room ID this message belongs to
  final String roomId;

  /// User ID of the message sender
  final String senderId;

  /// Message content (text)
  final String content;

  /// Optional image URL for image messages
  final String? imageUrl;

  /// Whether the message has been read by the recipient
  final bool isRead;

  /// When the message was created
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    this.imageUrl,
    required this.isRead,
    required this.createdAt,
  });

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

  /// Create a copy of Message with modified fields
  Message copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? content,
    String? imageUrl,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if the message has text content
  bool get hasContent => content.isNotEmpty;

  /// Check if the message has an image
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Check if the message is a text-only message
  bool get isTextOnly => hasContent && !hasImage;

  /// Check if the message is an image-only message
  bool get isImageOnly => !hasContent && hasImage;

  /// Check if the message has both text and image
  bool get hasTextAndImage => hasContent && hasImage;

  /// Get the message type description
  String get messageType {
    if (hasTextAndImage) return 'Text & Image';
    if (isImageOnly) return 'Image';
    if (isTextOnly) return 'Text';
    return 'Empty';
  }

  /// Check if the message is valid
  bool get isValid =>
      id.isNotEmpty &&
      roomId.isNotEmpty &&
      senderId.isNotEmpty &&
      (hasContent || hasImage);

  /// Get formatted creation time (HH:MM)
  String get formattedTime {
    return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  /// Get formatted creation date and time
  String get formattedCreatedAt {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')} $formattedTime';
  }

  /// Get relative time description
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Create a read version of this message
  Message markAsRead() {
    return copyWith(isRead: true);
  }

  /// Create an unread version of this message
  Message markAsUnread() {
    return copyWith(isRead: false);
  }

  /// Check if this message was sent by a specific user
  bool isFromUser(String userId) => senderId == userId;
}
