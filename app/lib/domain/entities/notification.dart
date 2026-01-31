import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';

/// Domain entity representing a notification in the system.
/// This entity contains business logic and is immutable.
@freezed
class Notification with _$Notification {
  const Notification._(); // Private constructor for adding custom methods

  const factory Notification({
    /// Unique identifier for the notification
    required String id,

    /// Notification title
    required String title,

    /// Notification body/content
    required String body,

    /// Whether the notification has been read
    required bool isRead,

    /// User ID this notification belongs to
    required String userId,

    /// When the notification was created
    required DateTime createdAt,
  }) = _Notification;

  /// Check if the notification has content
  bool get hasContent => title.isNotEmpty || body.isNotEmpty;

  /// Get the display title (fallback if empty)
  String get displayTitle => title.isNotEmpty ? title : 'Notification';

  /// Get the display body (fallback if empty)
  String get displayBody => body.isNotEmpty ? body : 'No content';

  /// Check if the notification is valid
  bool get isValid => id.isNotEmpty && userId.isNotEmpty && hasContent;

  /// Get formatted creation date
  String get formattedCreatedAt {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
  }

  /// Get formatted creation time
  String get formattedCreatedAtTime {
    return '${formattedCreatedAt} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  /// Get relative time description (simplified)
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

  /// Create a read version of this notification
  Notification markAsRead() {
    return copyWith(isRead: true);
  }

  /// Create an unread version of this notification
  Notification markAsUnread() {
    return copyWith(isRead: false);
  }
}