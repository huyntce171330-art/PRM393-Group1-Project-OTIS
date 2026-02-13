// This use case encapsulates the business logic for updating the user's profile.
//
// Steps to implement:
// 1. Create a class `UpdateProfileUsecase`.
// 2. Inject `ProfileRepository` via constructor.
// 3. Define a `call` method that takes the updated `User` object (or specific fields) and returns `Future<Either<Failure, User>>`.
// 4. In the `call` method, invoke `repository.updateProfile(user)`.
