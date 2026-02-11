import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/presentation/bloc/order/order_bloc.dart';
import 'package:frontend_otis/presentation/bloc/order/order_state.dart';
import 'package:frontend_otis/presentation/bloc/order/order_event.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';
import 'package:frontend_otis/presentation/widgets/order/order_card.dart';
import 'package:go_router/go_router.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(title: 'My Orders'),
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
                return OrderCard(
                  order: order,
                  onTap: () => context.push('/order/${order.id}'),
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
}
