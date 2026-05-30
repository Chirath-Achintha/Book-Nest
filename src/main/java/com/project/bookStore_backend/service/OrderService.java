package com.project.bookStore_backend.service;

import com.project.bookStore_backend.model.*;
import com.project.bookStore_backend.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class OrderService {

    @Autowired
    private OrdersRepository ordersRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private CartRepository cartRepository;

    @Autowired(required = false)
    private DiscountService discountService;

    // Place a new order
    public Orders placeOrder(Long customerId, OrderRequest orderRequest) {
        // Get customer
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new RuntimeException("Customer not found"));

        // Create new order
        Orders order = new Orders();
        order.setCustomer(customer);
        order.setBillingAddress(orderRequest.getBillingAddress());
        order.setShippingAddress(orderRequest.getShippingAddress());
        order.setPaymentMethod(orderRequest.getPaymentMethod());
        order.setOrderNotes(orderRequest.getOrderNotes());
        order.setOrderDate(LocalDateTime.now());

        // Calculate total amount
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (OrderItemRequest item : orderRequest.getOrderItems()) {
            Book book = bookRepository.findById(item.getBookId())
                    .orElseThrow(() -> new RuntimeException("Book not found: " + item.getBookId()));
            
            BigDecimal itemTotal = BigDecimal.valueOf(book.getPrice()).multiply(BigDecimal.valueOf(item.getQuantity()));
            totalAmount = totalAmount.add(itemTotal);
        }
        order.setTotalAmount(totalAmount);

        // Save order
        Orders savedOrder = ordersRepository.save(order);

        // Update book stock without saving order_details records
        for (OrderItemRequest item : orderRequest.getOrderItems()) {
            Book book = bookRepository.findById(item.getBookId()).orElse(null);
            if (book != null) {
                book.setStock(book.getStock() - item.getQuantity());
                bookRepository.save(book);
            }
        }

        // Clear customer's cart
        cartRepository.deleteByCustomerCid(customerId);

        return savedOrder;
    }

    // Place order from cart items (without order details - those are saved after payment)
    public Orders placeOrderFromCart(Long customerId, OrderRequest orderRequest) {
        System.out.println("=== PLACING ORDER FROM CART ===");
        System.out.println("Customer ID: " + customerId);
        
        // Input validation
        if (customerId == null || customerId <= 0) {
            throw new IllegalArgumentException("Invalid customer ID");
        }
        if (orderRequest == null) {
            throw new IllegalArgumentException("Order request is required");
        }
        if (orderRequest.getBillingAddress() == null || orderRequest.getBillingAddress().trim().isEmpty()) {
            throw new IllegalArgumentException("Billing address is required");
        }
        if (orderRequest.getBillingAddress().trim().length() < 10) {
            throw new IllegalArgumentException("Billing address must be at least 10 characters long");
        }
        if (orderRequest.getShippingAddress() == null || orderRequest.getShippingAddress().trim().isEmpty()) {
            throw new IllegalArgumentException("Shipping address is required");
        }
        if (orderRequest.getShippingAddress().trim().length() < 10) {
            throw new IllegalArgumentException("Shipping address must be at least 10 characters long");
        }
        if (orderRequest.getPaymentMethod() == null || orderRequest.getPaymentMethod().trim().isEmpty()) {
            throw new IllegalArgumentException("Payment method is required");
        }
        if (!orderRequest.getPaymentMethod().matches("^(CREDIT_CARD|DEBIT_CARD|CASH_ON_DELIVERY|PAYPAL|BANK_TRANSFER)$")) {
            throw new IllegalArgumentException("Invalid payment method");
        }
        if (orderRequest.getOrderNotes() != null && orderRequest.getOrderNotes().length() > 1000) {
            throw new IllegalArgumentException("Order notes cannot exceed 1000 characters");
        }
        
        // Get customer
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new IllegalArgumentException("Customer not found: " + customerId));
        
        System.out.println("Customer found: " + customer.getCname() + " (ID: " + customer.getCid() + ")");

        // Get cart items
        List<CartItem> cartItems = cartRepository.findByCustomerCid(customerId);
        System.out.println("Cart items found: " + cartItems.size());
        
        if (cartItems.isEmpty()) {
            throw new IllegalArgumentException("Cart is empty for customer: " + customerId);
        }

        // Create new order
        Orders order = new Orders();
        order.setCustomer(customer);
        order.setBillingAddress(orderRequest.getBillingAddress());
        order.setShippingAddress(orderRequest.getShippingAddress());
        order.setPaymentMethod(orderRequest.getPaymentMethod());
        order.setOrderNotes(orderRequest.getOrderNotes());
        order.setOrderDate(LocalDateTime.now());
        // Defaults; may be overridden below
        order.setPaymentStatus(Orders.PaymentStatus.Pending);
        order.setStatus(Orders.OrderStatus.Pending);

        // Calculate total amount from cart items
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem cartItem : cartItems) {
            BigDecimal itemTotal = BigDecimal.valueOf(cartItem.getBook().getPrice()).multiply(BigDecimal.valueOf(cartItem.getQuantity()));
            totalAmount = totalAmount.add(itemTotal);
        }
        // Apply active percentage discount if available (first active one)
        try {
            List<com.project.bookStore_backend.model.Discount> active = discountService == null ? java.util.Collections.emptyList() : discountService.getActiveDiscounts();
            if (!active.isEmpty()) {
                java.math.BigDecimal pct = active.get(0).getPercentage();
                if (pct != null && pct.compareTo(java.math.BigDecimal.ZERO) > 0) {
                    java.math.BigDecimal factor = java.math.BigDecimal.ONE.subtract(pct.divide(new java.math.BigDecimal("100")));
                    totalAmount = totalAmount.multiply(factor).setScale(2, java.math.RoundingMode.HALF_UP);
                }
            }
        } catch (Exception ignored) {}
        order.setTotalAmount(totalAmount);

        // Set payment method and keep order pending until payment is processed
        String method = orderRequest.getPaymentMethod() == null ? "" : orderRequest.getPaymentMethod().trim().toUpperCase();
        if (method.isEmpty()) {
            order.setPaymentMethod("CARD");
        } else if ("COD".equals(method) || "CASH_ON_DELIVERY".equals(method) || "CARD".equals(method)) {
            order.setPaymentMethod(method.equals("COD") ? "CASH_ON_DELIVERY" : method);
        } else {
            order.setPaymentMethod("CARD");
        }
        
        // Keep order pending until payment is processed
        order.setPaymentStatus(Orders.PaymentStatus.Pending);
        order.setStatus(Orders.OrderStatus.Pending);

        // Validate order before saving
        order.validate();

        // Save order
        Orders savedOrder = ordersRepository.save(order);
        System.out.println("Order saved with ID: " + savedOrder.getOid());
        System.out.println("Order total: " + savedOrder.getTotalAmount());
        System.out.println("Order status: " + savedOrder.getStatus());
        System.out.println("Payment status: " + savedOrder.getPaymentStatus());

        // Don't update stock or clear cart until payment is confirmed
        // This will be done in processPayment method

        return savedOrder;
    }

    // Note: Payment processing is now handled by PaymentService
    // This method is kept for backward compatibility but should not be used
    @Deprecated
    public Orders processPayment(Long orderId) {
        throw new RuntimeException("Payment processing should be done through PaymentService");
    }

    // Get order by ID
    public Optional<Orders> getOrderById(Long orderId) {
        return ordersRepository.findByIdWithCustomer(orderId);
    }

    // Get customer orders
    public List<Orders> getCustomerOrders(Long customerId) {
        return ordersRepository.findByCustomerCidOrderByOrderDateDesc(customerId);
    }

    // Get customer orders with pagination
    public Page<Orders> getCustomerOrders(Long customerId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return ordersRepository.findByCustomerCidOrderByOrderDateDesc(customerId, pageable);
    }

    // Update order status
    // Update order status - NO VALIDATION AT ALL
    public boolean updateOrderStatus(Long orderId, Orders.OrderStatus status, String trackingNumber, LocalDateTime estimatedDelivery) {
        System.out.println("UPDATING ORDER STATUS - NO VALIDATION");
        
        Optional<Orders> orderOpt = ordersRepository.findById(orderId);
        if (orderOpt.isPresent()) {
            Orders order = orderOpt.get();
            
            // UPDATE EVERYTHING - NO VALIDATION
            order.setStatus(status);
            order.setTrackingNumber(trackingNumber);
            order.setEstimatedDelivery(estimatedDelivery);
            order.updateLastUpdated();
            
            ordersRepository.save(order);
            System.out.println("ORDER STATUS UPDATED - NO VALIDATION");
            return true;
        }
        return false;
    }

    // Update payment status - NO VALIDATION AT ALL
    public boolean updatePaymentStatus(Long orderId, Orders.PaymentStatus paymentStatus, String transactionId) {
        System.out.println("UPDATING PAYMENT STATUS - NO VALIDATION");
        
        Optional<Orders> orderOpt = ordersRepository.findById(orderId);
        if (orderOpt.isPresent()) {
            Orders order = orderOpt.get();
            
            // UPDATE EVERYTHING - NO VALIDATION
            order.setPaymentStatus(paymentStatus);
            order.setTransactionId(transactionId);
            order.updateLastUpdated();
            
            ordersRepository.save(order);
            System.out.println("PAYMENT STATUS UPDATED - NO VALIDATION");
            return true;
        }
        return false;
    }

    // Update order details - NO VALIDATION AT ALL
    public boolean updateOrderDetails(Long orderId, String billingAddress, String shippingAddress, String orderNotes) {
        System.out.println("UPDATING ORDER DETAILS - NO VALIDATION");
        
        Optional<Orders> orderOpt = ordersRepository.findById(orderId);
        if (orderOpt.isPresent()) {
            Orders order = orderOpt.get();
            
            // UPDATE EVERYTHING - NO VALIDATION
            order.setBillingAddress(billingAddress);
            order.setShippingAddress(shippingAddress);
            order.setOrderNotes(orderNotes);
            order.updateLastUpdated();
            
            ordersRepository.save(order);
            System.out.println("ORDER DETAILS UPDATED - NO VALIDATION");
            return true;
        }
        return false;
    }

    // Save order - SIMPLE SAVE
    public boolean saveOrder(Orders order) {
        try {
            order.updateLastUpdated();
            ordersRepository.save(order);
            System.out.println("ORDER SAVED TO DATABASE: " + order.getOid());
            return true;
        } catch (Exception e) {
            System.err.println("SAVE ERROR: " + e.getMessage());
            return false;
        }
    }

    // Delete order (FORCE DELETE - NO MATTER WHAT)
    public boolean deleteOrder(Long orderId) {
        try {
            System.out.println("FORCE DELETING ORDER " + orderId + " FROM DATABASE");
            Optional<Orders> orderOpt = ordersRepository.findById(orderId);
            if (orderOpt.isPresent()) {
                Orders order = orderOpt.get();
                ordersRepository.delete(order);
                System.out.println("FORCE DELETE SUCCESSFUL - Order " + orderId + " deleted from database");
                return true;
            } else {
                System.err.println("Order not found with ID: " + orderId);
                return false;
            }
        } catch (Exception e) {
            System.err.println("FORCE DELETE ERROR: " + e.getMessage());
            e.printStackTrace();
            // Try to delete anyway
            try {
                ordersRepository.deleteById(orderId);
                System.out.println("FORCE DELETE RETRY SUCCESSFUL");
                return true;
            } catch (Exception e2) {
                System.err.println("FORCE DELETE RETRY FAILED: " + e2.getMessage());
                return false;
            }
        }
    }

    // Get order details
    public List<OrderDetails> getOrderDetails(Long orderId) {
        // Deprecated: order_details table no longer used in payment/checkout flow
        return java.util.Collections.emptyList();
    }

    // Track order by tracking number
    public Optional<Orders> trackOrder(String trackingNumber) {
        return ordersRepository.findByTrackingNumber(trackingNumber);
    }

    // Get all orders (admin)
    public List<Orders> getAllOrders() {
        return ordersRepository.findAll();
    }

    // Get orders by status
    public List<Orders> getOrdersByStatus(Orders.OrderStatus status) {
        return ordersRepository.findByStatusOrderByOrderDateDesc(status);
    }

    // Get orders needing attention
    public List<Orders> getOrdersNeedingAttention() {
        return ordersRepository.findOrdersNeedingAttention();
    }

    // Get order statistics
    public OrderStatistics getOrderStatistics() {
        OrderStatistics stats = new OrderStatistics();
        stats.setTotalOrders(ordersRepository.count());
        stats.setPendingOrders(ordersRepository.countByStatus(Orders.OrderStatus.Pending));
        stats.setProcessingOrders(ordersRepository.countByStatus(Orders.OrderStatus.Processing));
        stats.setShippedOrders(ordersRepository.countByStatus(Orders.OrderStatus.Shipped));
        stats.setDeliveredOrders(ordersRepository.countByStatus(Orders.OrderStatus.Delivered));
        stats.setTotalSales(ordersRepository.getTotalSalesAmount());
        return stats;
    }

    // Approve order (admin)
    public boolean approveOrder(Long orderId) {
        Optional<Orders> orderOpt = ordersRepository.findById(orderId);
        if (orderOpt.isPresent()) {
            Orders order = orderOpt.get();
            if (order.getStatus() == Orders.OrderStatus.Pending) {
                order.setStatus(Orders.OrderStatus.Processing);
                
                // Generate tracking number
                String trackingNumber = generateTrackingNumber();
                order.setTrackingNumber(trackingNumber);
                
                // Set estimated delivery (7 days from now)
                LocalDateTime estimatedDelivery = LocalDateTime.now().plusDays(7);
                order.setEstimatedDelivery(estimatedDelivery);
                
                // Update last updated timestamp
                order.updateLastUpdated();
                
                ordersRepository.save(order);
                return true;
            }
        }
        return false;
    }

    // Decline order (admin)
    public boolean declineOrder(Long orderId) {
        Optional<Orders> orderOpt = ordersRepository.findById(orderId);
        if (orderOpt.isPresent()) {
            Orders order = orderOpt.get();
            if (order.getStatus() == Orders.OrderStatus.Pending) {
                order.setStatus(Orders.OrderStatus.Cancelled);
                
                // Update last updated timestamp
                order.updateLastUpdated();
                
                ordersRepository.save(order);
                return true;
            }
        }
        return false;
    }

    // Generate unique tracking number
    private String generateTrackingNumber() {
        String prefix = "TRK";
        String timestamp = String.valueOf(System.currentTimeMillis());
        String random = String.valueOf((int)(Math.random() * 1000));
        return prefix + timestamp.substring(timestamp.length() - 6) + random;
    }

    // Inner classes for request/response
    public static class OrderRequest {
        private String billingAddress;
        private String shippingAddress;
        private String paymentMethod;
        private String orderNotes;
        private List<OrderItemRequest> orderItems;
        // Card fields (only when paymentMethod=CARD)
        private String cardNumber;
        private String cardExpiry; // MM/YY
        private String cardCvv;

        // Getters and setters
        public String getBillingAddress() { return billingAddress; }
        public void setBillingAddress(String billingAddress) { this.billingAddress = billingAddress; }
        public String getShippingAddress() { return shippingAddress; }
        public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
        public String getPaymentMethod() { return paymentMethod; }
        public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
        public String getOrderNotes() { return orderNotes; }
        public void setOrderNotes(String orderNotes) { this.orderNotes = orderNotes; }
        public List<OrderItemRequest> getOrderItems() { return orderItems; }
        public void setOrderItems(List<OrderItemRequest> orderItems) { this.orderItems = orderItems; }
        public String getCardNumber() { return cardNumber; }
        public void setCardNumber(String cardNumber) { this.cardNumber = cardNumber; }
        public String getCardExpiry() { return cardExpiry; }
        public void setCardExpiry(String cardExpiry) { this.cardExpiry = cardExpiry; }
        public String getCardCvv() { return cardCvv; }
        public void setCardCvv(String cardCvv) { this.cardCvv = cardCvv; }
    }

    public static class OrderItemRequest {
        private Long bookId;
        private Integer quantity;

        // Getters and setters
        public Long getBookId() { return bookId; }
        public void setBookId(Long bookId) { this.bookId = bookId; }
        public Integer getQuantity() { return quantity; }
        public void setQuantity(Integer quantity) { this.quantity = quantity; }
    }

    public static class OrderStatistics {
        private long totalOrders;
        private long pendingOrders;
        private long processingOrders;
        private long shippedOrders;
        private long deliveredOrders;
        private Double totalSales;

        // Getters and setters
        public long getTotalOrders() { return totalOrders; }
        public void setTotalOrders(long totalOrders) { this.totalOrders = totalOrders; }
        public long getPendingOrders() { return pendingOrders; }
        public void setPendingOrders(long pendingOrders) { this.pendingOrders = pendingOrders; }
        public long getProcessingOrders() { return processingOrders; }
        public void setProcessingOrders(long processingOrders) { this.processingOrders = processingOrders; }
        public long getShippedOrders() { return shippedOrders; }
        public void setShippedOrders(long shippedOrders) { this.shippedOrders = shippedOrders; }
        public long getDeliveredOrders() { return deliveredOrders; }
        public void setDeliveredOrders(long deliveredOrders) { this.deliveredOrders = deliveredOrders; }
        public Double getTotalSales() { return totalSales; }
        public void setTotalSales(Double totalSales) { this.totalSales = totalSales; }
    }
}
