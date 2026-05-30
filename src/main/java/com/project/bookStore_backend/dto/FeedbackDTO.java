package com.project.bookStore_backend.dto;

public class FeedbackDTO {
    private Long feedbackId;
    private Long customerId;
    private String customerName;
    private int rating;
    private String comment;
    private String createdAtFormatted;

    public FeedbackDTO(Long feedbackId, Long customerId, String customerName, int rating, String comment, String createdAtFormatted) {
        this.feedbackId = feedbackId;
        this.customerId = customerId;
        this.customerName = customerName;
        this.rating = rating;
        this.comment = comment;
        this.createdAtFormatted = createdAtFormatted;
    }

    // Legacy constructor for backward compatibility
    public FeedbackDTO(String customerName, int rating, String comment, String createdAtFormatted) {
        this.customerName = customerName;
        this.rating = rating;
        this.comment = comment;
        this.createdAtFormatted = createdAtFormatted;
    }

    public Long getFeedbackId() {
        return feedbackId;
    }

    public Long getCustomerId() {
        return customerId;
    }

    public String getCustomerName() {
        return customerName;
    }
    public int getRating() {
        return rating;
    }
    public String getComment() {
        return comment;
    }
    public String getCreatedAtFormatted() {
        return createdAtFormatted;
    }
}

