-- ===========================================
-- QUICK FIX FOR FEEDBACK FOREIGN KEY ERROR
-- Run this in your MySQL database management tool
-- ===========================================

-- Step 1: Check current constraints
SHOW CREATE TABLE feedback;

-- Step 2: Drop the incorrect foreign key constraint
-- (Replace 'FKlxlc8baec1rv7rt7ebhft9p3t' with the actual constraint name from Step 1)
ALTER TABLE feedback DROP FOREIGN KEY FKlxlc8baec1rv7rt7ebhft9p3t;

-- Step 3: Add the correct foreign key constraint
ALTER TABLE feedback ADD CONSTRAINT fk_feedback_customer 
    FOREIGN KEY (cid) REFERENCES customer(cid) ON DELETE CASCADE;

-- Step 4: Verify the fix
SELECT 
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_NAME = 'feedback' 
AND CONSTRAINT_NAME LIKE '%fk%';

-- Step 5: Test the constraint (this should work without errors)
SELECT COUNT(*) FROM feedback f 
JOIN customer c ON f.cid = c.cid 
WHERE f.cid IS NOT NULL;
