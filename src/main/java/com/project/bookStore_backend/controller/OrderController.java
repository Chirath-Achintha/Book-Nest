package com.project.bookStore_backend.controller;

import com.project.bookStore_backend.model.Orders;
import com.project.bookStore_backend.service.OrderService;
import com.project.bookStore_backend.util.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    // Helper method to convert LocalDateTime to Date for JSP compatibility
    private Date convertToDate(LocalDateTime localDateTime) {
        if (localDateTime == null) {
            return null;
        }
        return Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
    }

    // Show checkout page (orders mapping)
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

            Orders order = orderService.placeOrderFromCart(customerId, orderRequest);
            // Redirect to payment page to process payment
            return "redirect:/payment/" + order.getOid();
        } catch (Exception e) {
            model.addAttribute("error", "Failed to place order: " + e.getMessage());
            return "redirect:/cart?error=order_failed";
        }
    }

    // Show order confirmation page
    @GetMapping("/confirmation/{orderId}")
    public String orderConfirmation(@PathVariable Long orderId, Model model, HttpSession session) {
        Long customerId = SessionUtils.getCurrentCustomerId(session);
        if (customerId == null) {
            return "redirect:/login";
        }

        Optional<Orders> orderOpt = orderService.getOrderById(orderId);
        if (orderOpt.isPresent()) {
            Orders order = orderOpt.get();
            // Verify the order belongs to the current customer
            if (order.getCustomer().getCid().equals(customerId)) {
                model.addAttribute("order", order);
                model.addAttribute("orderDetails", orderService.getOrderDetails(orderId));
                return "orderConfirmation";
            }
        }
        return "redirect:/profile?error=order_not_found";
    }


    // View specific order details
    @GetMapping("/details/{orderId}")
    public String orderDetails(@PathVariable Long orderId, Model model, HttpSession session) {
        Long customerId = SessionUtils.getCurrentCustomerId(session);
        if (customerId == null) {
            return "redirect:/login";
        }

        Optional<Orders> orderOpt = orderService.getOrderById(orderId);
        if (orderOpt.isPresent()) {
            Orders order = orderOpt.get();
            // Verify the order belongs to the current customer
            if (order.getCustomer().getCid().equals(customerId)) {
                model.addAttribute("order", order);
                model.addAttribute("orderDetails", orderService.getOrderDetails(orderId));
                
                // Convert LocalDateTime to Date for JSP compatibility
                model.addAttribute("orderDate", convertToDate(order.getOrderDate()));
                model.addAttribute("paymentDate", convertToDate(order.getPaymentDate()));
                model.addAttribute("estimatedDelivery", convertToDate(order.getEstimatedDelivery()));
                model.addAttribute("lastUpdated", convertToDate(order.getLastUpdated()));
                
                return "orderDetails";
            }
        }
        return "redirect:/profile?error=order_not_found";
    }

    // View order details with tracking information
    @GetMapping("/tracking/{orderId}")
    public String orderTracking(@PathVariable Long orderId, Model model, HttpSession session) {
        Long customerId = SessionUtils.getCurrentCustomerId(session);
        if (customerId == null) {
            return "redirect:/login";
        }

        Optional<Orders> orderOpt = orderService.getOrderById(orderId);
        if (orderOpt.isPresent()) {
            Orders order = orderOpt.get();
            // Verify the order belongs to the current customer
            if (order.getCustomer().getCid().equals(customerId)) {
                model.addAttribute("order", order);
                model.addAttribute("orderDetails", orderService.getOrderDetails(orderId));
                
                // Convert LocalDateTime to Date for JSP compatibility
                model.addAttribute("orderDate", convertToDate(order.getOrderDate()));
                model.addAttribute("paymentDate", convertToDate(order.getPaymentDate()));
                model.addAttribute("estimatedDelivery", convertToDate(order.getEstimatedDelivery()));
                model.addAttribute("lastUpdated", convertToDate(order.getLastUpdated()));
                
                return "trackOrder";
            }
        }
        return "redirect:/profile?error=order_not_found";
    }

    // Track order by tracking number
    @GetMapping("/track")
    public String trackOrder(@RequestParam String trackingNumber, Model model) {
        Optional<Orders> orderOpt = orderService.trackOrder(trackingNumber);
        if (orderOpt.isPresent()) {
            Orders order = orderOpt.get();
            model.addAttribute("order", order);
            model.addAttribute("orderDetails", orderService.getOrderDetails(order.getOid()));
            
            // Convert LocalDateTime to Date for JSP compatibility
            model.addAttribute("orderDate", convertToDate(order.getOrderDate()));
            model.addAttribute("paymentDate", convertToDate(order.getPaymentDate()));
            model.addAttribute("estimatedDelivery", convertToDate(order.getEstimatedDelivery()));
            model.addAttribute("lastUpdated", convertToDate(order.getLastUpdated()));
            
            return "trackOrder";
        } else {
            model.addAttribute("error", "Order not found with tracking number: " + trackingNumber);
            return "trackOrder";
        }
    }

    // Show tracking page
    @GetMapping("/tracking")
    public String showTrackPage() {
        return "trackOrder";
    }

    // Cancel order (customer)
    @PostMapping("/cancel/{orderId}")
    public String cancelOrder(@PathVariable Long orderId, HttpSession session) {
        Long customerId = SessionUtils.getCurrentCustomerId(session);
        if (customerId == null) {
            return "redirect:/login";
        }

        Optional<Orders> orderOpt = orderService.getOrderById(orderId);
        if (orderOpt.isPresent()) {
            Orders order = orderOpt.get();
            // Verify the order belongs to the current customer
            if (order.getCustomer().getCid().equals(customerId) && order.canBeCancelled()) {
                orderService.updateOrderStatus(orderId, Orders.OrderStatus.Cancelled, null, null);
            }
        }
        return "redirect:/profile";
    }

    // Admin endpoints
    @GetMapping("/admin")
    public String adminOrderManagement(@RequestParam(defaultValue = "0") int page,
                                     @RequestParam(defaultValue = "10") int size,
                                     @RequestParam(required = false) String status,
                                     Model model, HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }

        List<Orders> orders;
        if (status != null && !status.isEmpty()) {
            try {
                Orders.OrderStatus orderStatus = Orders.OrderStatus.valueOf(status.toUpperCase());
                orders = orderService.getOrdersByStatus(orderStatus);
            } catch (IllegalArgumentException e) {
                orders = orderService.getAllOrders();
            }
        } else {
            orders = orderService.getAllOrders();
        }

        model.addAttribute("orders", orders);
        model.addAttribute("orderStatistics", orderService.getOrderStatistics());
        return "admin/manageOrders";
    }

    // Update order status (admin)
    @PostMapping("/admin/{orderId}/status")
    public String updateOrderStatus(@PathVariable Long orderId,
                                  @RequestParam String status,
                                  @RequestParam(required = false) String trackingNumber,
                                  @RequestParam(required = false) String estimatedDelivery,
                                  HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }

        try {
            Orders.OrderStatus orderStatus = Orders.OrderStatus.valueOf(status.toUpperCase());
            LocalDateTime estimatedDeliveryDate = null;
            if (estimatedDelivery != null && !estimatedDelivery.trim().isEmpty()) {
                estimatedDeliveryDate = LocalDateTime.parse(estimatedDelivery);
            }
            
            orderService.updateOrderStatus(orderId, orderStatus, trackingNumber, estimatedDeliveryDate);
        } catch (Exception e) {
            // Handle error
        }
        
        return "redirect:/orders/admin";
    }

    // Update payment status (admin)
    @PostMapping("/admin/{orderId}/payment")
    public String updatePaymentStatus(@PathVariable Long orderId,
                                    @RequestParam String paymentStatus,
                                    @RequestParam(required = false) String transactionId,
                                    HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }

        try {
            Orders.PaymentStatus status = Orders.PaymentStatus.valueOf(paymentStatus.toUpperCase());
            orderService.updatePaymentStatus(orderId, status, transactionId);
        } catch (Exception e) {
            // Handle error
        }
        
        return "redirect:/orders/admin";
    }

    // Delete/Archive order (admin)
    @PostMapping("/admin/{orderId}/delete")
    public String deleteOrder(@PathVariable Long orderId, HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }

        orderService.deleteOrder(orderId);
        return "redirect:/orders/admin";
    }

    // API endpoints for AJAX calls
    @GetMapping("/api/{orderId}")
    @ResponseBody
    public ResponseEntity<Orders> getOrderApi(@PathVariable Long orderId, HttpSession session) {
        Long customerId = SessionUtils.getCurrentCustomerId(session);
        if (customerId == null) {
            return ResponseEntity.status(401).build();
        }

        Optional<Orders> orderOpt = orderService.getOrderById(orderId);
        if (orderOpt.isPresent()) {
            Orders order = orderOpt.get();
            if (order.getCustomer().getCid().equals(customerId)) {
                return ResponseEntity.ok(order);
            }
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/api/statistics")
    @ResponseBody
    public ResponseEntity<OrderService.OrderStatistics> getOrderStatistics(HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return ResponseEntity.status(401).build();
        }
        
        return ResponseEntity.ok(orderService.getOrderStatistics());
    }

    // Download invoice PDF
    @GetMapping("/{orderId}/invoice")
    public ResponseEntity<String> downloadInvoice(@PathVariable Long orderId, HttpSession session) {
        try {
            Long customerId = SessionUtils.getCurrentCustomerId(session);
            if (customerId == null) {
                return ResponseEntity.status(401).build();
            }

            Optional<Orders> orderOpt = orderService.getOrderById(orderId);
            if (orderOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Orders order = orderOpt.get();
            // Verify the order belongs to the current customer
            if (!order.getCustomer().getCid().equals(customerId)) {
                return ResponseEntity.status(403).build();
            }

            // Generate simple text invoice
            String invoiceText = "Invoice for Order #" + orderId + "\n" +
                               "Customer: " + order.getCustomer().getCname() + "\n" +
                               "Order Date: " + order.getOrderDate() + "\n" +
                               "Total Amount: $" + order.getTotalAmount();
            
            return ResponseEntity.ok()
                    .header("Content-Type", "text/plain")
                    .header("Content-Disposition", "attachment; filename=invoice-" + orderId + ".txt")
                    .body(invoiceText);
                    
        } catch (Exception e) {
            System.err.println("Invoice generation error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }
}
