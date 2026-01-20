INSERT INTO categories (name)
VALUES ('Car Tires'), ('Motorbike Tires');

INSERT INTO products (category_id, name, price, thumbnail_url)
VALUES
(1, 'Michelin Pilot Sport 4', 150.00, 'https://res.cloudinary.com/dj7jvklwp/image/upload/v1768495113/e30fb14e-1d18-485a-b661-6f77be7f3c5c.png'),
(1, 'Bridgestone Turanza T005', 130.00, 'https://res.cloudinary.com/dj7jvklwp/image/upload/v1768495080/4b50620a-8f51-4e19-82b7-3ebee3854a3c.png');

INSERT INTO product_details (product_id, description, brand, origin, warranty_months)
VALUES
(1, 'High performance tire for sports cars', 'Michelin', 'France', 24),
(2, 'Comfortable and durable tire', 'Bridgestone', 'Japan', 18);
