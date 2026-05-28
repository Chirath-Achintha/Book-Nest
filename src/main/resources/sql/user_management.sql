-- ===========================================
-- USER MANAGEMENT SQL
-- Tables: customer, registered_customer, admin_staff
-- ===========================================

-- Create customer table
CREATE TABLE IF NOT EXISTS customer (
    cid BIGINT AUTO_INCREMENT PRIMARY KEY,
    cname VARCHAR(100) NOT NULL
);

-- Create registered_customer table
CREATE TABLE IF NOT EXISTS registered_customer (
    cid BIGINT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER',
    FOREIGN KEY (cid) REFERENCES customer(cid) ON DELETE CASCADE
);

-- Create admin_staff table
CREATE TABLE IF NOT EXISTS admin_staff (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    role VARCHAR(20) NOT NULL DEFAULT 'ADMIN',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_registered_customer_username ON registered_customer(username);
CREATE INDEX IF NOT EXISTS idx_registered_customer_email ON registered_customer(email);
CREATE INDEX IF NOT EXISTS idx_registered_customer_cid ON registered_customer(cid);
CREATE INDEX IF NOT EXISTS idx_admin_staff_username ON admin_staff(username);

