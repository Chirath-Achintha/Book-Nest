package com.project.bookStore_backend.service;

import com.project.bookStore_backend.model.Discount;
import com.project.bookStore_backend.model.Discount.DiscountStatus;
import com.project.bookStore_backend.repository.DiscountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class DiscountService {

    @Autowired
    private DiscountRepository discountRepository;

    public Discount createDiscount(Discount discount) {
        // Validate discount before saving
        discount.validate();
        discount.recomputeStatus(LocalDate.now());
        return discountRepository.save(discount);
    }

    public Optional<Discount> updateDiscount(Long id, Discount updated) {
        return discountRepository.findById(id).map(existing -> {
            existing.setDname(updated.getDname());
            existing.setDtype(updated.getDtype());
            existing.setPercentage(updated.getPercentage());
            existing.setStartDate(updated.getStartDate());
            existing.setEndDate(updated.getEndDate());
            // Validate discount before saving
            existing.validate();
            existing.recomputeStatus(LocalDate.now());
            return discountRepository.save(existing);
        });
    }

    public void deleteDiscount(Long id) {
        discountRepository.deleteById(id);
    }

    public List<Discount> getAllDiscounts() {
        // Refresh statuses lazily
        List<Discount> list = discountRepository.findAll();
        LocalDate today = LocalDate.now();
        for (Discount d : list) {
            d.recomputeStatus(today);
        }
        return list;
    }

    public List<Discount> getActiveDiscounts() {
        return discountRepository.findByStatus(DiscountStatus.ACTIVE);
    }

    public Optional<Discount> getDiscountById(Long id) {
        return discountRepository.findById(id).map(discount -> {
            discount.recomputeStatus(LocalDate.now());
            return discount;
        });
    }
}

