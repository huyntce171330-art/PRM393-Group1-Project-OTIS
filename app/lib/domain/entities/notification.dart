import 'package:equatable/equatable.dart';

/// Domain entity representing a notification in the system.
/// This entity contains business logic and is immutable.
class Notification extends Equatable {
  /// Unique identifier for the notification
  final String id;

  /// Notification title
  final String title;

  /// Notification body/content
  final String body;

  /// Whether the notification has been read
  final bool isRead;

  /// User ID this notification belongs to
  final String userId;

  /// When the notification was created
  final DateTime createdAt;

  const Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.userId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, body, isRead, userId, createdAt];

  /// Create a copy of Notification with modified fields
  Notification copyWith({
    String? id,
    String? title,
    String? body,
    bool? isRead,
    String? userId,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
    return '$formattedCreatedAt ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
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
