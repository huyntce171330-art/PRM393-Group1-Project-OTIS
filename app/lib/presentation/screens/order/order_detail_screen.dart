// Screen to view order details.
//
// Steps:
// 1. Receive `orderId` via constructor/route args.
// 2. Dispatch `LoadOrderDetailEvent`.
// 3. Show Order Info (ID, Status, Date) and List of Items.
// 4. If status is 'pending', show "Pay Now" button -> Navigate to `PaymentScreen`.
