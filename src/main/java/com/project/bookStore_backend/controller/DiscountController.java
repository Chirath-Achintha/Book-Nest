package com.project.bookStore_backend.controller;

import com.project.bookStore_backend.model.Discount;
import com.project.bookStore_backend.service.DiscountService;
import com.project.bookStore_backend.util.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/admin/discounts")
public class DiscountController {

    @Autowired
    private DiscountService discountService;

    private boolean ensureAdmin(HttpSession session) {
        return SessionUtils.isAdminLoggedIn(session);
    }

    @PostMapping("")
    public ResponseEntity<Discount> create(@Valid @RequestBody Discount discount, HttpSession session) {
        if (!ensureAdmin(session)) {
            return ResponseEntity.status(403).build();
        }
        try {
            return ResponseEntity.ok(discountService.createDiscount(discount));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<Discount> update(@PathVariable Long id, @Valid @RequestBody Discount discount, HttpSession session) {
        if (!ensureAdmin(session)) {
            return ResponseEntity.status(403).build();
        }
        try {
            Optional<Discount> updated = discountService.updateDiscount(id, discount);
            return updated.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id, HttpSession session) {
        if (!ensureAdmin(session)) {
            return ResponseEntity.status(403).build();
        }
        discountService.deleteDiscount(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("")
    public ResponseEntity<List<Discount>> listAll(HttpSession session) {
        if (!ensureAdmin(session)) {
            return ResponseEntity.status(403).build();
        }
        return ResponseEntity.ok(discountService.getAllDiscounts());
    }

    @GetMapping("/active")
    public ResponseEntity<List<Discount>> listActive(HttpSession session) {
        if (!ensureAdmin(session)) {
            return ResponseEntity.status(403).build();
        }
        return ResponseEntity.ok(discountService.getActiveDiscounts());
    }
}

