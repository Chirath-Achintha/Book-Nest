package com.project.bookStore_backend.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;

@Entity
@Table(name = "order_details")
@Getter
@Setter
public class OrderDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "odid")
    private Long odid;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "oid", nullable = false)
    private Orders order;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "book_id", nullable = false)
    private Book book;

    @Column(nullable = false)
    private Integer quantity;

    @Column(precision = 10, scale = 2)
    private BigDecimal price;

    // Helper method to calculate line total
    public BigDecimal getLineTotal() {
        if (price != null && quantity != null) {
            return price.multiply(BigDecimal.valueOf(quantity));
        }
        return BigDecimal.ZERO;
    }

    // Helper method to get book title
    public String getBookTitle() {
        return book != null ? book.getTitle() : "Unknown Book";
    }

    // Helper method to get book author
    public String getBookAuthor() {
        return book != null ? book.getAuthor() : "Unknown Author";
    }

    // Helper method to get book ISBN
    public String getBookIsbn() {
        return book != null ? book.getIsbn() : "Unknown ISBN";
    }

    // Helper method to get book description
    public String getBookDescription() {
        return book != null ? book.getDescription() : "";
    }
}
