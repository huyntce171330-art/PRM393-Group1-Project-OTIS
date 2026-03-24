import 'package:equatable/equatable.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<AppNotification> notifications;
  final int currentPage;
  final bool hasMore;
  final NotificationFilter? currentFilter;

  const NotificationLoaded({
    required this.notifications,
    this.currentPage = 1,
    this.hasMore = true,
    this.currentFilter,
  });

  NotificationLoaded copyWith({
    List<AppNotification>? notifications,
    int? currentPage,
    bool? hasMore,
    NotificationFilter? currentFilter,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }

  @override
  List<Object?> get props => [notifications, currentPage, hasMore, currentFilter];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

enum NotificationOperationType { markRead, markUnread, delete, markAllRead, create }

class NotificationOperationSuccess extends NotificationState {
  final String message;
  final NotificationOperationType type;
  final NotificationLoaded previousState;

  const NotificationOperationSuccess({
    required this.message,
    required this.type,
    required this.previousState,
  });

  @override
  List<Object?> get props => [message, type, previousState];
}

class NotificationDetailLoaded extends NotificationState {
  final AppNotification notification;
  final List<AppNotification>? cachedList;

  const NotificationDetailLoaded({
    required this.notification,
    this.cachedList,
  });

  @override
  List<Object?> get props => [notification, cachedList];
}
