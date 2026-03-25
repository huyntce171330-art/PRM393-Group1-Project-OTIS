import 'package:sqflite/sqflite.dart';
import 'package:frontend_otis/core/error/exceptions.dart';
import 'package:frontend_otis/data/datasources/order/order_remote_datasource.dart';
import 'package:frontend_otis/data/models/order_model.dart';

class OrderRemoteDatasourceImpl implements OrderRemoteDatasource {
  final Database database;

  OrderRemoteDatasourceImpl(this.database);

  @override
  Future<List<OrderModel>> fetchOrders() async {
    try {
      // Fetch orders for user_id = 2 (Simulating logged in user)
      // Joined with users for customer_name and payments for payment_method
      final List<Map<String, dynamic>> orderMaps = await database.rawQuery(
        '''
        SELECT o.*, u.full_name as customer_name, p.method as payment_method
        FROM orders o
        JOIN users u ON o.user_id = u.user_id
        LEFT JOIN payments p ON o.order_id = p.order_id
        WHERE o.user_id = ?
        ORDER BY o.created_at DESC
      ''',
        [2],
      );

      final List<OrderModel> orders = [];

      for (var orderMap in orderMaps) {
        final orderId = orderMap['order_id'];

        final List<Map<String, dynamic>> itemMaps = await database.rawQuery(
          '''
          SELECT oi.*, p.name as product_name 
          FROM order_items oi
          JOIN products p ON oi.product_id = p.product_id
          WHERE oi.order_id = ?
        ''',
          [orderId],
        );

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
  Future<List<OrderModel>> fetchAllOrders() async {
    try {
      // Fetch ALL orders for admin view
      final List<Map<String, dynamic>> orderMaps = await database.rawQuery(
        '''
        SELECT o.*, u.full_name as customer_name, p.method as payment_method
        FROM orders o
        JOIN users u ON o.user_id = u.user_id
        LEFT JOIN payments p ON o.order_id = p.order_id
        ORDER BY o.created_at DESC
      ''',
      );

      final List<OrderModel> orders = [];

      for (var orderMap in orderMaps) {
        final orderId = orderMap['order_id'];

        final List<Map<String, dynamic>> itemMaps = await database.rawQuery(
          '''
          SELECT oi.*, p.name as product_name 
          FROM order_items oi
          JOIN products p ON oi.product_id = p.product_id
          WHERE oi.order_id = ?
        ''',
          [orderId],
        );

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
      // Handle ID passed as String but DB uses Integer
      List<Map<String, dynamic>> orderMaps;

      final query = '''
        SELECT o.*, u.full_name as customer_name, p.method as payment_method
        FROM orders o
        JOIN users u ON o.user_id = u.user_id
        LEFT JOIN payments p ON o.order_id = p.order_id
        WHERE o.order_id = ? OR o.code = ?
      ''';

      orderMaps = await database.rawQuery(query, [id, id]);

      if (orderMaps.isEmpty) {
        throw ServerException(message: 'Order not found');
      }

      final orderMap = orderMaps.first;
      final orderId = orderMap['order_id'];

      final List<Map<String, dynamic>> itemMaps = await database.rawQuery(
        '''
        SELECT oi.*, p.name as product_name 
        FROM order_items oi
        JOIN products p ON oi.product_id = p.product_id
        WHERE oi.order_id = ?
      ''',
        [orderId],
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
    return await database.transaction((txn) async {
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
          'source': orderData['source'] ?? 'cart',
          'user_id': userId,
          'created_at': DateTime.now().toIso8601String(),
        });

        // 2. Insert Payment Record
        final paymentMethod = orderData['payment_method'] ?? 'cod';
        await txn.insert('payments', {
          'order_id': orderId,
          'payment_code': 'PAY-${DateTime.now().millisecondsSinceEpoch}',
          'amount': totalAmount,
          'method': paymentMethod,
          'status': 'pending',
          'created_at': DateTime.now().toIso8601String(),
        });

        // 3. Insert Items and Update Stock
        final items = orderData['items'] as List;
        for (var item in items) {
          final int productId = int.parse(item['product_id'].toString());
          final int quantity = int.parse(item['quantity'].toString());

          // 1. Check stock availability
          final List<Map<String, dynamic>> productQueryResult = await txn.query(
            'products',
            columns: ['stock_quantity'],
            where: 'product_id = ?',
            whereArgs: [productId],
          );

          if (productQueryResult.isEmpty) {
            throw ServerException(message: "Product not found: $productId");
          }

          final int currentStock = productQueryResult.first['stock_quantity'];
          if (currentStock < quantity) {
            final String productName = item['product_name'] ?? 'Product';
            throw ServerException(
              message: "Insufficient stock for $productName ($currentStock available)",
            );
          }

          // 2. Insert Order Item
          await txn.insert('order_items', {
            'order_id': orderId,
            'product_id': productId,
            'quantity': quantity,
            'unit_price': item['price'],
          });

          // 3. Decrement Stock
          await txn.update(
            'products',
            {'stock_quantity': currentStock - quantity},
            where: 'product_id = ?',
            whereArgs: [productId],
          );
        }

        // Fetch created order to return full model
        // (Simplified return matching current implementation but including new fields)
        final createdOrderMap = {
          'order_id': orderId,
          'code': code,
          'total_amount': totalAmount,
          'status': status,
          'shipping_address': shippingAddress,
          'created_at': DateTime.now().toIso8601String(),
          'user_id': userId,
          'customer_name': orderData['customer_name'],
          'payment_method': paymentMethod,
          'order_items': items
              .map(
                (i) => {
                  'product_id': i['product_id'],
                  'quantity': i['quantity'],
                  'unit_price': i['price'],
                  'product_name': i['product_name'] ?? '',
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
      // Fetch current order to check previous status and get items
      final List<Map<String, dynamic>> maps = await database.query(
        'orders',
        where: 'order_id = ? OR code = ?',
        whereArgs: [id, id],
      );

      if (maps.isEmpty) {
        throw ServerException(message: 'Order not found for update');
      }

      final String currentStatus = maps.first['status'];
      final int orderId = maps.first['order_id'];

      // If transition to canceled, restore stock
      if (currentStatus != 'canceled' && status == 'canceled') {
        final List<Map<String, dynamic>> items = await database.query(
          'order_items',
          where: 'order_id = ?',
          whereArgs: [orderId],
        );

        for (var item in items) {
          final int productId = item['product_id'];
          final int quantity = item['quantity'];

          await database.rawUpdate(
            'UPDATE products SET stock_quantity = stock_quantity + ? WHERE product_id = ?',
            [quantity, productId],
          );
        }
      }

      // Update status
      int count = await database.update(
        'orders',
        {'status': status},
        where: 'order_id = ?',
        whereArgs: [orderId],
      );

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
