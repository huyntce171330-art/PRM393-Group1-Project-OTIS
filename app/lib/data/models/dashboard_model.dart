import '../../domain/entities/dashboard_entity.dart';

/// Data model for DashboardEntity with JSON serialization support.
/// Follows BankAccountModel pattern: model extends entity.
///
/// Revenue Business Logic:
/// - All revenue metrics: SUM(total_amount) from orders WHERE status = 'completed' ONLY.
/// - confirmedRevenue = totalRevenue (all revenue is from completed orders).
/// - pendingRevenue = 0.
class DashboardModel extends DashboardEntity {
  const DashboardModel({
    super.todayRevenue,
    super.monthRevenue,
    super.totalRevenue,
    super.confirmedRevenue,
    super.pendingRevenue,
    super.totalCustomers,
    super.totalProducts,
    super.lowStockCount,
    super.todayNewOrders,
    required super.orderStatusBreakdown,
    required super.topSellingProducts,
    required super.recentOrders,
    required super.lowStockProducts,
    required super.weeklyRevenue,
    required super.lastUpdated,
  });

  /// Factory constructor to create DashboardModel from JSON map (SQLite row map).
  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      todayRevenue: (json['todayRevenue'] as num?)?.toDouble() ?? 0.0,
      monthRevenue: (json['monthRevenue'] as num?)?.toDouble() ?? 0.0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      confirmedRevenue: (json['confirmedRevenue'] as num?)?.toDouble() ?? 0.0,
      pendingRevenue: (json['pendingRevenue'] as num?)?.toDouble() ?? 0.0,
      totalCustomers: (json['totalCustomers'] as num?)?.toInt() ?? 0,
      totalProducts: (json['totalProducts'] as num?)?.toInt() ?? 0,
      lowStockCount: (json['lowStockCount'] as num?)?.toInt() ?? 0,
      todayNewOrders: (json['todayNewOrders'] as num?)?.toInt() ?? 0,
      orderStatusBreakdown:
          (json['orderStatusBreakdown'] as List<dynamic>?)
              ?.map(
                (e) => OrderStatusBreakdownModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      topSellingProducts:
          (json['topSellingProducts'] as List<dynamic>?)
              ?.map(
                (e) =>
                    TopSellingProductModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      recentOrders:
          (json['recentOrders'] as List<dynamic>?)
              ?.map((e) => RecentOrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lowStockProducts:
          (json['lowStockProducts'] as List<dynamic>?)
              ?.map(
                (e) => LowStockProductModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      weeklyRevenue:
          (json['weeklyRevenue'] as List<dynamic>?)
              ?.map(
                (e) => DailyRevenueModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      lastUpdated: json['lastUpdated'] != null
          ? (json['lastUpdated'] is DateTime
                ? json['lastUpdated'] as DateTime
                : DateTime.tryParse(json['lastUpdated'] as String? ?? '') ??
                      DateTime.now())
          : DateTime.now(),
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'todayRevenue': todayRevenue,
      'monthRevenue': monthRevenue,
      'totalRevenue': totalRevenue,
      'confirmedRevenue': confirmedRevenue,
      'pendingRevenue': pendingRevenue,
      'totalCustomers': totalCustomers,
      'totalProducts': totalProducts,
      'lowStockCount': lowStockCount,
      'todayNewOrders': todayNewOrders,
      'orderStatusBreakdown': orderStatusBreakdown
          .map((e) => OrderStatusBreakdownModel.fromDomain(e).toJson())
          .toList(),
      'topSellingProducts': topSellingProducts
          .map((e) => TopSellingProductModel.fromDomain(e).toJson())
          .toList(),
      'recentOrders': recentOrders
          .map((e) => RecentOrderModel.fromDomain(e).toJson())
          .toList(),
      'lowStockProducts': lowStockProducts
          .map((e) => LowStockProductModel.fromDomain(e).toJson())
          .toList(),
      'weeklyRevenue': weeklyRevenue
          .map((e) => DailyRevenueModel.fromDomain(e).toJson())
          .toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Convert to domain entity (returns this since model extends entity).
  DashboardEntity toDomain() => this;

  /// Convert from domain entity.
  factory DashboardModel.fromDomain(DashboardEntity entity) {
    return DashboardModel(
      todayRevenue: entity.todayRevenue,
      monthRevenue: entity.monthRevenue,
      totalRevenue: entity.totalRevenue,
      confirmedRevenue: entity.confirmedRevenue,
      pendingRevenue: entity.pendingRevenue,
      totalCustomers: entity.totalCustomers,
      totalProducts: entity.totalProducts,
      lowStockCount: entity.lowStockCount,
      todayNewOrders: entity.todayNewOrders,
      orderStatusBreakdown: entity.orderStatusBreakdown,
      topSellingProducts: entity.topSellingProducts,
      recentOrders: entity.recentOrders,
      lowStockProducts: entity.lowStockProducts,
      weeklyRevenue: entity.weeklyRevenue,
      lastUpdated: entity.lastUpdated,
    );
  }
}

/// Model for OrderStatusBreakdown entity.
class OrderStatusBreakdownModel extends OrderStatusBreakdown {
  const OrderStatusBreakdownModel({
    required super.status,
    required super.count,
  });

  /// Factory from JSON map (SQLite row).
  factory OrderStatusBreakdownModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusBreakdownModel(
      status: json['status'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {'status': status, 'count': count};
  }

  /// Convert from domain entity.
  factory OrderStatusBreakdownModel.fromDomain(OrderStatusBreakdown entity) {
    return OrderStatusBreakdownModel(
      status: entity.status,
      count: entity.count,
    );
  }
}

/// Model for TopSellingProduct entity.
class TopSellingProductModel extends TopSellingProduct {
  const TopSellingProductModel({
    required super.productId,
    required super.productName,
    required super.quantitySold,
    required super.revenue,
  });

  /// Factory from JSON map (SQLite row).
  factory TopSellingProductModel.fromJson(Map<String, dynamic> json) {
    return TopSellingProductModel(
      productId:
          (json['productId'] as num?)?.toInt() ??
          (json['product_id'] as num?)?.toInt() ??
          0,
      productName:
          (json['productName'] as String?) ??
          (json['product_name'] as String?) ??
          '',
      quantitySold:
          (json['quantitySold'] as num?)?.toInt() ??
          (json['quantity_sold'] as num?)?.toInt() ??
          0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantitySold': quantitySold,
      'revenue': revenue,
    };
  }

  /// Convert from domain entity.
  factory TopSellingProductModel.fromDomain(TopSellingProduct entity) {
    return TopSellingProductModel(
      productId: entity.productId,
      productName: entity.productName,
      quantitySold: entity.quantitySold,
      revenue: entity.revenue,
    );
  }
}

/// Model for RecentOrder entity.
class RecentOrderModel extends RecentOrder {
  const RecentOrderModel({
    required super.orderId,
    required super.customerName,
    required super.status,
    required super.totalAmount,
    required super.createdAt,
  });

  /// Factory from JSON map (SQLite row).
  factory RecentOrderModel.fromJson(Map<String, dynamic> json) {
    return RecentOrderModel(
      orderId:
          (json['orderId'] as num?)?.toInt() ??
          (json['order_id'] as num?)?.toInt() ??
          0,
      customerName:
          (json['customerName'] as String?) ??
          (json['customer_name'] as String?) ??
          '',
      status: json['status'] as String? ?? '',
      totalAmount:
          (json['totalAmount'] as num?)?.toDouble() ??
          (json['total_amount'] as num?)?.toDouble() ??
          0.0,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is DateTime
                ? json['createdAt'] as DateTime
                : DateTime.tryParse(json['createdAt'] as String? ?? '') ??
                      DateTime.now())
          : DateTime.now(),
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'customerName': customerName,
      'status': status,
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Convert from domain entity.
  factory RecentOrderModel.fromDomain(RecentOrder entity) {
    return RecentOrderModel(
      orderId: entity.orderId,
      customerName: entity.customerName,
      status: entity.status,
      totalAmount: entity.totalAmount,
      createdAt: entity.createdAt,
    );
  }
}

/// Model for LowStockProduct entity.
class LowStockProductModel extends LowStockProduct {
  const LowStockProductModel({
    required super.productId,
    required super.productName,
    required super.stockQuantity,
  });

  /// Factory from JSON map (SQLite row).
  factory LowStockProductModel.fromJson(Map<String, dynamic> json) {
    return LowStockProductModel(
      productId:
          (json['productId'] as num?)?.toInt() ??
          (json['id'] as num?)?.toInt() ??
          0,
      productName:
          (json['productName'] as String?) ?? (json['name'] as String?) ?? '',
      stockQuantity:
          (json['stockQuantity'] as num?)?.toInt() ??
          (json['stock_quantity'] as num?)?.toInt() ??
          0,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'stockQuantity': stockQuantity,
    };
  }

  /// Convert from domain entity.
  factory LowStockProductModel.fromDomain(LowStockProduct entity) {
    return LowStockProductModel(
      productId: entity.productId,
      productName: entity.productName,
      stockQuantity: entity.stockQuantity,
    );
  }
}

/// Model for DailyRevenue entity.
class DailyRevenueModel extends DailyRevenue {
  const DailyRevenueModel({required super.date, required super.revenue});

  /// Factory from JSON map (SQLite row).
  factory DailyRevenueModel.fromJson(Map<String, dynamic> json) {
    return DailyRevenueModel(
      date: json['date'] != null
          ? (json['date'] is DateTime
                ? json['date'] as DateTime
                : DateTime.tryParse(json['date'] as String? ?? '') ??
                      DateTime.now())
          : DateTime.now(),
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {'date': date.toIso8601String(), 'revenue': revenue};
  }

  /// Convert from domain entity.
  factory DailyRevenueModel.fromDomain(DailyRevenue entity) {
    return DailyRevenueModel(date: entity.date, revenue: entity.revenue);
  }
}
