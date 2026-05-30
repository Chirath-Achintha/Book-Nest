-- ===========================================
-- FIX FEEDBACK FOREIGN KEY CONSTRAINT
-- This script fixes the foreign key constraint error
-- ===========================================

-- Drop the incorrect foreign key constraint
ALTER TABLE feedback DROP FOREIGN KEY FKlxlc8baec1rv7rt7ebhft9p3t;

-- Add the correct foreign key constraint pointing to customer table
ALTER TABLE feedback ADD CONSTRAINT fk_feedback_customer 
    FOREIGN KEY (cid) REFERENCES customer(cid) ON DELETE CASCADE;

-- Verify the constraint is working
-- This should not throw an error if the constraint is correct
SELECT COUNT(*) FROM feedback f 
JOIN customer c ON f.cid = c.cid 
WHERE f.cid IS NOT NULL;
