import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/domain/entities/notification.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';
import 'package:frontend_otis/domain/usecases/notification/create_notification_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/delete_notification_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/get_notification_detail_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/get_notifications_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/mark_all_as_read_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/search_notifications_usecase.dart';
import 'package:frontend_otis/domain/usecases/notification/update_notification_status_usecase.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_event.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUsecase getNotifications;
  final GetNotificationDetailUsecase getNotificationDetail;
  final UpdateNotificationStatusUsecase updateNotificationStatus;
  final DeleteNotificationUsecase deleteNotification;
  final SearchNotificationsUsecase searchNotifications;
  final CreateNotificationUsecase createNotification;
  final MarkAllAsReadUsecase markAllAsRead;

  AppNotification? _lastDeletedNotification;

  NotificationBloc({
    required this.getNotifications,
    required this.getNotificationDetail,
    required this.updateNotificationStatus,
    required this.deleteNotification,
    required this.searchNotifications,
    required this.createNotification,
    required this.markAllAsRead,
  }) : super(NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<RefreshNotificationsEvent>(_onRefresh);
    on<LoadMoreNotificationsEvent>(_onLoadMore);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<MarkAsUnreadEvent>(_onMarkAsUnread);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
    on<DeleteNotificationEvent>(_onDelete);
    on<UndoDeleteNotificationEvent>(_onUndoDelete);
    on<SearchNotificationsEvent>(_onSearch);
    on<GetNotificationDetailEvent>(_onGetDetail);
    on<CreateNotificationEvent>(_onCreateNotification);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NotificationLoaded || (currentState).notifications.isEmpty) {
      emit(NotificationLoading());
    }

    final result = await getNotifications(filter: event.filter);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (data) => emit(NotificationLoaded(
        notifications: data.notifications,
        currentPage: 1,
        hasMore: data.hasMore,
        currentFilter: event.filter,
      )),
    );
  }

  Future<void> _onRefresh(
    RefreshNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    NotificationFilter? currentFilter;
    if (state is NotificationLoaded) {
      currentFilter = (state as NotificationLoaded).currentFilter;
    }

    final result = await getNotifications(filter: currentFilter);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (data) => emit(NotificationLoaded(
        notifications: data.notifications,
        currentPage: 1,
        hasMore: data.hasMore,
        currentFilter: currentFilter,
      )),
    );
  }

  Future<void> _onLoadMore(
    LoadMoreNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NotificationLoaded || !currentState.hasMore) return;

    final nextPage = currentState.currentPage + 1;
    final filter = currentState.currentFilter != null
        ? currentState.currentFilter!.copyWith(page: nextPage)
        : NotificationFilter(page: nextPage);

    final result = await getNotifications(filter: filter);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (data) => emit(NotificationLoaded(
        notifications: [...currentState.notifications, ...data.notifications],
        currentPage: nextPage,
        hasMore: data.hasMore,
        currentFilter: currentState.currentFilter,
      )),
    );
  }

  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    final result = await updateNotificationStatus.call(event.id, true);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) {
        final updated = currentState.notifications.map((n) {
          return n.id == event.id ? n.markAsRead() : n;
        }).toList();

        emit(NotificationOperationSuccess(
          message: 'Marked as read',
          type: NotificationOperationType.markRead,
          previousState: currentState.copyWith(notifications: updated),
        ));
        emit(NotificationLoaded(
          notifications: updated,
          currentPage: currentState.currentPage,
          hasMore: currentState.hasMore,
          currentFilter: currentState.currentFilter,
        ));
      },
    );
  }

  Future<void> _onMarkAsUnread(
    MarkAsUnreadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    final result = await updateNotificationStatus.call(event.id, false);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) {
        final updated = currentState.notifications.map((n) {
          return n.id == event.id ? n.markAsUnread() : n;
        }).toList();

        emit(NotificationOperationSuccess(
          message: 'Marked as unread',
          type: NotificationOperationType.markUnread,
          previousState: currentState.copyWith(notifications: updated),
        ));
        emit(NotificationLoaded(
          notifications: updated,
          currentPage: currentState.currentPage,
          hasMore: currentState.hasMore,
          currentFilter: currentState.currentFilter,
        ));
      },
    );
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    final result = await markAllAsRead.call();

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) {
        final updated = currentState.notifications.map((n) => n.markAsRead()).toList();

        emit(NotificationOperationSuccess(
          message: 'All marked as read',
          type: NotificationOperationType.markAllRead,
          previousState: currentState.copyWith(notifications: updated),
        ));
        emit(NotificationLoaded(
          notifications: updated,
          currentPage: currentState.currentPage,
          hasMore: currentState.hasMore,
          currentFilter: currentState.currentFilter,
        ));
      },
    );
  }

  Future<void> _onDelete(
    DeleteNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    _lastDeletedNotification = currentState.notifications.firstWhere(
      (n) => n.id == event.id,
      orElse: () => throw Exception('Notification not found'),
    );

    final result = await deleteNotification.call(event.id);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) {
        final updated = currentState.notifications.where((n) => n.id != event.id).toList();

        emit(NotificationOperationSuccess(
          message: 'Notification deleted',
          type: NotificationOperationType.delete,
          previousState: currentState.copyWith(notifications: updated),
        ));
        emit(NotificationLoaded(
          notifications: updated,
          currentPage: currentState.currentPage,
          hasMore: currentState.hasMore,
          currentFilter: currentState.currentFilter,
        ));
      },
    );
  }

  Future<void> _onUndoDelete(
    UndoDeleteNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (_lastDeletedNotification == null) return;
    if (state is! NotificationLoaded) return;

    final currentState = state as NotificationLoaded;
    final toRestore = _lastDeletedNotification!;

    final result = await createNotification.call(toRestore);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) {
        final updated = [toRestore, ...currentState.notifications];
        _lastDeletedNotification = null;

        emit(NotificationLoaded(
          notifications: updated,
          currentPage: currentState.currentPage,
          hasMore: currentState.hasMore,
          currentFilter: currentState.currentFilter,
        ));
      },
    );
  }

  Future<void> _onSearch(
    SearchNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    final result = await searchNotifications.call(event.query);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) => emit(NotificationLoaded(
        notifications: notifications,
        currentPage: 1,
        hasMore: false,
      )),
    );
  }

  Future<void> _onGetDetail(
    GetNotificationDetailEvent event,
    Emitter<NotificationState> emit,
  ) async {
    List<AppNotification>? cachedList;
    if (state is NotificationLoaded) {
      cachedList = (state as NotificationLoaded).notifications;
    }

    emit(NotificationLoading());

    final result = await getNotificationDetail.call(event.id);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (      notification) => emit(NotificationDetailLoaded(
        notification: notification,
        cachedList: cachedList,
      )),
    );
  }

  Future<void> _onCreateNotification(
    CreateNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;

    final result = await createNotification.call(event.notification);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notification) {
        if (currentState is NotificationLoaded) {
          final updated = [notification, ...currentState.notifications];
          emit(NotificationOperationSuccess(
            message: 'Notification created',
            type: NotificationOperationType.create,
            previousState: currentState.copyWith(notifications: updated),
          ));
          emit(NotificationLoaded(
            notifications: updated,
            currentPage: currentState.currentPage,
            hasMore: currentState.hasMore,
            currentFilter: currentState.currentFilter,
          ));
        } else {
          emit(NotificationOperationSuccess(
            message: 'Notification created',
            type: NotificationOperationType.create,
            previousState: const NotificationLoaded(notifications: []),
          ));
        }
      },
    );
  }
}
