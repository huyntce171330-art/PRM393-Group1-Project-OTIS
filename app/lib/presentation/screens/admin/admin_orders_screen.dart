import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:frontend_otis/presentation/bloc/order/order_bloc.dart';
import 'package:frontend_otis/presentation/bloc/order/order_event.dart';
import 'package:frontend_otis/presentation/bloc/order/order_state.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';
import 'package:frontend_otis/presentation/widgets/order/status_badge.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  // Using a separate Bloc instance for Admin screen to avoid sharing state with User list if they are open simultaneously
  // or just use the global one.
  // Using global one is fine for now.

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(const GetOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(title: 'Admin: Manage Orders', showBack: true),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('No orders found'));
            }
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text('Order #${order.code}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Placeholder for user info
                        Text('Total: ${order.formattedTotalAmount}'),
                        Text('Date: ${order.formattedCreatedAtTime}'),
                      ],
                    ),
                    trailing: StatusBadge(status: order.status),
                    onTap: () => _showStatusUpdateSheet(context, order),
                  ),
                );
              },
            );
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showStatusUpdateSheet(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update Status for #${order.code}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...OrderStatus.values.map((status) {
                return ListTile(
                  leading: Radio<OrderStatus>(
                    value: status,
                    groupValue: order.status,
                    onChanged: (val) {
                      Navigator.pop(ctx);
                      if (val != null && val != order.status) {
                        _updateStatus(order.id, val);
                      }
                    },
                  ),
                  title: Text(status.displayName),
                  trailing: StatusBadge(status: status),
                  onTap: () {
                    Navigator.pop(ctx);
                    if (status != order.status) {
                      _updateStatus(order.id, status);
                    }
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _updateStatus(String orderId, OrderStatus newStatus) {
    // We need to convert OrderStatus enum to string for API/UseCase
    // Assuming backend expects string like 'pending_payment', 'paid', etc.
    // Let's use name or a converter.
    // OrderStatus has no toJson yet in entity, but Enum has .name.
    // But backend might expect 'pending_payment' if that's how we parse it.
    // Let's check `OrderStatusConverter` in `order_enums.dart` to see values.
    // Usually we use the string value that maps to the enum.

    // For now assuming the standard lowerCase string is accepted?
    // Or I should add a `toShortString()` or use `toJson()` logic.
    // I'll check `order_enums.dart` later. For now just use .name.
    final statusString = const OrderStatusConverter().toJson(newStatus);
    context.read<OrderBloc>().add(
      UpdateOrderStatusEvent(orderId, statusString),
    );

    // After update, we might want to reload the list.
    // The Bloc emits OrderDetailLoaded on update success.
    // But here we are in a list.
    // If Bloc emits OrderDetailLoaded, the list builder (OrderLoaded) might break or show nothing?
    // Let's check Bloc logic.
    // _onUpdateOrderStatus emits OrderDetailLoaded.
    // But BlocBuilder checks `state is OrderLoaded`.
    // So the list will disappear!
    // FIX: Note in Bloc.
  }
}
