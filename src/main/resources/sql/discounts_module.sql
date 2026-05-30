-- ===========================================
-- DISCOUNT & PROMOTION MANAGEMENT SQL
-- Tables: store_owner, discount
-- ===========================================

-- Optional: remove legacy table if present to avoid confusion
-- DROP TABLE IF EXISTS discounts;

-- Create store_owner table (if not exists)
CREATE TABLE IF NOT EXISTS store_owner (
    owner_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    owner_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create discount table per requirements
CREATE TABLE IF NOT EXISTS discount (
    dis_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dname VARCHAR(100) NOT NULL,
    dtype ENUM('PERCENTAGE','FLAT') NOT NULL,
    percentage DECIMAL(5,2),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('ACTIVE','EXPIRED','UPCOMING') DEFAULT 'UPCOMING',
    owner_id BIGINT,
    FOREIGN KEY (owner_id) REFERENCES store_owner(owner_id)
);

-- Useful indexes
CREATE INDEX IF NOT EXISTS idx_discount_status ON discount(status);
CREATE INDEX IF NOT EXISTS idx_discount_date ON discount(start_date, end_date);

