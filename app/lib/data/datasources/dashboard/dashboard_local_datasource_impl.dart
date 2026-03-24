import 'package:sqflite/sqflite.dart';

import '../../models/dashboard_model.dart';
import 'dashboard_local_datasource.dart';

/// Implementation of [DashboardLocalDataSource] that queries the SQLite database
/// using existing tables (orders, order_items, products, users, user_roles).
///
/// Revenue Business Logic:
/// - Revenue = SUM(total_amount) from orders WHERE status = 'completed' ONLY.
///   Only FULLY COMPLETED orders are counted as revenue. This ensures the
///   business only recognizes revenue when the order lifecycle is fully closed
///   (payment confirmed + goods delivered + customer received).
/// - Top Selling Products revenue is also based only on 'completed' orders.
class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final Database _database;

  DashboardLocalDataSourceImpl({required Database database}) : _database = database;

  @override
  Future<DashboardModel> getDashboardStatistics() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    final monthStart = DateTime(now.year, now.month, 1);
    final weekStart = todayStart.subtract(Duration(days: now.weekday - 1));

    final results = await Future.wait([
      _getTodayRevenue(todayStart, todayEnd),    // completed today
      _getMonthRevenue(monthStart),              // completed this month
      _getTotalRevenue(),                        // completed all time
      _getOrderStatusBreakdown(),
      _getTotalCustomers(),
      _getTotalProducts(),
      _getLowStockProducts(),
      _getTopSellingProducts(),
      _getRecentOrders(),
      _getWeeklyRevenue(weekStart),
      _getTodayNewOrders(todayStart, todayEnd),
    ]);

    final lowStockProducts = results[6] as List<LowStockProductModel>;
    final totalRevenue = results[2] as double;

    return DashboardModel(
      todayRevenue: results[0] as double,
      monthRevenue: results[1] as double,
      totalRevenue: totalRevenue,
      // confirmedRevenue & pendingRevenue are both set to totalRevenue since
      // we only recognize revenue from completed orders.
      confirmedRevenue: totalRevenue,
      pendingRevenue: 0.0,
      orderStatusBreakdown: results[3] as List<OrderStatusBreakdownModel>,
      totalCustomers: results[4] as int,
      totalProducts: results[5] as int,
      lowStockCount: lowStockProducts.length,
      lowStockProducts: lowStockProducts,
      topSellingProducts: results[7] as List<TopSellingProductModel>,
      recentOrders: results[8] as List<RecentOrderModel>,
      weeklyRevenue: results[9] as List<DailyRevenueModel>,
      todayNewOrders: results[10] as int,
      lastUpdated: DateTime.now(),
    );
  }

  // -------------------------------------------------------------------------
  // REVENUE QUERIES — all based on orders.status = 'completed' ONLY
  // -------------------------------------------------------------------------

  /// Today's completed revenue: orders WHERE status = 'completed' AND created today.
  Future<double> _getTodayRevenue(DateTime start, DateTime end) async {
    final result = await _database.rawQuery(
      '''
        SELECT COALESCE(SUM(total_amount), 0) AS revenue
        FROM orders
        WHERE status = 'completed'
          AND created_at >= ?
          AND created_at < ?
      ''',
      [start.toIso8601String(), end.toIso8601String()],
    );
    return (result.first['revenue'] as num?)?.toDouble() ?? 0.0;
  }

  /// This month's completed revenue.
  Future<double> _getMonthRevenue(DateTime monthStart) async {
    final result = await _database.rawQuery(
      '''
        SELECT COALESCE(SUM(total_amount), 0) AS revenue
        FROM orders
        WHERE status = 'completed'
          AND created_at >= ?
      ''',
      [monthStart.toIso8601String()],
    );
    return (result.first['revenue'] as num?)?.toDouble() ?? 0.0;
  }

  /// Total completed revenue (all time, orders with status = 'completed' only).
  Future<double> _getTotalRevenue() async {
    final result = await _database.rawQuery(
      '''
        SELECT COALESCE(SUM(total_amount), 0) AS revenue
        FROM orders
        WHERE status = 'completed'
      ''',
    );
    return (result.first['revenue'] as num?)?.toDouble() ?? 0.0;
  }

  // -------------------------------------------------------------------------
  // WEEKLY REVENUE — based on orders.status = 'completed' ONLY
  // -------------------------------------------------------------------------

  /// Weekly completed revenue for the last 7 days (Mon-Sun).
  Future<List<DailyRevenueModel>> _getWeeklyRevenue(DateTime weekStart) async {
    final result = await _database.rawQuery(
      '''
        SELECT
          DATE(created_at) AS date,
          COALESCE(SUM(total_amount), 0) AS revenue
        FROM orders
        WHERE status = 'completed'
          AND created_at >= ?
        GROUP BY DATE(created_at)
        ORDER BY date ASC
      ''',
      [weekStart.toIso8601String()],
    );

    // Build a map of existing data
    final dataMap = <String, double>{};
    for (final row in result) {
      final dateStr = row['date'] as String? ?? '';
      dataMap[dateStr] = (row['revenue'] as num?)?.toDouble() ?? 0.0;
    }

    // Fill in missing days with 0
    final List<DailyRevenueModel> weeklyRevenue = [];
    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dateStr =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      weeklyRevenue.add(DailyRevenueModel(
        date: day,
        revenue: dataMap[dateStr] ?? 0.0,
      ));
    }
    return weeklyRevenue;
  }

  // -------------------------------------------------------------------------
  // ORDER STATUS BREAKDOWN
  // -------------------------------------------------------------------------

  /// Counts all orders grouped by status (no filter — for full status overview).
  Future<List<OrderStatusBreakdownModel>> _getOrderStatusBreakdown() async {
    final result = await _database.rawQuery(
      '''
        SELECT status, COUNT(*) AS count
        FROM orders
        GROUP BY status
        ORDER BY count DESC
      ''',
    );
    return result.map((row) {
      return OrderStatusBreakdownModel(
        status: row['status'] as String? ?? '',
        count: (row['count'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  }

  // -------------------------------------------------------------------------
  // CUSTOMERS & PRODUCTS
  // -------------------------------------------------------------------------

  /// Total active customers (role = 'customer' and status = 'active').
  Future<int> _getTotalCustomers() async {
    final result = await _database.rawQuery(
      '''
        SELECT COUNT(DISTINCT u.user_id) AS customer_count
        FROM users u
        INNER JOIN user_roles ur ON u.role_id = ur.role_id
        WHERE ur.role_name = 'customer'
          AND u.status = 'active'
      ''',
    );
    return (result.first['customer_count'] as num?)?.toInt() ?? 0;
  }

  /// Total active products.
  Future<int> _getTotalProducts() async {
    final result = await _database.rawQuery(
      '''
        SELECT COUNT(*) AS product_count
        FROM products
        WHERE is_active = 1
      ''',
    );
    return (result.first['product_count'] as num?)?.toInt() ?? 0;
  }

  /// Low stock products (stock < 10).
  Future<List<LowStockProductModel>> _getLowStockProducts() async {
    final result = await _database.rawQuery(
      '''
        SELECT product_id, name, stock_quantity
        FROM products
        WHERE stock_quantity < 10
          AND is_active = 1
        ORDER BY stock_quantity ASC
        LIMIT 5
      ''',
    );
    return result.map((row) {
      return LowStockProductModel(
        productId: (row['product_id'] as num?)?.toInt() ?? 0,
        productName: (row['name'] as String?) ?? '',
        stockQuantity: (row['stock_quantity'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  }

  // -------------------------------------------------------------------------
  // TOP SELLING PRODUCTS — only from completed orders
  // -------------------------------------------------------------------------

  /// Top 5 products ranked by quantity sold from completed orders only.
  Future<List<TopSellingProductModel>> _getTopSellingProducts() async {
    final result = await _database.rawQuery(
      '''
        SELECT
          p.product_id,
          p.name AS product_name,
          COALESCE(SUM(oi.quantity), 0) AS quantity_sold,
          COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS revenue
        FROM products p
        LEFT JOIN order_items oi ON p.product_id = oi.product_id
        LEFT JOIN orders o ON oi.order_id = o.order_id
          AND o.status = 'completed'
        WHERE p.is_active = 1
        GROUP BY p.product_id, p.name
        ORDER BY quantity_sold DESC
        LIMIT 5
      ''',
    );
    return result.map((row) {
      return TopSellingProductModel(
        productId: (row['product_id'] as num?)?.toInt() ?? 0,
        productName: (row['product_name'] as String?) ?? '',
        quantitySold: (row['quantity_sold'] as num?)?.toInt() ?? 0,
        revenue: (row['revenue'] as num?)?.toDouble() ?? 0.0,
      );
    }).toList();
  }

  // -------------------------------------------------------------------------
  // RECENT ORDERS
  // -------------------------------------------------------------------------

  /// 5 most recent orders (all statuses, for the orders list on dashboard).
  Future<List<RecentOrderModel>> _getRecentOrders() async {
    final result = await _database.rawQuery(
      '''
        SELECT
          o.order_id,
          COALESCE(u.full_name, 'Khach vang lai') AS customer_name,
          o.status,
          o.total_amount,
          o.created_at
        FROM orders o
        LEFT JOIN users u ON o.user_id = u.user_id
        ORDER BY o.created_at DESC
        LIMIT 5
      ''',
    );
    return result.map((row) {
      final createdAtRaw = row['created_at'];
      DateTime createdAt;
      if (createdAtRaw is String) {
        createdAt = DateTime.tryParse(createdAtRaw) ?? DateTime.now();
      } else {
        createdAt = DateTime.now();
      }
      return RecentOrderModel(
        orderId: (row['order_id'] as num?)?.toInt() ?? 0,
        customerName: (row['customer_name'] as String?) ?? '',
        status: (row['status'] as String?) ?? '',
        totalAmount: (row['total_amount'] as num?)?.toDouble() ?? 0.0,
        createdAt: createdAt,
      );
    }).toList();
  }

  // -------------------------------------------------------------------------
  // TODAY'S NEW ORDERS COUNT
  // -------------------------------------------------------------------------

  /// Count of all orders created today (regardless of status).
  Future<int> _getTodayNewOrders(DateTime start, DateTime end) async {
    final result = await _database.rawQuery(
      '''
        SELECT COUNT(*) AS order_count
        FROM orders
        WHERE created_at >= ?
          AND created_at < ?
      ''',
      [start.toIso8601String(), end.toIso8601String()],
    );
    return (result.first['order_count'] as num?)?.toInt() ?? 0;
  }
}
