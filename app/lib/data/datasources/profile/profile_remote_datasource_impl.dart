// This file should contain the implementation of the ProfileRemoteDatasource.
//
// Steps to implement:
// 1. Create a class `ProfileRemoteDatasourceImpl` that implements `ProfileRemoteDatasource`.
// 2. Inject `ApiClient` or `http.Client` via the constructor.
// 3. Implement `getProfile()`:
//    - Make a GET request to the profile endpoint (e.g., `/users/me`).
//    - Check for 200 OK status.
//    - Parse the JSON response into a `UserModel` using `UserModel.fromJson`.
//    - Throw a `ServerException` if the status code is not 200.
// 4. Implement `updateProfile(UserModel user)`:
//    - Make a PUT or PATCH request to the update profile endpoint.
//    - Send the `user.toJson()` or specific fields in the body.
//    - Check for success status (200/201).
//    - Parse and return the updated `UserModel`.
//    - Throw a `ServerException` on failure.
