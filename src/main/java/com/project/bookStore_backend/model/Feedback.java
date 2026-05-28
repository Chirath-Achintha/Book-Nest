package com.project.bookStore_backend.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "feedback")
@Getter
@Setter
public class Feedback {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "fid")
    private Long feedbackId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cid", nullable = false)
    private Customer customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "bid")
    private Book book; // Nullable - if null, it's website feedback

    @Column(nullable = false)
    private Integer rating; // 1-5 rating

    @Column(columnDefinition = "TEXT")
    private String comment;

    @Column(name = "feedback_date")
    private LocalDateTime createdAt = LocalDateTime.now();

    // Helper method to check if this is book feedback
    public boolean isBookFeedback() {
        return book != null;
    }

    // Helper method to check if this is website feedback
    public boolean isWebsiteFeedback() {
        return book == null;
    }

    // Helper method to get customer name
    public String getCustomerName() {
        return customer != null ? customer.getCname() : "Anonymous";
    }

    // Helper method to get book title (for book feedback)
    public String getBookTitle() {
        return book != null ? book.getTitle() : null;
    }
}