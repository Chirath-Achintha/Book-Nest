package com.project.bookStore_backend.repository;

import com.project.bookStore_backend.model.RegisteredCustomer;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface RegisteredCustomerRepository extends JpaRepository<RegisteredCustomer, Long> {
    Optional<RegisteredCustomer> findByUsername(String username);
    Optional<RegisteredCustomer> findByEmail(String email);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    List<RegisteredCustomer> findByUsernameContainingIgnoreCaseOrEmailContainingIgnoreCase(String username, String email);
    List<RegisteredCustomer> findByRole(String role);
}
