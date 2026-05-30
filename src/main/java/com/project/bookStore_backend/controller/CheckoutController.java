package com.project.bookStore_backend.controller;

import com.project.bookStore_backend.model.Orders;
import com.project.bookStore_backend.service.OrderService;
import com.project.bookStore_backend.util.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;

@Controller
public class CheckoutController {

    @Autowired
    private OrderService orderService;

    // Show checkout page (direct mapping)
    @GetMapping("/checkout")
    public String showCheckoutPage(HttpSession session, Model model) {
        Long customerId = SessionUtils.getCurrentCustomerId(session);
        if (customerId == null) {
            return "redirect:/login?error=login_required";
        }

        // Get customer's cart items for checkout
        // You might want to add a method to get cart items here
        model.addAttribute("orderRequest", new OrderService.OrderRequest());
        return "checkout";
    }

    // Place a new order (checkout)
    @PostMapping("/checkout")
    public String placeOrder(@ModelAttribute OrderService.OrderRequest orderRequest, 
                           HttpSession session, Model model) {
        try {
            Long customerId = SessionUtils.getCurrentCustomerId(session);
            if (customerId == null) {
                return "redirect:/login?error=login_required";
            }

            // Input validation
            if (orderRequest.getBillingAddress() == null || orderRequest.getBillingAddress().trim().isEmpty()) {
                return "redirect:/checkout?error=billing_address_required";
            }
            if (orderRequest.getBillingAddress().trim().length() < 10) {
                return "redirect:/checkout?error=billing_address_length";
            }
            if (!orderRequest.getBillingAddress().matches("^[a-zA-Z0-9\\s\\-.,#/]+$")) {
                return "redirect:/checkout?error=billing_address_invalid";
            }

            if (orderRequest.getShippingAddress() == null || orderRequest.getShippingAddress().trim().isEmpty()) {
                return "redirect:/checkout?error=shipping_address_required";
            }
            if (orderRequest.getShippingAddress().trim().length() < 10) {
                return "redirect:/checkout?error=shipping_address_length";
            }
            if (!orderRequest.getShippingAddress().matches("^[a-zA-Z0-9\\s\\-.,#/]+$")) {
                return "redirect:/checkout?error=shipping_address_invalid";
            }

            if (orderRequest.getPaymentMethod() == null || orderRequest.getPaymentMethod().trim().isEmpty()) {
                return "redirect:/checkout?error=payment_method_required";
            }
            if (!orderRequest.getPaymentMethod().matches("^(CREDIT_CARD|DEBIT_CARD|CASH_ON_DELIVERY|PAYPAL|BANK_TRANSFER)$")) {
                return "redirect:/checkout?error=payment_method_invalid";
            }

            if (orderRequest.getOrderNotes() != null && orderRequest.getOrderNotes().length() > 1000) {
                return "redirect:/checkout?error=order_notes_length";
            }

            Orders order = orderService.placeOrderFromCart(customerId, orderRequest);
            // Redirect to payment page to process payment
            return "redirect:/payment/" + order.getOid();
        } catch (IllegalArgumentException e) {
            System.err.println("Validation error: " + e.getMessage());
            return "redirect:/checkout?error=validation_failed";
        } catch (Exception e) {
            System.err.println("Order placement error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/cart?error=order_failed";
        }
    }
}