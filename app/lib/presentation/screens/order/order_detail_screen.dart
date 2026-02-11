import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:frontend_otis/presentation/bloc/order/order_bloc.dart';
import 'package:frontend_otis/presentation/bloc/order/order_event.dart';
import 'package:frontend_otis/presentation/bloc/order/order_state.dart';
import 'package:frontend_otis/presentation/bloc/payment/payment_bloc.dart';
import 'package:frontend_otis/presentation/screens/payment/payment_screen.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrderDetailEvent(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? const Color(0xFF101622)
        : const Color(0xFFF6F6F8);
    final surfaceColor = isDarkMode ? const Color(0xFF1A2230) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const HeaderBar(title: 'Order Details', showBack: true),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailLoaded) {
            final order = state.order;
            return _buildContent(context, order, surfaceColor);
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Order order, Color surfaceColor) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Section
                _buildStatusSection(order, surfaceColor),
                const SizedBox(height: 2),

                // Product List
                _buildProductList(order, surfaceColor),
                const SizedBox(height: 2),

                // Delivery Info
                _buildDeliveryInfo(order, surfaceColor),
                const SizedBox(height: 2),

                // Cost Summary
                _buildCostSummary(order, surfaceColor),
                const SizedBox(height: 80), // Space for fixed footer
              ],
            ),
          ),
        ),
        // Fixed Footer
        _buildFixedFooter(order, surfaceColor),
      ],
    );
  }

  Widget _buildStatusSection(Order order, Color surfaceColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF135BEC);

    // Determine stepper status
    int currentStep = 0;
    if (order.status == OrderStatus.pendingPayment)
      currentStep = 0;
    else if (order.status == OrderStatus.processing)
      currentStep = 1;
    else if (order.status == OrderStatus.completed)
      currentStep = 2;

    return Container(
      color: surfaceColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.status == OrderStatus.completed
                ? 'Arrived on ${order.formattedCreatedAt}'
                : 'Arriving soon...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 32),
          // Stepper
          Stack(
            alignment: Alignment.center,
            children: [
              // Progress Line Background
              Container(
                height: 4,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              ),
              // Progress Line Active
              LayoutBuilder(
                builder: (context, constraints) {
                  double progressWidth = 0;
                  if (currentStep == 1)
                    progressWidth = (constraints.maxWidth - 40) / 2;
                  else if (currentStep == 2)
                    progressWidth = constraints.maxWidth - 40;

                  return Positioned(
                    left: 20,
                    child: Container(
                      height: 4,
                      width: progressWidth,
                      color: primaryColor,
                    ),
                  );
                },
              ),
              // Steps
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStepCircle(
                    Icons.check,
                    currentStep >= 0,
                    'Ordered',
                    primaryColor,
                    true,
                  ),
                  _buildStepCircle(
                    Icons.local_shipping,
                    currentStep >= 1,
                    'Shipping',
                    primaryColor,
                    currentStep >= 1,
                  ),
                  _buildStepCircle(
                    Icons.home,
                    currentStep >= 2,
                    'Delivered',
                    primaryColor,
                    currentStep >= 2,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24), // Extra padding for labels
        ],
      ),
    );
  }

  Widget _buildStepCircle(
    IconData icon,
    bool isActive,
    String label,
    Color primaryColor,
    bool isCompleted,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive
                ? primaryColor
                : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
          child: Icon(
            isActive && isCompleted && icon == Icons.check ? Icons.check : icon,
            size: 18,
            color: isActive ? Colors.white : Colors.grey[500],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? primaryColor : Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildProductList(Order order, Color surfaceColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items (${order.items.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDarkMode
                  ? Colors.grey[800]?.withValues(alpha: 0.5)
                  : Colors.grey[100],
            ),
            itemBuilder: (context, index) {
              final item = order.items[index];
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName ?? 'Product #${item.productId}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Qty: ${item.quantity}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                item.formattedTotalPrice,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(Order order, Color surfaceColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF135BEC);

    return Container(
      color: surfaceColor,
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: primaryColor),
                    const SizedBox(width: 8),
                    const Text(
                      'CUSTOMER INFORMATION',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCustomerDetailItem(
                  'Full Name',
                  'Nguyen Van A',
                  isDarkMode,
                ),
                const SizedBox(height: 12),
                _buildCustomerDetailItem(
                  'Delivery Address',
                  order.shippingAddress.isNotEmpty &&
                          !order.shippingAddress.contains("OTIS Shop")
                      ? order.shippingAddress
                      : "123 Ly Tu Trong, District 1, HCMC",
                  isDarkMode,
                  icon: Icons.location_on,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDetailItem(
    String label,
    String value,
    bool isDarkMode, {
    IconData? icon,
  }) {
    final primaryColor = const Color(0xFF135BEC);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(icon, size: 14, color: primaryColor),
              ),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCostSummary(Order order, Color surfaceColor) {
    final primaryColor = const Color(0xFF135BEC);
    return Container(
      color: surfaceColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ORDER SUMMARY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Subtotal',
            order.formattedTotalAmount,
          ), // Placeholder subtotal
          _buildSummaryRow('Shipping', 'Free'),
          _buildSummaryRow('Estimated Tax', '0 đ'), // Placeholder tax
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Cost',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                order.formattedTotalAmount,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedFooter(Order order, Color surfaceColor) {
    final primaryColor = const Color(0xFF135BEC);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Rate Product',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (order.status == OrderStatus.pendingPayment) {
                  _navigateToPayment(context, order);
                } else {
                  // Re-order logic
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                order.status == OrderStatus.pendingPayment
                    ? 'Pay Now'
                    : 'Re-order',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPayment(BuildContext context, Order order) async {
    try {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<PaymentBloc>(),
            child: PaymentScreen(order: order),
          ),
        ),
      );

      if (result == true) {
        if (mounted) {
          context.read<OrderBloc>().add(GetOrderDetailEvent(widget.orderId));
        }
      }
    } catch (e) {
      debugPrint('Navigation to Payment Screen failed: $e');
    }
  }
}
