package com.project.bookStore_backend.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "book")
@Getter
@Setter
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long bid;

    @NotBlank(message = "Book title is required")
    @Size(min = 2, max = 200, message = "Title must be between 2 and 200 characters")
    @Pattern(regexp = "^[a-zA-Z0-9\\s\\-_&().,!?]+$", message = "Title can only contain letters, numbers, spaces, hyphens, underscores, ampersands, parentheses, periods, commas, exclamation marks, and question marks")
    @Column(nullable = false, length = 200)
    private String title;

    @NotBlank(message = "Author name is required")
    @Size(min = 2, max = 100, message = "Author name must be between 2 and 100 characters")
    @Pattern(regexp = "^[a-zA-Z\\s\\-.,]+$", message = "Author name can only contain letters, spaces, hyphens, periods, and commas")
    @Column(length = 100)
    private String author;

    @NotBlank(message = "Genre is required")
    @Size(min = 2, max = 50, message = "Genre must be between 2 and 50 characters")
    @Pattern(regexp = "^[a-zA-Z\\s\\-&]+$", message = "Genre can only contain letters, spaces, hyphens, and ampersands")
    @Column(length = 50)
    private String genre;

    @NotNull(message = "Price is required")
    @DecimalMin(value = "0.01", message = "Price must be greater than 0")
    @DecimalMax(value = "9999.99", message = "Price cannot exceed $9999.99")
    @Column(nullable = false)
    private Double price;

    @NotNull(message = "Stock quantity is required")
    @Min(value = 0, message = "Stock cannot be negative")
    @Max(value = 9999, message = "Stock cannot exceed 9999")
    private Integer stock;

    @Size(max = 2000, message = "Description cannot exceed 2000 characters")
    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "publication_date")
    private LocalDate publicationDate;

    @Pattern(regexp = "^(?:ISBN(?:-1[03])?:? )?(?=[0-9X]{10}$|(?=(?:[0-9]+[- ]){3})[- 0-9X]{13}$|97[89][0-9]{10}$|(?=(?:[0-9]+[- ]){4})[- 0-9]{17}$)(?:97[89][- ]?)?[0-9]{1,5}[- ]?[0-9]+[- ]?[0-9]+[- ]?[0-9X]$", 
             message = "Invalid ISBN format. Use format like: 978-0-123456-78-9 or 1234567890")
    @Column(name = "isbn", length = 20)
    private String isbn;

    @Pattern(regexp = "^(https?://)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([/\\w \\.-]*)*/?$", 
             message = "Invalid URL format. Must be a valid HTTP/HTTPS URL")
    @Size(max = 500, message = "Image URL cannot exceed 500 characters")
    @Column(name = "image_url", length = 500)
    private String imageUrl;

    @Column(name = "rating")
    private Double rating = 0.0;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    // One book → many order details
    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL)
    private List<OrderDetails> orderDetails;

    // Helper method to check if book is in stock
    public boolean isInStock() {
        return stock != null && stock > 0;
    }

    // Helper method to get stock status message
    public String getStockStatus() {
        if (stock == null || stock <= 0) {
            return "Out of Stock";
        } else if (stock <= 5) {
            return "Only " + stock + " left in stock";
        } else {
            return "In Stock";
        }
    }

    // Custom validation method for business logic
    public void validate() {
        if (title != null && title.trim().length() < 2) {
            throw new IllegalArgumentException("Book title must be at least 2 characters long");
        }
        
        if (author != null && author.trim().length() < 2) {
            throw new IllegalArgumentException("Author name must be at least 2 characters long");
        }
        
        if (genre != null && genre.trim().length() < 2) {
            throw new IllegalArgumentException("Genre must be at least 2 characters long");
        }
        
        if (price != null && price <= 0) {
            throw new IllegalArgumentException("Price must be greater than 0");
        }
        
        if (stock != null && stock < 0) {
            throw new IllegalArgumentException("Stock cannot be negative");
        }
        
        if (description != null && description.length() > 2000) {
            throw new IllegalArgumentException("Description cannot exceed 2000 characters");
        }
        
        if (publicationDate != null && publicationDate.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("Publication date cannot be in the future");
        }
        
        // Validate ISBN format if provided
        if (isbn != null && !isbn.trim().isEmpty()) {
            String cleanIsbn = isbn.replaceAll("[^0-9X]", "");
            if (cleanIsbn.length() != 10 && cleanIsbn.length() != 13) {
                throw new IllegalArgumentException("ISBN must be either 10 or 13 digits");
            }
        }
        
        // Validate image URL format if provided
        if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            if (!imageUrl.matches("^(https?://)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([/\\w \\.-]*)*/?$")) {
                throw new IllegalArgumentException("Invalid image URL format");
            }
        }
    }
}
