-- ===========================================
-- REVIEW & RATING MANAGEMENT SQL
-- Tables: feedback
-- ===========================================

-- Create feedback table
CREATE TABLE IF NOT EXISTS feedback (
    fid BIGINT AUTO_INCREMENT PRIMARY KEY,
    cid BIGINT,
    bid BIGINT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    feedback_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cid) REFERENCES customer(cid) ON DELETE CASCADE,
    FOREIGN KEY (bid) REFERENCES book(bid) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_feedback_cid ON feedback(cid);
CREATE INDEX IF NOT EXISTS idx_feedback_bid ON feedback(bid);
CREATE INDEX IF NOT EXISTS idx_feedback_rating ON feedback(rating);

