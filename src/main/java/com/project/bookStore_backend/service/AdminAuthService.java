package com.project.bookStore_backend.service;

import com.project.bookStore_backend.model.AdminStaff;
import com.project.bookStore_backend.repository.AdminStaffRepository;
import org.springframework.beans.factory.annotation.Autowired;
// Removed BCrypt import - using plain text passwords
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class AdminAuthService {

    @Autowired
    private AdminStaffRepository adminStaffRepository;

    // Removed BCrypt password encoder - using plain text passwords

    // Authenticate admin with username/email and password
    public Optional<AdminStaff> authenticateAdmin(String usernameOrEmail, String password) {
        try {
            // First try to find by username
            Optional<AdminStaff> adminOpt = adminStaffRepository.findByUsernameAndIsActiveTrue(usernameOrEmail);
            
            // If not found by username, try by email
            if (adminOpt.isEmpty()) {
                adminOpt = adminStaffRepository.findByEmailAndIsActiveTrue(usernameOrEmail);
            }
            
            if (adminOpt.isPresent()) {
                AdminStaff admin = adminOpt.get();
                
                // Verify password using plain text comparison
                if (password.equals(admin.getPassword())) {
                    // Update last login time
                    admin.setLastLogin(LocalDateTime.now());
                    adminStaffRepository.save(admin);
                    
                    return Optional.of(admin);
                }
            }
            
            return Optional.empty();
        } catch (Exception e) {
            System.err.println("Admin authentication error: " + e.getMessage());
            e.printStackTrace();
            return Optional.empty();
        }
    }

    // Create new admin (for super admin use)
    public AdminStaff createAdmin(AdminStaff admin) {
        try {
            // Check if username already exists
            if (adminStaffRepository.existsByUsername(admin.getUsername())) {
                throw new RuntimeException("Username already exists");
            }

            // Check if email already exists (if provided)
            if (admin.getEmail() != null && !admin.getEmail().isEmpty() && 
                adminStaffRepository.existsByEmail(admin.getEmail())) {
                throw new RuntimeException("Email already exists");
            }

            // Store password as plain text (no encoding)
            // admin.setPassword() - password is already plain text
            
            // Set default values
            admin.setIsActive(true);
            admin.setRole(admin.getRole() != null ? admin.getRole() : "ADMIN");
            admin.setCreatedAt(LocalDateTime.now());
            admin.setUpdatedAt(LocalDateTime.now());

            return adminStaffRepository.save(admin);
        } catch (Exception e) {
            System.err.println("Error creating admin: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    // Update admin password
    public boolean updateAdminPassword(Long adminId, String oldPassword, String newPassword) {
        try {
            Optional<AdminStaff> adminOpt = adminStaffRepository.findById(adminId);
            
            if (adminOpt.isPresent()) {
                AdminStaff admin = adminOpt.get();
                
                // Verify old password using plain text comparison
                if (oldPassword.equals(admin.getPassword())) {
                    // Update with new password (plain text)
                    admin.setPassword(newPassword);
                    admin.setUpdatedAt(LocalDateTime.now());
                    adminStaffRepository.save(admin);
                    return true;
                }
            }
            
            return false;
        } catch (Exception e) {
            System.err.println("Error updating admin password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Get admin by ID
    public Optional<AdminStaff> getAdminById(Long adminId) {
        return adminStaffRepository.findById(adminId);
    }

    // Get admin by username
    public Optional<AdminStaff> getAdminByUsername(String username) {
        return adminStaffRepository.findByUsername(username);
    }

    // Get all active admins
    public List<AdminStaff> getAllActiveAdmins() {
        return adminStaffRepository.findByIsActiveTrue();
    }

    // Get admins by role
    public List<AdminStaff> getAdminsByRole(String role) {
        return adminStaffRepository.findByRoleAndIsActiveTrue(role);
    }

    // Deactivate admin
    public boolean deactivateAdmin(Long adminId) {
        try {
            Optional<AdminStaff> adminOpt = adminStaffRepository.findById(adminId);
            
            if (adminOpt.isPresent()) {
                AdminStaff admin = adminOpt.get();
                admin.setIsActive(false);
                admin.setUpdatedAt(LocalDateTime.now());
                adminStaffRepository.save(admin);
                return true;
            }
            
            return false;
        } catch (Exception e) {
            System.err.println("Error deactivating admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Activate admin
    public boolean activateAdmin(Long adminId) {
        try {
            Optional<AdminStaff> adminOpt = adminStaffRepository.findById(adminId);
            
            if (adminOpt.isPresent()) {
                AdminStaff admin = adminOpt.get();
                admin.setIsActive(true);
                admin.setUpdatedAt(LocalDateTime.now());
                adminStaffRepository.save(admin);
                return true;
            }
            
            return false;
        } catch (Exception e) {
            System.err.println("Error activating admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Check if admin exists by username
    public boolean adminExists(String username) {
        return adminStaffRepository.existsByUsername(username);
    }

    // Check if admin exists by email
    public boolean adminEmailExists(String email) {
        return adminStaffRepository.existsByEmail(email);
    }

    // Get admin count
    public long getActiveAdminCount() {
        return adminStaffRepository.countByIsActiveTrue();
    }

    // Search admins by name
    public List<AdminStaff> searchAdminsByName(String name) {
        return adminStaffRepository.findByNameContainingIgnoreCase(name);
    }

    // Update admin profile
    public boolean updateAdminProfile(Long adminId, String name, String email, String phone) {
        try {
            Optional<AdminStaff> adminOpt = adminStaffRepository.findById(adminId);
            
            if (adminOpt.isPresent()) {
                AdminStaff admin = adminOpt.get();
                
                // Check if email is being changed and if it already exists
                if (email != null && !email.isEmpty() && !email.equals(admin.getEmail())) {
                    if (adminStaffRepository.existsByEmail(email)) {
                        throw new RuntimeException("Email already exists");
                    }
                }
                
                admin.setName(name);
                admin.setEmail(email);
                admin.setPhone(phone);
                admin.setUpdatedAt(LocalDateTime.now());
                
                adminStaffRepository.save(admin);
                return true;
            }
            
            return false;
        } catch (Exception e) {
            System.err.println("Error updating admin profile: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
