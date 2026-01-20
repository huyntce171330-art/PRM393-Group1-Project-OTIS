// BLoC for Cart Management.
//
// Steps:
// 1. Extend `Bloc<CartEvent, CartState>`.
// 2. Inject use cases: `GetCart`, `AddToCart`, `UpdateCart`.
// 3. Implement event handlers:
//    - `on<LoadCartEvent>`: Call `GetCartUsecase`.
//    - `on<AddProductToCartEvent>`: Call `AddToCartUsecase`, then emit updated cart.
//    - `on<UpdateCartItemEvent>`: Call `UpdateCartUsecase`, then emit updated cart.
