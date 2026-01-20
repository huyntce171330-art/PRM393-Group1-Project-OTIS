// This screen allows the user to update their profile information.
//
// Steps to implement:
// 1. Create a `StatefulWidget` named `ProfileEditScreen`.
// 2. Accept the current `User` object via the constructor (to pre-fill the form).
// 3. Create `TextEditingController`s for each editable field (Name, Phone, etc.).
// 4. Initialize controllers with the passed `User` data in `initState`.
// 5. Build a Form using `TextFormField` widgets.
// 6. Add a "Save" or "Update" button.
// 7. On button press:
//    - Validate the form.
//    - Create an updated `User` object from the controllers' text.
//    - Dispatch `UpdateProfileEvent` to the `ProfileBloc`.
// 8. Use `BlocListener<ProfileBloc, ProfileState>` to handle success/failure:
//    - If `ProfileLoaded` (success): Show a snackbar "Profile Updated" and `Navigator.pop(context)`.
//    - If `ProfileError`: Show a snackbar with the error message.
