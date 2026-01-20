// Interface for Cart Repository (Domain Layer).
//
// Steps:
// 1. Define abstract class `CartRepository`.
// 2. Define methods returning `Future<Either<Failure, T>>`:
//    - `addToCart(String productId, int quantity);`
//    - `getCart();` -> returns `Cart` entity.
//    - `updateCartItem(String cartItemId, int quantity);`
//    - `removeFromCart(String cartItemId);`
//    - `clearCart();`
