package com.project.bookStore_backend.service;

import com.project.bookStore_backend.model.RegisteredCustomer;
import com.project.bookStore_backend.repository.RegisteredCustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private RegisteredCustomerRepository customerRepository;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    // Get total customers count
    public long getTotalCustomersCount() {
        return customerRepository.count();
    }

    // Get customers with pagination
    public Page<RegisteredCustomer> getCustomersWithPagination(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return customerRepository.findAll(pageable);
    }

    // Get recent customers
    public List<RegisteredCustomer> getRecentCustomers(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return customerRepository.findAll(pageable).getContent();
    }

    // Get customer by ID
    public Optional<RegisteredCustomer> getCustomerById(Long id) {
        return customerRepository.findById(id);
    }

    // Get customer by username
    public Optional<RegisteredCustomer> getCustomerByUsername(String username) {
        return customerRepository.findByUsername(username);
    }

    // Get customer by email
    public Optional<RegisteredCustomer> getCustomerByEmail(String email) {
        return customerRepository.findByEmail(email);
    }

    // Get customers with pagination and sorting
    public Page<RegisteredCustomer> getCustomersWithPaginationAndSorting(int page, int size, String sortBy, String sortDir) {
        Pageable pageable = PageRequest.of(page, size);
        return customerRepository.findAll(pageable);
    }

    // Search customers by username or email
    public List<RegisteredCustomer> searchCustomers(String searchTerm) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return customerRepository.findAll();
        }
        return customerRepository.findByUsernameContainingIgnoreCaseOrEmailContainingIgnoreCase(
            searchTerm.trim(), searchTerm.trim());
    }

    // Create new user with validation and password encryption
    public RegisteredCustomer createUser(RegisteredCustomer user) {
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new IllegalArgumentException("Username is required");
        }
        if (customerRepository.existsByUsername(user.getUsername().trim())) {
            throw new IllegalArgumentException("Username already exists");
        }
        if (user.getEmail() != null && !user.getEmail().trim().isEmpty()) {
            if (customerRepository.existsByEmail(user.getEmail().trim())) {
                throw new IllegalArgumentException("Email already in use");
            }
        }
        if (user.getPassword() == null || user.getPassword().isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        if (user.getRole() == null || user.getRole().isEmpty()) {
            user.setRole("CUSTOMER");
        }
        return customerRepository.save(user);
    }

    // Update user fields (email, phone, address, role)
    public RegisteredCustomer updateUser(Long id, String email, String phone, String address, String role) {
        RegisteredCustomer existing = customerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        if (email != null) {
            String trimmed = email.trim();
            if (!trimmed.isEmpty()) {
                // If email changed, check uniqueness
                if (!trimmed.equals(existing.getEmail()) && customerRepository.existsByEmail(trimmed)) {
                    throw new IllegalArgumentException("Email already in use");
                }
                existing.setEmail(trimmed);
            } else {
                existing.setEmail(null);
            }
        }
        if (phone != null) existing.setPhone(phone.trim());
        if (address != null) existing.setAddress(address.trim());
        if (role != null && ("CUSTOMER".equals(role) || "ADMIN".equals(role))) {
            existing.setRole(role);
        }
        return customerRepository.save(existing);
    }

    // Change/reset password
    public void changePassword(Long id, String rawPassword) {
        if (rawPassword == null || rawPassword.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters");
        }
        RegisteredCustomer existing = customerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        existing.setPassword(passwordEncoder.encode(rawPassword));
        customerRepository.save(existing);
    }

    // Assign role
    public void assignRole(Long id, String role) {
        if (!"CUSTOMER".equals(role) && !"ADMIN".equals(role)) {
            throw new IllegalArgumentException("Invalid role");
        }
        RegisteredCustomer existing = customerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        existing.setRole(role);
        customerRepository.save(existing);
    }

    // Update profile for given user id (username, email, phone, address)
    public RegisteredCustomer updateProfile(Long id, String username, String email, String phone, String address) {
        RegisteredCustomer existing = customerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (username != null && !username.isBlank()) {
            String newUsername = username.trim();
            if (!newUsername.equals(existing.getUsername()) && customerRepository.existsByUsername(newUsername)) {
                throw new IllegalArgumentException("Username already exists");
            }
            existing.setUsername(newUsername);
        }

        if (email != null) {
            String trimmed = email.trim();
            if (!trimmed.isEmpty()) {
                if (!trimmed.equals(existing.getEmail()) && customerRepository.existsByEmail(trimmed)) {
                    throw new IllegalArgumentException("Email already in use");
                }
                existing.setEmail(trimmed);
            } else {
                existing.setEmail(null);
            }
        }

        if (phone != null) existing.setPhone(phone.trim());
        if (address != null) existing.setAddress(address.trim());

        return customerRepository.save(existing);
    }

    // Change password with old password verification for given user id
    public void changePassword(Long id, String oldPassword, String newPassword) {
        if (newPassword == null || newPassword.length() < 6) {
            throw new IllegalArgumentException("New password must be at least 6 characters");
        }
        RegisteredCustomer existing = customerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (oldPassword == null || !passwordEncoder.matches(oldPassword, existing.getPassword())) {
            throw new IllegalArgumentException("Old password is incorrect");
        }

        existing.setPassword(passwordEncoder.encode(newPassword));
        customerRepository.save(existing);
    }

    // Deactivate customer
    public boolean deactivateCustomer(Long customerId) {
        try {
            Optional<RegisteredCustomer> customerOpt = customerRepository.findById(customerId);
            if (customerOpt.isPresent()) {
                RegisteredCustomer customer = customerOpt.get();
                // You might need to add an 'active' field to the model
                customerRepository.delete(customer);
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("Error deactivating customer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Delete customer
    public boolean deleteCustomer(Long customerId) {
        try {
            if (customerRepository.existsById(customerId)) {
                customerRepository.deleteById(customerId);
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("Error deleting customer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Get customers count by role
    public long getCustomersCountByRole(String role) {
        return customerRepository.findAll().stream()
                .filter(customer -> role.equals(customer.getRole()))
                .count();
    }
}
