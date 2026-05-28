-- ===========================================
-- ORDER MANAGEMENT SQL
-- Tables: orders
-- ===========================================

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
    oid BIGINT AUTO_INCREMENT PRIMARY KEY,
    cid BIGINT NOT NULL,
    billing_address VARCHAR(255),
    shipping_address VARCHAR(255),
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_date DATETIME,
    payment_method VARCHAR(50),
    payment_status ENUM('PENDING', 'PAID', 'FAILED', 'REFUNDED') DEFAULT 'PENDING',
    status ENUM('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'RETURNED') DEFAULT 'PENDING',
    total_amount DECIMAL(10,2),
    transaction_id VARCHAR(100),
    order_notes TEXT,
    tracking_number VARCHAR(100),
    estimated_delivery DATETIME,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cid) REFERENCES customer(cid) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_orders_cid ON orders(cid);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON orders(payment_status);
CREATE INDEX IF NOT EXISTS idx_orders_order_date ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_orders_tracking_number ON orders(tracking_number);

