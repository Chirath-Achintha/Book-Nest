package com.project.bookStore_backend.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

@Entity
@Table(name = "discount")
@Getter
@Setter
public class Discount {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "dis_id")
    private Long disId;

    @NotBlank(message = "Discount name is required")
    @Size(min = 2, max = 100, message = "Discount name must be between 2 and 100 characters")
    @Pattern(regexp = "^[a-zA-Z0-9\\s\\-_&()]+$", message = "Discount name can only contain letters, numbers, spaces, hyphens, underscores, ampersands, and parentheses")
    @Column(name = "dname", nullable = false, length = 100)
    private String dname;

    public enum DiscountType { PERCENTAGE, FLAT }

    @Enumerated(EnumType.STRING)
    @Column(name = "dtype", nullable = false)
    private DiscountType dtype;

    @NotNull(message = "Percentage is required")
    @DecimalMin(value = "0.01", message = "Percentage must be greater than 0")
    @DecimalMax(value = "100.00", message = "Percentage cannot exceed 100%")
    @Digits(integer = 3, fraction = 2, message = "Percentage must have at most 3 integer digits and 2 decimal places")
    @Column(name = "percentage", precision = 5, scale = 2)
    private java.math.BigDecimal percentage;

    @NotNull(message = "Start date is required")
    @Future(message = "Start date must be in the future")
    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @NotNull(message = "End date is required")
    @Column(name = "end_date", nullable = false)
    private LocalDate endDate;

    public enum DiscountStatus { ACTIVE, EXPIRED, UPCOMING }

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private DiscountStatus status = DiscountStatus.UPCOMING;

    public void recomputeStatus(LocalDate today) {
        if (today == null) today = LocalDate.now();
        if (today.isBefore(startDate)) {
            status = DiscountStatus.UPCOMING;
        } else if ((today.isEqual(startDate) || today.isAfter(startDate)) && (today.isEqual(endDate) || today.isBefore(endDate))) {
            status = DiscountStatus.ACTIVE;
        } else {
            status = DiscountStatus.EXPIRED;
        }
    }

    // Custom validation method
    public void validate() {
        if (startDate != null && endDate != null && endDate.isBefore(startDate)) {
            throw new IllegalArgumentException("End date cannot be before start date");
        }
        
        if (dtype == DiscountType.PERCENTAGE && (percentage == null || percentage.compareTo(java.math.BigDecimal.ZERO) <= 0)) {
            throw new IllegalArgumentException("Percentage must be greater than 0 for percentage discounts");
        }
        
        if (dtype == DiscountType.FLAT && (percentage == null || percentage.compareTo(java.math.BigDecimal.ZERO) <= 0)) {
            throw new IllegalArgumentException("Flat amount must be greater than 0 for flat discounts");
        }
    }

    // Date conversion methods for JSP compatibility
    public Date getStartDateAsDate() {
        if (startDate == null) return null;
        return Date.from(startDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
    }

    public Date getEndDateAsDate() {
        if (endDate == null) return null;
        return Date.from(endDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
    }
}
