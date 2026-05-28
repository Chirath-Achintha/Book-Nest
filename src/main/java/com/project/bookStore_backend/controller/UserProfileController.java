package com.project.bookStore_backend.controller;

import com.project.bookStore_backend.model.RegisteredCustomer;
import com.project.bookStore_backend.service.OrderService;
import com.project.bookStore_backend.service.UserService;
import com.project.bookStore_backend.util.SessionUtils;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/profile")
public class UserProfileController {

    @Autowired
    private UserService userService;

    @Autowired
    private OrderService orderService;

    private boolean ensureCustomer(HttpSession session) {
        return SessionUtils.isCustomerLoggedIn(session);
    }

    @GetMapping("")
    public String viewProfile(HttpSession session, Model model) {
        if (!ensureCustomer(session)) {
            return "redirect:/login?error=login_required";
        }
        Long customerId = SessionUtils.getCurrentCustomerId(session);
        RegisteredCustomer user = userService.getCustomerById(customerId).orElse(null);
        model.addAttribute("user", user);
        model.addAttribute("orders", orderService.getCustomerOrders(customerId));
        return "profile";
    }

    @GetMapping("/edit")
    public String editProfileForm(HttpSession session, Model model) {
        if (!ensureCustomer(session)) {
            return "redirect:/login?error=login_required";
        }
        Long customerId = SessionUtils.getCurrentCustomerId(session);
        RegisteredCustomer user = userService.getCustomerById(customerId).orElse(null);
        model.addAttribute("user", user);
        return "editProfile";
    }

    @PostMapping("/update")
    public String updateProfile(@RequestParam(required = false) String username,
                                @RequestParam(required = false) String email,
                                @RequestParam(required = false) String phone,
                                @RequestParam(required = false) String address,
                                HttpSession session) {
        if (!ensureCustomer(session)) {
            return "redirect:/login?error=login_required";
        }
        Long customerId = SessionUtils.getCurrentCustomerId(session);
        try {
            userService.updateProfile(customerId, username, email, phone, address);
            // If username changed, refresh session username
            if (username != null && !username.isBlank()) {
                session.setAttribute(SessionUtils.CUSTOMER_USERNAME_KEY, username.trim());
            }
            return "redirect:/profile?success=profile_updated";
        } catch (IllegalArgumentException e) {
            return "redirect:/profile/edit?error=" + e.getMessage();
        } catch (Exception e) {
            return "redirect:/profile/edit?error=update_failed";
        }
    }

    @GetMapping("/change-password")
    public String changePasswordForm(HttpSession session) {
        if (!ensureCustomer(session)) {
            return "redirect:/login?error=login_required";
        }
        return "changePassword";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam String oldPassword,
                                 @RequestParam String newPassword,
                                 HttpSession session) {
        if (!ensureCustomer(session)) {
            return "redirect:/login?error=login_required";
        }
        Long customerId = SessionUtils.getCurrentCustomerId(session);
        try {
            userService.changePassword(customerId, oldPassword, newPassword);
            return "redirect:/profile?success=password_changed";
        } catch (IllegalArgumentException e) {
            return "redirect:/profile/change-password?error=" + e.getMessage();
        } catch (Exception e) {
            return "redirect:/profile/change-password?error=change_failed";
        }
    }
}


