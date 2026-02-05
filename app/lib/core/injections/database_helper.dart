import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'otis.db');

    // Check if database already exists
    final dbFile = File(path);
    if (dbFile.existsSync()) {
      print("📦 Opening existing database");
      return await openDatabase(path);
    }

    print("📦 Copying pre-built database from assets...");

    // Load database from assets
    final bytes = await rootBundle.load('assets/database/otis.db');

    // Write to app's database directory
    await dbFile.writeAsBytes(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
    );

    print("✅ Database copied successfully");

    return await openDatabase(path);
  }

  static Future<void> _runSampleData(Database db) async {
    // Check if data already exists
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM user_roles'),
    );

    if (count == 0) {
      print("📊 Inserting sample data from SQL file...");
      try {
        // Read and execute SQL file from assets
        final sqlContent = await rootBundle.loadString(
          'assets/database/migration_v2.sql',
        );

        // Split by semicolons and execute each statement
        final statements = sqlContent.split(';');
        for (final statement in statements) {
          final trimmed = statement.trim();
          if (trimmed.isNotEmpty && !trimmed.startsWith('--')) {
            try {
              await db.execute(trimmed);
            } catch (e) {
              // Ignore errors from comments or empty statements
            }
          }
        }
        print("✅ Sample data inserted from migration_v2.sql");
      } catch (e) {
        print("⚠️ Could not load SQL file: $e");
        print("📊 Inserting sample data manually...");
        await _insertManualSampleData(db);
      }
    }
  }

  static Future<void> _runMigrations(Database db) async {
    // Create products table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS products (
        product_id INTEGER PRIMARY KEY AUTOINCREMENT,
        sku TEXT UNIQUE,
        name TEXT,
        image_url TEXT,
        brand_id INTEGER,
        make_id INTEGER,
        tire_spec_id INTEGER,
        price DECIMAL,
        stock_quantity INTEGER,
        is_active INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
        FOREIGN KEY (tire_spec_id) REFERENCES tire_specs(tire_spec_id),
        FOREIGN KEY (make_id) REFERENCES vehicle_makes(make_id)
      )
    ''');

    // Create brands table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS brands (
        brand_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL,
        logo_url TEXT
      )
    ''');

    // Create tire_specs table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tire_specs (
        tire_spec_id INTEGER PRIMARY KEY AUTOINCREMENT,
        width INTEGER,
        aspect_ratio INTEGER,
        rim_diameter INTEGER,
        UNIQUE (width, aspect_ratio, rim_diameter)
      )
    ''');

    // Create vehicle_makes table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS vehicle_makes (
        make_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE,
        logo_url TEXT
      )
    ''');

    // Create users table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        full_name TEXT,
        address TEXT,
        shop_name TEXT,
        role_id INTEGER,
        status TEXT,
        avatar_url TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (role_id) REFERENCES user_roles(role_id)
      )
    ''');

    // Create user_roles table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_roles (
        role_id INTEGER PRIMARY KEY AUTOINCREMENT,
        role_name TEXT UNIQUE NOT NULL
      )
    ''');

    // Create cart_items table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cart_items (
        user_id INTEGER,
        product_id INTEGER,
        quantity INTEGER,
        PRIMARY KEY (user_id, product_id),
        FOREIGN KEY (user_id) REFERENCES users(user_id),
        FOREIGN KEY (product_id) REFERENCES products(product_id)
      )
    ''');

    // Create orders table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS orders (
        order_id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT UNIQUE,
        total_amount DECIMAL,
        status TEXT,
        shipping_address TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES users(user_id)
      )
    ''');

    // Create order_items table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS order_items (
        order_id INTEGER,
        product_id INTEGER,
        quantity INTEGER,
        unit_price DECIMAL,
        PRIMARY KEY (order_id, product_id),
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
        FOREIGN KEY (product_id) REFERENCES products(product_id)
      )
    ''');

    // Create notifications table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notifications (
        notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT,
        is_read INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES users(user_id)
      )
    ''');

    // Create chat_rooms table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS chat_rooms (
        room_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER UNIQUE,
        status TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(user_id)
      )
    ''');

    // Create messages table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS messages (
        message_id INTEGER PRIMARY KEY AUTOINCREMENT,
        room_id INTEGER,
        sender_id INTEGER,
        content TEXT,
        image_url TEXT,
        is_read INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (room_id) REFERENCES chat_rooms(room_id),
        FOREIGN KEY (sender_id) REFERENCES users(user_id)
      )
    ''');

    // Insert sample data if tables are empty
    await _runSampleData(db);
  }

  /// Fallback: Insert sample data manually if SQL file cannot be loaded
  static Future<void> _insertManualSampleData(Database db) async {
    print("📊 Inserting sample data manually...");

    // Insert user roles
    await db.execute("INSERT INTO user_roles (role_name) VALUES ('admin')");
    await db.execute("INSERT INTO user_roles (role_name) VALUES ('customer')");

    // Insert sample users
    await db.execute(
      "INSERT INTO users (phone, password_hash, full_name, address, shop_name, role_id, status) "
      "VALUES ('0900000000', 'hash_admin', 'Admin System', 'HCM', 'Admin Shop', 1, 'active')",
    );
    await db.execute(
      "INSERT INTO users (phone, password_hash, full_name, address, shop_name, role_id, status) "
      "VALUES ('0900000001', 'hash_u1', 'Nguyen Van A', 'HCM', 'Shop A', 2, 'active')",
    );

    // Insert brands
    await db.execute(
      "INSERT INTO brands (name, logo_url) VALUES ('Bridgestone', 'bridgestone.png')",
    );
    await db.execute(
      "INSERT INTO brands (name, logo_url) VALUES ('Michelin', 'michelin.png')",
    );
    await db.execute(
      "INSERT INTO brands (name, logo_url) VALUES ('Yokohama', 'yokohama.png')",
    );
    await db.execute(
      "INSERT INTO brands (name, logo_url) VALUES ('Sailun', 'sailun.png')",
    );
    await db.execute(
      "INSERT INTO brands (name, logo_url) VALUES ('Goodride', 'goodride.png')",
    );

    // Insert vehicle makes
    await db.execute(
      "INSERT INTO vehicle_makes (name, logo_url) VALUES ('Toyota', 'toyota.png')",
    );
    await db.execute(
      "INSERT INTO vehicle_makes (name, logo_url) VALUES ('Honda', 'honda.png')",
    );
    await db.execute(
      "INSERT INTO vehicle_makes (name, logo_url) VALUES ('Mazda', 'mazda.png')",
    );
    await db.execute(
      "INSERT INTO vehicle_makes (name, logo_url) VALUES ('Ford', 'ford.png')",
    );
    await db.execute(
      "INSERT INTO vehicle_makes (name, logo_url) VALUES ('Hyundai', 'hyundai.png')",
    );

    // Insert tire specs
    final tireSpecs = [
      [245, 45, 18],
      [175, 65, 14],
      [225, 45, 18],
      [215, 60, 16],
      [245, 40, 19],
      [185, 60, 15],
      [225, 65, 17],
      [205, 55, 16],
      [225, 60, 18],
      [265, 60, 18],
      [235, 60, 18],
      [225, 55, 18],
      [215, 45, 17],
      [265, 65, 17],
      [195, 65, 15],
      [215, 70, 15],
      [225, 50, 17],
      [185, 65, 15],
      [235, 40, 18],
      [295, 35, 20],
      [145, 70, 13],
      [205, 65, 16],
      [205, 65, 15],
      [155, 65, 14],
      [175, 70, 14],
      [175, 70, 13],
      [175, 50, 15],
      [165, 80, 13],
      [165, 65, 14],
      [165, 65, 13],
      [165, 60, 14],
      [155, 80, 13],
      [155, 70, 13],
      [155, 65, 13],
    ];
    for (final spec in tireSpecs) {
      await db.execute(
        "INSERT INTO tire_specs (width, aspect_ratio, rim_diameter) VALUES (${spec[0]}, ${spec[1]}, ${spec[2]})",
      );
    }

    // Insert products - Bridgestone (10 products)
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('BR-245/45R18-S001', 'LỐP BRIDGESTONE 245/45R18 96W POTENZA S001 RUNFLAT', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769708160/r4vfxpqajbqn6n7l7iss.jpg', 1, 1, 1, 1510000, 51, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('BR-175/65R14-EP150', 'LỐP BRIDGESTONE 175/65R14 82H ECOPIA EP150', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711162/kztjcilxt2v7gdwecqpr.jpg', 1, 2, 2, 1520000, 52, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('BR-225/45R18-S001', 'LỐP BRIDGESTONE 225/45R18 91W POTENZA S001 RUNFLAT', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711196/bsfs2hsbnx9f8fr4kajs.webp', 1, 3, 3, 1530000, 53, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('BR-215/60R16-T005A', 'LỐP BRIDGESTONE 215/60R16 95V TURANZA T005A', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711269/vvszoh4pbkpffufh5zul.jpg', 1, 4, 4, 1540000, 54, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('BR-245/40R19-S001', 'LỐP BRIDGESTONE 245/40R19 94W POTENZA S001 RUNFLAT', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711300/xc2ljnbcafy4rqzvexce.jpg', 1, 5, 5, 1550000, 55, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('BR-185/60R15-EP150', 'LỐP BRIDGESTONE 185/60R15 84H ECOPIA EP150', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711364/alpt6z7kuqoeoz3jj8jf.jpg', 1, 1, 6, 1560000, 56, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('BR-225/65R17-H/T470', 'LỐP BRIDGESTONE 225/65R17 102H DUELER H/T 470', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711386/vpettguxbnijq2hkezsg.jpg', 1, 2, 7, 1570000, 57, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('BR-205/55R16-T005A', 'LỐP BRIDGESTONE 205/55R16 91V TURANZA T005A', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711486/pfftqchqlv9uncybezbu.webp', 1, 3, 8, 1580000, 58, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('BR-225/60R18-H/L33', 'LỐP BRIDGESTONE 225/60R18 100H DUELER H/L 33', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711504/cvpok4myhnrmai7bsuvr.jpg', 1, 4, 9, 1590000, 59, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('BR-265/60R18-H/T684II', 'LỐP BRIDGESTONE 265/60R18 110H DUELER H/T 684II', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769713078/vhl2afk6ggob1ho7iqpm.jpg', 1, 5, 10, 1600000, 60, 1)",
    );
    // Michelin (10 products)
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('MI-225/45R18-PS5', 'LỐP MICHELIN 225/45R18 95Y XL PILOT SPORT 5 TL', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769718156/yagfio7w6t6iqlpoizun.webp', 2, 4, 1, 1640000, 64, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('MI-265/65R17-LTX', 'LỐP MICHELIN 265/65R17 112T LTX TRAIL', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769718170/aflvulgpvrcjqwbfaoq7.webp', 2, 5, 14, 1650000, 65, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('MI-195/65R15-XM2+', 'LỐP MICHELIN 195/65R15 91V ENERGY XM2+ TL', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769718322/vvo8zzb0sra9nuxullrv.webp', 2, 1, 15, 1660000, 66, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('MI-205/55R16-P4', 'LỐP MICHELIN 205/55R16 91V PRIMACY 4 ST TL', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769718344/zbzzkaogih2uaa5acjum.webp', 2, 2, 8, 1670000, 67, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('MI-215/70R15C-AG3', 'LỐP MICHELIN 215/70R15C 109/107S AGILIS 3 TL', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769720112/c4ktdwjslkfwslud9say.webp', 2, 3, 16, 1680000, 68, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('MI-225/50R17-P4', 'LỐP MICHELIN 225/50R17 98W XL PRIMACY 4 ST TL', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769720125/opfmztsisasveglbycd9.webp', 2, 4, 17, 1690000, 69, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('MI-185/65R15-XM2+', 'LỐP MICHELIN 185/65R15 88H ENERGY XM2+ TL', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769720139/dhldcptq16il3o7zvwdz.webp', 2, 5, 18, 1700000, 70, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('MI-245/45R18-PS5', 'LỐP MICHELIN 245/45R18 100Y XL PILOT SPORT 5 TL', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769720154/gsrxdnoil2wy3jdkvjot.webp', 2, 1, 1, 1710000, 71, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('MI-235/40R18-PS5', 'LỐP MICHELIN 235/40R18 95Y XL PILOT SPORT 5 TL', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769720166/hinvpwekyymvy3xflmx1.jpg', 2, 2, 19, 1720000, 72, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('MI-295/35R20-PSS', 'LỐP MICHELIN 295/35R20 PILOT SUPER SPORT', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769720206/lheew5voymezgsv1kfrq.webp', 2, 3, 20, 1730000, 73, 1)",
    );
    // Yokohama (5 products)
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('YO-235/60R18-AE61', 'LỐP YOKOHAMA 235/60R18 AE61', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721862/qjyush9codcyxvg7z2bs.jpg', 3, 3, 11, 1780000, 78, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('YO-265/65R17-G015', 'LỐP YOKOHAMA 265/65R17 G015', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721864/msralhuvnsjhpgommhwp.jpg', 3, 4, 14, 1790000, 79, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('YO-215/55R17-AE61', 'LỐP YOKOHAMA 215/55R17 AE61', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721897/i6ar6bq7bpfcm5iwtbmv.png', 3, 1, 12, 1810000, 81, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('YO-205/55R16-AE51', 'LỐP YOKOHAMA 205/55R16 91V AE51', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721908/djrnnpvoqijjgbkbcgu5.png', 3, 2, 8, 1820000, 82, 1)",
    );
    await db.execute(
      "INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) "
      "VALUES ('YO-205/65R16-AE51', 'LỐP YOKOHAMA 205/65R16 AE51', "
      "'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721928/jalczbfvminculmi3pmk.jpg', 3, 4, 22, 1840000, 84, 1)",
    );

    print("✅ Sample data inserted manually");
  }
}
