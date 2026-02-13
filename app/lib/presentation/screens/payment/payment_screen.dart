import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:frontend_otis/domain/entities/user.dart';
import 'package:frontend_otis/presentation/bloc/order/order_bloc.dart';
import 'package:frontend_otis/presentation/bloc/order/order_event.dart';
import 'package:frontend_otis/presentation/bloc/payment/payment_bloc.dart';
import 'package:frontend_otis/presentation/bloc/payment/payment_event.dart';
import 'package:frontend_otis/presentation/bloc/payment/payment_state.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_bloc.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_state.dart';
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
      listener: (context, paymentState) {
        if (paymentState is PaymentInitiated) {
          if (paymentState.payment.method == PaymentMethod.cash) {
            _showSuccess(context, "Order placed successfully (COD)");
          }
        } else if (paymentState is PaymentSuccess) {
          _showSuccess(context, "Payment Confirmed");
        } else if (paymentState is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(paymentState.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, paymentState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            User? currentUser;
            if (authState is Authenticated) {
              currentUser = authState.user;
            }

            // Enforce Profile Completion
            if (currentUser != null) {
              final missingInfo =
                  currentUser.fullName.isEmpty ||
                  currentUser.address.isEmpty ||
                  currentUser.phone.isEmpty;

              if (missingInfo) {
                return Scaffold(
                  appBar: AppBar(title: const Text("Complete Profile")),
                  body: _buildProfileUpdateRequired(context),
                );
              }
            } else {
              // If unauthenticated, you might want to force login or handle guest
              // For this implementation, we'll suggest logging in if user is null
              // assuming this screen is protected.
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  paymentState is PaymentInitiated
                      ? "Scan to Pay"
                      : "Select Payment",
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child:
                    paymentState is PaymentInitiated &&
                        paymentState.payment.method == PaymentMethod.transfer
                    ? _buildQRCodeView(
                        context,
                        paymentState.payment.paymentCode,
                        paymentState.bankAccount,
                        currentUser,
                      )
                    : _buildSelectionView(
                        context,
                        paymentState is PaymentLoading,
                        currentUser,
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfileUpdateRequired(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              "Profile Incomplete",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "We need your full name, address, and phone number to process the order. Please update your profile.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/profile/update'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Update Profile Now",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    // Navigate to Booking Success Screen with order details
    context.go('/booking-success', extra: widget.order);
  }

  Widget _buildSelectionView(BuildContext context, bool isLoading, User? user) {
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
          const SizedBox(height: 32),
          _buildCustomerInfo(user),
          const SizedBox(height: 48),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Confirm Payment Method",
                      style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildOrderSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryItem("Order Code", widget.order.code, isCentered: true),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildSummaryItem(
            "Branch",
            "OTIS Shop - District 1",
            isCentered: true,
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.order.formattedTotalAmount,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value, {
    bool isCentered = false,
  }) {
    return Column(
      crossAxisAlignment: isCentered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo(User? user) {
    // If user is null (e.g. guest), fallback or hide?
    // Requirement implies logged in user.
    final name = user?.fullName.isNotEmpty == true
        ? user!.fullName
        : "Guest/Unknown";
    final address = user?.address.isNotEmpty == true
        ? user!.address
        : "No address provided";
    // Phone usually exists if logged in

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "CUSTOMER INFORMATION",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "Verified",
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow(Icons.person_rounded, "Customer Full Name", name),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              _buildInfoRow(
                Icons.phone_rounded,
                "Phone Number",
                user?.phone ?? "N/A",
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              _buildInfoRow(
                Icons.location_on_rounded,
                "Customer Address",
                address,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
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
    User? user,
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

          // Added Customer Info to QR view for visibility
          _buildCustomerInfo(user),

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
