// This use case encapsulates the business logic for retrieving the user's profile.
//
// Steps to implement:
// 1. Create a class `GetProfileUsecase`.
// 2. Inject `ProfileRepository` via constructor.
// 3. Define a `call` method (or a method named `execute`) that returns `Future<Either<Failure, User>>`.
// 4. In the `call` method, invoke `repository.getProfile()`.
// 5. Use `NoParams` or `void` if no arguments are needed to get the current profile.
