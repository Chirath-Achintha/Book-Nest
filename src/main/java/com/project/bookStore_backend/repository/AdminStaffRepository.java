package com.project.bookStore_backend.repository;

import com.project.bookStore_backend.model.AdminStaff;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AdminStaffRepository extends JpaRepository<AdminStaff, Long> {
    
    // Find admin by username
    Optional<AdminStaff> findByUsername(String username);
    
    // Find admin by username and active status
    Optional<AdminStaff> findByUsernameAndIsActiveTrue(String username);
    
    // Find admin by email
    Optional<AdminStaff> findByEmail(String email);
    
    // Find admin by email and active status
    Optional<AdminStaff> findByEmailAndIsActiveTrue(String email);
    
    // Find all active admins
    List<AdminStaff> findByIsActiveTrue();
    
    // Find admins by role
    List<AdminStaff> findByRole(String role);
    
    // Find active admins by role
    List<AdminStaff> findByRoleAndIsActiveTrue(String role);
    
    // Check if username exists
    boolean existsByUsername(String username);
    
    // Check if email exists
    boolean existsByEmail(String email);
    
    // Find admins by name (case insensitive)
    @Query("SELECT a FROM AdminStaff a WHERE LOWER(a.name) LIKE LOWER(CONCAT('%', :name, '%')) AND a.isActive = true")
    List<AdminStaff> findByNameContainingIgnoreCase(@Param("name") String name);
    
    // Count active admins
    long countByIsActiveTrue();
    
    // Find admins created after a specific date
    @Query("SELECT a FROM AdminStaff a WHERE a.createdAt >= :date AND a.isActive = true")
    List<AdminStaff> findActiveAdminsCreatedAfter(@Param("date") java.time.LocalDateTime date);
}
