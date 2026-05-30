package com.project.bookStore_backend.repository;

import com.project.bookStore_backend.model.OrderDetails;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderDetailsRepository extends JpaRepository<OrderDetails, Long> {

    // Find order details by order ID
    List<OrderDetails> findByOrderOidOrderByOdid(Long orderId);

    // Find order details by order ID with book details
    @Query("SELECT od FROM OrderDetails od LEFT JOIN FETCH od.book WHERE od.order.oid = :orderId ORDER BY od.odid")
    List<OrderDetails> findByOrderIdWithBookDetails(@Param("orderId") Long orderId);

    // Find order details by book ID
    List<OrderDetails> findByBookBidOrderByOrderOrderDateDesc(Long bookId);

    // Count order details by order ID
    long countByOrderOid(Long orderId);

    // Get total quantity sold for a book
    @Query("SELECT COALESCE(SUM(od.quantity), 0) FROM OrderDetails od WHERE od.book.bid = :bookId")
    Integer getTotalQuantitySoldForBook(@Param("bookId") Long bookId);

    // Get total revenue for a book
    @Query("SELECT COALESCE(SUM(od.price * od.quantity), 0) FROM OrderDetails od WHERE od.book.bid = :bookId")
    Double getTotalRevenueForBook(@Param("bookId") Long bookId);

    // Find best selling books
    @Query("SELECT od.book.bid, od.book.title, SUM(od.quantity) as totalQuantity " +
           "FROM OrderDetails od " +
           "GROUP BY od.book.bid, od.book.title " +
           "ORDER BY totalQuantity DESC")
    List<Object[]> findBestSellingBooks();

    // Find order details by multiple order IDs
    List<OrderDetails> findByOrderOidInOrderByOrderOrderDateDesc(List<Long> orderIds);
}
