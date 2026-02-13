// Screen to display Map.
//
// Steps:
// 1. Use `GoogleMap` widget (from `google_maps_flutter`).
// 2. `BlocBuilder` to handle states:
//    - If `LocationLoaded`: Move camera to user.
//    - If `StoresLoaded`: Add `Marker`s for stores.
//    - If `RouteLoaded`: Add `Polyline`.
// 3. FAB to "My Location" (triggers `LoadCurrentLocationEvent`).
