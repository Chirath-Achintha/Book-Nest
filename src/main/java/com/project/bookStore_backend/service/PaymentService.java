package com.project.bookStore_backend.service;

import com.project.bookStore_backend.model.*;
import com.project.bookStore_backend.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private OrdersRepository ordersRepository;

    // Customer repository not directly used but kept for future use
    @Autowired(required = false)
    private CustomerRepository customerRepository;

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private OrderDetailsRepository orderDetailsRepository;

    // Process payment for an order
    public Payment processPayment(Long orderId, String cardNumber, String cardExpiry, String cardholderName) {
        System.out.println("=== PROCESSING PAYMENT ===");
        System.out.println("Order ID: " + orderId);
        
        // Get order details
        Optional<Orders> orderOpt = ordersRepository.findById(orderId);
        if (orderOpt.isEmpty()) {
            throw new RuntimeException("Order not found: " + orderId);
        }

        Orders order = orderOpt.get();
        System.out.println("Order found for customer: " + order.getCustomer().getCid() + " (" + order.getCustomer().getCname() + ")");
        
        // Check if order is still pending payment
        if (order.getPaymentStatus() != Orders.PaymentStatus.Pending) {
            throw new RuntimeException("Order payment status is not pending");
        }

        // Create payment record
        Payment payment = new Payment();
        payment.setOrder(order);
        payment.setCustomer(order.getCustomer());
        payment.setPaymentMethod(order.getPaymentMethod());
        payment.setPaymentAmount(order.getTotalAmount());
        payment.setPaymentStatus(Payment.PaymentStatus.COMPLETED);
        payment.setPaymentDate(LocalDateTime.now());
        payment.setTransactionId(UUID.randomUUID().toString());
        
        // Store card details (masked)
        if (cardNumber != null && !cardNumber.trim().isEmpty()) {
            payment.setCardNumberMasked(cardNumber);
            payment.setCardExpiry(cardExpiry);
            payment.setCardholderName(cardholderName);
        }
        
        payment.setPaymentNotes("Payment processed successfully");
        
        // Save payment record
        Payment savedPayment = paymentRepository.save(payment);
        System.out.println("Payment saved with ID: " + savedPayment.getPaymentId());
        System.out.println("Transaction ID: " + savedPayment.getTransactionId());
        
        // Update order status
        order.setPaymentStatus(Orders.PaymentStatus.Paid);
        order.setStatus(Orders.OrderStatus.Processing);
        order.setPaymentDate(LocalDateTime.now());
        order.setTransactionId(savedPayment.getTransactionId());
        ordersRepository.save(order);
        System.out.println("Order status updated to: " + order.getStatus() + ", Payment: " + order.getPaymentStatus());
        
        // Create order details from cart items
        createOrderDetailsFromCart(order);
        
        // Update stock and clear cart
        updateStockAndClearCart(order.getCustomer().getCid());
        
        System.out.println("Payment processed successfully for order ID: " + orderId);
        System.out.println("Payment ID: " + savedPayment.getPaymentId());
        System.out.println("Transaction ID: " + savedPayment.getTransactionId());
        
        return savedPayment;
    }

    // Process Cash on Delivery payment
    public Payment processCODPayment(Long orderId) {
        // Get order details
        Optional<Orders> orderOpt = ordersRepository.findById(orderId);
        if (orderOpt.isEmpty()) {
            throw new RuntimeException("Order not found: " + orderId);
        }

        Orders order = orderOpt.get();
        
        // Check if order is still pending payment
        if (order.getPaymentStatus() != Orders.PaymentStatus.Pending) {
            throw new RuntimeException("Order payment status is not pending");
        }

        // Create payment record for COD
        Payment payment = new Payment();
        payment.setOrder(order);
        payment.setCustomer(order.getCustomer());
        payment.setPaymentMethod("CASH_ON_DELIVERY");
        payment.setPaymentAmount(order.getTotalAmount());
        payment.setPaymentStatus(Payment.PaymentStatus.COMPLETED);
        payment.setPaymentDate(LocalDateTime.now());
        payment.setTransactionId("COD-" + UUID.randomUUID().toString());
        payment.setPaymentNotes("Cash on Delivery - Payment to be collected on delivery");
        
        // Save payment record
        Payment savedPayment = paymentRepository.save(payment);
        
        // Update order status
        order.setPaymentStatus(Orders.PaymentStatus.Paid);
        order.setStatus(Orders.OrderStatus.Processing);
        order.setPaymentDate(LocalDateTime.now());
        order.setTransactionId(savedPayment.getTransactionId());
        ordersRepository.save(order);
        
        // Create order details from cart items
        createOrderDetailsFromCart(order);
        
        // Update stock and clear cart
        updateStockAndClearCart(order.getCustomer().getCid());
        
        System.out.println("COD Payment processed successfully for order ID: " + orderId);
        System.out.println("Payment ID: " + savedPayment.getPaymentId());
        System.out.println("Transaction ID: " + savedPayment.getTransactionId());
        
        return savedPayment;
    }

    // Create order details from cart items
    private void createOrderDetailsFromCart(Orders order) {
        System.out.println("=== CREATING ORDER DETAILS ===");
        List<CartItem> cartItems = cartRepository.findByCustomerCid(order.getCustomer().getCid());
        System.out.println("Found " + cartItems.size() + " cart items for customer: " + order.getCustomer().getCid());
        
        for (CartItem cartItem : cartItems) {
            OrderDetails orderDetail = new OrderDetails();
            orderDetail.setOrder(order);
            orderDetail.setBook(cartItem.getBook());
            orderDetail.setQuantity(cartItem.getQuantity());
            orderDetail.setPrice(BigDecimal.valueOf(cartItem.getBook().getPrice()));
            
            orderDetailsRepository.save(orderDetail);
            System.out.println("Created order detail for book: " + cartItem.getBook().getTitle() + " (Qty: " + cartItem.getQuantity() + ")");
        }
        
        System.out.println("Created " + cartItems.size() + " order details for order ID: " + order.getOid());
    }

    // Update stock and clear cart
    private void updateStockAndClearCart(Long customerId) {
        System.out.println("=== UPDATING STOCK AND CLEARING CART ===");
        List<CartItem> cartItems = cartRepository.findByCustomerCid(customerId);
        System.out.println("Found " + cartItems.size() + " cart items to process for customer: " + customerId);
        
        for (CartItem cartItem : cartItems) {
            Book book = cartItem.getBook();
            int oldStock = book.getStock();
            book.setStock(book.getStock() - cartItem.getQuantity());
            bookRepository.save(book);
            System.out.println("Updated stock for book '" + book.getTitle() + "': " + oldStock + " -> " + book.getStock() + " (sold: " + cartItem.getQuantity() + ")");
        }
        
        // Clear customer's cart
        cartRepository.deleteByCustomerCid(customerId);
        System.out.println("Cleared cart for customer: " + customerId);
        
        System.out.println("Updated stock for " + cartItems.size() + " items and cleared cart for customer: " + customerId);
    }

    // Get payment by ID
    public Optional<Payment> getPaymentById(Long paymentId) {
        return paymentRepository.findByIdWithCustomerAndOrder(paymentId);
    }

    // Get payments by customer ID
    public List<Payment> getPaymentsByCustomer(Long customerId) {
        return paymentRepository.findByCustomerCidOrderByCreatedAtDesc(customerId);
    }

    // Get payments by order ID
    public List<Payment> getPaymentsByOrder(Long orderId) {
        return paymentRepository.findByOrderOidOrderByCreatedAtDesc(orderId);
    }

    // Get payment by transaction ID
    public Optional<Payment> getPaymentByTransactionId(String transactionId) {
        return paymentRepository.findByTransactionId(transactionId);
    }

    // Get total payment amount for customer
    public BigDecimal getTotalPaymentAmountByCustomer(Long customerId) {
        Double total = paymentRepository.getTotalPaymentAmountByCustomer(customerId);
        return total != null ? BigDecimal.valueOf(total) : BigDecimal.ZERO;
    }

    // Get total payment count for customer
    public Long getTotalPaymentCountByCustomer(Long customerId) {
        return paymentRepository.getTotalPaymentCountByCustomer(customerId);
    }

    // Check if payment exists for order
    public boolean hasCompletedPayment(Long orderId) {
        return paymentRepository.existsCompletedPaymentForOrder(orderId);
    }

    // Refund payment
    public Payment refundPayment(Long paymentId, String reason) {
        Optional<Payment> paymentOpt = paymentRepository.findById(paymentId);
        if (paymentOpt.isEmpty()) {
            throw new RuntimeException("Payment not found: " + paymentId);
        }

        Payment payment = paymentOpt.get();
        
        if (payment.getPaymentStatus() != Payment.PaymentStatus.COMPLETED) {
            throw new RuntimeException("Only completed payments can be refunded");
        }

        // Update payment status
        payment.setPaymentStatus(Payment.PaymentStatus.REFUNDED);
        payment.setPaymentNotes(payment.getPaymentNotes() + " | Refunded: " + reason);
        payment.updateTimestamp();
        
        Payment refundedPayment = paymentRepository.save(payment);
        
        // Update order status if needed
        Orders order = payment.getOrder();
        if (order.getPaymentStatus() == Orders.PaymentStatus.Paid) {
            order.setPaymentStatus(Orders.PaymentStatus.Refunded);
            ordersRepository.save(order);
        }
        
        System.out.println("Payment refunded successfully: " + paymentId);
        return refundedPayment;
    }
}
