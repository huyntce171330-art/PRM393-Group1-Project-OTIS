import 'package:frontend_otis/core/error/exceptions.dart';
import 'package:frontend_otis/core/injections/database_helper.dart';
import 'package:frontend_otis/data/datasources/order/order_remote_datasource.dart';
import 'package:frontend_otis/data/models/order_model.dart';

class OrderRemoteDatasourceImpl implements OrderRemoteDatasource {
  OrderRemoteDatasourceImpl();

  @override
  Future<List<OrderModel>> fetchOrders() async {
    try {
      final db = await DatabaseHelper.database;
      // Fetch orders for user_id = 2 (Simulating logged in user)
      final List<Map<String, dynamic>> orderMaps = await db.query(
        'orders',
        where: 'user_id = ?',
        whereArgs: [2],
        orderBy: 'created_at DESC',
      );

      final List<OrderModel> orders = [];

      for (var orderMap in orderMaps) {
        final orderId = orderMap['order_id'];
        final List<Map<String, dynamic>> itemMaps = await db.query(
          'order_items',
          where: 'order_id = ?',
          whereArgs: [orderId],
        );

        // Merge items into order map for Model parsing
        final fullOrderMap = Map<String, dynamic>.from(orderMap);
        fullOrderMap['order_items'] = itemMaps;

        orders.add(OrderModel.fromJson(fullOrderMap));
      }

      return orders;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<OrderModel> fetchOrderDetail(String id) async {
    try {
      final db = await DatabaseHelper.database;

      // Handle ID being passed as String but DB using Integer
      // If ID starts with "ORD-", query by code, else by ID
      List<Map<String, dynamic>> orderMaps;

      if (int.tryParse(id) != null) {
        orderMaps = await db.query(
          'orders',
          where: 'order_id = ?',
          whereArgs: [id],
        );
      } else {
        // Maybe it's a code? Or just invalid.
        // Let's assume the app passes the ID (int) as string.
        // But wait, createOrder generates ID as timestamp (String) in recent edits?
        // The SQLite schema uses AUTOINCREMENT INTEGER for order_id.
        // And "code" as TEXT.
        // If createOrder passes a String ID (timestamp) to "createOrder", it might fail insertion if mapped to order_id.
        // I need to fix createOrder to let DB handle ID, or map "id" to "code".

        // Let's query by ID or Code just to be safe
        orderMaps = await db.query(
          'orders',
          where: 'order_id = ? OR code = ?',
          whereArgs: [id, id],
        );
      }

      if (orderMaps.isEmpty) {
        throw ServerException(message: 'Order not found');
      }

      final orderMap = orderMaps.first;
      final orderId = orderMap['order_id'];

      final List<Map<String, dynamic>> itemMaps = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [orderId],
      );

      final fullOrderMap = Map<String, dynamic>.from(orderMap);
      fullOrderMap['order_items'] = itemMaps;

      return OrderModel.fromJson(fullOrderMap);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
    final db = await DatabaseHelper.database;
    return await db.transaction((txn) async {
      try {
        // Prepare Order Data
        // orderData comes from Repository which maps Order entity.
        // Entity has 'id' (timestamp string), 'code'.
        // We should ignore the 'id' (let DB auto-increment) and use 'code'.
        // Or if 'id' is used as 'code'...

        // Map keys from Repository: 'total_amount', 'shipping_address', 'items', 'code' (need to ensure this exists)
        // Check OrderRepositoryImpl.createOrder to see what it sends.
        // It currently maps 'items', 'total_amount', 'shipping_address'.
        // It MISSES 'code', 'status', 'user_id'.
        // I need to update Repository to send these OR handle defaults here.
        // I'll handle defaults/logic here for robustness if keys are missing.

        final code =
            orderData['code'] ?? 'ORD-${DateTime.now().millisecondsSinceEpoch}';
        final status = orderData['status'] ?? 'pending_payment';
        final userId = 2; // Hardcoded logged in user
        final totalAmount = orderData['total_amount'];
        final shippingAddress = orderData['shipping_address'];

        // Insert Order
        final orderId = await txn.insert('orders', {
          'code': code,
          'total_amount': totalAmount,
          'status': status,
          'shipping_address': shippingAddress,
          'user_id': userId,
          'created_at': DateTime.now().toIso8601String(),
        });

        // Insert Items
        final items = orderData['items'] as List;
        for (var item in items) {
          await txn.insert('order_items', {
            'order_id': orderId,
            'product_id': item['product_id'],
            'quantity': item['quantity'],
            'unit_price': item['price'],
          });
        }

        // Fetch created order to return full model
        // We can't reuse fetchOrderDetail easily inside transaction without passing txn.
        // So just construct it efficiently.

        // Need to refetch items with details if needed, but we have input.
        // But OrderModel needs OrderItemModels.

        // Just return what we created but with the new DB ID.
        // We need to fetch items again to match format or just map input.

        final createdOrderMap = {
          'order_id': orderId,
          'code': code,
          'total_amount': totalAmount,
          'status': status,
          'shipping_address': shippingAddress,
          'created_at': DateTime.now().toIso8601String(),
          'user_id': userId,
          'order_items': items
              .map(
                (i) => {
                  'product_id': i['product_id'],
                  'quantity': i['quantity'],
                  'unit_price': i['price'],
                },
              )
              .toList(),
        };

        return OrderModel.fromJson(createdOrderMap);
      } catch (e) {
        throw ServerException(message: "Create Order Failed: $e");
      }
    });
  }

  @override
  Future<OrderModel> updateOrderStatus(String id, String status) async {
    try {
      final db = await DatabaseHelper.database;

      // Update status
      // Handle id vs code
      int count = await db.update(
        'orders',
        {'status': status},
        where: 'order_id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        // Try code
        count = await db.update(
          'orders',
          {'status': status},
          where: 'code = ?',
          whereArgs: [id],
        );
      }

      if (count == 0) {
        throw ServerException(message: 'Order not found for update');
      }

      // Return updated order
      return await fetchOrderDetail(id);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
