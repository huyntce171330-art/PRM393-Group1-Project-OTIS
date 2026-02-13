// Interface for Map/Location Repository.
//
// Steps:
// 1. Define abstract class `MapRepository`.
// 2. Define methods:
//    - `Future<Either<Failure, AppLocation>> getCurrentLocation();`
//    - `Future<Either<Failure, List<Store>>> getStoreLocations();`
//    - `Future<Either<Failure, List<AppLocation>>> getRoute(AppLocation start, AppLocation end);`
//      - Returns list of points for Polyline.
