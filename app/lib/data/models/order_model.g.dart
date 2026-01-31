// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['id'] as String,
  code: json['code'] as String,
  totalAmount: (json['totalAmount'] as num).toDouble(),
  status: const OrderStatusConverter().fromJson(json['status'] as String),
  shippingAddress: json['shippingAddress'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'totalAmount': instance.totalAmount,
      'status': const OrderStatusConverter().toJson(instance.status),
      'shippingAddress': instance.shippingAddress,
      'createdAt': instance.createdAt.toIso8601String(),
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
