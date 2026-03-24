import 'package:equatable/equatable.dart';

enum NotificationType {
  order,
  promotion,
  system,
  general,
}

class NotificationFilter extends Equatable {
  final int page;
  final int limit;
  final NotificationType? type;
  final bool? isRead;
  final String? searchQuery;

  const NotificationFilter({
    this.page = 1,
    this.limit = 20,
    this.type,
    this.isRead,
    this.searchQuery,
  });

  NotificationFilter copyWith({
    int? page,
    int? limit,
    NotificationType? type,
    bool? isRead,
    String? searchQuery,
  }) {
    return NotificationFilter(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasFilters =>
      type != null || isRead != null || (searchQuery?.isNotEmpty ?? false);

  @override
  List<Object?> get props => [page, limit, type, isRead, searchQuery];
}
