package com.project.bookStore_backend.controller;

import com.project.bookStore_backend.model.AdminStaff;
import com.project.bookStore_backend.model.Customer;
import com.project.bookStore_backend.model.RegisteredCustomer;
import com.project.bookStore_backend.repository.CustomerRepository;
import com.project.bookStore_backend.repository.RegisteredCustomerRepository;
import com.project.bookStore_backend.service.AdminAuthService;
import com.project.bookStore_backend.util.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
// Security removed; password encoding disabled for now
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class AuthController {

    @Autowired
    private RegisteredCustomerRepository customerRepo;

    @Autowired
    private CustomerRepository baseCustomerRepo;

    @Autowired
    private AdminAuthService adminAuthService;

    // Hardcoded admin credentials for admin panel login
    private static final String HARDCODED_ADMIN_USERNAME = "admin";
    private static final String HARDCODED_ADMIN_PASSWORD = "admin123";
    private static final String HARDCODED_ADMIN_EMAIL = "admin@booknest.local";

    // PasswordEncoder removed along with Spring Security

    // GET mappings for /login and /register are in HomeController

    @PostMapping("/register")
    @Transactional
    public String registerUser(@ModelAttribute RegisteredCustomer registeredCustomer) {
        try {
            // Check if email already exists
            if (customerRepo.findByEmail(registeredCustomer.getEmail()).isPresent()) {
                return "redirect:/register?error=email_exists";
            }

            // Create base customer row first
            Customer base = new Customer();
            base.setCname(registeredCustomer.getUsername());
            base = baseCustomerRepo.save(base);

            // Create registered customer with proper relationship
            RegisteredCustomer newRegisteredCustomer = new RegisteredCustomer();
            newRegisteredCustomer.setCid(base.getCid());
            newRegisteredCustomer.setUsername(registeredCustomer.getUsername());
            newRegisteredCustomer.setPassword(registeredCustomer.getPassword());
            newRegisteredCustomer.setEmail(registeredCustomer.getEmail());
            newRegisteredCustomer.setPhone(registeredCustomer.getPhone());
            newRegisteredCustomer.setAddress(registeredCustomer.getAddress());
            newRegisteredCustomer.setRole("CUSTOMER");

            // Save the registered customer
            customerRepo.save(newRegisteredCustomer);

            return "redirect:/login?registered";
        } catch (Exception e) {
            // Log the error for debugging
            System.err.println("Registration error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/register?error=database_error";
        }
    }

    // Handle login form submission
    @PostMapping("/login")
    public String loginUser(@RequestParam String email, 
                           @RequestParam String password, 
                           @RequestParam(value = "redirect", required = false) String redirect,
                           HttpSession session) {
        try {
            // First check if it's an admin login
            Optional<AdminStaff> adminOpt = adminAuthService.authenticateAdmin(email, password);

            if (adminOpt.isEmpty()) {
                // Fallback to hardcoded admin credentials
                if ((HARDCODED_ADMIN_USERNAME.equalsIgnoreCase(email) || HARDCODED_ADMIN_EMAIL.equalsIgnoreCase(email))
                        && HARDCODED_ADMIN_PASSWORD.equals(password)) {
                    AdminStaff hardcodedAdmin = new AdminStaff();
                    hardcodedAdmin.setAdminId(null);
                    hardcodedAdmin.setUsername(HARDCODED_ADMIN_USERNAME);
                    hardcodedAdmin.setPassword(HARDCODED_ADMIN_PASSWORD);
                    hardcodedAdmin.setEmail(HARDCODED_ADMIN_EMAIL);
                    hardcodedAdmin.setName("Administrator");
                    hardcodedAdmin.setRole(SessionUtils.ROLE_SUPER_ADMIN);
                    hardcodedAdmin.setIsActive(true);
                    hardcodedAdmin.setCreatedAt(java.time.LocalDateTime.now());
                    hardcodedAdmin.setUpdatedAt(java.time.LocalDateTime.now());
                    adminOpt = Optional.of(hardcodedAdmin);
                }
            }

            if (adminOpt.isPresent()) {
                AdminStaff admin = adminOpt.get();
                
                // Store admin in session using SessionUtils constants
                session.setAttribute(SessionUtils.ADMIN_SESSION_KEY, admin);
                session.setAttribute(SessionUtils.ADMIN_ID_KEY, admin.getAdminId());
                session.setAttribute(SessionUtils.ADMIN_USERNAME_KEY, admin.getUsername());
                session.setAttribute(SessionUtils.ADMIN_ROLE_KEY, admin.getRole());
                session.setAttribute(SessionUtils.ADMIN_NAME_KEY, admin.getName());
                
                return "redirect:/admin/panel?login=success";
            }
            
            // If not admin, check for regular customer
            // First try to find by email
            Optional<RegisteredCustomer> user = customerRepo.findByEmail(email);
            
            // If not found by email, try by username
            if (user.isEmpty()) {
                user = customerRepo.findByUsername(email);
            }
            
            if (user.isPresent() && user.get().getPassword().equals(password)) {
                // Login successful - store user in session using SessionUtils constants
                session.setAttribute(SessionUtils.CUSTOMER_SESSION_KEY, user.get());
                session.setAttribute(SessionUtils.CUSTOMER_ID_KEY, user.get().getCid());
                session.setAttribute(SessionUtils.CUSTOMER_USERNAME_KEY, user.get().getUsername());
                session.setAttribute(SessionUtils.CUSTOMER_ROLE_KEY, user.get().getRole());
                
                // Check if there's a pending cart action
                String pendingAction = (String) session.getAttribute("pendingCartAction");
                if ("add".equals(pendingAction)) {
                    return "redirect:/cart/handle-pending";
                }
                
                // Check if there's a redirect parameter
                if ("cart".equals(redirect)) {
                    return "redirect:/cart";
                }
                
                return "redirect:/?login=success";
            } else {
                // Login failed
                return "redirect:/login?error=invalid_credentials";
            }
        } catch (Exception e) {
            System.err.println("Login error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/login?error=login_failed";
        }
    }

    // Handle logout
    @GetMapping("/logout")
    public String logoutUser(HttpSession session) {
        session.invalidate();
        return "redirect:/?logout=success";
    }

    // Profile routes moved to UserProfileController under /profile/**
}
