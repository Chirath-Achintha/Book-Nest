package com.project.bookStore_backend.controller;

import com.project.bookStore_backend.model.CartItem;
import com.project.bookStore_backend.service.CartService;
import com.project.bookStore_backend.util.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    /**
     * View cart page
     */
    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        if (!SessionUtils.isCustomerLoggedIn(session)) {
            return "redirect:/login";
        }

        Long customerId = SessionUtils.getCurrentUserId(session);
        List<CartItem> cartItems = cartService.getCartItems(customerId);
        Double cartTotal = cartService.getCartTotal(customerId);
        Integer itemCount = cartService.getCartItemCount(customerId);

        model.addAttribute("cartItems", cartItems);
        model.addAttribute("cartTotal", cartTotal);
        model.addAttribute("itemCount", itemCount);
        model.addAttribute("isEmpty", cartItems.isEmpty());

        return "cart";
    }

    /**
     * Add item to cart
     */
    @PostMapping("/add")
    public String addToCart(@RequestParam Long bookId, 
                           @RequestParam(defaultValue = "1") Integer quantity,
                           HttpSession session, 
                           RedirectAttributes redirectAttributes) {
        // Check if user is logged in
        if (!SessionUtils.isCustomerLoggedIn(session)) {
            // Store the intended action in session for after login
            session.setAttribute("pendingCartAction", "add");
            session.setAttribute("pendingBookId", bookId);
            session.setAttribute("pendingQuantity", quantity);
            return "redirect:/login?redirect=cart";
        }

        // Input validation
        if (bookId == null || bookId <= 0) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid book ID");
            return "redirect:/cart";
        }
        if (quantity == null || quantity < 1) {
            redirectAttributes.addFlashAttribute("errorMessage", "Quantity must be at least 1");
            return "redirect:/cart";
        }
        if (quantity > 99) {
            redirectAttributes.addFlashAttribute("errorMessage", "Quantity cannot exceed 99");
            return "redirect:/cart";
        }

        Long customerId = SessionUtils.getCurrentUserId(session);
        boolean success = cartService.addToCart(customerId, bookId, quantity);
        
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage", "Item added to cart successfully!");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to add item to cart. Check stock availability.");
        }

        return "redirect:/cart";
    }

    /**
     * Update cart item quantity
     */
    @PostMapping("/update")
    public String updateQuantity(@RequestParam Long bookId, 
                                @RequestParam Integer quantity,
                                HttpSession session, 
                                RedirectAttributes redirectAttributes) {
        if (!SessionUtils.isCustomerLoggedIn(session)) {
            return "redirect:/login";
        }

        // Input validation
        if (bookId == null || bookId <= 0) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid book ID");
            return "redirect:/cart";
        }
        if (quantity == null || quantity < 1) {
            redirectAttributes.addFlashAttribute("errorMessage", "Quantity must be at least 1");
            return "redirect:/cart";
        }
        if (quantity > 99) {
            redirectAttributes.addFlashAttribute("errorMessage", "Quantity cannot exceed 99");
            return "redirect:/cart";
        }

        Long customerId = SessionUtils.getCurrentUserId(session);
        boolean success = cartService.updateCartItemQuantity(customerId, bookId, quantity);
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage", "Cart updated successfully!");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to update cart. Check stock availability.");
        }

        return "redirect:/cart";
    }

    /**
     * Remove item from cart
     */
    @PostMapping("/remove")
    public String removeFromCart(@RequestParam Long bookId, 
                                HttpSession session, 
                                RedirectAttributes redirectAttributes) {
        if (!SessionUtils.isCustomerLoggedIn(session)) {
            return "redirect:/login";
        }

        // Input validation
        if (bookId == null || bookId <= 0) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid book ID");
            return "redirect:/cart";
        }

        Long customerId = SessionUtils.getCurrentUserId(session);
        boolean success = cartService.removeFromCart(customerId, bookId);
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage", "Item removed from cart!");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to remove item from cart.");
        }

        return "redirect:/cart";
    }

    /**
     * Clear entire cart
     */
    @PostMapping("/clear")
    public String clearCart(HttpSession session, RedirectAttributes redirectAttributes) {
        if (!SessionUtils.isCustomerLoggedIn(session)) {
            return "redirect:/login";
        }

        Long customerId = SessionUtils.getCurrentUserId(session);
        boolean success = cartService.clearCart(customerId);
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage", "Cart cleared successfully!");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to clear cart.");
        }

        return "redirect:/cart";
    }

    /**
     * Get cart item count (AJAX endpoint)
     */
    @GetMapping("/count")
    @ResponseBody
    public Integer getCartItemCount(HttpSession session) {
        if (!SessionUtils.isCustomerLoggedIn(session)) {
            return 0;
        }
        Long customerId = SessionUtils.getCurrentUserId(session);
        return cartService.getCartItemCount(customerId);
    }

    /**
     * Handle pending cart action after login
     */
    @GetMapping("/handle-pending")
    public String handlePendingCartAction(HttpSession session, RedirectAttributes redirectAttributes) {
        if (!SessionUtils.isCustomerLoggedIn(session)) {
            return "redirect:/login";
        }

        String pendingAction = (String) session.getAttribute("pendingCartAction");
        if ("add".equals(pendingAction)) {
            Long bookId = (Long) session.getAttribute("pendingBookId");
            Integer quantity = (Integer) session.getAttribute("pendingQuantity");
            
            if (bookId != null && quantity != null) {
                Long customerId = SessionUtils.getCurrentUserId(session);
                boolean success = cartService.addToCart(customerId, bookId, quantity);
                
                if (success) {
                    redirectAttributes.addFlashAttribute("successMessage", "Item added to cart successfully!");
                } else {
                    redirectAttributes.addFlashAttribute("errorMessage", "Failed to add item to cart. Check stock availability.");
                }
                
                // Clear pending action
                session.removeAttribute("pendingCartAction");
                session.removeAttribute("pendingBookId");
                session.removeAttribute("pendingQuantity");
            }
        }
        
        return "redirect:/cart";
    }
}
