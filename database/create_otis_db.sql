-- Create OTIS SQLite Database
-- Schema for Products, Categories, and Product Details

BEGIN TRANSACTION;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS product_details;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

-- Create categories table
CREATE TABLE categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- Create products table
CREATE TABLE products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    price REAL NOT NULL CHECK (price >= 0),
    thumbnail_url TEXT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Create product_details table
CREATE TABLE product_details (
    product_id INTEGER PRIMARY KEY,
    description TEXT NOT NULL,
    brand TEXT,
    origin TEXT,
    warranty_months INTEGER CHECK (warranty_months >= 0),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Insert categories data
INSERT INTO categories (name) VALUES
('Car Tires'),
('Motorbike Tires');

-- Insert products data
INSERT INTO products (category_id, name, price, thumbnail_url) VALUES
(1, 'Michelin Pilot Sport 4', 150.00, 'https://res.cloudinary.com/dj7jvklwp/image/upload/v1768495113/e30fb14e-1d18-485a-b661-6f77be7f3c5c.png'),
(1, 'Bridgestone Turanza T005', 130.00, 'https://res.cloudinary.com/dj7jvklwp/image/upload/v1768495080/4b50620a-8f51-4e19-82b7-3ebee3854a3c.png'),
(1, 'Continental PremiumContact 6', 145.00, 'https://res.cloudinary.com/demo/image/upload/continental_pc6.png'),
(1, 'Goodyear Eagle F1 Asymmetric 5', 155.00, 'https://res.cloudinary.com/demo/image/upload/goodyear_f1.png'),
(2, 'Michelin Pilot Street 2', 75.00, 'https://res.cloudinary.com/demo/image/upload/pilot_street_2.png'),
(2, 'Pirelli Angel City', 70.00, 'https://res.cloudinary.com/demo/image/upload/angel_city.png'),
(2, 'Bridgestone Battlax BT46', 82.00, 'https://res.cloudinary.com/demo/image/upload/battlax_bt46.png'),
(2, 'Michelin X Multi Z', 280.00, 'https://res.cloudinary.com/demo/image/upload/x_multi_z.png'),
(2, 'Bridgestone Ecopia H-Steer 001', 265.00, 'https://res.cloudinary.com/demo/image/upload/ecopia_hsteer.png'),
(2, 'Goodyear Fuelmax Endurance', 290.00, 'https://res.cloudinary.com/demo/image/upload/fuelmax_endurance.png');

-- Insert product_details data
INSERT INTO product_details (product_id, description, brand, origin, warranty_months) VALUES
(1, 'High performance tire for sports cars', 'Michelin', 'France', 24),
(2, 'Comfortable and durable tire', 'Bridgestone', 'Japan', 18),
(3, 'High performance tire for sports cars', 'Michelin', 'France', 24),
(4, 'Comfortable touring tire with low noise', 'Bridgestone', 'Japan', 24),
(5, 'Excellent grip and braking performance', 'Continental', 'Germany', 24),
(6, 'Ultra high performance tire for premium vehicles', 'Goodyear', 'USA', 24),
(7, 'Durable tire for urban motorbike usage', 'Michelin', 'Thailand', 18),
(8, 'Designed for city riding with good wet grip', 'Pirelli', 'Indonesia', 18),
(9, 'Classic touring tire for motorcycles', 'Bridgestone', 'Japan', 18),
(10, 'Long-haul truck tire with high durability', 'Michelin', 'France', 36),
(11, 'Fuel-efficient tire for heavy-duty trucks', 'Bridgestone', 'Japan', 36),
(12, 'Long distance tire with optimized rolling resistance', 'Goodyear', 'USA', 36);

COMMIT;

