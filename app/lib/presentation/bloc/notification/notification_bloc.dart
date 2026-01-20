// BLoC for Notification Management.
//
// Steps:
// 1. Extend `Bloc<NotificationEvent, NotificationState>`.
// 2. Inject all Use Cases (`get`, `search`, `update`, `delete`, `create`).
// 3. Handle `LoadNotificationsEvent`:
//    - Call `GetNotificationsUsecase`.
//    - Emit `NotificationLoaded`.
// 4. Handle `SearchNotificationsEvent`:
//    - Call `SearchNotificationsUsecase`.
//    - Emit `NotificationLoaded` with results.
// 5. Handle `MarkAsReadEvent` / `DeleteNotificationEvent`:
//    - Call `Update`/`Delete` usecases.
//    - Emit `NotificationOperationSuccess` -> then reload list (add `LoadNotificationsEvent`).
