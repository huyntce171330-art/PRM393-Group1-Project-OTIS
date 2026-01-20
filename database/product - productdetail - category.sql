BEGIN;

DROP TABLE IF EXISTS product_details;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    thumbnail_url TEXT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE product_details (
    product_id INT PRIMARY KEY,
    description TEXT NOT NULL,
    brand VARCHAR(100),
    origin VARCHAR(100),
    warranty_months INT CHECK (warranty_months >= 0),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

COMMIT;
