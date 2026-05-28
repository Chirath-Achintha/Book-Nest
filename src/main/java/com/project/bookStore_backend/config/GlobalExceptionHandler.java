package com.project.bookStore_backend.config;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.InvalidDataAccessApiUsageException;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(DataIntegrityViolationException.class)
    public String handleDataIntegrityViolation(DataIntegrityViolationException ex, Model model) {
        String message = ex.getMessage();
        if (message.contains("foreign key constraint")) {
            message = "Database constraint error. Please ensure all required data is properly set up.";
        }
        model.addAttribute("statusCode", 400);
        model.addAttribute("message", message);
        return "error";
    }

    @ExceptionHandler(InvalidDataAccessApiUsageException.class)
    public String handleInvalidDataAccess(InvalidDataAccessApiUsageException ex, Model model) {
        model.addAttribute("statusCode", 400);
        model.addAttribute("message", "Data access error: " + ex.getMessage());
        return "error";
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public String handleIllegalArgument(IllegalArgumentException ex, Model model) {
        model.addAttribute("statusCode", 400);
        model.addAttribute("message", ex.getMessage());
        return "error";
    }

    @ExceptionHandler(Exception.class)
    public String handleAnyException(Exception ex, Model model) {
        model.addAttribute("statusCode", 500);
        model.addAttribute("message", ex.getMessage());
        return "error";
    }
}


