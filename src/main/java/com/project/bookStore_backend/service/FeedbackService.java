package com.project.bookStore_backend.service;

import com.project.bookStore_backend.model.Book;
import com.project.bookStore_backend.model.Customer;
import com.project.bookStore_backend.model.Feedback;
import com.project.bookStore_backend.repository.BookRepository;
import com.project.bookStore_backend.repository.CustomerRepository;
import com.project.bookStore_backend.repository.FeedbackRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class FeedbackService {

    @Autowired
    private FeedbackRepository feedbackRepository;

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private CustomerRepository customerRepository;

    /**
     * Add feedback for a specific book
     */
    public Feedback addBookFeedback(Long customerId, Long bookId, Integer rating, String comment) {
        // Validate inputs
        if (customerId == null) {
            throw new IllegalArgumentException("Customer ID is required");
        }
        if (bookId == null) {
            throw new IllegalArgumentException("Book ID is required");
        }
        if (rating == null || rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }

        // Find customer and book
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new IllegalArgumentException("Customer not found with ID: " + customerId));
        
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new IllegalArgumentException("Book not found with ID: " + bookId));

        // Check if customer already left feedback for this book
        Feedback existingFeedback = feedbackRepository.findByCustomerCidAndBookBid(customerId, bookId);
        
        Feedback feedback;
        if (existingFeedback != null) {
            // Update existing feedback
            feedback = existingFeedback;
            feedback.setRating(rating);
            feedback.setComment(comment);
        } else {
            // Create new feedback
            feedback = new Feedback();
            feedback.setCustomer(customer);
            feedback.setBook(book);
            feedback.setRating(rating);
            feedback.setComment(comment);
        }

        feedback = feedbackRepository.save(feedback);
        
        // Update book's average rating
        updateBookRating(bookId);
        
        return feedback;
    }

    /**
     * Add website feedback (general testimonials)
     */
    public Feedback addWebsiteFeedback(Long customerId, Integer rating, String comment) {
        // Validate inputs
        if (customerId == null) {
            throw new IllegalArgumentException("Customer ID is required");
        }
        if (rating == null || rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }

        // Find customer
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new IllegalArgumentException("Customer not found with ID: " + customerId));

        // Check if customer already left website feedback
        Feedback existingFeedback = feedbackRepository.findByCustomerCidAndBookIsNull(customerId);
        
        Feedback feedback;
        if (existingFeedback != null) {
            // Update existing feedback
            feedback = existingFeedback;
            feedback.setRating(rating);
            feedback.setComment(comment);
        } else {
            // Create new feedback
            feedback = new Feedback();
            feedback.setCustomer(customer);
            feedback.setBook(null); // Website feedback has no book
            feedback.setRating(rating);
            feedback.setComment(comment);
        }

        return feedbackRepository.save(feedback);
    }

    /**
     * Get all feedback for a specific book
     */
    @Transactional(readOnly = true)
    public List<Feedback> getFeedbackForBook(Long bookId) {
        return feedbackRepository.findByBookBid(bookId);
    }

    /**
     * Get all website feedback
     */
    @Transactional(readOnly = true)
    public List<Feedback> getWebsiteFeedback() {
        return feedbackRepository.findByBookIsNullOrderByCreatedAtDesc();
    }

    /**
     * Get recent website feedback for homepage (limited to 10)
     */
    @Transactional(readOnly = true)
    public List<Feedback> getRecentWebsiteFeedback() {
        return feedbackRepository.findRecentWebsiteFeedback();
    }

    /**
     * Get recent book feedback for a specific book (limited to 5)
     */
    @Transactional(readOnly = true)
    public List<Feedback> getRecentBookFeedback(Long bookId) {
        return feedbackRepository.findRecentBookFeedback(bookId);
    }

    /**
     * Get average rating for a book
     */
    @Transactional(readOnly = true)
    public Double getAverageRatingForBook(Long bookId) {
        Double avgRating = feedbackRepository.getAverageRatingByBookId(bookId);
        return avgRating != null ? Math.round(avgRating * 10.0) / 10.0 : 0.0;
    }

    /**
     * Get feedback count for a book
     */
    @Transactional(readOnly = true)
    public Long getFeedbackCountForBook(Long bookId) {
        return feedbackRepository.getFeedbackCountByBookId(bookId);
    }

    /**
     * Get all feedback (for admin panel)
     */
    @Transactional(readOnly = true)
    public List<Feedback> getAllFeedback() {
        return feedbackRepository.findAllByOrderByCreatedAtDesc();
    }

    /**
     * Delete feedback by ID
     */
    public void deleteFeedback(Long feedbackId) {
        Feedback feedback = feedbackRepository.findById(feedbackId)
                .orElseThrow(() -> new IllegalArgumentException("Feedback not found"));
        
        Long bookId = null;
        if (feedback.getBook() != null) {
            bookId = feedback.getBook().getBid();
        }
        
        feedbackRepository.delete(feedback);
        
        // Update book rating if it was book feedback
        if (bookId != null) {
            updateBookRating(bookId);
        }
    }

    /**
     * Update book's average rating
     */
    private void updateBookRating(Long bookId) {
        Double avgRating = getAverageRatingForBook(bookId);
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new IllegalArgumentException("Book not found"));
        book.setRating(avgRating);
        bookRepository.save(book);
    }

    /**
     * Check if customer has already left feedback for a book
     */
    @Transactional(readOnly = true)
    public boolean hasCustomerLeftBookFeedback(Long customerId, Long bookId) {
        return feedbackRepository.findByCustomerCidAndBookBid(customerId, bookId) != null;
    }

    /**
     * Check if customer has already left website feedback
     */
    @Transactional(readOnly = true)
    public boolean hasCustomerLeftWebsiteFeedback(Long customerId) {
        return feedbackRepository.findByCustomerCidAndBookIsNull(customerId) != null;
    }

    /**
     * Get customer's existing book feedback
     */
    @Transactional(readOnly = true)
    public Optional<Feedback> getCustomerBookFeedback(Long customerId, Long bookId) {
        Feedback feedback = feedbackRepository.findByCustomerCidAndBookBid(customerId, bookId);
        return Optional.ofNullable(feedback);
    }

    /**
     * Get customer's existing website feedback
     */
    @Transactional(readOnly = true)
    public Optional<Feedback> getCustomerWebsiteFeedback(Long customerId) {
        Feedback feedback = feedbackRepository.findByCustomerCidAndBookIsNull(customerId);
        return Optional.ofNullable(feedback);
    }

    /**
     * Get feedback by ID
     */
    @Transactional(readOnly = true)
    public Optional<Feedback> getFeedbackById(Long feedbackId) {
        return feedbackRepository.findById(feedbackId);
    }

    /**
     * Update existing feedback
     */
    public Feedback updateFeedback(Long feedbackId, Integer rating, String comment) {
        // Validate rating
        if (rating == null || rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }

        // Find feedback
        Feedback feedback = feedbackRepository.findById(feedbackId)
                .orElseThrow(() -> new IllegalArgumentException("Feedback not found"));

        // Update feedback
        feedback.setRating(rating);
        feedback.setComment(comment);

        feedback = feedbackRepository.save(feedback);
        
        // Update book's average rating if it's book feedback
        if (feedback.getBook() != null) {
            updateBookRating(feedback.getBook().getBid());
        }
        
        return feedback;
    }
}