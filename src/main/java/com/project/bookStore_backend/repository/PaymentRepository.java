package com.project.bookStore_backend.repository;

import com.project.bookStore_backend.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {

    // Find payments by customer ID
    List<Payment> findByCustomerCidOrderByCreatedAtDesc(Long customerId);

    // Find payments by order ID
    List<Payment> findByOrderOidOrderByCreatedAtDesc(Long orderId);

    // Find payment by transaction ID
    Optional<Payment> findByTransactionId(String transactionId);

    // Find payments by status
    List<Payment> findByPaymentStatusOrderByCreatedAtDesc(Payment.PaymentStatus status);

    // Find payments by customer and status
    List<Payment> findByCustomerCidAndPaymentStatusOrderByCreatedAtDesc(Long customerId, Payment.PaymentStatus status);

    // Find payments by order and status
    List<Payment> findByOrderOidAndPaymentStatusOrderByCreatedAtDesc(Long orderId, Payment.PaymentStatus status);

    // Get total payments amount for a customer
    @Query("SELECT COALESCE(SUM(p.paymentAmount), 0) FROM Payment p WHERE p.customer.cid = :customerId AND p.paymentStatus = 'COMPLETED'")
    Double getTotalPaymentAmountByCustomer(@Param("customerId") Long customerId);

    // Get total payments count for a customer
    @Query("SELECT COUNT(p) FROM Payment p WHERE p.customer.cid = :customerId AND p.paymentStatus = 'COMPLETED'")
    Long getTotalPaymentCountByCustomer(@Param("customerId") Long customerId);

    // Get payments with customer details
    @Query("SELECT p FROM Payment p JOIN FETCH p.customer c WHERE p.paymentId = :paymentId")
    Optional<Payment> findByIdWithCustomer(@Param("paymentId") Long paymentId);

    // Get payments with order details
    @Query("SELECT p FROM Payment p JOIN FETCH p.order o WHERE p.paymentId = :paymentId")
    Optional<Payment> findByIdWithOrder(@Param("paymentId") Long paymentId);

    // Get payments with both customer and order details
    @Query("SELECT p FROM Payment p JOIN FETCH p.customer c JOIN FETCH p.order o WHERE p.paymentId = :paymentId")
    Optional<Payment> findByIdWithCustomerAndOrder(@Param("paymentId") Long paymentId);

    // Get recent payments for a customer
    @Query("SELECT p FROM Payment p JOIN FETCH p.order o WHERE p.customer.cid = :customerId ORDER BY p.createdAt DESC")
    List<Payment> findRecentPaymentsByCustomer(@Param("customerId") Long customerId);

    // Check if payment exists for order
    @Query("SELECT COUNT(p) > 0 FROM Payment p WHERE p.order.oid = :orderId AND p.paymentStatus = 'COMPLETED'")
    boolean existsCompletedPaymentForOrder(@Param("orderId") Long orderId);
}
