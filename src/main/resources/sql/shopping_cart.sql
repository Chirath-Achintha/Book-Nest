-- ===========================================
-- SHOPPING CART MANAGEMENT SQL
-- Tables: cart
-- ===========================================

-- Create cart table
CREATE TABLE IF NOT EXISTS cart (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cid BIGINT,
    bid BIGINT,
    quantity INT NOT NULL DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cid) REFERENCES customer(cid) ON DELETE CASCADE,
    FOREIGN KEY (bid) REFERENCES book(bid) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_cart_cid ON cart(cid);
CREATE INDEX IF NOT EXISTS idx_cart_bid ON cart(bid);

