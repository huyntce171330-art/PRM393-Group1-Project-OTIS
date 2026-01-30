import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  print('========================================');
  print('🔄 CREATING NEW DATABASE');
  print('========================================\n');

  // Get database path
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'otis.db');

  // Delete existing database
  if (await File(path).exists()) {
    await File(path).delete();
    print('🗑️ Deleted existing database');
  }

  // Open new database
  final db = await openDatabase(path, version: 1);
  print('📦 Creating new database...\n');

  // Enable foreign keys
  await db.execute('PRAGMA foreign_keys = ON;');

  // ========== 1. USER_ROLES ==========
  await db.execute('DROP TABLE IF EXISTS user_roles');
  await db.execute('''
    CREATE TABLE user_roles (
      role_id INTEGER PRIMARY KEY AUTOINCREMENT,
      role_name TEXT UNIQUE NOT NULL
    )
  ''');
  print('✅ Created table: user_roles');

  // ========== 2. USERS ==========
  await db.execute('DROP TABLE IF EXISTS users');
  await db.execute('''
    CREATE TABLE users (
      user_id INTEGER PRIMARY KEY AUTOINCREMENT,
      phone TEXT UNIQUE NOT NULL,
      password_hash TEXT NOT NULL,
      full_name TEXT,
      address TEXT,
      role_id INTEGER,
      status TEXT,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (role_id) REFERENCES user_roles(role_id)
    )
  ''');
  print('✅ Created table: users');

  // ========== 3. BRANDS ==========
  await db.execute('DROP TABLE IF EXISTS brands');
  await db.execute('''
    CREATE TABLE brands (
      brand_id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE NOT NULL,
      logo_url TEXT
    )
  ''');
  print('✅ Created table: brands');

  // ========== 4. TIRE_SPECS ==========
  await db.execute('DROP TABLE IF EXISTS tire_specs');
  await db.execute('''
    CREATE TABLE tire_specs (
      tire_spec_id INTEGER PRIMARY KEY AUTOINCREMENT,
      width INTEGER,
      aspect_ratio INTEGER,
      rim_diameter INTEGER
    )
  ''');
  print('✅ Created table: tire_specs');

  // ========== 5. PRODUCTS ==========
  await db.execute('DROP TABLE IF EXISTS products');
  await db.execute('''
    CREATE TABLE products (
      product_id INTEGER PRIMARY KEY AUTOINCREMENT,
      brand_id INTEGER,
      sku TEXT UNIQUE,
      name TEXT,
      price REAL,
      stock_quantity INTEGER,
      tire_spec_id INTEGER,
      is_active INTEGER DEFAULT 1,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
      FOREIGN KEY (tire_spec_id) REFERENCES tire_specs(tire_spec_id)
    )
  ''');
  print('✅ Created table: products');

  // ========== 6. CART_ITEMS ==========
  await db.execute('DROP TABLE IF EXISTS cart_items');
  await db.execute('''
    CREATE TABLE cart_items (
      user_id INTEGER,
      product_id INTEGER,
      quantity INTEGER,
      PRIMARY KEY (user_id, product_id),
      FOREIGN KEY (user_id) REFERENCES users(user_id),
      FOREIGN KEY (product_id) REFERENCES products(product_id)
    )
  ''');
  print('✅ Created table: cart_items');

  // ========== 7. ORDERS ==========
  await db.execute('DROP TABLE IF EXISTS orders');
  await db.execute('''
    CREATE TABLE orders (
      order_id INTEGER PRIMARY KEY AUTOINCREMENT,
      total_amount REAL,
      status TEXT,
      shipping_address TEXT,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP,
      user_id INTEGER,
      FOREIGN KEY (user_id) REFERENCES users(user_id)
    )
  ''');
  print('✅ Created table: orders');

  // ========== 8. ORDER_ITEMS ==========
  await db.execute('DROP TABLE IF EXISTS order_items');
  await db.execute('''
    CREATE TABLE order_items (
      order_id INTEGER,
      product_id INTEGER,
      quantity INTEGER,
      unit_price REAL,
      PRIMARY KEY (order_id, product_id),
      FOREIGN KEY (order_id) REFERENCES orders(order_id),
      FOREIGN KEY (product_id) REFERENCES products(product_id)
    )
  ''');
  print('✅ Created table: order_items');

  // ========== 9. NOTIFICATIONS ==========
  await db.execute('DROP TABLE IF EXISTS notifications');
  await db.execute('''
    CREATE TABLE notifications (
      notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      body TEXT,
      is_read INTEGER DEFAULT 0,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP,
      user_id INTEGER,
      FOREIGN KEY (user_id) REFERENCES users(user_id)
    )
  ''');
  print('✅ Created table: notifications');

  // ========== 10. CHAT_ROOMS ==========
  await db.execute('DROP TABLE IF EXISTS chat_rooms');
  await db.execute('''
    CREATE TABLE chat_rooms (
      room_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER UNIQUE,
      status TEXT,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP,
      updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(user_id)
    )
  ''');
  print('✅ Created table: chat_rooms');

  // ========== 11. MESSAGES ==========
  await db.execute('DROP TABLE IF EXISTS messages');
  await db.execute('''
    CREATE TABLE messages (
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
  print('✅ Created table: messages');

  // ========== 12. VEHICLE_MAKES ==========
  await db.execute('DROP TABLE IF EXISTS vehicle_makes');
  await db.execute('''
    CREATE TABLE vehicle_makes (
      make_id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE,
      logo_url TEXT
    )
  ''');
  print('✅ Created table: vehicle_makes');

  // ========== INSERT SAMPLE DATA ==========
  print('\n📋 Inserting sample data...\n');

  await db.execute('''
    INSERT INTO user_roles (role_name) VALUES 
    ('admin'), ('customer'), ('staff')
  ''');
  print('✅ Inserted: user_roles (3 rows)');

  await db.execute('''
    INSERT INTO users (phone, password_hash, full_name, address, role_id, status) VALUES 
    ('0381234567', '\$2b\$10\$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/nMskyB.M0aUB/LQCGmWce', 'Admin OTIS', '123 Admin Street, District 1, HCMC', 1, 'active'),
    ('0382345678', '\$2b\$10\$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/nMskyB.M0aUB/LQCGmWce', 'Staff Member', '456 Staff Avenue, District 3, HCMC', 3, 'active'),
    ('0383456789', '\$2b\$10\$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/nMskyB.M0aUB/LQCGmWce', 'John Doe', '789 Customer Road, District 5, HCMC', 2, 'active'),
    ('0384567890', '\$2b\$10\$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/nMskyB.M0aUB/LQCGmWce', 'Jane Smith', '321 Buyer Lane, District 7, HCMC', 2, 'active'),
    ('0385678901', '\$2b\$10\$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/nMskyB.M0aUB/LQCGmWce', 'Mike Wilson', '654 Shopper Street, District 10, HCMC', 2, 'active'),
    ('0386789012', '\$2b\$10\$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/nMskyB.M0aUB/LQCGmWce', 'Sarah Johnson', '987 Purchaser Ave, Binh Thanh, HCMC', 2, 'active')
  ''');
  print('✅ Inserted: users (6 rows)');

  await db.execute('''
    INSERT INTO brands (name, logo_url) VALUES 
    ('Michelin', 'https://example.com/logos/michelin.png'),
    ('Bridgestone', 'https://example.com/logos/bridgestone.png'),
    ('Continental', 'https://example.com/logos/continental.png'),
    ('Goodyear', 'https://example.com/logos/goodyear.png'),
    ('Pirelli', 'https://example.com/logos/pirelli.png'),
    ('Dunlop', 'https://example.com/logos/dunlop.png'),
    ('Yokohama', 'https://example.com/logos/yokohama.png'),
    ('Hankook', 'https://example.com/logos/hankook.png'),
    ('Maxxis', 'https://example.com/logos/maxxis.png'),
    ('Kenda', 'https://example.com/logos/kenda.png')
  ''');
  print('✅ Inserted: brands (10 rows)');

  await db.execute('''
    INSERT INTO tire_specs (width, aspect_ratio, rim_diameter) VALUES 
    (185, 65, 15), (195, 65, 15), (205, 55, 16), (215, 55, 17),
    (225, 45, 18), (235, 40, 19), (245, 35, 20), (90, 90, 14),
    (100, 80, 17), (110, 70, 17), (120, 70, 17), (295, 80, 22.5),
    (315, 80, 22.5), (385, 65, 22.5)
  ''');
  print('✅ Inserted: tire_specs (14 rows)');

  await db.execute('''
    INSERT INTO products (brand_id, sku, name, price, stock_quantity, tire_spec_id, is_active) VALUES 
    (1, 'MICH-PS4-2055516', 'Michelin Pilot Sport 4', 1850000, 50, 3, 1),
    (2, 'BRID-T005-1956515', 'Bridgestone Turanza T005', 1650000, 45, 2, 1),
    (3, 'CONT-PC6-2155517', 'Continental PremiumContact 6', 1950000, 40, 4, 1),
    (4, 'GOOD-F1-2254518', 'Goodyear Eagle F1 Asymmetric 5', 1750000, 35, 5, 1),
    (5, 'PIRE-PZERO-2354019', 'Pirelli P Zero', 2200000, 25, 6, 1),
    (1, 'MICH-PS2-9014', 'Michelin Pilot Street 2', 850000, 100, 8, 1),
    (2, 'BRID-BT46-1008017', 'Bridgestone Battlax BT46', 920000, 80, 9, 1),
    (6, 'DUN-GPR300-1107017', 'Dunlop Sportmax GPR-300', 780000, 90, 10, 1),
    (9, 'MAX-M9RR-1207017', 'Maxxis Metzeler M9RR', 950000, 70, 11, 1),
    (1, 'MICH-XMULTI-2958022', 'Michelin X Multi Z', 3500000, 30, 12, 1),
    (2, 'BRID-ECOPEIA-3158022', 'Bridgestone Ecopia H-Steer 001', 3200000, 25, 12, 1),
    (3, 'CONT-REGIONAL-3856522', 'Continental Conti EcoRegional HS3', 3800000, 20, 13, 1),
    (4, 'GOOD-FUELMAX-3856522', 'Goodyear Fuelmax Endurance', 3600000, 22, 13, 1)
  ''');
  print('✅ Inserted: products (13 rows)');

  await db.execute('''
    INSERT INTO cart_items (user_id, product_id, quantity) VALUES 
    (3, 1, 2), (3, 6, 4), (4, 3, 2), (4, 7, 1), (5, 10, 4)
  ''');
  print('✅ Inserted: cart_items (5 rows)');

  await db.execute('''
    INSERT INTO orders (total_amount, status, shipping_address, user_id) VALUES 
    (5100000, 'delivered', '789 Customer Road, District 5, HCMC', 3),
    (4370000, 'shipped', '321 Buyer Lane, District 7, HCMC', 4),
    (14200000, 'processing', '654 Shopper Street, District 10, HCMC', 5),
    (1850000, 'pending', '789 Customer Road, District 5, HCMC', 3),
    (1950000, 'delivered', '321 Buyer Lane, District 7, HCMC', 4)
  ''');
  print('✅ Inserted: orders (5 rows)');

  await db.execute('''
    INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
    (1, 1, 2, 1850000), (1, 6, 2, 850000), (2, 3, 2, 1950000),
    (2, 7, 1, 920000), (3, 10, 4, 3500000), (4, 1, 1, 1850000), (5, 3, 1, 1950000)
  ''');
  print('✅ Inserted: order_items (7 rows)');

  await db.execute('''
    INSERT INTO notifications (title, body, user_id, is_read) VALUES 
    ('Chào mừng đến với OTIS', 'Cảm ơn bạn đã đăng ký tài khoản tại OTIS!', 3, 1),
    ('Đơn hàng đã được xác nhận', 'Đơn hàng #1 của bạn đã được xác nhận.', 3, 1),
    ('Khuyến mãi mùa hè', 'Giảm giá 20% cho tất cả các dòng lốp Michelin!', 3, 0),
    ('Giao hàng thành công', 'Đơn hàng #1 đã được giao thành công.', 3, 1),
    ('Đánh giá sản phẩm', 'Hãy đánh giá sản phẩm bạn đã mua!', 3, 0)
  ''');
  print('✅ Inserted: notifications (5 rows)');

  await db.execute('''
    INSERT INTO chat_rooms (user_id, status) VALUES 
    (3, 'active'), (4, 'active'), (5, 'inactive')
  ''');
  print('✅ Inserted: chat_rooms (3 rows)');

  await db.execute('''
    INSERT INTO messages (room_id, sender_id, content, is_read) VALUES 
    (1, 3, 'Xin chào, tôi muốn hỏi về lốp Michelin Pilot Sport 4', 1),
    (1, 2, 'Chào anh/chị, lốp Michelin Pilot Sport 4 là dòng lốp hiệu suất cao.', 1),
    (1, 3, 'Lốp này có phù hợp cho xe BMW 3 Series không?', 0),
    (1, 2, 'Vâng, lốp này rất phù hợp. Kích thước 205/55R16 là lựa chọn phổ biến.', 0),
    (2, 4, 'Tôi muốn đổi lốp xe máy, bên có loại nào tốt không?', 1),
    (2, 2, 'Bridgestone Battlax BT46 và Michelin Pilot Street 2 đều là những lựa chọn tốt.', 1)
  ''');
  print('✅ Inserted: messages (6 rows)');

  await db.execute('''
    INSERT INTO vehicle_makes (name, logo_url) VALUES 
    ('Toyota', 'https://example.com/logos/toyota.png'),
    ('Honda', 'https://example.com/logos/honda.png'),
    ('Ford', 'https://example.com/logos/ford.png'),
    ('BMW', 'https://example.com/logos/bmw.png'),
    ('Mercedes-Benz', 'https://example.com/logos/mercedes.png'),
    ('Audi', 'https://example.com/logos/audi.png'),
    ('Hyundai', 'https://example.com/logos/hyundai.png'),
    ('Kia', 'https://example.com/logos/kia.png'),
    ('Mazda', 'https://example.com/logos/mazda.png'),
    ('Chevrolet', 'https://example.com/logos/chevrolet.png')
  ''');
  print('✅ Inserted: vehicle_makes (10 rows)');

  await db.close();

  // Copy to assets folder
  final assetsPath = 'app/assets/database';
  await Directory(assetsPath).create(recursive: true);
  final assetsDbPath = join(assetsPath, 'otis.db');
  await File(path).copy(assetsDbPath);

  print('\n========================================');
  print('✅ DATABASE CREATED SUCCESSFULLY!');
  print('========================================');
  print('📍 Device database: $path');
  print('📍 Assets database: $assetsDbPath');
  print('📊 Total tables: 12');
  print('📊 Total records: ~90 rows');
}

