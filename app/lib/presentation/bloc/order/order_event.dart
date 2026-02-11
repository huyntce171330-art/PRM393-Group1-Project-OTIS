import 'package:equatable/equatable.dart';
import 'package:frontend_otis/domain/entities/order.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class GetOrdersEvent extends OrderEvent {
  final Map<String, dynamic>? filter;
  const GetOrdersEvent({this.filter});

  @override
  List<Object?> get props => [filter];
}

class GetOrderDetailEvent extends OrderEvent {
  final String orderId;
  const GetOrderDetailEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class CreateOrderEvent extends OrderEvent {
  final Order order;
  const CreateOrderEvent(this.order);

  @override
  List<Object?> get props => [order];
}

class UpdateOrderStatusEvent extends OrderEvent {
  final String orderId;
  final String status;
  const UpdateOrderStatusEvent(this.orderId, this.status);

  @override
  List<Object?> get props => [orderId, status];
}
