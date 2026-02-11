import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/domain/usecases/order/create_order_usecase.dart';
import 'package:frontend_otis/domain/usecases/order/get_order_detail_usecase.dart';
import 'package:frontend_otis/domain/usecases/order/get_orders_usecase.dart';
import 'package:frontend_otis/presentation/bloc/order/order_event.dart';
import 'package:frontend_otis/presentation/bloc/order/order_state.dart';

import 'package:frontend_otis/domain/usecases/order/update_order_status_usecase.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrdersUseCase getOrdersUseCase;
  final GetOrderDetailUseCase getOrderDetailUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;

  OrderBloc({
    required this.getOrdersUseCase,
    required this.getOrderDetailUseCase,
    required this.createOrderUseCase,
    required this.updateOrderStatusUseCase,
  }) : super(OrderInitial()) {
    on<GetOrdersEvent>(_onGetOrders);
    on<GetOrderDetailEvent>(_onGetOrderDetail);
    on<CreateOrderEvent>(_onCreateOrder);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
  }

  Future<void> _onGetOrders(
    GetOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await getOrdersUseCase.call();
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (orders) => emit(OrderLoaded(orders)),
    );
  }

  Future<void> _onGetOrderDetail(
    GetOrderDetailEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await getOrderDetailUseCase.call(event.orderId);
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderDetailLoaded(order)),
    );
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await createOrderUseCase.call(event.order);
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderCreated(order)),
    );
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<OrderState> emit,
  ) async {
    // Optimistic update or keep current state while loading?
    // For simplicity, we show loading then refresh.
    // But to keep list context, we need to know current state.
    final currentState = state;
    emit(OrderLoading());

    final result = await updateOrderStatusUseCase.call(
      event.orderId,
      event.status,
    );

    result.fold((failure) => emit(OrderError(failure.message)), (updatedOrder) {
      if (currentState is OrderLoaded) {
        final updatedList = currentState.orders.map((order) {
          return order.id == updatedOrder.id ? updatedOrder : order;
        }).toList();
        emit(OrderLoaded(updatedList));
      } else if (currentState is OrderDetailLoaded) {
        emit(OrderDetailLoaded(updatedOrder));
      } else {
        // If we were in some other state (e.g. initial), just emit details?
        // Or create a new list with just this order?
        // Safer to emit DetailLoaded as a fallback.
        emit(OrderDetailLoaded(updatedOrder));
      }
    });
  }
}
