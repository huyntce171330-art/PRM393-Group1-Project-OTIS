// Interface for Cart Remote Data Source.
//
// Steps:
// 1. Define abstract class `CartRemoteDatasource`.
// 2. Define methods:
//    - `Future<CartModel> getCart();`
//    - `Future<CartModel> addToCart(String productId, int quantity);`
//    - `Future<CartModel> updateCartItem(String itemId, int quantity);`
//    - `Future<CartModel> removeFromCart(String itemId);`
