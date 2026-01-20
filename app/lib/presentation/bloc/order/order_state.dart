// States for OrderBloc.
//
// Steps:
// 1. `OrderInitial`, `OrderLoading`.
// 2. `OrdersLoaded(List<Order>)`.
// 3. `OrderDetailLoaded(Order)`.
// 4. `OrderCreated(Order)` (Success state after creation).
// 5. `OrderError`.
