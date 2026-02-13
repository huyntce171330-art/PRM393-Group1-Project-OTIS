// Events for NotificationBloc.
//
// Steps:
// 1. Define events:
//    - `LoadNotificationsEvent({NotificationFilter? filter})`
//    - `SearchNotificationsEvent(String query)`
//    - `MarkAsReadEvent(String id)`
//    - `DeleteNotificationEvent(String id)`
//    - `CreateNotificationEvent(Notification notification)`
//    - `NotificationReceivedEvent(Notification notification)` (for real-time updates)
