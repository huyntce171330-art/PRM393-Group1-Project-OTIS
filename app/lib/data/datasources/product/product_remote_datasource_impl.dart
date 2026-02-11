import 'package:frontend_otis/core/error/failures.dart';
import 'package:frontend_otis/data/datasources/product/product_remote_datasource.dart';
import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/data/models/product_list_model.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/data/models/tire_spec_model.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:sqflite/sqflite.dart';

/// Implementation of [ProductRemoteDatasource] using SQLite database.
/// Handles all product-related database operations with pagination.
class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final Database database;

  ProductRemoteDatasourceImpl({required this.database});

  @override
  Future<ProductListModel> getProducts({
    required int page,
    required int limit,
    ProductFilter? filter,
  }) async {
    if (page < 1) page = 1;
    if (limit < 1) limit = 10;

    final offset = (page - 1) * limit;

    // Extract search query from filter
    final searchQuery = filter?.searchQuery;

    // Build dynamic WHERE clause
    final whereClauses = <String>['p.is_active = 1'];
    final whereArgs = <dynamic>[];

    // Add search query condition (search by name or SKU, case-insensitive)
    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClauses.add('(p.name LIKE ? OR p.sku LIKE ?)');
      whereArgs.add('%$searchQuery%');
      whereArgs.add('%$searchQuery%');
    }

    // Add category filter if provided
    if (filter?.categoryId != null) {
      whereClauses.add('p.category_id = ?');
      whereArgs.add(filter!.categoryId);
    }

    // Add brand filter if provided
    if (filter?.brandId != null) {
      whereClauses.add('p.brand_id = ?');
      whereArgs.add(filter!.brandId);
    }

    // Add vehicle make filter if provided
    if (filter?.vehicleMakeId != null) {
      whereClauses.add('p.make_id = ?');
      whereArgs.add(filter!.vehicleMakeId);
    }

    // Add price range filters if provided
    if (filter?.minPrice != null) {
      whereClauses.add('p.price >= ?');
      whereArgs.add(filter!.minPrice);
    }
    if (filter?.maxPrice != null) {
      whereClauses.add('p.price <= ?');
      whereArgs.add(filter!.maxPrice);
    }

    // Join all WHERE clauses
    final whereString = whereClauses.join(' AND ');

    // 1. Get total count of filtered products
    final countQuery = 'SELECT COUNT(*) as total FROM products p WHERE $whereString';
    final countResult = await database.rawQuery(countQuery, whereArgs);
    final total = countResult.first['total'] as int;

    // 2. Get paginated products with joined tables
    // Note: Need correct alias (AS) to match _rowToProductModel
    final productsResult = await database.rawQuery(
      '''
      SELECT
        p.product_id as id,
        p.sku,
        p.name,
        p.image_url,
        p.price,
        p.stock_quantity,
        p.is_active,
        p.created_at,

        -- Brand Info
        b.brand_id as brand_id,
        b.name as brand_name,
        b.logo_url as brand_logo_url,

        -- Vehicle Make Info
        vm.make_id as vehicle_make_id,
        vm.name as vehicle_make_name,
        vm.logo_url as vehicle_make_logo_url,

        -- Tire Spec Info
        ts.tire_spec_id,
        ts.width,
        ts.aspect_ratio,
        ts.rim_diameter

      FROM products p
      LEFT JOIN brands b ON p.brand_id = b.brand_id
      LEFT JOIN vehicle_makes vm ON p.make_id = vm.make_id
      LEFT JOIN tire_specs ts ON p.tire_spec_id = ts.tire_spec_id
      WHERE $whereString
      ORDER BY p.created_at DESC
      LIMIT ? OFFSET ?
    ''',
      [...whereArgs, limit, offset],
    );

    // Convert SQL rows to ProductModel list
    final products = productsResult
        .map((row) => _rowToProductModel(row))
        .toList();

    // Calculate pagination metadata
    final totalPages = (total / limit).ceil();
    final hasMore = page < totalPages;

    return ProductListModel(
      products: products,
      page: page,
      limit: limit,
      total: total,
      totalPages: totalPages,
      hasMore: hasMore,
    );
  }

  @override
  Future<ProductListModel> getProductDetail({required String productId}) async {
    // Query single product by ID
    final result = await database.rawQuery(
      '''
      SELECT
        p.product_id as id,
        p.sku,
        p.name,
        p.image_url,
        p.price,
        p.stock_quantity,
        p.is_active,
        p.created_at,

        -- Brand Info
        b.brand_id as brand_id,
        b.name as brand_name,
        b.logo_url as brand_logo_url,

        -- Vehicle Make Info
        vm.make_id as vehicle_make_id,
        vm.name as vehicle_make_name,
        vm.logo_url as vehicle_make_logo_url,

        -- Tire Spec Info
        ts.tire_spec_id as tire_spec_id,
        ts.width,
        ts.aspect_ratio,
        ts.rim_diameter

      FROM products p
      LEFT JOIN brands b ON p.brand_id = b.brand_id
      LEFT JOIN vehicle_makes vm ON p.make_id = vm.make_id
      LEFT JOIN tire_specs ts ON p.tire_spec_id = ts.tire_spec_id
      WHERE p.product_id = ?
      LIMIT 1
    ''',
      [productId],
    );

    if (result.isEmpty) {
      // Trả về rỗng nếu không tìm thấy
      return ProductListModel(
        products: [],
        page: 1,
        limit: 1,
        total: 0,
        totalPages: 0,
        hasMore: false,
      );
    }

    final product = _rowToProductModel(result.first);

    return ProductListModel(
      products: [product],
      page: 1,
      limit: 1,
      total: 1,
      totalPages: 1,
      hasMore: false,
    );
  }

  @override
  Future<ProductListModel> getAdminProducts({
    required int page,
    required int limit,
    AdminProductFilter? filter,
  }) async {
    if (page < 1) page = 1;
    if (limit < 1) limit = 20;

    final offset = (page - 1) * limit;

    // Get base filter for search query
    final baseFilter = filter?.baseFilter;
    final searchQuery = baseFilter?.searchQuery;

    // Build dynamic WHERE clause
    // NOTE: Admin products do NOT filter by is_active = 1
    // Admins need to see ALL products including inactive ones for inventory management
    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    // Add search query condition (search by name or SKU, case-insensitive)
    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClauses.add('(p.name LIKE ? OR p.sku LIKE ?)');
      whereArgs.add('%$searchQuery%');
      whereArgs.add('%$searchQuery%');
    }

    // Add category filter from base filter
    if (baseFilter?.categoryId != null) {
      whereClauses.add('p.category_id = ?');
      whereArgs.add(baseFilter!.categoryId);
    }

    // Add brand filter from base filter
    if (baseFilter?.brandId != null) {
      whereClauses.add('p.brand_id = ?');
      whereArgs.add(baseFilter!.brandId);
    }

    // Add vehicle make filter from base filter
    if (baseFilter?.vehicleMakeId != null) {
      whereClauses.add('p.make_id = ?');
      whereArgs.add(baseFilter!.vehicleMakeId);
    }

    // Add price range filters from base filter
    if (baseFilter?.minPrice != null) {
      whereClauses.add('p.price >= ?');
      whereArgs.add(baseFilter!.minPrice);
    }
    if (baseFilter?.maxPrice != null) {
      whereClauses.add('p.price <= ?');
      whereArgs.add(baseFilter!.maxPrice);
    }

    // Add admin-specific brand name filter (AdminProductFilter.brandName)
    if (filter is AdminProductFilter && filter.brandName != null) {
      print('DEBUG DS: Adding brand filter - brandName: ${filter.brandName}');
      whereClauses.add('b.name = ?');
      whereArgs.add(filter.brandName);
    } else {
      print('DEBUG DS: No brand filter - filter.brandName is null');
    }

    // Add admin-specific stock status filter (AdminProductFilter.stockStatus)
    if (filter is AdminProductFilter && filter.stockStatus != StockStatus.all) {
      if (filter.stockStatus == StockStatus.lowStock) {
        whereClauses.add('p.stock_quantity BETWEEN 1 AND 10');
      } else if (filter.stockStatus == StockStatus.outOfStock) {
        whereClauses.add('p.stock_quantity = 0');
      }
    }

    // Join all WHERE clauses
    final whereString = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : '1=1';
    print('DEBUG DS: Final WHERE clause: $whereString');

    // 1. Get total count of filtered products
    // Only add WHERE clause if there are conditions
    final countQuery = whereClauses.isNotEmpty
        ? 'SELECT COUNT(*) as total FROM products p LEFT JOIN brands b ON p.brand_id = b.brand_id WHERE $whereString'
        : 'SELECT COUNT(*) as total FROM products p LEFT JOIN brands b ON p.brand_id = b.brand_id';
    final countResult = await database.rawQuery(countQuery, whereArgs);
    final total = countResult.first['total'] as int;

    // 2. Get paginated products with joined tables
    final productsResult = await database.rawQuery(
      '''
      SELECT
        p.product_id as id,
        p.sku,
        p.name,
        p.image_url,
        p.price,
        p.stock_quantity,
        p.is_active,
        p.created_at,

        -- Brand Info
        b.brand_id as brand_id,
        b.name as brand_name,
        b.logo_url as brand_logo_url,

        -- Vehicle Make Info
        vm.make_id as vehicle_make_id,
        vm.name as vehicle_make_name,
        vm.logo_url as vehicle_make_logo_url,

        -- Tire Spec Info
        ts.tire_spec_id,
        ts.width,
        ts.aspect_ratio,
        ts.rim_diameter

      FROM products p
      LEFT JOIN brands b ON p.brand_id = b.brand_id
      LEFT JOIN vehicle_makes vm ON p.make_id = vm.make_id
      LEFT JOIN tire_specs ts ON p.tire_spec_id = ts.tire_spec_id
      ${whereClauses.isNotEmpty ? 'WHERE $whereString' : ''}
      ORDER BY p.created_at DESC
      LIMIT ? OFFSET ?
    ''',
      [...whereArgs, limit, offset],
    );

    // Convert SQL rows to ProductModel list
    final products = productsResult
        .map((row) => _rowToProductModel(row))
        .toList();

    // Calculate pagination metadata
    final totalPages = (total / limit).ceil();
    final hasMore = page < totalPages;

    return ProductListModel(
      products: products,
      page: page,
      limit: limit,
      total: total,
      totalPages: totalPages,
      hasMore: hasMore,
    );
  }

  @override
  Future<ProductModel> createProduct({
    required ProductModel product,
  }) async {
    print('=== DEBUG createProduct ===');
    print('DEBUG: product.name: ${product.name}');
    print('DEBUG: product.sku: ${product.sku}');
    print('DEBUG: product.tireSpec: width=${product.tireSpec.width}, aspect=${product.tireSpec.aspectRatio}, rim=${product.tireSpec.rimDiameter}');
    print('DEBUG: product.brand: id=${product.brand.id}, name=${product.brand.name}');
    print('DEBUG: product.vehicleMake: id=${product.vehicleMake.id}, name=${product.vehicleMake.name}');

    // 1. First, handle tire_spec - check if exists or insert new
    int tireSpecId;
    final tireSpec = product.tireSpec;

    // Check if tire_spec with same specs exists
    final existingTireSpec = await database.rawQuery(
      'SELECT tire_spec_id FROM tire_specs WHERE width = ? AND aspect_ratio = ? AND rim_diameter = ?',
      [tireSpec.width, tireSpec.aspectRatio, tireSpec.rimDiameter],
    );

    if (existingTireSpec.isNotEmpty) {
      // Use existing tire_spec
      tireSpecId = existingTireSpec.first['tire_spec_id'] as int;
      print('DEBUG: Using existing tire_spec_id: $tireSpecId');
    } else {
      // Insert new tire_spec
      final tireSpecResult = await database.rawInsert(
        'INSERT INTO tire_specs (width, aspect_ratio, rim_diameter) VALUES (?, ?, ?)',
        [tireSpec.width, tireSpec.aspectRatio, tireSpec.rimDiameter],
      );
      tireSpecId = tireSpecResult;
      print('DEBUG: Created new tire_spec_id: $tireSpecId');
    }

    // 2. Get brand_id and make_id from the model (they should already be IDs)
    final brandId = int.tryParse(product.brand.id) ?? 0;
    final makeId = int.tryParse(product.vehicleMake.id) ?? 0;

    print('DEBUG: brandId: $brandId, makeId: $makeId');

    // 3. Insert the product
    int newProductId;
    try {
      final productResult = await database.rawInsert(
        '''
        INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          product.sku,
          product.name,
          product.imageUrl,
          brandId > 0 ? brandId : null,
          makeId > 0 ? makeId : null,
          tireSpecId,
          product.price,
          product.stockQuantity,
          product.isActive ? 1 : 0,
          DateTime.now().toIso8601String(),
        ],
      );

      newProductId = productResult;
      print('DEBUG: Created product with id: $newProductId');
    } on DatabaseException catch (e) {
      // Handle duplicate SKU error
      if (e.toString().contains('UNIQUE constraint failed: products.sku')) {
        print('DEBUG: Duplicate SKU error detected');
        throw ValidationFailure(
          message: 'SKU "${product.sku}" đã tồn tại. Vui lòng sử dụng SKU khác.',
        );
      }
      // Re-throw other database errors as CacheFailure
      print('DEBUG: Database error: $e');
      throw CacheFailure(message: 'Lỗi cơ sở dữ liệu: $e');
    }

    // 4. Fetch and return the created product
    final result = await database.rawQuery(
      '''
      SELECT
        p.product_id as id,
        p.sku,
        p.name,
        p.image_url,
        p.price,
        p.stock_quantity,
        p.is_active,
        p.created_at,

        -- Brand Info
        b.brand_id as brand_id,
        b.name as brand_name,
        b.logo_url as brand_logo_url,

        -- Vehicle Make Info
        vm.make_id as vehicle_make_id,
        vm.name as vehicle_make_name,
        vm.logo_url as vehicle_make_logo_url,

        -- Tire Spec Info
        ts.tire_spec_id as tire_spec_id,
        ts.width,
        ts.aspect_ratio,
        ts.rim_diameter

      FROM products p
      LEFT JOIN brands b ON p.brand_id = b.brand_id
      LEFT JOIN vehicle_makes vm ON p.make_id = vm.make_id
      LEFT JOIN tire_specs ts ON p.tire_spec_id = ts.tire_spec_id
      WHERE p.product_id = ?
      LIMIT 1
    ''',
      [newProductId],
    );

    if (result.isEmpty) {
      throw Exception('Failed to fetch created product');
    }

    final createdProduct = _rowToProductModel(result.first);

    return createdProduct;
  }

  @override
  Future<ProductListModel> updateProduct({
    required String productId,
    required ProductListModel product,
  }) async {
    // TODO: Implement update product logic if needed
    throw UnimplementedError('updateProduct not yet implemented');
  }

  @override
  Future<bool> deleteProduct({required String productId}) async {
    // Soft delete - set is_active to 0
    final result = await database.rawUpdate(
      'UPDATE products SET is_active = 0 WHERE product_id = ?',
      [productId],
    );
    return result > 0;
  }

  /// Converts a database row to [ProductModel].
  ///
  /// MAPPING KEYS:
  /// - id -> p.product_id
  /// - brand_logo_url -> b.logo_url
  /// - vehicle_make_logo_url -> vm.logo_url
  ProductModel _rowToProductModel(Map<String, dynamic> row) {
    return ProductModel(
      id: (row['id'] as int?)?.toString() ?? '',
      sku: (row['sku'] as String?) ?? '',
      name: (row['name'] as String?) ?? '',
      imageUrl: (row['image_url'] as String?) ?? '',
      brand: BrandModel(
        id: (row['brand_id'] as int?)?.toString() ?? '',
        name: (row['brand_name'] as String?) ?? '',
        logoUrl: (row['brand_logo_url'] as String?) ?? '',
      ),
      vehicleMake: VehicleMakeModel(
        id: (row['vehicle_make_id'] as int?)?.toString() ?? '',
        name: (row['vehicle_make_name'] as String?) ?? '',
        logoUrl: (row['vehicle_make_logo_url'] as String?) ?? '',
      ),
      tireSpec: TireSpecModel(
        id: (row['tire_spec_id'] as int?)?.toString() ?? '',
        width: (row['width'] as int?) ?? 0,
        aspectRatio: (row['aspect_ratio'] as int?) ?? 0,
        rimDiameter: (row['rim_diameter'] as int?) ?? 0,
      ),
      price: (row['price'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: (row['stock_quantity'] as int?) ?? 0,
      isActive: (row['is_active'] as int?) == 1,
      createdAt: _parseDateTime(row['created_at']),
    );
  }

  /// Parses a dynamic value to [DateTime].
  DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      return parsed ?? DateTime.now();
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.now();
  }

  @override
  Future<List<BrandModel>> getBrands() async {
    print('=== DEBUG getBrands ===');
    final result = await database.rawQuery(
      'SELECT brand_id as id, name, logo_url FROM brands ORDER BY name ASC',
    );

    print('DEBUG: Found ${result.length} brands');

    return result.map((row) {
      return BrandModel(
        id: (row['id'] as int?)?.toString() ?? '',
        name: (row['name'] as String?) ?? '',
        logoUrl: (row['logo_url'] as String?) ?? '',
      );
    }).toList();
  }

  @override
  Future<List<VehicleMakeModel>> getVehicleMakes() async {
    print('=== DEBUG getVehicleMakes ===');
    final result = await database.rawQuery(
      'SELECT make_id as id, name, logo_url FROM vehicle_makes ORDER BY name ASC',
    );

    print('DEBUG: Found ${result.length} vehicle makes');

    return result.map((row) {
      return VehicleMakeModel(
        id: (row['id'] as int?)?.toString() ?? '',
        name: (row['name'] as String?) ?? '',
        logoUrl: (row['logo_url'] as String?) ?? '',
      );
    }).toList();
  }
}
