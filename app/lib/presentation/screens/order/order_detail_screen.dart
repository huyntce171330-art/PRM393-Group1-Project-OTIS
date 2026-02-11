import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:frontend_otis/presentation/bloc/order/order_bloc.dart';
import 'package:frontend_otis/presentation/bloc/order/order_event.dart';
import 'package:frontend_otis/presentation/bloc/order/order_state.dart';
import 'package:frontend_otis/presentation/bloc/payment/payment_bloc.dart';
import 'package:frontend_otis/presentation/screens/payment/payment_screen.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';
import 'package:frontend_otis/presentation/widgets/order/status_badge.dart';

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
    return Scaffold(
      appBar: const HeaderBar(title: 'Order Details'),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailLoaded) {
            final order = state.order;
            return _buildContent(context, order);
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Order order) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.code}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Date: ${order.formattedCreatedAtTime}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Items List
          const Text(
            'Items',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = order.items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    // Placeholder for product image
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productId, // Should verify if name is available or fetch it
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.formattedUnitPrice} x ${item.quantity}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item.formattedTotalPrice,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(thickness: 1, height: 32),

          // Pricing Summary
          _buildSummaryRow('Shipping Address', order.shippingAddress),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Total Amount',
            order.formattedTotalAmount,
            isBold: true,
            isPrimary: true,
          ),

          const SizedBox(height: 32),

          // Actions
          if (order.status == OrderStatus.pendingPayment)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _navigateToPayment(context, order),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

          if (order.status == OrderStatus.completed)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Re-order logic (add items to cart)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Re-order functionality coming soon'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Re-order'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    bool isPrimary = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.grey[800],
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isPrimary ? AppColors.primary : Colors.grey[800],
            ),
          ),
        ),
      ],
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
        // Refresh order details if payment success
        if (mounted) {
          context.read<OrderBloc>().add(GetOrderDetailEvent(widget.orderId));
        }
      }
    } catch (e) {
      debugPrint('Navigation to Payment Screen failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open payment screen: $e')),
        );
      }
    }
  }
}
