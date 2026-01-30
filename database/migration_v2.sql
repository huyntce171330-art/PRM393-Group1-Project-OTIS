PRAGMA foreign_keys = ON;

-- ========== 1. USER_ROLES ==========
DROP TABLE IF EXISTS user_roles;
CREATE TABLE user_roles (
  role_id INTEGER PRIMARY KEY AUTOINCREMENT,
  role_name TEXT UNIQUE NOT NULL
);

-- ========== 2. USERS ==========
DROP TABLE IF EXISTS users;
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
);

-- ========== 3. BRANDS ==========
DROP TABLE IF EXISTS brands;
CREATE TABLE brands (
  brand_id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  logo_url TEXT
);

-- ========== 4. TIRE_SPECS ==========
DROP TABLE IF EXISTS tire_specs;
CREATE TABLE tire_specs (
  tire_spec_id INTEGER PRIMARY KEY AUTOINCREMENT,
  width INTEGER,
  aspect_ratio INTEGER,
  rim_diameter INTEGER
);

-- ========== 5. PRODUCTS ==========
DROP TABLE IF EXISTS products;
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
);

-- ========== 6. CART_ITEMS ==========
DROP TABLE IF EXISTS cart_items;
CREATE TABLE cart_items (
  user_id INTEGER,
  product_id INTEGER,
  quantity INTEGER,
  PRIMARY KEY (user_id, product_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ========== 7. ORDERS ==========
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id INTEGER PRIMARY KEY AUTOINCREMENT,
  total_amount REAL,
  status TEXT,
  shipping_address TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ========== 8. ORDER_ITEMS ==========
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
  order_id INTEGER,
  product_id INTEGER,
  quantity INTEGER,
  unit_price REAL,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ========== 9. NOTIFICATIONS ==========
DROP TABLE IF EXISTS notifications;
CREATE TABLE notifications (
  notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  body TEXT,
  is_read INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ========== 10. CHAT_ROOMS ==========
DROP TABLE IF EXISTS chat_rooms;
CREATE TABLE chat_rooms (
  room_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER UNIQUE,
  status TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ========== 11. MESSAGES ==========
DROP TABLE IF EXISTS messages;
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
);

-- ========== 12. VEHICLE_MAKES ==========
DROP TABLE IF EXISTS vehicle_makes;
CREATE TABLE vehicle_makes (
  make_id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE,
  logo_url TEXT
);

-- =====================================================
-- ========== INSERT SAMPLE DATA ==========
-- =====================================================

-- 1. USER_ROLES

PRAGMA foreign_keys = ON;

-- ======================
-- USER ROLES
-- ======================
INSERT INTO user_roles (role_name) VALUES
('admin'),
('customer');

-- ======================
-- USERS
-- ======================
INSERT INTO users (phone, password_hash, full_name, address, role_id, status) VALUES
('0900000000','hash_admin','Admin System','HCM',1,'active'),
('0900000001','hash_u1','Nguyen Van A','HCM',2,'active'),
('0900000002','hash_u2','Tran Thi B','Ha Noi',2,'active'),
('0900000003','hash_u3','Le Van C','Da Nang',2,'active');

-- ======================
-- BRANDS
-- ======================
INSERT INTO brands (name, logo_url) VALUES
('Bridgestone','bridgestone.png'),
('Michelin','michelin.png'),
('Dunlop','dunlop.png'),
('Continental','continental.png'),
('Pirelli','pirelli.png');

-- ======================
-- TIRE SPECS
-- ======================
INSERT INTO tire_specs (width, aspect_ratio, rim_diameter) VALUES
(195,65,15),
(205,55,16),
(215,45,17),
(225,50,17),
(235,45,18);

-- 5. PRODUCTS (20 ITEMS - simple data)
INSERT INTO products (id, name, price, stock, rating, image_url, brand_id, tire_spec_id) VALUES
INSERT INTO products (id, name, price, stock, rating, image_url, brand_id, tire_spec_id) VALUES
(1, 'LỐP BRIDGESTONE 245/45R18 96W POTENZA S001 RUNFLAT', 1510000, 51, 2, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769708160/r4vfxpqajbqn6n7l7iss.jpg', 1, 1),
(2, 'LỐP BRIDGESTONE 175/65R14 82H ECOPIA EP150', 1520000, 52, 3, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711162/kztjcilxt2v7gdwecqpr.jpg', 1, 1),
(3, 'LỐP BRIDGESTONE 225/45R18 91W POTENZA S001 RUNFLAT', 1530000, 53, 4, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711196/bsfs2hsbnx9f8fr4kajs.webp', 1, 1),
(4, 'LỐP BRIDGESTONE 215/60R16 95V TURANZA T005A', 1540000, 54, 5, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711269/vvszoh4pbkpffufh5zul.jpg', 1, 1),
(5, 'LỐP BRIDGESTONE 245/40R19 94W POTENZA S001 RUNFLAT', 1550000, 55, 1, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711300/xc2ljnbcafy4rqzvexce.jpg', 1, 1),
(6, 'LỐP BRIDGESTONE 185/60R15 84H ECOPIA EP150', 1560000, 56, 2, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711364/alpt6z7kuqoeoz3jj8jf.jpg', 1, 1),
(7, 'LỐP BRIDGESTONE 225/65R17 102H DUELER H/T 470', 1570000, 57, 3, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711386/vpettguxbnijq2hkezsg.jpg', 1, 1),
(8, 'LỐP BRIDGESTONE 205/55R16 91V TURANZA T005A', 1580000, 58, 4, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711486/pfftqchqlv9uncybezbu.webp', 1, 1),
(9, 'LỐP BRIDGESTONE 225/60R18 100H DUELER H/L 33', 1590000, 59, 5, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769711504/cvpok4myhnrmai7bsuvr.jpg', 1, 1),
(10, 'LỐP BRIDGESTONE 265/60R18 110H DUELER H/T 684II', 1600000, 60, 1, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769713078/vhl2afk6ggob1ho7iqpm.jpg', 1, 1),
(11, 'LỐP BRIDGESTONE 235/60R18 103W ALENZA 001', 1610000, 61, 2, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769715427/s892bdjbpoku2g6hb0kg.webp', 1, 1),
(12, 'LỐP BRIDGESTONE 225/55R18 98H DUELER H/P SPORT AS', 1620000, 62, 3, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769715446/h2cwi6wuq52fo7enqiis.webp', 1, 1),
(13, 'LỐP BRIDGESTONE 215/45R17 91W POTENZA RE004', 1630000, 63, 4, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769718154/mior6x2t2jysr5gklafr.webp', 1, 1),
(14, 'LỐP MICHELIN 225/45R18 95Y XL PILOT SPORT 5 TL', 1640000, 64, 5, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769718156/yagfio7w6t6iqlpoizun.webp', 2, 2),
(15, 'LỐP MICHELIN 265/65R17 112T LTX TRAIL', 1650000, 65, 1, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769718170/aflvulgpvrcjqwbfaoq7.webp', 2, 2),
(16, 'LỐP MICHELIN 195/65R15 91V ENERGY XM2+ TL', 1660000, 66, 2, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769718322/vvo8zzb0sra9nuxullrv.webp', 2, 2),
(17, 'LỐP MICHELIN 205/55R16 91V PRIMACY 4 ST TL', 1670000, 67, 3, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769718344/zbzzkaogih2uaa5acjum.webp', 2, 2),
(18, 'LỐP MICHELIN 215/70R15C 109/107S AGILIS 3 TL', 1680000, 68, 4, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769720112/c4ktdwjslkfwslud9say.webp', 2, 2),
(19, 'LỐP MICHELIN 225/50R17 98W XL PRIMACY 4 ST TL', 1690000, 69, 5, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769720125/opfmztsisasveglbycd9.webp', 2, 2),
(20, 'LỐP MICHELIN 185/65R15 88H ENERGY XM2+ TL', 1700000, 70, 1, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769720139/dhldcptq16il3o7zvwdz.webp', 2, 2),
(21, 'LỐP MICHELIN 245/45R18 100Y XL PILOT SPORT 5 TL', 1710000, 71, 2, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769720154/gsrxdnoil2wy3jdkvjot.webp', 2, 2),
(22, 'LỐP MICHELIN 235/40R18 95Y XL PILOT SPORT 5 TL', 1720000, 72, 3, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769720166/hinvpwekyymvy3xflmx1.jpg', 2, 2),
(23, 'LỐP MICHELIN 295/35R20 PILOT SUPER SPORT', 1730000, 73, 4, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769720206/lheew5voymezgsv1kfrq.webp', 2, 2),
(24, 'LỐP MICHELIN 155/70R13 75T ENERGY XM2+ TL', 1740000, 74, 5, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721560/rk48x2jgimmp3u0nrzgu.jpg', 2, 2),
(25, 'LỐP MICHELIN 205/65R16 95V PRIMACY 4ST TL', 1750000, 75, 1, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721767/d7qc3jchmtiyaod3hs0f.jpg', 2, 2),
(26, 'LỐP MICHELIN 205/65R15 94V XL ENERGY XM2+ TL', 1760000, 76, 2, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721785/duf71nwwbvesj7rcuu0q.jpg', 2, 2),
(27, 'LỐP MICHELIN 185/60R15 88H ENERGY XM2+ TL', 1770000, 77, 3, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721806/nwqtxz8wizuuzxwex9cv.jpg', 2, 2),
(28, 'LỐP YOKOHAMA 235/60R18 AE61', 1780000, 78, 4, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721862/qjyush9codcyxvg7z2bs.jpg', 3, 3),
(29, 'LỐP YOKOHAMA 265/65R17 G015', 1790000, 79, 5, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721864/msralhuvnsjhpgommhwp.jpg', 3, 3),
(30, 'LỐP YOKOHAMA 265/65R17 G056', 1800000, 80, 1, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721887/rtkenxin73v8vq2gb78v.png', 3, 3),
(31, 'LỐP YOKOHAMA 215/55R17 AE61', 1810000, 81, 2, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721897/i6ar6bq7bpfcm5iwtbmv.png', 3, 3),
(32, 'LỐP YOKOHAMA 205/55R16 91V AE51', 1820000, 82, 3, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721908/djrnnpvoqijjgbkbcgu5.png', 3, 3),
(33, 'LỐP YOKOHAMA 205/65R15 AE51 JP', 1830000, 83, 4, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721921/slm1zie0nfhjurlklkbn.png', 3, 3),
(34, 'LỐP YOKOHAMA 205/65R16 AE51', 1840000, 84, 5, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721928/jalczbfvminculmi3pmk.jpg', 3, 3),
(35, 'LỐP YOKOHAMA 225/55R19 AE61', 1850000, 85, 1, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721969/adblm6mhdgczn5gmzdqf.png', 3, 3),
(36, 'LỐP YOKOHAMA 225/55R18 AE61', 1860000, 86, 2, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721987/kee92tiobkdb14vvnsnf.png', 3, 3),
(37, 'LỐP YOKOHAMA 225/50R18 95V AE61', 1870000, 87, 3, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769721993/lwqpdyrhd56ibcgutd1e.webp', 3, 3),
(38, 'LỐP YOKOHAMA 185/55R16 AE51', 1880000, 88, 4, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769724095/fmtndt7ow8omdbquvnyr.webp', 3, 3),
(39, 'LỐP YOKOHAMA 155/65R14 ES32', 1890000, 89, 5, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769724112/z0403nkbefmqs7pfrotm.webp', 3, 3),
(40, 'LỐP SAILUN 175/70R14 84T SH406', 1900000, 90, 1, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769724118/e10k33prx8smtrood6on.webp', 4, 4),
(41, 'LỐP SAILUN 175/70R13 82T SH406', 1910000, 91, 2, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769724221/bd6umlkkii5qnmnglnxh.png', 4, 4),
(42, 'LỐP SAILUN 175/65R14 82H SH406', 1920000, 92, 3, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769724233/xfc7wdmyvmv5nc39wpt2.png', 4, 4),
(43, 'LỐP SAILUN 175/50R15 75V SH406', 1930000, 93, 4, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769724241/w7fawn8xnh49beu5zy7z.png', 4, 4),
(44, 'LỐP SAILUN 165/80R13 83T SH 406', 1940000, 94, 5, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769724253/pwjdqfwxi8fmzhhdu46q.webp', 4, 4),
(45, 'LỐP SAILUN 165/65R14 79T SH406', 1950000, 95, 1, 'https://res.cloudinary.com/dfprej0x0/image/upload/v1769724266/of2kt628ly3jjieqkbfb.png', 4, 4),
(46, 'LỐP SAILUN 165/65R13 77T SH407', 1960000, 96, 2, 'https://voxethaiphung.vn/userfiles/image/1.san-pham/lop-sailun-165-65r13-77t-sh407/xxxx.jpg.webp', 4, 4),
(47, 'LỐP SAILUN 165/60R14 75H SH406', 1970000, 97, 3, 'https://voxethaiphung.vn/userfiles/image/1.san-pham/lop-sailun-165-60r14-75h-sh406/lop-sailun155-70-13-768x768.png', 4, 4),
(48, 'LỐP SAILUN 155/80R13 79T SH406', 1980000, 98, 4, 'https://voxethaiphung.vn/userfiles/image/1.san-pham/lop-sailun-155-80r13-79t-sh406/lop-sailun155-70-13-768x768.png', 4, 4),
(49, 'LỐP SAILUN 155/70R13 75T SH407', 1990000, 99, 5, 'https://voxethaiphung.vn/userfiles/image/1.san-pham/lop-sailun-155-70r13-75t-sh407/xxxx.jpg.webp', 4, 4),
(50, 'LỐP SAILUN 155/65R13 73T SH406', 2000000, 100, 4, 'https://voxethaiphung.vn/userfiles/image/1.san-pham/lop-sailun-155-65r13-73t-sh406/lop-sailun155-70-13-768x768_300x300.png', 4, 4);



-- 6. CART ITEMS
INSERT INTO cart_items (user_id, product_id, quantity) VALUES
(2, 1, 2),
(2, 5, 1),
(3, 6, 3),
(3, 9, 1),
(4, 3, 2);

-- 7. ORDERS
INSERT INTO orders (order_id, total_amount, status, shipping_address, user_id) VALUES
(1, 6800000, 'pending', 'HCM', 2),
(2, 4500000, 'completed', 'Ha Noi', 3),
(3, 3200000, 'shipping', 'Da Nang', 4);

-- 8. ORDER ITEMS
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 1510000),
(1, 5, 1, 1550000),
(2, 6, 2, 1640000),
(3, 3, 1, 1530000),
(3, 4, 1, 1540000);

-- 9. NOTIFICATIONS
INSERT INTO notifications (title, body, user_id) VALUES
('Don hang moi', 'Don hang #1 dang cho xac nhan', 2),
('Thanh toan thanh cong', 'Don hang #2 da hoan tat', 3),
('Dang giao hang', 'Don hang #3 dang van chuyen', 4),
('Khuyen mai', 'Giam 10% cho lop Michelin', 2);

-- 10. CHAT ROOMS
INSERT INTO chat_rooms (user_id, status) VALUES
(2, 'open'),
(3, 'open'),
(4, 'open');

-- 11. MESSAGES
INSERT INTO messages (room_id, sender_id, content) VALUES
(1, 2, 'Shop oi, tu van giup toi loai lop phu hop'),
(1, 1, 'Dang anh cho shop biet loai xe nhe'),
(2, 3, 'Lop nay chay cao toc on khong?'),
(2, 1, 'Dang rat on va tiet kiem nhien lieu'),
(3, 4, 'Bao lau thi giao hang?'),
(3, 1, 'Dang tu 1-2 ngay a');

-- ======================
-- VEHICLE MAKES
-- ======================
INSERT INTO vehicle_makes (name, logo_url) VALUES
('Toyota','toyota.png'),
('Honda','honda.png'),
('Mazda','mazda.png'),
('Ford','ford.png'),
('Hyundai','hyundai.png');
