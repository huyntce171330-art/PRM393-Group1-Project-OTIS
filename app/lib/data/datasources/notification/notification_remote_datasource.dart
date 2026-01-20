// Interface for Notification Remote Data Source.
//
// Steps:
// 1. Define `NotificationRemoteDatasource`.
// 2. Methods matching the repository (returning `Future<List<NotificationModel>>` etc.):
//    - `fetchNotifications(Map<String, dynamic>? filterParams)`
//    - `fetchNotificationDetail(String id)`
//    - `searchNotifications(String query)`
//    - `createNotification(Map<String, dynamic> data)`
//    - `updateNotificationStatus(String id, bool status)`
//    - `deleteNotification(String id)`
