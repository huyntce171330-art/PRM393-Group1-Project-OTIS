
Lần đầu phải làm chuyện này 


cd T:\PRM393-Group1-Project-OTIS
dart create_db_standalone.dart




# Hướng dẫn xem dữ liệu SQLite Database

## Mở Database

```powershell
sqlite3 T:\PRM393-Group1-Project-OTIS\app\assets\database\otis.db
```

## Các lệnh xem dữ liệu

### Xem tất cả products
```sql
SELECT * FROM products;
```

### Xem products với thông tin cơ bản
```sql
SELECT id, name, price, stock, rating, brand_id FROM products;
```

### Xem 5 products đầu tiên
```sql
SELECT id, name, price FROM products LIMIT 5;
```

### Xem brands (thương hiệu)
```sql
SELECT * FROM brands;
```

### Xem users (người dùng)
```sql
SELECT * FROM users;
```

### Xem cart_items (giỏ hàng)
```sql
SELECT * FROM cart_items;
```

### Xem orders (đơn hàng)
```sql
SELECT * FROM orders;
```

### Xem order_items (chi tiết đơn hàng)
```sql
SELECT * FROM order_items;
```

### Xem payments (thanh toán)
```sql
SELECT * FROM payments;
```

### Xem tire_specs (thông số lốp)
```sql
SELECT * FROM tire_specs;
```

### Xem tất cả các bảng có trong database
```sql
.tables
```

### Xem cấu trúc bảng
```sql
.schema products
```

### Thoát khỏi SQLite
```sql
.quit
```

## Xem nhanh trong PowerShell (không cần vào SQLite)

```powershell
# Xem 10 products đầu tiên
sqlite3 T:\PRM393-Group1-Project-OTIS\app\assets\database\otis.db "SELECT id, name, price FROM products LIMIT 10;"

# Xem tất cả brands
sqlite3 T:\PRM393-Group1-Project-OTIS\app\assets\database\otis.db "SELECT * FROM brands;"

# Đếm số lượng products
sqlite3 T:\PRM393-Group1-Project-OTIS\app\assets\database\otis.db "SELECT COUNT(*) FROM products;"

# Xem products của brand cụ thể (brand_id = 1)
sqlite3 T:\PRM393-Group1-Project-OTIS\app\assets\database\otis.db "SELECT * FROM products WHERE brand_id = 1 LIMIT 5;"
```

## Ví dụ xem dữ liệu quan hệ

### Xem products kèm tên brand
```sql
SELECT p.id, p.name, p.price, b.name as brand_name
FROM products p
JOIN brands b ON p.brand_id = b.id
LIMIT 10;
```

### Xem products kèm thông số lốp
```sql
SELECT p.id, p.name, p.price, t.width, t.aspect_ratio, t.rim_size
FROM products p
JOIN tire_specs t ON p.tire_spec_id = t.id
LIMIT 10;
```

---

**Lưu ý**: Database nằm tại `app/assets/database/otis.db`

