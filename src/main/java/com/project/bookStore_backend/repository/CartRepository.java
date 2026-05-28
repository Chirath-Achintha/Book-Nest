package com.project.bookStore_backend.repository;

import com.project.bookStore_backend.model.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CartRepository extends JpaRepository<CartItem, Long> {
    List<CartItem> findByCustomerCid(Long cid);
    Optional<CartItem> findByCustomerCidAndBookBid(Long cid, Long bid);
    void deleteByCustomerCid(Long cid);
}
