// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductListModel _$ProductListModelFromJson(Map<String, dynamic> json) =>
    ProductListModel(
      products: ProductListModel._productsFromJson(json['data']),
      page: safeIntFromJson(json['page']),
      limit: safeIntFromJson(json['limit']),
      total: safeIntFromJson(json['total']),
      totalPages: safeIntFromJson(json['totalPages']),
      hasMore: safeBoolFromJson(json['hasMore']),
    );

Map<String, dynamic> _$ProductListModelToJson(ProductListModel instance) =>
    <String, dynamic>{
      'data': instance.products,
      'page': safeIntToJson(instance.page),
      'limit': safeIntToJson(instance.limit),
      'total': safeIntToJson(instance.total),
      'totalPages': safeIntToJson(instance.totalPages),
      'hasMore': safeBoolToJson(instance.hasMore),
    };
