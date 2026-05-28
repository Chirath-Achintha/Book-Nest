-- ===========================================
-- BOOK CATALOG MANAGEMENT SQL
-- Tables: book, discounts
-- ===========================================

-- Create book table
CREATE TABLE IF NOT EXISTS book (
    bid BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100),
    genre VARCHAR(50),
    price DOUBLE NOT NULL,
    stock INT,
    description TEXT,
    publication_date DATETIME,
    isbn VARCHAR(20),
    image_url VARCHAR(500),
    rating DOUBLE DEFAULT 0.0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create discounts table
CREATE TABLE IF NOT EXISTS discounts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    discount_type ENUM('PERCENTAGE', 'FIXED_AMOUNT') NOT NULL,
    value DECIMAL(10,2) NOT NULL,
    min_order_amount DECIMAL(10,2) DEFAULT 0.00,
    usage_limit INT DEFAULT -1,
    is_active BOOLEAN DEFAULT TRUE,
    valid_until DATETIME,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES admin_staff(id) ON DELETE SET NULL
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_book_genre ON book(genre);
CREATE INDEX IF NOT EXISTS idx_book_price ON book(price);
CREATE INDEX IF NOT EXISTS idx_book_rating ON book(rating);
CREATE INDEX IF NOT EXISTS idx_book_author ON book(author);
CREATE INDEX IF NOT EXISTS idx_book_title ON book(title);

