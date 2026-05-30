package com.project.bookStore_backend.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "cart")
@Getter
@Setter
public class CartItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Link to customer
    @ManyToOne
    @JoinColumn(name = "cid", nullable = false)
    private Customer customer;

    // Link to book
    @ManyToOne
    @JoinColumn(name = "bid", nullable = false)
    private Book book;

    @NotNull(message = "Quantity is required")
    @Min(value = 1, message = "Quantity must be at least 1")
    @Max(value = 99, message = "Quantity cannot exceed 99")
    @Column(nullable = false)
    private Integer quantity = 1;

    @Column(name = "added_at", insertable = false, updatable = false)
    private java.sql.Timestamp addedAt;

    // Custom validation method for business logic
    public void validate() {
        if (quantity == null || quantity < 1) {
            throw new IllegalArgumentException("Quantity must be at least 1");
        }
        if (quantity > 99) {
            throw new IllegalArgumentException("Quantity cannot exceed 99");
        }
        if (customer == null) {
            throw new IllegalArgumentException("Customer is required");
        }
        if (book == null) {
            throw new IllegalArgumentException("Book is required");
        }
        if (book.getStock() != null && quantity > book.getStock()) {
            throw new IllegalArgumentException("Quantity cannot exceed available stock");
        }
    }
}
