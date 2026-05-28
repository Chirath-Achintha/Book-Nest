package com.project.bookStore_backend.controller;

import com.project.bookStore_backend.model.RegisteredCustomer;
import com.project.bookStore_backend.service.UserService;
import com.project.bookStore_backend.util.SessionUtils;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.constraints.Email;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController {

    @Autowired
    private UserService userService;

    private boolean ensureAdmin(HttpSession session) {
        return SessionUtils.isAdminLoggedIn(session);
    }

    @GetMapping("")
    public String listUsers(@RequestParam(value = "search", required = false) String search,
                            HttpSession session, Model model) {
        if (!ensureAdmin(session)) {
            return "redirect:/admin/login?error=access_denied";
        }
        List<RegisteredCustomer> users = (search != null && !search.isBlank())
                ? userService.searchCustomers(search)
                : userService.getCustomersWithPagination(0, 500).getContent();
        model.addAttribute("users", users);
        model.addAttribute("search", search == null ? "" : search);
        return "admin/userList";
    }

    @GetMapping("/add")
    public String addUserForm(HttpSession session, Model model) {
        if (!ensureAdmin(session)) {
            return "redirect:/admin/login?error=access_denied";
        }
        model.addAttribute("user", new RegisteredCustomer());
        model.addAttribute("roles", List.of("CUSTOMER", "ADMIN"));
        return "admin/userForm";
    }

    @PostMapping("/add")
    public String addUser(@ModelAttribute("user") RegisteredCustomer user,
                          BindingResult bindingResult,
                          HttpSession session, Model model) {
        if (!ensureAdmin(session)) {
            return "redirect:/admin/login?error=access_denied";
        }
        try {
            userService.createUser(user);
            return "redirect:/admin/users?success=user_created";
        } catch (IllegalArgumentException e) {
            bindingResult.reject("error", e.getMessage());
        } catch (Exception e) {
            bindingResult.reject("error", "Failed to create user");
        }
        model.addAttribute("roles", List.of("CUSTOMER", "ADMIN"));
        return "admin/userForm";
    }

    @GetMapping("/edit/{id}")
    public String editUserForm(@PathVariable Long id, HttpSession session, Model model) {
        if (!ensureAdmin(session)) {
            return "redirect:/admin/login?error=access_denied";
        }
        Optional<RegisteredCustomer> existing = userService.getCustomerById(id);
        if (existing.isEmpty()) {
            return "redirect:/admin/users?error=user_not_found";
        }
        model.addAttribute("user", existing.get());
        model.addAttribute("roles", List.of("CUSTOMER", "ADMIN"));
        return "admin/userForm";
    }

    @PostMapping("/edit/{id}")
    public String editUser(@PathVariable Long id,
                           @RequestParam(required = false) @Email String email,
                           @RequestParam(required = false) String phone,
                           @RequestParam(required = false) String address,
                           @RequestParam(required = false) String role,
                           HttpSession session, Model model) {
        if (!ensureAdmin(session)) {
            return "redirect:/admin/login?error=access_denied";
        }
        try {
            userService.updateUser(id, email, phone, address, role);
            return "redirect:/admin/users?success=user_updated";
        } catch (IllegalArgumentException e) {
            return "redirect:/admin/users/edit/" + id + "?error=" + e.getMessage();
        } catch (Exception e) {
            return "redirect:/admin/users/edit/" + id + "?error=update_failed";
        }
    }

    @PostMapping("/password/{id}")
    public String changePassword(@PathVariable Long id, @RequestParam String password,
                                 HttpSession session) {
        if (!ensureAdmin(session)) {
            return "redirect:/admin/login?error=access_denied";
        }
        try {
            userService.changePassword(id, password);
            return "redirect:/admin/users?success=password_changed";
        } catch (Exception e) {
            return "redirect:/admin/users?error=password_change_failed";
        }
    }

    @PostMapping("/delete/{id}")
    public String deleteUser(@PathVariable Long id, HttpSession session) {
        if (!ensureAdmin(session)) {
            return "redirect:/admin/login?error=access_denied";
        }
        boolean ok = userService.deleteCustomer(id);
        return ok ? "redirect:/admin/users?success=user_deleted" : "redirect:/admin/users?error=delete_failed";
    }

    @GetMapping("/view/{id}")
    public String viewUserDetails(@PathVariable Long id, HttpSession session, Model model) {
        if (!ensureAdmin(session)) {
            return "redirect:/admin/login?error=access_denied";
        }
        try {
            System.out.println("Loading user details for user ID: " + id);
            Optional<RegisteredCustomer> existing = userService.getCustomerById(id);
            if (existing.isEmpty()) {
                System.out.println("User not found with ID: " + id);
                return "redirect:/admin/users?error=user_not_found";
            }
            RegisteredCustomer user = existing.get();
            System.out.println("Found user: " + user.getUsername() + " (ID: " + user.getCid() + ")");
            model.addAttribute("user", user);
            return "admin/userDetails";
        } catch (Exception e) {
            System.err.println("Error loading user details: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/users?error=load_failed";
        }
    }

    @GetMapping("/{id}")
    public String userDetails(@PathVariable Long id, HttpSession session, Model model) {
        if (!ensureAdmin(session)) {
            return "redirect:/admin/login?error=access_denied";
        }
        try {
            System.out.println("Loading user details for user ID: " + id);
            Optional<RegisteredCustomer> existing = userService.getCustomerById(id);
            if (existing.isEmpty()) {
                System.out.println("User not found with ID: " + id);
                return "redirect:/admin/users?error=user_not_found";
            }
            RegisteredCustomer user = existing.get();
            System.out.println("Found user: " + user.getUsername() + " (ID: " + user.getCid() + ")");
            model.addAttribute("user", user);
            return "admin/userDetails";
        } catch (Exception e) {
            System.err.println("Error loading user details: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/users?error=load_failed";
        }
    }
}


