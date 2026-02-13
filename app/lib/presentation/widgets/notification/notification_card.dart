// Widget for a single notification item.
//
// Steps:
// 1. `ListTile` or custom `Card`.
// 2. Display Title, Body (truncated), Timestamp.
// 3. Visual indicator for `isRead` (e.g., bold text or dot).
// 4. `onTap` -> navigate to `NotificationDetailScreen`.
// 5. `Dismissible` -> background delete action -> triggers `DeleteNotificationEvent`.
