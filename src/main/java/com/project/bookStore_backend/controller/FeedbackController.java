package com.project.bookStore_backend.controller;

import com.project.bookStore_backend.dto.FeedbackDTO;
import com.project.bookStore_backend.model.Feedback;
import com.project.bookStore_backend.service.FeedbackService;
import com.project.bookStore_backend.util.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/feedback")
public class FeedbackController {

    @Autowired
    private FeedbackService feedbackService;

    /**
     * Display book feedback form and existing reviews
     */
    @GetMapping("/book/{bookId}")
    public String showBookFeedback(@PathVariable Long bookId, Model model, HttpServletRequest request) {
        try {
            // Get book feedback
            List<Feedback> bookFeedback = feedbackService.getFeedbackForBook(bookId);
            Double averageRating = feedbackService.getAverageRatingForBook(bookId);
            Long feedbackCount = feedbackService.getFeedbackCountForBook(bookId);

            // Format feedback dates for JSP using DTO
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
            List<FeedbackDTO> feedbackList = new ArrayList<>();
            for (Feedback fb : bookFeedback) {
                feedbackList.add(new FeedbackDTO(
                    fb.getFeedbackId(),
                    fb.getCustomer().getCid(),
                    fb.getCustomer().getCname(),
                    fb.getRating(),
                    fb.getComment(),
                    fb.getCreatedAt() != null ? fb.getCreatedAt().format(formatter) : ""
                ));
            }

            model.addAttribute("bookId", bookId);
            model.addAttribute("bookFeedback", feedbackList);
            model.addAttribute("averageRating", averageRating);
            model.addAttribute("feedbackCount", feedbackCount);

            // Check if current user has already left feedback
            Long customerId = SessionUtils.getCurrentCustomerId(request.getSession());
            model.addAttribute("currentCustomerId", customerId);
            if (customerId != null) {
                Optional<Feedback> existingFeedback = feedbackService.getCustomerBookFeedback(customerId, bookId);
                model.addAttribute("existingFeedback", existingFeedback.orElse(null));
                model.addAttribute("hasLeftFeedback", existingFeedback.isPresent());
            }

            return "feedback/bookFeedback";
        } catch (Exception e) {
            model.addAttribute("error", "Error loading feedback: " + e.getMessage());
            return "error";
        }
    }

    /**
     * Submit book feedback
     */
    @PostMapping("/book/{bookId}")
    public String submitBookFeedback(@PathVariable Long bookId,
                                   @RequestParam Integer rating,
                                   @RequestParam(required = false) String comment,
                                   HttpServletRequest request,
                                   Model model) {
        try {
            Long customerId = SessionUtils.getCurrentCustomerId(request.getSession());
            if (customerId == null) {
                model.addAttribute("error", "You must be logged in to leave feedback");
                return "error";
            }

            feedbackService.addBookFeedback(customerId, bookId, rating, comment);
            return "redirect:/feedback/book/" + bookId + "?success=true";
        } catch (Exception e) {
            model.addAttribute("error", "Error submitting feedback: " + e.getMessage());
            return "error";
        }
    }

    /**
     * Display website feedback form and testimonials
     */
    @GetMapping("/website")
    public String showWebsiteFeedback(Model model, HttpServletRequest request) {
        try {
            // Get website feedback
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

            // Check if current user has already left website feedback
            Long customerId = SessionUtils.getCurrentCustomerId(request.getSession());
            model.addAttribute("currentCustomerId", customerId);
            if (customerId != null) {
                Optional<Feedback> existingFeedback = feedbackService.getCustomerWebsiteFeedback(customerId);
                model.addAttribute("existingFeedback", existingFeedback.orElse(null));
                model.addAttribute("hasLeftFeedback", existingFeedback.isPresent());
            }

            return "feedback/websiteFeedback";
        } catch (Exception e) {
            model.addAttribute("error", "Error loading feedback: " + e.getMessage());
            return "error";
        }
    }

    /**
     * Submit website feedback
     */
    @PostMapping("/website")
    public String submitWebsiteFeedback(@RequestParam Integer rating,
                                      @RequestParam(required = false) String comment,
                                      HttpServletRequest request,
                                      Model model) {
        try {
            Long customerId = SessionUtils.getCurrentCustomerId(request.getSession());
            if (customerId == null) {
                model.addAttribute("error", "You must be logged in to leave feedback");
                return "error";
            }

            feedbackService.addWebsiteFeedback(customerId, rating, comment);
            return "redirect:/?success=true";
        } catch (Exception e) {
            model.addAttribute("error", "Error submitting feedback: " + e.getMessage());
            return "error";
        }
    }

    /**
     * REST API: Get book feedback
     */
    @GetMapping("/api/book/{bookId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getBookFeedbackApi(@PathVariable Long bookId) {
        try {
            List<Feedback> feedback = feedbackService.getFeedbackForBook(bookId);
            Double averageRating = feedbackService.getAverageRatingForBook(bookId);
            Long feedbackCount = feedbackService.getFeedbackCountForBook(bookId);

            Map<String, Object> response = new HashMap<>();
            response.put("feedback", feedback);
            response.put("averageRating", averageRating);
            response.put("feedbackCount", feedbackCount);
            response.put("success", true);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * REST API: Get website feedback
     */
    @GetMapping("/api/website")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getWebsiteFeedbackApi() {
        try {
            List<Feedback> feedback = feedbackService.getWebsiteFeedback();
            Map<String, Object> response = new HashMap<>();
            response.put("feedback", feedback);
            response.put("success", true);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * REST API: Submit book feedback
     */
    @PostMapping("/api/book/{bookId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> submitBookFeedbackApi(@PathVariable Long bookId,
                                                                    @RequestParam Long customerId,
                                                                    @RequestParam Integer rating,
                                                                    @RequestParam(required = false) String comment) {
        try {
            Feedback feedback = feedbackService.addBookFeedback(customerId, bookId, rating, comment);
            Map<String, Object> response = new HashMap<>();
            response.put("feedback", feedback);
            response.put("success", true);
            response.put("message", "Feedback submitted successfully");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * REST API: Submit website feedback
     */
    @PostMapping("/api/website")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> submitWebsiteFeedbackApi(@RequestParam Long customerId,
                                                                       @RequestParam Integer rating,
                                                                       @RequestParam(required = false) String comment) {
        try {
            Feedback feedback = feedbackService.addWebsiteFeedback(customerId, rating, comment);
            Map<String, Object> response = new HashMap<>();
            response.put("feedback", feedback);
            response.put("success", true);
            response.put("message", "Feedback submitted successfully");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * Admin: View all feedback
     */
    @GetMapping("/admin/all")
    public String adminViewAllFeedback(Model model) {
        try {
            List<Feedback> allFeedback = feedbackService.getAllFeedback();
            model.addAttribute("allFeedback", allFeedback);
            return "admin/manageFeedback";
        } catch (Exception e) {
            model.addAttribute("error", "Error loading feedback: " + e.getMessage());
            return "error";
        }
    }

    /**
     * Admin: Delete feedback
     */
    @PostMapping("/admin/delete/{feedbackId}")
    public String adminDeleteFeedback(@PathVariable Long feedbackId, Model model) {
        try {
            feedbackService.deleteFeedback(feedbackId);
            return "redirect:/feedback/admin/all?success=true";
        } catch (Exception e) {
            model.addAttribute("error", "Error deleting feedback: " + e.getMessage());
            return "error";
        }
    }

    /**
     * Customer: Edit their own feedback
     */
    @PostMapping("/edit/{feedbackId}")
    public String editFeedback(@PathVariable Long feedbackId,
                              @RequestParam Integer rating,
                              @RequestParam(required = false) String comment,
                              @RequestParam(required = false) String redirectTo,
                              HttpServletRequest request,
                              Model model) {
        try {
            Long customerId = SessionUtils.getCurrentCustomerId(request.getSession());
            if (customerId == null) {
                model.addAttribute("error", "You must be logged in to edit feedback");
                return "error";
            }

            // Check if feedback exists and belongs to current user
            Optional<Feedback> feedbackOpt = feedbackService.getFeedbackById(feedbackId);
            if (feedbackOpt.isEmpty()) {
                model.addAttribute("error", "Feedback not found");
                return "error";
            }

            Feedback feedback = feedbackOpt.get();
            if (!feedback.getCustomer().getCid().equals(customerId)) {
                model.addAttribute("error", "You can only edit your own feedback");
                return "error";
            }

            // Update feedback
            feedbackService.updateFeedback(feedbackId, rating, comment);

            // Redirect based on the source page or feedback type
            if (redirectTo != null) {
                // If redirectTo parameter is provided, use it
                return "redirect:" + redirectTo + "?success=true";
            } else if (feedback.isBookFeedback()) {
                // For book feedback, redirect to book details page
                return "redirect:/books/" + feedback.getBook().getBid() + "?success=true";
            } else {
                // For website feedback, redirect to homepage
                return "redirect:/?success=true";
            }
        } catch (Exception e) {
            model.addAttribute("error", "Error editing feedback: " + e.getMessage());
            return "error";
        }
    }

    /**
     * Customer: Delete their own feedback
     */
    @PostMapping("/delete/{feedbackId}")
    public String deleteFeedback(@PathVariable Long feedbackId,
                                @RequestParam(required = false) String redirectTo,
                                HttpServletRequest request,
                                Model model) {
        try {
            Long customerId = SessionUtils.getCurrentCustomerId(request.getSession());
            
            if (customerId == null && !SessionUtils.isAdminLoggedIn(request.getSession())) {
                model.addAttribute("error", "You must be logged in to delete feedback");
                return "error";
            }

            // Check if feedback exists
            Optional<Feedback> feedbackOpt = feedbackService.getFeedbackById(feedbackId);
            if (feedbackOpt.isEmpty()) {
                model.addAttribute("error", "Feedback not found");
                return "error";
            }

            Feedback feedback = feedbackOpt.get();
            
            // Security check: Only admin or feedback owner can delete
            boolean canDelete = false;
            if (SessionUtils.isAdminLoggedIn(request.getSession())) {
                canDelete = true; // Admin can delete any feedback
            } else if (customerId != null && feedback.getCustomer().getCid().equals(customerId)) {
                canDelete = true; // Owner can delete their own feedback
            }

            if (!canDelete) {
                model.addAttribute("error", "You can only delete your own feedback");
                return "error";
            }

            // Store book ID for redirect before deletion
            Long bookId = null;
            if (feedback.isBookFeedback()) {
                bookId = feedback.getBook().getBid();
            }

            // Delete feedback
            feedbackService.deleteFeedback(feedbackId);

            // Redirect based on the source page or feedback type
            if (redirectTo != null) {
                // If redirectTo parameter is provided, use it
                return "redirect:" + redirectTo + "?success=true";
            } else if (bookId != null) {
                // For book feedback, redirect to book details page
                return "redirect:/books/" + bookId + "?success=true";
            } else {
                // For website feedback, redirect to homepage
                return "redirect:/?success=true";
            }
        } catch (Exception e) {
            model.addAttribute("error", "Error deleting feedback: " + e.getMessage());
            return "error";
        }
    }

    /**
     * REST API: Edit feedback
     */
    @PostMapping("/api/edit/{feedbackId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> editFeedbackApi(@PathVariable Long feedbackId,
                                                              @RequestParam Long customerId,
                                                              @RequestParam Integer rating,
                                                              @RequestParam(required = false) String comment) {
        try {
            // Check if feedback exists and belongs to customer
            Optional<Feedback> feedbackOpt = feedbackService.getFeedbackById(feedbackId);
            if (feedbackOpt.isEmpty()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("error", "Feedback not found");
                return ResponseEntity.badRequest().body(response);
            }

            Feedback feedback = feedbackOpt.get();
            if (!feedback.getCustomer().getCid().equals(customerId)) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("error", "You can only edit your own feedback");
                return ResponseEntity.badRequest().body(response);
            }

            // Update feedback
            Feedback updatedFeedback = feedbackService.updateFeedback(feedbackId, rating, comment);
            
            Map<String, Object> response = new HashMap<>();
            response.put("feedback", updatedFeedback);
            response.put("success", true);
            response.put("message", "Feedback updated successfully");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * REST API: Delete feedback
     */
    @PostMapping("/api/delete/{feedbackId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteFeedbackApi(@PathVariable Long feedbackId,
                                                                @RequestParam Long customerId) {
        try {
            // Check if feedback exists and belongs to customer
            Optional<Feedback> feedbackOpt = feedbackService.getFeedbackById(feedbackId);
            if (feedbackOpt.isEmpty()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("error", "Feedback not found");
                return ResponseEntity.badRequest().body(response);
            }

            Feedback feedback = feedbackOpt.get();
            if (!feedback.getCustomer().getCid().equals(customerId)) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("error", "You can only delete your own feedback");
                return ResponseEntity.badRequest().body(response);
            }

            // Delete feedback
            feedbackService.deleteFeedback(feedbackId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Feedback deleted successfully");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}