package com.project.bookStore_backend.repository;

import com.project.bookStore_backend.model.Orders;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface OrdersRepository extends JpaRepository<Orders, Long> {

    // Find orders by customer ID
    List<Orders> findByCustomerCidOrderByOrderDateDesc(Long customerId);

    // Find orders by customer ID with pagination
    Page<Orders> findByCustomerCidOrderByOrderDateDesc(Long customerId, Pageable pageable);

    // Find order by ID with customer details
    @Query("SELECT o FROM Orders o LEFT JOIN FETCH o.customer WHERE o.oid = :orderId")
    Optional<Orders> findByIdWithCustomer(@Param("orderId") Long orderId);

    // Removed: order_details dependency. Use findByIdWithCustomer instead.

    // Find orders by status
    List<Orders> findByStatusOrderByOrderDateDesc(Orders.OrderStatus status);

    // Find orders by payment status
    List<Orders> findByPaymentStatusOrderByOrderDateDesc(Orders.PaymentStatus paymentStatus);

    // Find orders by date range
    List<Orders> findByOrderDateBetweenOrderByOrderDateDesc(LocalDateTime startDate, LocalDateTime endDate);

    // Find orders by tracking number
    Optional<Orders> findByTrackingNumber(String trackingNumber);

    // Count orders by customer
    long countByCustomerCid(Long customerId);

    // Count orders by status
    long countByStatus(Orders.OrderStatus status);

    // Find recent orders (last 30 days)
    @Query("SELECT o FROM Orders o WHERE o.orderDate >= :since ORDER BY o.orderDate DESC")
    List<Orders> findRecentOrders(@Param("since") LocalDateTime since);

    // Find orders needing attention (pending payment or processing)
    @Query("SELECT o FROM Orders o WHERE o.paymentStatus = 'Pending' OR o.status = 'Processing' ORDER BY o.orderDate ASC")
    List<Orders> findOrdersNeedingAttention();

    // Get total sales amount
    @Query("SELECT COALESCE(SUM(o.totalAmount), 0) FROM Orders o WHERE o.paymentStatus = 'Paid'")
    Double getTotalSalesAmount();

    // Get total sales amount by date range
    @Query("SELECT COALESCE(SUM(o.totalAmount), 0) FROM Orders o WHERE o.paymentStatus = 'Paid' AND o.orderDate BETWEEN :startDate AND :endDate")
    Double getTotalSalesAmountByDateRange(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
}
