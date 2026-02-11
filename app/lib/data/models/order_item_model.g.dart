// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      productId: safeStringFromJson(json['product_id']),
      quantity: safeIntFromJson(json['quantity']),
      unitPrice: safeDoubleFromJson(json['unit_price']),
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'product_id': safeStringToJson(instance.productId),
      'quantity': safeIntToJson(instance.quantity),
      'unit_price': safeDoubleToJson(instance.unitPrice),
    };
