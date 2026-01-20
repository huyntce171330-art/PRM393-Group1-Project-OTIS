// This use case encapsulates the business logic for registering a new user.
//
// Steps to implement:
// 1. Create a class `RegisterUsecase`.
// 2. Inject `AuthRepository` via constructor.
// 3. Define a `call` method taking `RegisterParams` (name, email, password, phone, etc.) and returning `Future<Either<Failure, User>>`.
// 4. In `call`, invoke `repository.register(...)`.
