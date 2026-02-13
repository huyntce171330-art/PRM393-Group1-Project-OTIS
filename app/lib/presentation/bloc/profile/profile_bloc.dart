// This file manages the state management for the Profile feature using BLoC.
//
// Steps to implement:
// 1. Create a class `ProfileBloc` extending `Bloc<ProfileEvent, ProfileState>`.
// 2. Inject `GetProfileUsecase` and `UpdateProfileUsecase` via constructor.
// 3. Register event handlers using `on<Event>`:
//    - `on<GetProfileEvent>(_onGetProfile);`
//    - `on<UpdateProfileEvent>(_onUpdateProfile);`
// 4. Implement `_onGetProfile`:
//    - Emit `ProfileLoading`.
//    - Call `getProfileUsecase()`.
//    - Emit `ProfileLoaded(user)` on success (Right).
//    - Emit `ProfileError(message)` on failure (Left).
// 5. Implement `_onUpdateProfile`:
//    - Emit `ProfileLoading` (or a specific updating state if you want to keep data visible).
//    - Call `updateProfileUsecase(event.user)`.
//    - Emit `ProfileLoaded(user)` (or `ProfileUpdated`) on success.
//    - Emit `ProfileError(message)` on failure.
