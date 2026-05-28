package com.project.bookStore_backend.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "admin_staff")
@Getter
@Setter
public class AdminStaff {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long adminId;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 100)
    private String email;

    @Column(length = 20)
    private String phone;

    @Column(unique = true, nullable = false, length = 50)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String role = "ADMIN";

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    // Helper method to check if admin is active
    public boolean isActive() {
        return isActive != null && isActive;
    }

    public String getCreatedAtFormatted() {
        return createdAt != null ? createdAt.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : "";
    }
    public String getLastLoginFormatted() {
        return lastLogin != null ? lastLogin.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : "";
    }
}
