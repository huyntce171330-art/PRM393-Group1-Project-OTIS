// Events for CartBloc.
//
// Steps:
// 1. Define abstract class `CartEvent`.
// 2. `LoadCartEvent`: Triggered to fetch cart data.
// 3. `AddProductToCartEvent`: Contains `Product` (or ID) and `quantity`.
// 4. `UpdateCartItemEvent`: Contains `CartItem` (or ID) and `newQuantity`.
// 5. `RemoveFromCartEvent`: Contains `CartItem` ID.
