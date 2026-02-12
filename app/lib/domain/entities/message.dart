import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

/// Domain entity representing a message in a chat room.
/// This entity contains business logic and is immutable.
@immutable
@freezed
class Message with _$Message {
  const Message._(); // Private constructor for adding custom methods

  const factory Message({
    /// Unique identifier for the message
    required String id,

    /// Chat room ID this message belongs to
    required String roomId,

    /// User ID of the message sender
    required String senderId,

    /// Message content (text)
    required String content,

    /// Optional image URL for image messages
    String? imageUrl,

    /// Whether the message has been read by the recipient
    required bool isRead,

    /// When the message was created
    required DateTime createdAt,
  }) = _Message;

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
  bool get isValid => id.isNotEmpty && roomId.isNotEmpty && senderId.isNotEmpty && (hasContent || hasImage);

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