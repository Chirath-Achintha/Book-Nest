-- ===========================================
-- PAYMENT MANAGEMENT SQL
-- Tables: payments
-- ===========================================

-- Create payments table
CREATE TABLE IF NOT EXISTS payments (
    payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    oid BIGINT NOT NULL,
    cid BIGINT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED', 'CANCELLED') DEFAULT 'PENDING',
    transaction_id VARCHAR(100) UNIQUE,
    payment_date DATETIME,
    card_number_masked VARCHAR(20),
    card_expiry VARCHAR(10),
    cardholder_name VARCHAR(100),
    payment_notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (oid) REFERENCES orders(oid) ON DELETE CASCADE,
    FOREIGN KEY (cid) REFERENCES customer(cid) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_payments_oid ON payments(oid);
CREATE INDEX IF NOT EXISTS idx_payments_cid ON payments(cid);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(payment_status);
CREATE INDEX IF NOT EXISTS idx_payments_transaction_id ON payments(transaction_id);
CREATE INDEX IF NOT EXISTS idx_payments_payment_date ON payments(payment_date);
CREATE INDEX IF NOT EXISTS idx_payments_created_at ON payments(created_at);

-- Add payment tracking to orders table if not exists
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS payment_tracking_id VARCHAR(100);

-- Create index for payment tracking
CREATE INDEX IF NOT EXISTS idx_orders_payment_tracking ON orders(payment_tracking_id);
