import 'package:equatable/equatable.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {
  final NotificationFilter? filter;
  const LoadNotificationsEvent({this.filter});

  @override
  List<Object?> get props => [filter];
}

class RefreshNotificationsEvent extends NotificationEvent {
  const RefreshNotificationsEvent();
}

class LoadMoreNotificationsEvent extends NotificationEvent {
  const LoadMoreNotificationsEvent();
}

class MarkAsReadEvent extends NotificationEvent {
  final String id;
  const MarkAsReadEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class MarkAsUnreadEvent extends NotificationEvent {
  final String id;
  const MarkAsUnreadEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class MarkAllAsReadEvent extends NotificationEvent {
  const MarkAllAsReadEvent();
}

class DeleteNotificationEvent extends NotificationEvent {
  final String id;
  const DeleteNotificationEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UndoDeleteNotificationEvent extends NotificationEvent {
  const UndoDeleteNotificationEvent();
}

class SearchNotificationsEvent extends NotificationEvent {
  final String query;
  const SearchNotificationsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class GetNotificationDetailEvent extends NotificationEvent {
  final String id;
  const GetNotificationDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateNotificationEvent extends NotificationEvent {
  final AppNotification notification;
  const CreateNotificationEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}
