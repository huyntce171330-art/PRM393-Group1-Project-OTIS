import 'package:sqflite/sqflite.dart';
import 'package:frontend_otis/data/datasources/cart/cart_remote_datasource.dart';
import 'package:frontend_otis/data/models/cart_item_model.dart';

class CartRemoteDatasourceImpl implements CartRemoteDatasource {
  final Database database;

  CartRemoteDatasourceImpl({required this.database});

  Future<int?> _getCurrentUserId() async {
    final rows = await database.query('app_session', limit: 1);
    if (rows.isEmpty) return null;
    final val = rows.first['user_id'];
    return val as int?;
  }

  @override
  Future<List<CartItemModel>> getCart() async {
    final userId = await _getCurrentUserId();
    if (userId == null) return [];

    final result = await database.query(
      'cart_items',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return result.map((e) => CartItemModel.fromJson(e)).toList();
  }

  @override
  Future<List<CartItemModel>> addToCart(String productId, int quantity) async {
    final userId = await _getCurrentUserId();
    if (userId == null) return [];

    final existing = await database.query(
      'cart_items',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );

    if (existing.isNotEmpty) {
      final currentQty = existing.first['quantity'] as int;
      await database.update(
        'cart_items',
        {'quantity': currentQty + quantity},
        where: 'user_id = ? AND product_id = ?',
        whereArgs: [userId, productId],
      );
    } else {
      await database.insert('cart_items', {
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
      });
    }

    return getCart();
  }

  @override
  Future<List<CartItemModel>> updateCartItem(String productId, int quantity) async {
    final userId = await _getCurrentUserId();
    if (userId == null) return [];

    if (quantity <= 0) {
      await removeFromCart(productId);
    } else {
      await database.update(
        'cart_items',
        {'quantity': quantity},
        where: 'user_id = ? AND product_id = ?',
        whereArgs: [userId, productId],
      );
    }

    return getCart();
  }

  @override
  Future<List<CartItemModel>> removeFromCart(String productId) async {
    final userId = await _getCurrentUserId();
    if (userId == null) return [];

    await database.delete(
      'cart_items',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );

    return getCart();
  }

  @override
  Future<void> clearCart() async {
    final userId = await _getCurrentUserId();
    if (userId == null) return;

    await database.delete(
      'cart_items',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
