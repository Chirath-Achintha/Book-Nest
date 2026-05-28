package com.project.bookStore_backend.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Entity
@Table(name = "payments")
@Getter
@Setter
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "payment_id")
    private Long paymentId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "oid", nullable = false)
    private Orders order;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cid", nullable = false)
    private Customer customer;

    @Column(name = "payment_method", length = 50, nullable = false)
    private String paymentMethod;

    @Column(name = "payment_amount", precision = 10, scale = 2, nullable = false)
    private BigDecimal paymentAmount;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status", nullable = false)
    private PaymentStatus paymentStatus = PaymentStatus.PENDING;

    @Column(name = "transaction_id", length = 100, unique = true)
    private String transactionId;

    @Column(name = "payment_date")
    private LocalDateTime paymentDate;

    @Column(name = "card_number_masked", length = 20)
    private String cardNumberMasked;

    @Column(name = "card_expiry", length = 10)
    private String cardExpiry;

    @Column(name = "cardholder_name", length = 100)
    private String cardholderName;

    @Column(name = "payment_notes", columnDefinition = "TEXT")
    private String paymentNotes;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    // Date fields for JSP compatibility (not persisted)
    @Transient
    private Date paymentDateAsDate;
    
    @Transient
    private Date createdAtAsDate;
    
    @Transient
    private Date updatedAtAsDate;

    // Payment status enum
    public enum PaymentStatus {
        PENDING, COMPLETED, FAILED, REFUNDED, CANCELLED
    }

    // Helper methods
    public boolean isCompleted() {
        return paymentStatus == PaymentStatus.COMPLETED;
    }

    public boolean isFailed() {
        return paymentStatus == PaymentStatus.FAILED;
    }

    public boolean canBeRefunded() {
        return paymentStatus == PaymentStatus.COMPLETED;
    }

    // Getter methods for JSP property access
    public boolean getIsCompleted() {
        return isCompleted();
    }

    public boolean getIsFailed() {
        return isFailed();
    }

    public boolean getCanBeRefunded() {
        return canBeRefunded();
    }

    public String getStatusDisplayName() {
        return paymentStatus.name().replace("_", " ");
    }

    // Helper method to update timestamp
    public void updateTimestamp() {
        this.updatedAt = LocalDateTime.now();
    }

    // Date conversion methods for JSP compatibility
    public Date getPaymentDateAsDate() {
        if (paymentDate == null) return null;
        return Date.from(paymentDate.atZone(ZoneId.systemDefault()).toInstant());
    }

    public Date getCreatedAtAsDate() {
        if (createdAt == null) return null;
        return Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
    }

    public Date getUpdatedAtAsDate() {
        if (updatedAt == null) return null;
        return Date.from(updatedAt.atZone(ZoneId.systemDefault()).toInstant());
    }

    // Helper method to mask card number
    public void setCardNumberMasked(String cardNumber) {
        if (cardNumber != null && cardNumber.length() > 4) {
            String masked = "*".repeat(cardNumber.length() - 4) + cardNumber.substring(cardNumber.length() - 4);
            this.cardNumberMasked = masked;
        } else {
            this.cardNumberMasked = cardNumber;
        }
    }
}
