package com.project.bookStore_backend.repository;

import com.project.bookStore_backend.model.Book;
import com.project.bookStore_backend.model.Feedback;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FeedbackRepository extends JpaRepository<Feedback, Long> {

    /**
     * Find all feedback for a specific book
     */
    List<Feedback> findByBook(Book book);

    /**
     * Find all feedback for a specific book by book ID
     */
    List<Feedback> findByBookBid(Long bookId);

    /**
     * Find all website feedback (where book is null)
     */
    List<Feedback> findByBookIsNull();

    /**
     * Find all feedback by a specific customer
     */
    List<Feedback> findByCustomerCid(Long customerId);

    /**
     * Find book feedback by a specific customer for a specific book
     */
    Feedback findByCustomerCidAndBookBid(Long customerId, Long bookId);

    /**
     * Find website feedback by a specific customer
     */
    Feedback findByCustomerCidAndBookIsNull(Long customerId);

    /**
     * Get average rating for a specific book
     */
    @Query("SELECT AVG(f.rating) FROM Feedback f WHERE f.book.bid = :bookId")
    Double getAverageRatingByBookId(@Param("bookId") Long bookId);

    /**
     * Get count of feedback for a specific book
     */
    @Query("SELECT COUNT(f) FROM Feedback f WHERE f.book.bid = :bookId")
    Long getFeedbackCountByBookId(@Param("bookId") Long bookId);

    /**
     * Get all feedback ordered by creation date (newest first)
     */
    List<Feedback> findAllByOrderByCreatedAtDesc();

    /**
     * Get book feedback ordered by creation date (newest first)
     */
    List<Feedback> findByBookIsNotNullOrderByCreatedAtDesc();

    /**
     * Get website feedback ordered by creation date (newest first)
     */
    List<Feedback> findByBookIsNullOrderByCreatedAtDesc();

    /**
     * Get recent feedback (last 10) for homepage display
     */
    @Query("SELECT f FROM Feedback f WHERE f.book IS NULL ORDER BY f.createdAt DESC")
    List<Feedback> findRecentWebsiteFeedback();

    /**
     * Get recent book feedback for a specific book (last 5)
     */
    @Query("SELECT f FROM Feedback f WHERE f.book.bid = :bookId ORDER BY f.createdAt DESC")
    List<Feedback> findRecentBookFeedback(@Param("bookId") Long bookId);
}