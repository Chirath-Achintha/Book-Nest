package com.project.bookStore_backend.repository;

import com.project.bookStore_backend.model.Discount;
import com.project.bookStore_backend.model.Discount.DiscountStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DiscountRepository extends JpaRepository<Discount, Long> {
    List<Discount> findByStatus(DiscountStatus status);
}

