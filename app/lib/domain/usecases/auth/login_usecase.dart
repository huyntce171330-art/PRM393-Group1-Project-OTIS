// This use case encapsulates the business logic for logging in a user.
//
// Steps to implement:
// 1. Create a class `LoginUsecase`.
// 2. Inject `AuthRepository` via constructor.
// 3. Define a `call` method taking `LoginParams` (containing email, password) and returning `Future<Either<Failure, User>>`.
// 4. In `call`, invoke `repository.login(params.email, params.password)`.
