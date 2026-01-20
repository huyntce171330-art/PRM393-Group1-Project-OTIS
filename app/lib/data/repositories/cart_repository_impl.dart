// Implementation of Cart Repository.
//
// Steps:
// 1. Implement `CartRepository`.
// 2. Inject `CartRemoteDatasource` (and `NetworkInfo` if checking connectivity).
// 3. Implement methods:
//    - Call remote datasource method.
//    - Wrap result in `Right(result)`.
//    - Catch exceptions and return `Left(Failure)`.
