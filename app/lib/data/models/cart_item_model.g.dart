// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      productId: safeStringFromJson(json['product_id']),
      quantity: safeIntFromJson(json['quantity']),
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'product_id': safeStringToJson(instance.productId),
      'quantity': safeIntToJson(instance.quantity),
    };
