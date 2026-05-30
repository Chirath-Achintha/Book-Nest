package com.project.bookStore_backend.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Entity
@Table(name = "orders")
@Getter
@Setter
public class Orders {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "oid")
    private Long oid;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cid", nullable = false)
    private Customer customer;

    @NotBlank(message = "Billing address is required")
    @Size(min = 10, max = 255, message = "Billing address must be between 10 and 255 characters")
    @Pattern(regexp = "^[a-zA-Z0-9\\s\\-.,#/]+$", message = "Billing address can only contain letters, numbers, spaces, hyphens, periods, commas, hash, and forward slash")
    @Column(name = "billing_address", length = 255)
    private String billingAddress;

    @NotBlank(message = "Shipping address is required")
    @Size(min = 10, max = 255, message = "Shipping address must be between 10 and 255 characters")
    @Pattern(regexp = "^[a-zA-Z0-9\\s\\-.,#/]+$", message = "Shipping address can only contain letters, numbers, spaces, hyphens, periods, commas, hash, and forward slash")
    @Column(name = "shipping_address", length = 255)
    private String shippingAddress;

    @Column(name = "order_date")
    private LocalDateTime orderDate = LocalDateTime.now();

    @Column(name = "payment_date")
    private LocalDateTime paymentDate;

    @NotBlank(message = "Payment method is required")
    @Pattern(regexp = "^(CREDIT_CARD|DEBIT_CARD|CASH_ON_DELIVERY|PAYPAL|BANK_TRANSFER)$", 
             message = "Payment method must be one of: CREDIT_CARD, DEBIT_CARD, CASH_ON_DELIVERY, PAYPAL, BANK_TRANSFER")
    @Column(name = "payment_method", length = 50)
    private String paymentMethod;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status")
    private PaymentStatus paymentStatus = PaymentStatus.Pending;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private OrderStatus status = OrderStatus.Pending;

    @NotNull(message = "Total amount is required")
    @DecimalMin(value = "0.01", message = "Total amount must be greater than 0")
    @DecimalMax(value = "99999.99", message = "Total amount cannot exceed $99,999.99")
    @Digits(integer = 5, fraction = 2, message = "Total amount must have at most 5 integer digits and 2 decimal places")
    @Column(name = "total_amount", precision = 10, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "transaction_id", length = 100)
    private String transactionId;

    @Size(max = 1000, message = "Order notes cannot exceed 1000 characters")
    @Column(name = "order_notes", columnDefinition = "TEXT")
    private String orderNotes;

    // Tracking fields
    @Column(name = "tracking_number", length = 100)
    private String trackingNumber;

    @Column(name = "estimated_delivery")
    private LocalDateTime estimatedDelivery;

    @Column(name = "last_updated")
    private LocalDateTime lastUpdated = LocalDateTime.now();

    // Date fields for JSP compatibility (not persisted)
    @Transient
    private Date orderDateAsDate;
    
    @Transient
    private Date paymentDateAsDate;
    
    @Transient
    private Date estimatedDeliveryAsDate;
    
    @Transient
    private Date lastUpdatedAsDate;

    // Order details removed from model to avoid dependency on order_details table

    // Enums for status fields
    public enum PaymentStatus {
        Pending, Paid, Failed, Refunded
    }

    public enum OrderStatus {
        Pending, Processing, Shipped, In_Transit, Out_for_Delivery, Delivered, Cancelled, Returned
    }

    // Helper methods
    public boolean isPaid() {
        return paymentStatus == PaymentStatus.Paid;
    }

    public boolean isDelivered() {
        return status == OrderStatus.Delivered;
    }

    public boolean canBeCancelled() {
        return status == OrderStatus.Pending || status == OrderStatus.Processing;
    }

    // Getter methods for JSP property access
    public boolean getCanBeCancelled() {
        return canBeCancelled();
    }

    public boolean getIsPaid() {
        return isPaid();
    }

    public boolean getIsDelivered() {
        return isDelivered();
    }

    public String getStatusDisplayName() {
        return status.name().replace("_", " ");
    }

    public String getPaymentStatusDisplayName() {
        return paymentStatus.name().replace("_", " ");
    }

    // Helper method to update last updated timestamp
    public void updateLastUpdated() {
        this.lastUpdated = LocalDateTime.now();
    }

    // Date conversion methods for JSP compatibility
    public Date getOrderDateAsDate() {
        if (orderDate == null) return null;
        return Date.from(orderDate.atZone(ZoneId.systemDefault()).toInstant());
    }

    public Date getPaymentDateAsDate() {
        if (paymentDate == null) return null;
        return Date.from(paymentDate.atZone(ZoneId.systemDefault()).toInstant());
    }

    public Date getEstimatedDeliveryAsDate() {
        if (estimatedDelivery == null) return null;
        return Date.from(estimatedDelivery.atZone(ZoneId.systemDefault()).toInstant());
    }

    public Date getLastUpdatedAsDate() {
        if (lastUpdated == null) return null;
        return Date.from(lastUpdated.atZone(ZoneId.systemDefault()).toInstant());
    }

    // Custom validation method for business logic
    public void validate() {
        if (billingAddress == null || billingAddress.trim().length() < 10) {
            throw new IllegalArgumentException("Billing address must be at least 10 characters long");
        }
        if (shippingAddress == null || shippingAddress.trim().length() < 10) {
            throw new IllegalArgumentException("Shipping address must be at least 10 characters long");
        }
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            throw new IllegalArgumentException("Payment method is required");
        }
        if (!paymentMethod.matches("^(CREDIT_CARD|DEBIT_CARD|CASH_ON_DELIVERY|PAYPAL|BANK_TRANSFER)$")) {
            throw new IllegalArgumentException("Invalid payment method");
        }
        if (totalAmount == null || totalAmount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Total amount must be greater than 0");
        }
        if (totalAmount.compareTo(new BigDecimal("99999.99")) > 0) {
            throw new IllegalArgumentException("Total amount cannot exceed $99,999.99");
        }
        if (orderNotes != null && orderNotes.length() > 1000) {
            throw new IllegalArgumentException("Order notes cannot exceed 1000 characters");
        }
        if (customer == null) {
            throw new IllegalArgumentException("Customer is required");
        }
    }
}
