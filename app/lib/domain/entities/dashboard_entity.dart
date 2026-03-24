import 'package:equatable/equatable.dart';

/// Dashboard Entity - represents aggregated statistics for the admin dashboard.
/// All data is derived from existing database tables (no new tables created).
///
/// Revenue Business Logic:
/// - All revenue metrics (todayRevenue, monthRevenue, totalRevenue) = SUM(total_amount)
///   from orders WHERE status = 'completed' ONLY.
/// - confirmedRevenue = totalRevenue (all revenue is from completed orders).
/// - pendingRevenue = 0 (not applicable in completed-only logic).
/// - Top Selling Products revenue is also based only on 'completed' orders.
class DashboardEntity extends Equatable {
  /// Revenue metrics (all confirmed = payment.status = 'success')
  final double todayRevenue;
  final double monthRevenue;
  final double totalRevenue;

  /// Revenue breakdown
  /// Thuc nhan: orders + payments WHERE payment.status = 'success'
  final double confirmedRevenue;
  /// Cho thanh toan: orders + payments WHERE payment.status = 'pending'
  final double pendingRevenue;

  /// Count metrics
  final int totalCustomers;
  final int totalProducts;
  final int lowStockCount;
  final int todayNewOrders;

  /// Breakdown & lists
  final List<OrderStatusBreakdown> orderStatusBreakdown;
  final List<TopSellingProduct> topSellingProducts;
  final List<RecentOrder> recentOrders;
  final List<LowStockProduct> lowStockProducts;
  final List<DailyRevenue> weeklyRevenue;

  /// Timestamp
  final DateTime lastUpdated;

  const DashboardEntity({
    this.todayRevenue = 0.0,
    this.monthRevenue = 0.0,
    this.totalRevenue = 0.0,
    this.confirmedRevenue = 0.0,
    this.pendingRevenue = 0.0,
    this.totalCustomers = 0,
    this.totalProducts = 0,
    this.lowStockCount = 0,
    this.todayNewOrders = 0,
    required this.orderStatusBreakdown,
    required this.topSellingProducts,
    required this.recentOrders,
    required this.lowStockProducts,
    required this.weeklyRevenue,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        todayRevenue,
        monthRevenue,
        totalRevenue,
        confirmedRevenue,
        pendingRevenue,
        totalCustomers,
        totalProducts,
        lowStockCount,
        todayNewOrders,
        orderStatusBreakdown,
        topSellingProducts,
        recentOrders,
        lowStockProducts,
        weeklyRevenue,
        lastUpdated,
      ];

  DashboardEntity copyWith({
    double? todayRevenue,
    double? monthRevenue,
    double? totalRevenue,
    double? confirmedRevenue,
    double? pendingRevenue,
    int? totalCustomers,
    int? totalProducts,
    int? lowStockCount,
    int? todayNewOrders,
    List<OrderStatusBreakdown>? orderStatusBreakdown,
    List<TopSellingProduct>? topSellingProducts,
    List<RecentOrder>? recentOrders,
    List<LowStockProduct>? lowStockProducts,
    List<DailyRevenue>? weeklyRevenue,
    DateTime? lastUpdated,
  }) {
    return DashboardEntity(
      todayRevenue: todayRevenue ?? this.todayRevenue,
      monthRevenue: monthRevenue ?? this.monthRevenue,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      confirmedRevenue: confirmedRevenue ?? this.confirmedRevenue,
      pendingRevenue: pendingRevenue ?? this.pendingRevenue,
      totalCustomers: totalCustomers ?? this.totalCustomers,
      totalProducts: totalProducts ?? this.totalProducts,
      lowStockCount: lowStockCount ?? this.lowStockCount,
      todayNewOrders: todayNewOrders ?? this.todayNewOrders,
      orderStatusBreakdown: orderStatusBreakdown ?? this.orderStatusBreakdown,
      topSellingProducts: topSellingProducts ?? this.topSellingProducts,
      recentOrders: recentOrders ?? this.recentOrders,
      lowStockProducts: lowStockProducts ?? this.lowStockProducts,
      weeklyRevenue: weeklyRevenue ?? this.weeklyRevenue,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Breakdown of orders grouped by status.
class OrderStatusBreakdown extends Equatable {
  final String status;
  final int count;

  const OrderStatusBreakdown({
    required this.status,
    required this.count,
  });

  @override
  List<Object?> get props => [status, count];
}

/// Top selling product with quantity sold.
class TopSellingProduct extends Equatable {
  final int productId;
  final String productName;
  final int quantitySold;
  final double revenue;

  const TopSellingProduct({
    required this.productId,
    required this.productName,
    required this.quantitySold,
    required this.revenue,
  });

  @override
  List<Object?> get props => [productId, productName, quantitySold, revenue];
}

/// Recent order summary.
class RecentOrder extends Equatable {
  final int orderId;
  final String customerName;
  final String status;
  final double totalAmount;
  final DateTime createdAt;

  const RecentOrder({
    required this.orderId,
    required this.customerName,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [orderId, customerName, status, totalAmount, createdAt];
}

/// Product with low stock (below threshold).
class LowStockProduct extends Equatable {
  final int productId;
  final String productName;
  final int stockQuantity;

  const LowStockProduct({
    required this.productId,
    required this.productName,
    required this.stockQuantity,
  });

  @override
  List<Object?> get props => [productId, productName, stockQuantity];
}

/// Daily revenue for the last 7 days.
class DailyRevenue extends Equatable {
  final DateTime date;
  final double revenue;

  const DailyRevenue({
    required this.date,
    required this.revenue,
  });

  @override
  List<Object?> get props => [date, revenue];
}
