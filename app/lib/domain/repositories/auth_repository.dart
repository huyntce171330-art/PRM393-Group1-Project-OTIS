// This file defines the contract for Authentication Repository in the Domain layer.
//
// Steps to implement:
// 1. Import `dartz` (Either), `failure`, and `User` entity.
// 2. Define an abstract class `AuthRepository`.
// 3. Define `Future<Either<Failure, User>> login(String email, String password);`
// 4. Define `Future<Either<Failure, User>> register(String name, String email, String password, String phone);`
//    - Adjust parameters based on your User model and API requirements.
// 5. Define `Future<Either<Failure, void>> logout();`
//    - This might clear local tokens.
