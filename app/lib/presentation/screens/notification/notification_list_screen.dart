// Screen to list notifications.
//
// Steps:
// 1. `BlocBuilder<NotificationBloc, NotificationState>` to show loading/list/error.
// 2. SearchBar widget at top -> dispatches `SearchNotificationsEvent`.
// 3. Filter button -> opens Filter BottomSheet -> dispatches `LoadNotificationsEvent` with filter.
// 4. List of `NotificationCard`s.
// 5. `RefreshIndicator` to reload.
