// This screen displays the user's profile information.
//
// Steps to implement:
// 1. Create a `StatelessWidget` or `StatefulWidget` named `ProfileScreen`.
// 2. Used `BlocProvider` to provide `ProfileBloc` or access it if provided higher up.
// 3. Dispatch `GetProfileEvent` in `initState` (if StatefulWidget) or when the screen loads.
// 4. Use `BlocBuilder<ProfileBloc, ProfileState>` to build the UI:
//    - If `ProfileLoading`: Show `LoadingWidget`.
//    - If `ProfileError`: Show error message and a retry button.
//    - If `ProfileLoaded`: Display user details (Name, Email, Role, etc.).
// 5. Add an "Edit Profile" button that navigates to `ProfileEditScreen`.
//    - Pass the current `User` object to the edit screen so fields can be pre-filled.
