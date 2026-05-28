package com.project.bookStore_backend.controller;

import com.project.bookStore_backend.dto.FeedbackDTO;
import com.project.bookStore_backend.model.Book;
import com.project.bookStore_backend.model.Feedback;
import com.project.bookStore_backend.service.BookService;
import com.project.bookStore_backend.service.FeedbackService;
import com.project.bookStore_backend.util.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/books")
public class BookController {

    @Autowired
    private BookService bookService;
    
    @Autowired
    private FeedbackService feedbackService;

    // Display all books (catalog page)
    @GetMapping
    public String getAllBooks(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "12") int size,
            @RequestParam(value = "sortBy", defaultValue = "title") String sortBy,
            @RequestParam(value = "sortDir", defaultValue = "asc") String sortDir,
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "genre", required = false) String genre,
            @RequestParam(value = "minPrice", required = false) Double minPrice,
            @RequestParam(value = "maxPrice", required = false) Double maxPrice,
            @RequestParam(value = "inStock", required = false) Boolean inStock,
            Model model) {

        Page<Book> booksPage;
        
        // If search term is provided, use search functionality
        if (search != null && !search.trim().isEmpty()) {
            booksPage = bookService.searchBooks(search.trim(), page, size, sortBy, sortDir);
        } else {
            // Use advanced filtering
            booksPage = bookService.searchBooksWithFilters(
                search, null, genre, minPrice, maxPrice, inStock, page, size, sortBy, sortDir);
        }

        // Add data to model
        model.addAttribute("books", booksPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", booksPage.getTotalPages());
        model.addAttribute("totalElements", booksPage.getTotalElements());
        model.addAttribute("size", size);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("search", search);
        model.addAttribute("genre", genre);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("inStock", inStock);
        
        // Add genres for filter dropdown
        model.addAttribute("genres", bookService.getAllGenres());
        
        return "books/bookList";
    }

    // Display book details
    @GetMapping("/{id}")
    public String getBookDetails(@PathVariable Long id, Model model, HttpServletRequest request) {
        try {
            Optional<Book> book = bookService.getBookById(id);
            if (book.isPresent()) {
                model.addAttribute("book", book.get());
                model.addAttribute("relatedBooks", new ArrayList<>());
                try {
                    List<Feedback> bookFeedback = feedbackService.getFeedbackForBook(id);
                    Double averageRating = feedbackService.getAverageRatingForBook(id);
                    Long feedbackCount = feedbackService.getFeedbackCountForBook(id);

                    // Convert Feedback to FeedbackDTO for JSP compatibility
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
                    model.addAttribute("bookFeedback", feedbackList);
                    model.addAttribute("averageRating", averageRating);
                    model.addAttribute("feedbackCount", feedbackCount);

                    Long customerId = SessionUtils.getCurrentCustomerId(request.getSession());
                    model.addAttribute("currentCustomerId", customerId);
                    if (customerId != null) {
                        Optional<Feedback> existingFeedback = feedbackService.getCustomerBookFeedback(customerId, id);
                        model.addAttribute("existingFeedback", existingFeedback.orElse(null));
                        model.addAttribute("hasLeftFeedback", existingFeedback.isPresent());
                    }
                } catch (Exception e) {
                    System.err.println("Error loading feedback: " + e.getMessage());
                }
                return "books/bookDetails";
            } else {
                model.addAttribute("error", "Book not found");
                return "error";
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "An error occurred: " + e.getMessage());
            return "error";
        }
    }

    // Submit book feedback
    @PostMapping("/{id}/feedback")
    public String submitBookFeedback(@PathVariable Long id,
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

            feedbackService.addBookFeedback(customerId, id, rating, comment);
            return "redirect:/books/" + id + "?success=true";
        } catch (Exception e) {
            model.addAttribute("error", "Error submitting feedback: " + e.getMessage());
            return "error";
        }
    }

    // Search books (AJAX endpoint)
    @GetMapping("/search")
    @ResponseBody
    public List<Book> searchBooks(@RequestParam String q) {
        return bookService.searchBooks(q);
    }

    // Filter books by genre
    @GetMapping("/genre/{genre}")
    public String getBooksByGenre(
            @PathVariable String genre,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "12") int size,
            @RequestParam(value = "sortBy", defaultValue = "title") String sortBy,
            @RequestParam(value = "sortDir", defaultValue = "asc") String sortDir,
            Model model) {

        Page<Book> booksPage = bookService.searchBooksWithFilters(
            null, null, genre, null, null, null, page, size, sortBy, sortDir);

        model.addAttribute("books", booksPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", booksPage.getTotalPages());
        model.addAttribute("totalElements", booksPage.getTotalElements());
        model.addAttribute("size", size);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("genre", genre);
        model.addAttribute("genres", bookService.getAllGenres());

        return "books/bookList";
    }

    // Sort books
    @GetMapping("/sort")
    public String sortBooks(
            @RequestParam String sortBy,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "12") int size,
            @RequestParam(value = "sortDir", defaultValue = "asc") String sortDir,
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "genre", required = false) String genre,
            @RequestParam(value = "minPrice", required = false) Double minPrice,
            @RequestParam(value = "maxPrice", required = false) Double maxPrice,
            @RequestParam(value = "inStock", required = false) Boolean inStock,
            Model model) {

        Page<Book> booksPage = bookService.searchBooksWithFilters(
            search, null, genre, minPrice, maxPrice, inStock, page, size, sortBy, sortDir);

        model.addAttribute("books", booksPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", booksPage.getTotalPages());
        model.addAttribute("totalElements", booksPage.getTotalElements());
        model.addAttribute("size", size);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("search", search);
        model.addAttribute("genre", genre);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("inStock", inStock);
        model.addAttribute("genres", bookService.getAllGenres());

        return "books/bookList";
    }

    // Get featured books (for homepage)
    @GetMapping("/featured")
    @ResponseBody
    public List<Book> getFeaturedBooks(@RequestParam(defaultValue = "8") int limit) {
        return bookService.getFeaturedBooks(limit);
    }

    // Get new arrivals
    @GetMapping("/new-arrivals")
    public String getNewArrivals(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "12") int size,
            Model model) {

        Page<Book> booksPage = bookService.getBooksWithPaginationAndSorting(
            page, size, "createdAt", "desc");

        model.addAttribute("books", booksPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", booksPage.getTotalPages());
        model.addAttribute("totalElements", booksPage.getTotalElements());
        model.addAttribute("size", size);
        model.addAttribute("sortBy", "createdAt");
        model.addAttribute("sortDir", "desc");
        model.addAttribute("genres", bookService.getAllGenres());
        model.addAttribute("pageTitle", "New Arrivals");

        return "books/bookList";
    }

    // Get bestsellers
    @GetMapping("/bestsellers")
    public String getBestsellers(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "12") int size,
            Model model) {

        Page<Book> booksPage = bookService.getBooksWithPaginationAndSorting(
            page, size, "rating", "desc");

        model.addAttribute("books", booksPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", booksPage.getTotalPages());
        model.addAttribute("totalElements", booksPage.getTotalElements());
        model.addAttribute("size", size);
        model.addAttribute("sortBy", "rating");
        model.addAttribute("sortDir", "desc");
        model.addAttribute("genres", bookService.getAllGenres());
        model.addAttribute("pageTitle", "Bestsellers");

        return "books/bookList";
    }

    // Get books in stock
    @GetMapping("/in-stock")
    public String getBooksInStock(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "12") int size,
            @RequestParam(value = "sortBy", defaultValue = "title") String sortBy,
            @RequestParam(value = "sortDir", defaultValue = "asc") String sortDir,
            Model model) {

        Page<Book> booksPage = bookService.searchBooksWithFilters(
            null, null, null, null, null, true, page, size, sortBy, sortDir);

        model.addAttribute("books", booksPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", booksPage.getTotalPages());
        model.addAttribute("totalElements", booksPage.getTotalElements());
        model.addAttribute("size", size);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("genres", bookService.getAllGenres());
        model.addAttribute("pageTitle", "Books In Stock");

        return "books/bookList";
    }

    // Advanced search form
    @GetMapping("/search/advanced")
    public String showAdvancedSearch(Model model) {
        model.addAttribute("genres", bookService.getAllGenres());
        return "books/advancedSearch";
    }

    // Process advanced search
    @PostMapping("/search/advanced")
    public String processAdvancedSearch(
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String author,
            @RequestParam(required = false) String genre,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(required = false) Boolean inStock,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "12") int size,
            @RequestParam(value = "sortBy", defaultValue = "title") String sortBy,
            @RequestParam(value = "sortDir", defaultValue = "asc") String sortDir,
            Model model) {

        Page<Book> booksPage = bookService.searchBooksWithFilters(
            title, author, genre, minPrice, maxPrice, inStock, page, size, sortBy, sortDir);

        model.addAttribute("books", booksPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", booksPage.getTotalPages());
        model.addAttribute("totalElements", booksPage.getTotalElements());
        model.addAttribute("size", size);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("title", title);
        model.addAttribute("author", author);
        model.addAttribute("genre", genre);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("inStock", inStock);
        model.addAttribute("genres", bookService.getAllGenres());
        model.addAttribute("pageTitle", "Search Results");

        return "books/bookList";
    }
}
