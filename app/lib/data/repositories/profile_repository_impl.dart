// This file moves the data from the remote datasource to the domain layer (Repository).
//
// Steps to implement:
// 1. Create a class `ProfileRepositoryImpl` that implements `ProfileRepository` (from domain layer).
// 2. Inject `ProfileRemoteDatasource` and `NetworkInfo` (if you handle offline mode) via constructor.
// 3. Implement `getProfile()`:
//    - Check for network connectivity (optional but recommended).
//    - Call `remoteDatasource.getProfile()`.
//    - Wrap the result in `Right(user)`.
//    - Catch `ServerException` and return `Left(ServerFailure())`.
// 4. Implement `updateProfile(User user)`:
//    - Convert the `User` entity to `UserModel` (if necessary, or pass data directly).
//    - Call `remoteDatasource.updateProfile(userModel)`.
//    - Wrap the result in `Right(updatedUser)`.
//    - Catch `ServerException` and return `Left(ServerFailure())`.
