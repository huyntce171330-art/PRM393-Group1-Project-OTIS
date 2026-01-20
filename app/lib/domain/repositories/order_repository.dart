// Interface for Order Repository.
//
// Steps:
// 1. Define abstract class `OrderRepository`.
// 2. Define methods:
//    - `Future<Either<Failure, List<Order>>> getOrders();`
//    - `Future<Either<Failure, Order>> getOrderDetail(String id);`
//    - `Future<Either<Failure, Order>> createOrder(Order order);` (or pass cart/params)
