// Service for handling Firebase Push Notifications.
//
// Steps:
// 1. Import `firebase_messaging` and `flutter_local_notifications`.
// 2. Create class `PushNotificationService`.
// 3. Method `initialize()`:
//    - Request permission (`messaging.requestPermission`).
//    - Get FCM token (`messaging.getToken`).
//    - Configure foreground handlers (`FirebaseMessaging.onMessage`).
//    - Initialize local notifications to show alerts in foreground.
// 4. Method `onBackgroundMessage()`:
//    - Define top-level function for background handling.
