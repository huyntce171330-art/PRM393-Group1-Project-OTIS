-- ========================
-- USERS & ROLES
-- ========================

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    full_name VARCHAR(255),
    phone VARCHAR(20),
    avatar_url TEXT,
    status VARCHAR(20) CHECK (status IN ('active','inactive')) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE user_roles (
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    role_id INT REFERENCES roles(role_id),
    PRIMARY KEY (user_id, role_id)
);

-- ========================
-- CATEGORY & PRODUCT
-- ========================

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category_id INT REFERENCES categories(category_id),
    name VARCHAR(255) NOT NULL,
    brand VARCHAR(100),
    size VARCHAR(50),
    description TEXT,
    price NUMERIC(12,2) NOT NULL,
    image_url TEXT,
    status VARCHAR(20) CHECK (status IN ('available','out_of_stock')) DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- STORE & INVENTORY
-- ========================

CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE inventories (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    store_id INT REFERENCES stores(store_id),
    quantity INT NOT NULL CHECK (quantity >= 0),
    UNIQUE (product_id, store_id)
);

-- ========================
-- CART
-- ========================

CREATE TABLE carts (
    cart_id SERIAL PRIMARY KEY,
    user_id INT UNIQUE REFERENCES users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cart_items (
    cart_item_id SERIAL PRIMARY KEY,
    cart_id INT REFERENCES carts(cart_id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    UNIQUE (cart_id, product_id)
);

-- ========================
-- ORDER & PAYMENT
-- ========================

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    store_id INT REFERENCES stores(store_id),
    total_amount NUMERIC(12,2),
    status VARCHAR(30) CHECK (status IN ('pending','confirmed','shipped','completed','cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id),
    price_at_purchase NUMERIC(12,2) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0)
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT UNIQUE REFERENCES orders(order_id),
    method VARCHAR(50),
    status VARCHAR(30),
    paid_at TIMESTAMP
);

-- ========================
-- NOTIFICATION
-- ========================

CREATE TABLE notifications (
    notification_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    content TEXT,
    type VARCHAR(50),
    created_by INT REFERENCES users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_notifications (
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    notification_id INT REFERENCES notifications(notification_id) ON DELETE CASCADE,
    is_read BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (user_id, notification_id)
);

-- ========================
-- CHAT
-- ========================

CREATE TABLE chat_rooms (
    room_id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE chat_participants (
    room_id INT REFERENCES chat_rooms(room_id) ON DELETE CASCADE,
    user_id INT REFERENCES users(user_id),
    PRIMARY KEY (room_id, user_id)
);

CREATE TABLE messages (
    message_id SERIAL PRIMARY KEY,
    room_id INT REFERENCES chat_rooms(room_id) ON DELETE CASCADE,
    sender_id INT REFERENCES users(user_id),
    content TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
