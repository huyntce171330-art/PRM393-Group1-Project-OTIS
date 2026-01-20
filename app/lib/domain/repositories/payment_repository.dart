// Interface for Payment Repository.
//
// Steps:
// 1. Define abstract class `PaymentRepository`.
// 2. Define methods:
//    - `Future<Either<Failure, String>> processPayment({required String orderId, required double amount, required String method});`
//      - Returns Transaction ID or Payment Status.
