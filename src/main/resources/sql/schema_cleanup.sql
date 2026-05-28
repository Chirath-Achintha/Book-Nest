-- =====================================================
-- SCHEMA CLEANUP - ORDER DETAILS NAMING (NO-OP)
-- =====================================================
-- The application uses `oid` as the orders primary key and as the
-- foreign key in `order_details`. Do NOT rename to `order_id`.
-- This file is intentionally a no-op to avoid mismatches.

-- Step 1: Check current table structure
-- DESCRIBE order_details;

-- Step 2: Drop existing foreign key constraints (must be done first)
-- SET FOREIGN_KEY_CHECKS = 0;

-- Drop foreign key constraints
-- ALTER TABLE order_details DROP CONSTRAINT IF EXISTS fk_order_details_oid;
-- ALTER TABLE order_details DROP CONSTRAINT IF EXISTS fk_order_details_bid;
-- ALTER TABLE order_details DROP CONSTRAINT IF EXISTS fk_order_details_order_id;

-- Step 3: Drop existing primary key
-- ALTER TABLE order_details DROP PRIMARY KEY;

-- Step 4: Rename oid column to order_id for consistency
-- KEEP COLUMN NAME AS `oid` - DO NOT RENAME
-- ALTER TABLE order_details CHANGE COLUMN oid order_id BIGINT;

-- Step 5: Recreate primary key with consistent naming
-- ALTER TABLE order_details ADD PRIMARY KEY (order_id, bid);

-- Step 6: Recreate foreign key constraints with consistent naming
-- ALTER TABLE order_details 
-- ADD CONSTRAINT fk_order_details_order_id 
-- FOREIGN KEY (order_id) REFERENCES orders(oid) ON DELETE CASCADE;

-- ALTER TABLE order_details 
-- ADD CONSTRAINT fk_order_details_bid 
-- FOREIGN KEY (bid) REFERENCES book(bid) ON DELETE CASCADE;

-- Re-enable foreign key checks
-- SET FOREIGN_KEY_CHECKS = 1;

-- Step 7: Recreate indexes with consistent naming
-- DROP INDEX IF EXISTS idx_order_details_oid ON order_details;
-- CREATE INDEX IF NOT EXISTS idx_order_details_order_id ON order_details(order_id);
-- CREATE INDEX IF NOT EXISTS idx_order_details_bid ON order_details(bid);

-- Verify the new structure
-- DESCRIBE order_details;

-- Show the updated constraints
-- SELECT 
--     TABLE_NAME,
--     COLUMN_NAME,
--     CONSTRAINT_NAME,
--     REFERENCED_TABLE_NAME,
--     REFERENCED_COLUMN_NAME
-- FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
-- WHERE REFERENCED_TABLE_SCHEMA = DATABASE()
-- AND TABLE_NAME = 'order_details';
