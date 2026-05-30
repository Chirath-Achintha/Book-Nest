-- ===========================================
-- IMMEDIATE FIX FOR FEEDBACK CONSTRAINT ERROR
-- This will fix the specific constraint causing the error
-- ===========================================

-- Step 1: Drop the problematic constraint
ALTER TABLE feedback DROP FOREIGN KEY FKlxlc8baec1rv7rt7ebhft9p3t;

-- Step 2: Add the correct constraint
ALTER TABLE feedback ADD CONSTRAINT fk_feedback_customer 
    FOREIGN KEY (cid) REFERENCES customer(cid) ON DELETE CASCADE;

-- Step 3: Verify the fix
SELECT 
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_NAME = 'feedback' 
AND CONSTRAINT_NAME = 'fk_feedback_customer';
