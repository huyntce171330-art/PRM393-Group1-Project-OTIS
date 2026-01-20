// Service to handle Device Location (GPS).
//
// Steps:
// 1. Import `geolocator` package.
// 2. Create `LocationService`.
// 3. Method `getCurrentPosition()`:
//    - Check permissions (request if denied).
//    - Check service enabled.
//    - Return `Position` (mapped to `AppLocation` later).
