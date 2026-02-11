// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: safeStringFromJson(json['order_id']),
  code: safeStringFromJson(json['code']),
  totalAmount: safeDoubleFromJson(json['total_amount']),
  status: orderStatusFromJson(json['status']),
  shippingAddress: safeStringFromJson(json['shipping_address']),
  createdAt: safeDateTimeFromJson(json['created_at']),
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  userId: nullableSafeStringFromJson(json['user_id']),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'order_id': safeStringToJson(instance.id),
      'code': safeStringToJson(instance.code),
      'total_amount': safeDoubleToJson(instance.totalAmount),
      'status': orderStatusToJson(instance.status),
      'shipping_address': safeStringToJson(instance.shippingAddress),
      'created_at': safeDateTimeToJson(instance.createdAt),
      'items': instance.items.map((e) => e.toJson()).toList(),
      if (nullableSafeStringToJson(instance.userId) case final value?)
        'user_id': value,
    };
