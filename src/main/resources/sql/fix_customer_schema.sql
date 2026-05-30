-- ===========================================
-- FIX CUSTOMER SCHEMA
-- Fixes the registered_customer table structure
-- ===========================================

-- Drop the existing registered_customer table if it has the wrong structure
DROP TABLE IF EXISTS registered_customer;

-- Recreate registered_customer table with correct structure
CREATE TABLE registered_customer (
    cid BIGINT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER',
    FOREIGN KEY (cid) REFERENCES customer(cid) ON DELETE CASCADE
);

-- Recreate indexes
CREATE INDEX idx_registered_customer_username ON registered_customer(username);
CREATE INDEX idx_registered_customer_email ON registered_customer(email);
CREATE INDEX idx_registered_customer_cid ON registered_customer(cid);

-- Note: This will delete all existing registered customer data
-- In a production environment, you would need to migrate the data first
