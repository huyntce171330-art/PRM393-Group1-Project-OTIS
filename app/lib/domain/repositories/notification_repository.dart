// Interface for Notification Repository.
//
// Steps:
// 1. Define abstract class `NotificationRepository`.
// 2. Define methods:
//    - `Future<Either<Failure, List<Notification>>> getNotifications({NotificationFilter? filter});`
//    - `Future<Either<Failure, Notification>> getNotificationDetail(String id);`
//    - `Future<Either<Failure, List<Notification>>> searchNotifications(String query);`
//    - `Future<Either<Failure, void>> createNotification(Notification notification);`
//    - `Future<Either<Failure, void>> updateNotificationStatus(String id, bool isRead);`
//    - `Future<Either<Failure, void>> deleteNotification(String id);`
