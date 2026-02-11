import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:frontend_otis/presentation/bloc/order/order_bloc.dart';
import 'package:frontend_otis/presentation/bloc/order/order_event.dart';
import 'package:frontend_otis/presentation/bloc/payment/payment_bloc.dart';
import 'package:frontend_otis/presentation/bloc/payment/payment_event.dart';
import 'package:frontend_otis/presentation/bloc/payment/payment_state.dart';
import 'package:frontend_otis/domain/entities/bank_account.dart';
import 'package:go_router/go_router.dart';

class PaymentScreen extends StatefulWidget {
  final Order order;
  final PaymentMethod? initialMethod;

  const PaymentScreen({super.key, required this.order, this.initialMethod});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late PaymentMethod _selectedMethod;
  bool _processedInitialMethod = false;

  // Fake bank account data removed. Using data from BLoC state.

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.initialMethod ?? PaymentMethod.cash;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_processedInitialMethod && widget.initialMethod != null) {
      _processedInitialMethod = true;
      // Auto-trigger selection if method passed from checkout
      context.read<PaymentBloc>().add(
        SelectPaymentMethodEvent(
          orderId: widget.order.id,
          method: widget.initialMethod!,
          amount: widget.order.totalAmount,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentInitiated) {
          if (state.payment.method == PaymentMethod.cash) {
            _showSuccess(context, "Order placed successfully (COD)");
          }
        } else if (state is PaymentSuccess) {
          _showSuccess(context, "Payment Confirmed");
        } else if (state is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              state is PaymentInitiated ? "Scan to Pay" : "Select Payment",
            ),
            centerTitle: true,
          ),
          body:
              state is PaymentInitiated &&
                  state.payment.method == PaymentMethod.transfer
              ? _buildQRCodeView(
                  context,
                  state.payment.paymentCode,
                  state.bankAccount,
                )
              : _buildSelectionView(context, state is PaymentLoading),
        );
      },
    );
  }

  void _showSuccess(BuildContext context, String message) {
    // Navigate to Booking Success Screen with order details
    context.go('/booking-success', extra: widget.order);
  }

  Widget _buildSelectionView(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderSummary(),
          const SizedBox(height: 32),
          const Text(
            "Choose Payment Method",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          _buildMethodOption(
            PaymentMethod.cash,
            "Cash on Delivery",
            Icons.money,
          ),
          const SizedBox(height: 12),
          _buildMethodOption(
            PaymentMethod.transfer,
            "Bank Transfer",
            Icons.account_balance,
          ),
          const Spacer(),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<PaymentBloc>().add(
                        SelectPaymentMethodEvent(
                          orderId: widget.order.id,
                          method: _selectedMethod,
                          amount: widget.order.totalAmount,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Confirm Payment Method"),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _showReorderConfirmation(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancel & Re-order",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Order Code", style: TextStyle(color: Colors.grey)),
              Text(
                widget.order.code,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount", style: TextStyle(fontSize: 16)),
              Text(
                widget.order.formattedTotalAmount,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodOption(PaymentMethod method, String label, IconData icon) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedMethod == method
                ? AppColors.primary
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _selectedMethod == method
                  ? AppColors.primary
                  : Colors.grey,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: _selectedMethod == method
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (_selectedMethod == method)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCodeView(
    BuildContext context,
    String qrContent,
    BankAccount? bankAccount,
  ) {
    final transferContent = "Thanh toan don hang ${widget.order.code}";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // QR Code Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                QrImageView(
                  data: qrContent,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Scan with Mobile Banking",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.order.formattedTotalAmount,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Bank Info Section
          if (bankAccount != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bank Transfer Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildBankInfoRow("Bank", bankAccount.bankName),
                  _buildBankInfoRow(
                    "Account Number",
                    bankAccount.accountNumber,
                    isCopyable: true,
                  ),
                  _buildBankInfoRow(
                    "Account Holder",
                    bankAccount.accountHolder,
                  ),
                  if (bankAccount.branch != null)
                    _buildBankInfoRow("Branch", bankAccount.branch!),
                  _buildBankInfoRow(
                    "Content",
                    transferContent,
                    isCopyable: true,
                  ),
                ],
              ),
            ),

          const SizedBox(height: 32),

          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<PaymentBloc>().add(
                      ProcessPaymentEvent(widget.order.id),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "I Have Paid",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showReorderConfirmation(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Cancel & Re-order",
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBankInfoRow(
    String label,
    String value, {
    bool isCopyable = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isCopyable)
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$label copied to clipboard"),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.copy, size: 18, color: AppColors.primary),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReorderConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Order?"),
        content: const Text(
          "Are you sure you want to cancel this order and re-order? All current progress will be lost.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Keep Order"),
          ),
          ElevatedButton(
            onPressed: () {
              // 1. Cancel current order (inform server/DB)
              context.read<OrderBloc>().add(
                UpdateOrderStatusEvent(
                  widget.order.id,
                  const OrderStatusConverter().toJson(OrderStatus.canceled),
                ),
              );

              // 2. Clear dialog
              Navigator.pop(context);

              // 3. Return to previous screen (Checkout)
              // Since we used push() in CheckoutScreen, we can just pop()
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                // Fallback if somehow stack is lost
                context.go('/products');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text("Yes, Cancel & Re-order"),
          ),
        ],
      ),
    );
  }
}
