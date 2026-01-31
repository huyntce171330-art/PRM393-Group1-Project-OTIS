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
  shop_name TEXT,
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
  rim_diameter INTEGER,
  UNIQUE (width, aspect_ratio, rim_diameter)
);

-- ========== 5. VEHICLE_MAKES ==========
DROP TABLE IF EXISTS vehicle_makes;
CREATE TABLE vehicle_makes (
  make_id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE,
  logo_url TEXT
);

-- ========== 6. PRODUCTS ==========
DROP TABLE IF EXISTS products;
CREATE TABLE products (
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
);

-- ========== 7. CART_ITEMS ==========
DROP TABLE IF EXISTS cart_items;
CREATE TABLE cart_items (
  user_id INTEGER,
  product_id INTEGER,
  quantity INTEGER,
  PRIMARY KEY (user_id, product_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ========== 8. ORDERS ==========
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code TEXT UNIQUE,
  total_amount DECIMAL,
  status TEXT,
  shipping_address TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ========== 9. ORDER_ITEMS ==========
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
  order_id INTEGER,
  product_id INTEGER,
  quantity INTEGER,
  unit_price DECIMAL,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ========== 10. NOTIFICATIONS ==========
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

-- ========== 11. CHAT_ROOMS ==========
DROP TABLE IF EXISTS chat_rooms;
CREATE TABLE chat_rooms (
  room_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER UNIQUE,
  status TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ========== 12. MESSAGES ==========
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

-- =====================================================
-- ========== INSERT SAMPLE DATA ==========
-- =====================================================

-- 1. USER_ROLES
INSERT INTO user_roles (role_name) VALUES
('admin'),
('customer');

-- 2. USERS
INSERT INTO users (phone, password_hash, full_name, address, shop_name, role_id, status) VALUES
('0900000000','hash_admin','Admin System','HCM','Admin Shop',1,'active'),
('0900000001','hash_u1','Nguyen Van A','HCM','Shop A',2,'active'),
('0900000002','hash_u2','Tran Thi B','Ha Noi','Shop B',2,'active'),
('0900000003','hash_u3','Le Van C','Da Nang','Shop C',2,'active');

-- 3. BRANDS
INSERT INTO brands (name, logo_url) VALUES
('Bridgestone','bridgestone.png'),
('Michelin','michelin.png'),
('Yokohama','yokohama.png'),
('Sailun','sailun.png'),
('Goodride','goodride.png');

-- 4. TIRE SPECS (34 unique specs)
INSERT INTO tire_specs (width, aspect_ratio, rim_diameter) VALUES
(245,45,18),
(175,65,14),
(225,45,18),
(215,60,16),
(245,40,19),
(185,60,15),
(225,65,17),
(205,55,16),
(225,60,18),
(265,60,18),
(235,60,18),
(225,55,18),
(215,45,17),
(265,65,17),
(195,65,15),
(215,70,15),
(225,50,17),
(185,65,15),
(235,40,18),
(295,35,20),
(145,70,13),
(205,65,16),
(205,65,15),
(155,65,14),
(175,70,14),
(175,70,13),
(175,50,15),
(165,80,13),
(165,65,14),
(165,65,13),
(165,60,14),
(155,80,13),
(155,70,13),
(155,65,13);

-- 5. VEHICLE MAKES
INSERT INTO vehicle_makes (name, logo_url) VALUES
('Toyota','toyota.png'),
('Honda','honda.png'),
('Mazda','mazda.png'),
('Ford','ford.png'),
('Hyundai','hyundai.png');

-- 6. PRODUCTS (50 items - tire_spec_id matching product name specs, make_id varied)
INSERT INTO products (sku, name, image_url, brand_id, make_id, tire_spec_id, price, stock_quantity, is_active) VALUES
-- Bridgestone (13 products)
('BR-245/45R18-S001','LỐP BRIDGESTONE 245/45R18 96W POTENZA S001 RUNFLAT','https://res.cloudinary.com/dfprej0x0/image/upload/v1769708160/r4vfxpqajbqn6n7l7iss.jpg',1,1,1,1510000,51,1),
('BR-175/65R14-EP150','LỐP BRIDGESTONE 175/65R14 82H ECOPIA EP150','https://res.cloudinary.com/dfprej0x0/image/upload/v1769711162/kztjcilxt2v7gdwecqpr.jpg',1,2,2,1520000,52,1),
('BR-225/45R18-S001','LỐP BRIDGESTONE 225/45R18 91W POTENZA S001 RUNFLAT','https://res.cloudinary.com/dfprej0x0/image/upload/v1769711196/bsfs2hsbnx9f8fr4kajs.webp',1,3,3,1530000,53,1),
('BR-215/60R16-T005A','LỐP BRIDGESTONE 215/60R16 95V TURANZA T005A','https://res.cloudinary.com/dfprej0x0/image/upload/v1769711269/vvszoh4pbkpffufh5zul.jpg',1,4,4,1540000,54,1),
('BR-245/40R19-S001','LỐP BRIDGESTONE 245/40R19 94W POTENZA S001 RUNFLAT','https://res.cloudinary.com/dfprej0x0/image/upload/v1769711300/xc2ljnbcafy4rqzvexce.jpg',1,5,5,1550000,55,1),
('BR-185/60R15-EP150','LỐP BRIDGESTONE 185/60R15 84H ECOPIA EP150','https://res.cloudinary.com/dfprej0x0/image/upload/v1769711364/alpt6z7kuqoeoz3jj8jf.jpg',1,1,6,1560000,56,1),
('BR-225/65R17-H/T470','LỐP BRIDGESTONE 225/65R17 102H DUELER H/T 470','https://res.cloudinary.com/dfprej0x0/image/upload/v1769711386/vpettguxbnijq2hkezsg.jpg',1,2,7,1570000,57,1),
('BR-205/55R16-T005A','LỐP BRIDGESTONE 205/55R16 91V TURANZA T005A','https://res.cloudinary.com/dfprej0x0/image/upload/v1769711486/pfftqchqlv9uncybezbu.webp',1,3,8,1580000,58,1),
('BR-225/60R18-H/L33','LỐP BRIDGESTONE 225/60R18 100H DUELER H/L 33','https://res.cloudinary.com/dfprej0x0/image/upload/v1769711504/cvpok4myhnrmai7bsuvr.jpg',1,4,9,1590000,59,1),
('BR-265/60R18-H/T684II','LỐP BRIDGESTONE 265/60R18 110H DUELER H/T 684II','https://res.cloudinary.com/dfprej0x0/image/upload/v1769713078/vhl2afk6ggob1ho7iqpm.jpg',1,5,10,1600000,60,1),
('BR-235/60R18-001','LỐP BRIDGESTONE 235/60R18 103W ALENZA 001','https://res.cloudinary.com/dfprej0x0/image/upload/v1769715427/s892bdjbpoku2g6hb0kg.webp',1,1,11,1610000,61,1),
('BR-225/55R18-H/PSP','LỐP BRIDGESTONE 225/55R18 98H DUELER H/P SPORT AS','https://res.cloudinary.com/dfprej0x0/image/upload/v1769715446/h2cwi6wuq52fo7enqiis.webp',1,2,12,1620000,62,1),
('BR-215/45R17-RE004','LỐP BRIDGESTONE 215/45R17 91W POTENZA RE004','https://res.cloudinary.com/dfprej0x0/image/upload/v1769718154/mior6x2t2jysr5gklafr.webp',1,3,13,1630000,63,1),
-- Michelin (14 products)
('MI-225/45R18-PS5','LỐP MICHELIN 225/45R18 95Y XL PILOT SPORT 5 TL','https://res.cloudinary.com/dfprej0x0/image/upload/v1769718156/yagfio7w6t6iqlpoizun.webp',2,4,1,1640000,64,1),
('MI-265/65R17-LTX','LỐP MICHELIN 265/65R17 112T LTX TRAIL','https://res.cloudinary.com/dfprej0x0/image/upload/v1769718170/aflvulgpvrcjqwbfaoq7.webp',2,5,14,1650000,65,1),
('MI-195/65R15-XM2+','LỐP MICHELIN 195/65R15 91V ENERGY XM2+ TL','https://res.cloudinary.com/dfprej0x0/image/upload/v1769718322/vvo8zzb0sra9nuxullrv.webp',2,1,15,1660000,66,1),
('MI-205/55R16-P4','LỐP MICHELIN 205/55R16 91V PRIMACY 4 ST TL','https://res.cloudinary.com/dfprej0x0/image/upload/v1769718344/zbzzkaogih2uaa5acjum.webp',2,2,8,1670000,67,1),
('MI-215/70R15C-AG3','LỐP MICHELIN 215/70R15C 109/107S AGILIS 3 TL','https://res.cloudinary.com/dfprej0x0/image/upload/v1769720112/c4ktdwjslkfwslud9say.webp',2,3,16,1680000,68,1),
('MI-225/50R17-P4','LỐP MICHELIN 225/50R17 98W XL PRIMACY 4 ST TL','https://res.cloudinary.com/dfprej0x0/image/upload/v1769720125/opfmztsisasveglbycd9.webp',2,4,17,1690000,69,1),
('MI-185/65R15-XM2+','LỐP MICHELIN 185/65R15 88H ENERGY XM2+ TL','https://res.cloudinary.com/dfprej0x0/image/upload/v1769720139/dhldcptq16il3o7zvwdz.webp',2,5,18,1700000,70,1),
('MI-245/45R18-PS5','LỐP MICHELIN 245/45R18 100Y XL PILOT SPORT 5 TL','https://res.cloudinary.com/dfprej0x0/image/upload/v1769720154/gsrxdnoil2wy3jdkvjot.webp',2,1,1,1710000,71,1),
('MI-235/40R18-PS5','LỐP MICHELIN 235/40R18 95Y XL PILOT SPORT 5 TL','https://res.cloudinary.com/dfprej0x0/image/upload/v1769720166/hinvpwekyymvy3xflmx1.jpg',2,2,19,1720000,72,1),
('MI-295/35R20-PSS','LỐP MICHELIN 295/35R20 PILOT SUPER SPORT','https://res.cloudinary.com/dfprej0x0/image/upload/v1769720206/lheew5voymezgsv1kfrq.webp',2,3,20,1730000,73,1),
('MI-145/70R13-XM2+','LỐP MICHELIN 145/70R13 75T ENERGY XM2+ TL','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721560/rk48x2jgimmp3u0nrzgu.jpg',2,4,21,1740000,74,1),
('MI-205/65R16-P4','LỐP MICHELIN 205/65R16 95V PRIMACY 4ST TL','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721767/d7qc3jchmtiyaod3hs0f.jpg',2,5,22,1750000,75,1),
('MI-205/65R15-XM2+','LỐP MICHELIN 205/65R15 94V XL ENERGY XM2+ TL','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721785/duf71nwwbvesj7rcuu0q.jpg',2,1,23,1760000,76,1),
('MI-185/60R15-XM2+','LỐP MICHELIN 185/60R15 88H ENERGY XM2+ TL','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721806/nwqtxz8wizuuzxwex9cv.jpg',2,2,6,1770000,77,1),
-- Yokohama (12 products)
('YO-235/60R18-AE61','LỐP YOKOHAMA 235/60R18 AE61','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721862/qjyush9codcyxvg7z2bs.jpg',3,3,11,1780000,78,1),
('YO-265/65R17-G015','LỐP YOKOHAMA 265/65R17 G015','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721864/msralhuvnsjhpgommhwp.jpg',3,4,14,1790000,79,1),
('YO-265/65R17-G056','LỐP YOKOHAMA 265/65R17 G056','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721887/rtkenxin73v8vq2gb78v.png',3,5,14,1800000,80,1),
('YO-215/55R17-AE61','LỐP YOKOHAMA 215/55R17 AE61','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721897/i6ar6bq7bpfcm5iwtbmv.png',3,1,12,1810000,81,1),
('YO-205/55R16-AE51','LỐP YOKOHAMA 205/55R16 91V AE51','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721908/djrnnpvoqijjgbkbcgu5.png',3,2,8,1820000,82,1),
('YO-205/65R15-AE51','LỐP YOKOHAMA 205/65R15 AE51 JP','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721921/slm1zie0nfhjurlklkbn.png',3,3,23,1830000,83,1),
('YO-205/65R16-AE51','LỐP YOKOHAMA 205/65R16 AE51','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721928/jalczbfvminculmi3pmk.jpg',3,4,22,1840000,84,1),
('YO-225/55R19-AE61','LỐP YOKOHAMA 225/55R19 AE61','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721969/adblm6mhdgczn5gmzdqf.png',3,5,12,1850000,85,1),
('YO-225/55R18-AE61','LỐP YOKOHAMA 225/55R18 AE61','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721987/kee92tiobkdb14vvnsnf.png',3,1,12,1860000,86,1),
('YO-225/50R18-AE61','LỐP YOKOHAMA 225/50R18 95V AE61','https://res.cloudinary.com/dfprej0x0/image/upload/v1769721993/lwqpdyrhd56ibcgutd1e.webp',3,2,17,1870000,87,1),
('YO-185/55R16-AE51','LỐP YOKOHAMA 185/55R16 AE51','https://res.cloudinary.com/dfprej0x0/image/upload/v1769724095/fmtndt7ow8omdbquvnyr.webp',3,3,8,1880000,88,1),
('YO-155/65R14-ES32','LỐP YOKOHAMA 155/65R14 ES32','https://res.cloudinary.com/dfprej0x0/image/upload/v1769724112/z0403nkbefmqs7pfrotm.webp',3,4,24,1890000,89,1),
-- Sailun (10 products)
('SL-175/70R14-SH406','LỐP SAILUN 175/70R14 84T SH406','https://res.cloudinary.com/dfprej0x0/image/upload/v1769724118/e10k33prx8smtrood6on.webp',4,5,25,1900000,90,1),
('SL-175/70R13-SH406','LỐP SAILUN 175/70R13 82T SH406','https://res.cloudinary.com/dfprej0x0/image/upload/v1769724221/bd6umlkkii5qnmnglnxh.png',4,1,26,1910000,91,1),
('SL-175/65R14-SH406','LỐP SAILUN 175/65R14 82H SH406','https://res.cloudinary.com/dfprej0x0/image/upload/v1769724233/xfc7wdmyvmv5nc39wpt2.png',4,2,2,1920000,92,1),
('SL-175/50R15-SH406','LỐP SAILUN 175/50R15 75V SH406','https://res.cloudinary.com/dfprej0x0/image/upload/v1769724241/w7fawn8xnh49beu5zy7z.png',4,3,27,1930000,93,1),
('SL-165/80R13-SH406','LỐP SAILUN 165/80R13 83T SH 406','https://res.cloudinary.com/dfprej0x0/image/upload/v1769724253/pwjdqfwxi8fmzhhdu46q.webp',4,4,28,1940000,94,1),
('SL-165/65R14-SH406','LỐP SAILUN 165/65R14 79T SH406','https://res.cloudinary.com/dfprej0x0/image/upload/v1769724266/of2kt628ly3jjieqkbfb.png',4,5,29,1950000,95,1),
('SL-165/65R13-SH407','LỐP SAILUN 165/65R13 77T SH407','https://voxethaiphung.vn/userfiles/image/1.san-pham/lop-sailun-165-65r13-77t-sh407/xxxx.jpg.webp',4,1,30,1960000,96,1),
('SL-165/60R14-SH406','LỐP SAILUN 165/60R14 75H SH406','https://voxethaiphung.vn/userfiles/image/1.san-pham/lop-sailun-165-60r14-75h-sh406/lop-sailun155-70-13-768x768.png',4,2,31,1970000,97,1),
('SL-155/80R13-SH406','LỐP SAILUN 155/80R13 79T SH406','https://voxethaiphung.vn/userfiles/image/1.san-pham/lop-sailun-155-80r13-79t-sh406/lop-sailun155-70-13-768x768.png',4,3,32,1980000,98,1),
('SL-155/70R13-SH407','LỐP SAILUN 155/70R13 75T SH407','https://voxethaiphung.vn/userfiles/image/1.san-pham/lop-sailun-155-70r13-75t-sh407/xxxx.jpg.webp',4,4,33,1990000,99,1),
-- Goodride (1 product)
('SL-155/65R13-SH406','LỐP SAILUN 155/65R13 73T SH406','https://voxethaiphung.vn/userfiles/image/1.san-pham/lop-sailun-155-65r13-73t-sh406/lop-sailun155-70-13-768x768_300x300.png',5,5,34,2000000,100,1);

-- 7. CART ITEMS
INSERT INTO cart_items (user_id, product_id, quantity) VALUES
(2, 1, 2),
(2, 5, 1),
(3, 6, 3),
(3, 9, 1),
(4, 3, 2);

-- 8. ORDERS (total_amount = sum of order_items)
-- Order 1: product 1 (qty=2, price=1510000) + product 5 (qty=1, price=1550000) = 2*1510000 + 1550000 = 4570000
-- Order 2: product 6 (qty=2, price=1560000) + product 9 (qty=1, price=1590000) = 2*1560000 + 1590000 = 4710000
-- Order 3: product 3 (qty=1, price=1530000) + product 4 (qty=1, price=1540000) = 3070000
INSERT INTO orders (code, total_amount, status, shipping_address, user_id) VALUES
('ORD-001', 4570000, 'pending', 'HCM', 2),
('ORD-002', 4710000, 'completed', 'Ha Noi', 3),
('ORD-003', 3070000, 'shipping', 'Da Nang', 4);

-- 9. ORDER ITEMS
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 1510000),
(1, 5, 1, 1550000),
(2, 6, 2, 1560000),
(2, 9, 1, 1590000),
(3, 3, 1, 1530000),
(3, 4, 1, 1540000);

-- 10. NOTIFICATIONS
INSERT INTO notifications (title, body, user_id) VALUES
('Don hang moi', 'Don hang #1 dang cho xac nhan', 2),
('Thanh toan thanh cong', 'Don hang #2 da hoan tat', 3),
('Dang giao hang', 'Don hang #3 dang van chuyen', 4),
('Khuyen mai', 'Giam 10% cho lop Michelin', 2);

-- 11. CHAT ROOMS
INSERT INTO chat_rooms (user_id, status) VALUES
(2, 'open'),
(3, 'open'),
(4, 'open');

-- 12. MESSAGES
INSERT INTO messages (room_id, sender_id, content) VALUES
(1, 2, 'Shop oi, tu van giup toi loai lop phu hop'),
(1, 1, 'Dang anh cho shop biet loai xe nhe'),
(2, 3, 'Lop nay chay cao toc on khong?'),
(2, 1, 'Dang rat on va tiet kiem nhien lieu'),
(3, 4, 'Bao lau thi giao hang?'),
(3, 1, 'Dang tu 1-2 ngay a');
