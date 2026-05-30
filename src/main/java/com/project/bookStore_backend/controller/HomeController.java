package com.project.bookStore_backend.controller;

import com.project.bookStore_backend.dto.FeedbackDTO;
import com.project.bookStore_backend.model.Book;
import com.project.bookStore_backend.model.Feedback;
import com.project.bookStore_backend.service.BookService;
import com.project.bookStore_backend.service.FeedbackService;
import com.project.bookStore_backend.service.CartService;
import com.project.bookStore_backend.util.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
public class HomeController {

    @Autowired
    private BookService bookService;
    
    @Autowired
    private FeedbackService feedbackService;
    
    @Autowired
    private CartService cartService;

    // Landing page
    @GetMapping("/")
    public String homePage(Model model, HttpServletRequest request) {
        // Get featured books for homepage
        List<Book> featuredBooks = bookService.getFeaturedBooks(8);
        model.addAttribute("books", featuredBooks);
        
        // Add cart count for logged-in users
        Long customerId = SessionUtils.getCurrentCustomerId(request.getSession());
        if (customerId != null) {
            Integer cartCount = cartService.getCartItemCount(customerId);
            model.addAttribute("cartCount", cartCount);
        } else {
            model.addAttribute("cartCount", 0);
        }
        
        // Add website feedback data
        try {
            List<Feedback> websiteFeedback = feedbackService.getRecentWebsiteFeedback();
            
            // Format feedback dates for JSP using DTO
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
            List<FeedbackDTO> feedbackList = new ArrayList<>();
            for (Feedback fb : websiteFeedback) {
                feedbackList.add(new FeedbackDTO(
                    fb.getFeedbackId(),
                    fb.getCustomer().getCid(),
                    fb.getCustomer().getCname(),
                    fb.getRating(),
                    fb.getComment(),
                    fb.getCreatedAt() != null ? fb.getCreatedAt().format(formatter) : ""
                ));
            }
            
            model.addAttribute("websiteFeedback", feedbackList);
            model.addAttribute("currentCustomerId", customerId);

            // Check if current user has already left website feedback
            if (customerId != null) {
                Optional<Feedback> existingFeedback = feedbackService.getCustomerWebsiteFeedback(customerId);
                model.addAttribute("existingWebsiteFeedback", existingFeedback.orElse(null));
                model.addAttribute("hasLeftWebsiteFeedback", existingFeedback.isPresent());
            }
        } catch (Exception e) {
            // If feedback service fails, continue without feedback data
            System.err.println("Error loading website feedback: " + e.getMessage());
        }
        
        return "index"; // maps to /WEB-INF/jsp/index.jsp
    }

    // Show login page (JSP)
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }


    // Show register page (JSP)
    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("customer", new com.project.bookStore_backend.model.RegisteredCustomer());
        return "register";
    }
}
