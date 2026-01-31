import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room.freezed.dart';

/// Domain entity representing a chat room in the system.
/// This entity contains business logic and is immutable.
@freezed
class ChatRoom with _$ChatRoom {
  const ChatRoom._(); // Private constructor for adding custom methods

  const factory ChatRoom({
    /// Unique identifier for the chat room
    required String id,

    /// User ID associated with this chat room
    required String userId,

    /// Current status of the chat room
    required String status,

    /// When the chat room was created
    required DateTime createdAt,

    /// When the chat room was last updated
    required DateTime updatedAt,
  }) = _ChatRoom;

  /// Check if the chat room is active
  bool get isActive => status.toLowerCase() == 'open';

  /// Check if the chat room is closed
  bool get isClosed => status.toLowerCase() == 'closed';

  /// Get the display status (capitalized)
  String get displayStatus {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Open';
      case 'closed':
        return 'Closed';
      default:
        return status;
    }
  }

  /// Check if the chat room is valid
  bool get isValid => id.isNotEmpty && userId.isNotEmpty && status.isNotEmpty;

  /// Get formatted creation date
  String get formattedCreatedAt {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
  }

  /// Get formatted updated date
  String get formattedUpdatedAt {
    return '${updatedAt.year}-${updatedAt.month.toString().padLeft(2, '0')}-${updatedAt.day.toString().padLeft(2, '0')}';
  }

  /// Get relative time since last update
  String get relativeLastUpdate {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

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

  /// Create an updated version with current timestamp
  ChatRoom markAsUpdated() {
    return copyWith(updatedAt: DateTime.now());
  }
}