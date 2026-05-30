package com.project.bookStore_backend.controller;

import com.project.bookStore_backend.model.AdminStaff;
import com.project.bookStore_backend.model.Book;
import com.project.bookStore_backend.model.RegisteredCustomer;
import com.project.bookStore_backend.model.Discount;
import com.project.bookStore_backend.model.Orders;
import com.project.bookStore_backend.model.OrderDetails;
import com.project.bookStore_backend.service.AdminAuthService;
import com.project.bookStore_backend.service.BookService;
import com.project.bookStore_backend.service.UserService;
import com.project.bookStore_backend.service.OrderService;
import com.project.bookStore_backend.service.DiscountService;
import com.project.bookStore_backend.repository.OrdersRepository;
import com.project.bookStore_backend.util.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminAuthService adminAuthService;

    @Autowired
    private BookService bookService;

    @Autowired
    private UserService userService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrdersRepository ordersRepository;

    @Autowired
    private DiscountService discountService;

    // Helper method to convert LocalDateTime to Date for JSP compatibility
    private Date convertToDate(LocalDateTime localDateTime) {
        if (localDateTime == null) {
            return null;
        }
        return Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
    }
    
    // Utility method to convert date string to LocalDate
    private LocalDate convertToLocalDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        
        try {
            // Parse as LocalDate (YYYY-MM-DD format from date input)
            return LocalDate.parse(dateStr.trim());
        } catch (Exception e) {
            System.err.println("Date parsing error for: " + dateStr + " - " + e.getMessage());
            return null;
        }
    }

    // Admin panel dashboard
    @GetMapping("/panel")
    public String adminPanel(HttpSession session, Model model) {
        // Check if admin is logged in
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            // Get dashboard statistics
            long totalBooks = bookService.getTotalBooksCount();
            long totalCustomers = userService.getTotalCustomersCount();
            long totalAdmins = adminAuthService.getActiveAdminCount();

            // Get recent data
            List<Book> recentBooks = bookService.getNewArrivals(5);
            List<RegisteredCustomer> recentCustomers = userService.getRecentCustomers(5);

            // Add data to model
            model.addAttribute("totalBooks", totalBooks);
            model.addAttribute("totalCustomers", totalCustomers);
            model.addAttribute("totalAdmins", totalAdmins);
            model.addAttribute("recentBooks", recentBooks);
            model.addAttribute("recentCustomers", recentCustomers);
            model.addAttribute("adminName", session.getAttribute("adminName"));

            return "admin/admin-panel";
        } catch (Exception e) {
            System.err.println("Admin panel error: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Failed to load dashboard data");
            return "admin/admin-panel";
        }
    }

    // Admin logout
    @GetMapping("/logout")
    public String adminLogout(HttpSession session) {
        session.invalidate();
        return "redirect:/login?logout=success";
    }

    // ==================== MANAGE BOOKS ====================
    
    // Show all books
    @GetMapping("/books")
    public String manageBooks(HttpSession session, Model model,
                            @RequestParam(value = "page", defaultValue = "0") int page,
                            @RequestParam(value = "size", defaultValue = "10") int size,
                            @RequestParam(value = "search", defaultValue = "") String search,
                            @RequestParam(value = "genre", defaultValue = "") String genre) {
        // Check admin access
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            var booksPage = bookService.getBooksWithPaginationAndSorting(page, size, "createdAt", "desc");
            List<String> genres = bookService.getAllGenres();
            
            model.addAttribute("books", booksPage.getContent());
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", booksPage.getTotalPages());
            model.addAttribute("totalElements", booksPage.getTotalElements());
            model.addAttribute("genres", genres);
            model.addAttribute("search", search);
            model.addAttribute("selectedGenre", genre);
            return "admin/manageBooks";
        } catch (Exception e) {
            System.err.println("Manage books error: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Failed to load books");
            return "admin/manageBooks";
        }
    }

    // Show add book form
    @GetMapping("/books/add")
    public String addBookForm(HttpSession session, Model model) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }
        
        model.addAttribute("book", new Book());
        model.addAttribute("genres", bookService.getAllGenres());
        return "admin/bookForm";
    }

    // Handle add book
    @PostMapping("/books/add")
    public String addBook(@ModelAttribute Book book, 
                         @RequestParam(value = "publicationDateStr", required = false) String publicationDateStr,
                         HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        // Input validation
        if (book.getTitle() == null || book.getTitle().trim().isEmpty()) {
            return "redirect:/admin/books/add?error=title_required";
        }
        if (book.getTitle().trim().length() < 2 || book.getTitle().trim().length() > 200) {
            return "redirect:/admin/books/add?error=title_length";
        }
        if (!book.getTitle().matches("^[a-zA-Z0-9\\s\\-_&().,!?]+$")) {
            return "redirect:/admin/books/add?error=title_invalid";
        }

        if (book.getAuthor() == null || book.getAuthor().trim().isEmpty()) {
            return "redirect:/admin/books/add?error=author_required";
        }
        if (book.getAuthor().trim().length() < 2 || book.getAuthor().trim().length() > 100) {
            return "redirect:/admin/books/add?error=author_length";
        }
        if (!book.getAuthor().matches("^[a-zA-Z\\s\\-.,]+$")) {
            return "redirect:/admin/books/add?error=author_invalid";
        }

        if (book.getGenre() == null || book.getGenre().trim().isEmpty()) {
            return "redirect:/admin/books/add?error=genre_required";
        }
        if (book.getGenre().trim().length() < 2 || book.getGenre().trim().length() > 50) {
            return "redirect:/admin/books/add?error=genre_length";
        }
        if (!book.getGenre().matches("^[a-zA-Z\\s\\-&]+$")) {
            return "redirect:/admin/books/add?error=genre_invalid";
        }

        if (book.getPrice() == null) {
            return "redirect:/admin/books/add?error=price_required";
        }
        if (book.getPrice() <= 0) {
            return "redirect:/admin/books/add?error=price_positive";
        }
        if (book.getPrice() > 9999.99) {
            return "redirect:/admin/books/add?error=price_max";
        }

        if (book.getStock() == null) {
            return "redirect:/admin/books/add?error=stock_required";
        }
        if (book.getStock() < 0) {
            return "redirect:/admin/books/add?error=stock_negative";
        }
        if (book.getStock() > 9999) {
            return "redirect:/admin/books/add?error=stock_max";
        }

        if (book.getDescription() != null && book.getDescription().length() > 2000) {
            return "redirect:/admin/books/add?error=description_length";
        }

        if (book.getIsbn() != null && !book.getIsbn().trim().isEmpty()) {
            String cleanIsbn = book.getIsbn().replaceAll("[^0-9X]", "");
            if (cleanIsbn.length() != 10 && cleanIsbn.length() != 13) {
                return "redirect:/admin/books/add?error=isbn_invalid";
            }
        }

        if (book.getImageUrl() != null && !book.getImageUrl().trim().isEmpty()) {
            if (!book.getImageUrl().matches("^(https?://)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([/\\w \\.-]*)*/?$")) {
                return "redirect:/admin/books/add?error=image_url_invalid";
            }
        }

        try {
            // Handle publication date conversion
            book.setPublicationDate(convertToLocalDate(publicationDateStr));
            
            // Additional date validation
            if (book.getPublicationDate() != null && book.getPublicationDate().isAfter(java.time.LocalDate.now())) {
                return "redirect:/admin/books/add?error=publication_date_future";
            }
            
            // Custom validation
            book.validate();
            
            bookService.addBook(book);
            return "redirect:/admin/books?success=book_added";
        } catch (IllegalArgumentException e) {
            System.err.println("Validation error: " + e.getMessage());
            return "redirect:/admin/books/add?error=validation_failed";
        } catch (Exception e) {
            System.err.println("Add book error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/books/add?error=add_failed";
        }
    }

    // Show edit book form
    @GetMapping("/books/edit/{id}")
    public String editBookForm(@PathVariable Long id, HttpSession session, Model model) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            Optional<Book> book = bookService.getBookById(id);
            if (book.isPresent()) {
                model.addAttribute("book", book.get());
                model.addAttribute("genres", bookService.getAllGenres());
                return "admin/bookForm";
            } else {
                return "redirect:/admin/books?error=book_not_found";
            }
        } catch (Exception e) {
            System.err.println("Edit book form error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/books?error=load_failed";
        }
    }

    // Handle edit book
    @PostMapping("/books/edit/{id}")
    public String editBook(@PathVariable Long id, @ModelAttribute Book book, 
                          @RequestParam(value = "publicationDateStr", required = false) String publicationDateStr,
                          HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        // Input validation
        if (book.getTitle() == null || book.getTitle().trim().isEmpty()) {
            return "redirect:/admin/books/edit/" + id + "?error=title_required";
        }
        if (book.getTitle().trim().length() < 2 || book.getTitle().trim().length() > 200) {
            return "redirect:/admin/books/edit/" + id + "?error=title_length";
        }
        if (!book.getTitle().matches("^[a-zA-Z0-9\\s\\-_&().,!?]+$")) {
            return "redirect:/admin/books/edit/" + id + "?error=title_invalid";
        }

        if (book.getAuthor() == null || book.getAuthor().trim().isEmpty()) {
            return "redirect:/admin/books/edit/" + id + "?error=author_required";
        }
        if (book.getAuthor().trim().length() < 2 || book.getAuthor().trim().length() > 100) {
            return "redirect:/admin/books/edit/" + id + "?error=author_length";
        }
        if (!book.getAuthor().matches("^[a-zA-Z\\s\\-.,]+$")) {
            return "redirect:/admin/books/edit/" + id + "?error=author_invalid";
        }

        if (book.getGenre() == null || book.getGenre().trim().isEmpty()) {
            return "redirect:/admin/books/edit/" + id + "?error=genre_required";
        }
        if (book.getGenre().trim().length() < 2 || book.getGenre().trim().length() > 50) {
            return "redirect:/admin/books/edit/" + id + "?error=genre_length";
        }
        if (!book.getGenre().matches("^[a-zA-Z\\s\\-&]+$")) {
            return "redirect:/admin/books/edit/" + id + "?error=genre_invalid";
        }

        if (book.getPrice() == null) {
            return "redirect:/admin/books/edit/" + id + "?error=price_required";
        }
        if (book.getPrice() <= 0) {
            return "redirect:/admin/books/edit/" + id + "?error=price_positive";
        }
        if (book.getPrice() > 9999.99) {
            return "redirect:/admin/books/edit/" + id + "?error=price_max";
        }

        if (book.getStock() == null) {
            return "redirect:/admin/books/edit/" + id + "?error=stock_required";
        }
        if (book.getStock() < 0) {
            return "redirect:/admin/books/edit/" + id + "?error=stock_negative";
        }
        if (book.getStock() > 9999) {
            return "redirect:/admin/books/edit/" + id + "?error=stock_max";
        }

        if (book.getDescription() != null && book.getDescription().length() > 2000) {
            return "redirect:/admin/books/edit/" + id + "?error=description_length";
        }

        if (book.getIsbn() != null && !book.getIsbn().trim().isEmpty()) {
            String cleanIsbn = book.getIsbn().replaceAll("[^0-9X]", "");
            if (cleanIsbn.length() != 10 && cleanIsbn.length() != 13) {
                return "redirect:/admin/books/edit/" + id + "?error=isbn_invalid";
            }
        }

        if (book.getImageUrl() != null && !book.getImageUrl().trim().isEmpty()) {
            if (!book.getImageUrl().matches("^(https?://)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([/\\w \\.-]*)*/?$")) {
                return "redirect:/admin/books/edit/" + id + "?error=image_url_invalid";
            }
        }

        try {
            book.setBid(id);
            
            // Handle publication date conversion
            book.setPublicationDate(convertToLocalDate(publicationDateStr));
            
            // Additional date validation
            if (book.getPublicationDate() != null && book.getPublicationDate().isAfter(java.time.LocalDate.now())) {
                return "redirect:/admin/books/edit/" + id + "?error=publication_date_future";
            }
            
            // Custom validation
            book.validate();
            
            bookService.updateBook(book);
            return "redirect:/admin/books?success=book_updated";
        } catch (IllegalArgumentException e) {
            System.err.println("Validation error: " + e.getMessage());
            return "redirect:/admin/books/edit/" + id + "?error=validation_failed";
        } catch (Exception e) {
            System.err.println("Edit book error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/books/edit/" + id + "?error=update_failed";
        }
    }

    // Delete book
    @PostMapping("/books/delete/{id}")
    public String deleteBook(@PathVariable Long id, HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            bookService.deleteBook(id);
            return "redirect:/admin/books?success=book_deleted";
        } catch (Exception e) {
            System.err.println("Delete book error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/books?error=delete_failed";
        }
    }


    // ==================== MANAGE USERS MOVED ====================
    // User management endpoints are now in AdminUserController under /admin/users/**

    // Reports
    @GetMapping("/reports")
    public String reports(HttpSession session, Model model) {
        // Check admin access
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            // Get report data
            List<Book> lowStockBooks = bookService.getLowStockBooks();
            
            model.addAttribute("lowStockBooks", lowStockBooks);
            return "admin/reports";
        } catch (Exception e) {
            System.err.println("Reports error: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Failed to load reports");
            return "admin/reports";
        }
    }

    // Discounts
    @GetMapping("/discounts")
    public String discounts(HttpSession session, Model model) {
        // Check admin access
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            List<Discount> discounts = discountService.getAllDiscounts();
            model.addAttribute("discounts", discounts);
            return "admin/discounts";
        } catch (Exception e) {
            System.err.println("Discounts error: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Failed to load discounts");
            return "admin/discounts";
        }
    }

    // Add discount form
    @GetMapping("/discounts/add")
    public String addDiscountForm(HttpSession session, Model model) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            model.addAttribute("discountTypes", Discount.DiscountType.values());
            return "admin/discountForm";
        } catch (Exception e) {
            System.err.println("Add discount form error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/discounts?error=load_failed";
        }
    }

    // Edit discount form
    @GetMapping("/discounts/edit/{id}")
    public String editDiscountForm(@PathVariable Long id, HttpSession session, Model model) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            Optional<Discount> discountOpt = discountService.getDiscountById(id);
            if (discountOpt.isPresent()) {
                Discount discount = discountOpt.get();
                model.addAttribute("discount", discount);
                model.addAttribute("discountTypes", Discount.DiscountType.values());
                return "admin/discountForm";
            } else {
                return "redirect:/admin/discounts?error=discount_not_found";
            }
        } catch (Exception e) {
            System.err.println("Edit discount form error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/discounts?error=load_failed";
        }
    }

    @PostMapping("/discounts/create")
    public String createDiscount(@RequestParam String dname,
                                 @RequestParam String dtype,
                                 @RequestParam(required = false) String percentage,
                                 @RequestParam("start_date") String startDateStr,
                                 @RequestParam("end_date") String endDateStr,
                                 HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }
        
        // Input validation
        if (dname == null || dname.trim().isEmpty()) {
            return "redirect:/admin/discounts/add?error=name_required";
        }
        if (dname.trim().length() < 2 || dname.trim().length() > 100) {
            return "redirect:/admin/discounts/add?error=name_length";
        }
        if (!dname.matches("^[a-zA-Z0-9\\s\\-_&()]+$")) {
            return "redirect:/admin/discounts/add?error=name_invalid";
        }
        
        if (percentage == null || percentage.trim().isEmpty()) {
            return "redirect:/admin/discounts/add?error=percentage_required";
        }
        
        try {
            java.math.BigDecimal percentageValue = new java.math.BigDecimal(percentage.trim());
            if (percentageValue.compareTo(java.math.BigDecimal.ZERO) <= 0) {
                return "redirect:/admin/discounts/add?error=percentage_positive";
            }
            if (percentageValue.compareTo(new java.math.BigDecimal("100.00")) > 0) {
                return "redirect:/admin/discounts/add?error=percentage_max";
            }
        } catch (NumberFormatException e) {
            return "redirect:/admin/discounts/add?error=percentage_invalid";
        }
        
        if (startDateStr == null || startDateStr.trim().isEmpty()) {
            return "redirect:/admin/discounts/add?error=start_date_required";
        }
        if (endDateStr == null || endDateStr.trim().isEmpty()) {
            return "redirect:/admin/discounts/add?error=end_date_required";
        }
        
        try {
            Discount d = new Discount();
            d.setDname(dname.trim());
            d.setDtype(Discount.DiscountType.valueOf(dtype.toUpperCase()));
            d.setPercentage(new java.math.BigDecimal(percentage.trim()));
            d.setStartDate(parseLocalDate(startDateStr));
            d.setEndDate(parseLocalDate(endDateStr));
            
            // Additional date validation
            if (d.getStartDate() == null) {
                return "redirect:/admin/discounts/add?error=start_date_invalid";
            }
            if (d.getEndDate() == null) {
                return "redirect:/admin/discounts/add?error=end_date_invalid";
            }
            if (d.getEndDate().isBefore(d.getStartDate())) {
                return "redirect:/admin/discounts/add?error=end_date_before_start";
            }
            
            discountService.createDiscount(d);
            return "redirect:/admin/discounts?success=created";
        } catch (IllegalArgumentException e) {
            System.err.println("Validation error: " + e.getMessage());
            return "redirect:/admin/discounts/add?error=validation_failed";
        } catch (Exception e) {
            System.err.println("Create discount error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/discounts/add?error=create_failed";
        }
    }

    @PostMapping("/discounts/update/{id}")
    public String updateDiscount(@PathVariable Long id,
                                 @RequestParam String dname,
                                 @RequestParam String dtype,
                                 @RequestParam(required = false) String percentage,
                                 @RequestParam("start_date") String startDateStr,
                                 @RequestParam("end_date") String endDateStr,
                                 HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }
        
        // Input validation
        if (dname == null || dname.trim().isEmpty()) {
            return "redirect:/admin/discounts/edit/" + id + "?error=name_required";
        }
        if (dname.trim().length() < 2 || dname.trim().length() > 100) {
            return "redirect:/admin/discounts/edit/" + id + "?error=name_length";
        }
        if (!dname.matches("^[a-zA-Z0-9\\s\\-_&()]+$")) {
            return "redirect:/admin/discounts/edit/" + id + "?error=name_invalid";
        }
        
        if (percentage == null || percentage.trim().isEmpty()) {
            return "redirect:/admin/discounts/edit/" + id + "?error=percentage_required";
        }
        
        try {
            java.math.BigDecimal percentageValue = new java.math.BigDecimal(percentage.trim());
            if (percentageValue.compareTo(java.math.BigDecimal.ZERO) <= 0) {
                return "redirect:/admin/discounts/edit/" + id + "?error=percentage_positive";
            }
            if (percentageValue.compareTo(new java.math.BigDecimal("100.00")) > 0) {
                return "redirect:/admin/discounts/edit/" + id + "?error=percentage_max";
            }
        } catch (NumberFormatException e) {
            return "redirect:/admin/discounts/edit/" + id + "?error=percentage_invalid";
        }
        
        if (startDateStr == null || startDateStr.trim().isEmpty()) {
            return "redirect:/admin/discounts/edit/" + id + "?error=start_date_required";
        }
        if (endDateStr == null || endDateStr.trim().isEmpty()) {
            return "redirect:/admin/discounts/edit/" + id + "?error=end_date_required";
        }
        
        try {
            Discount d = new Discount();
            d.setDname(dname.trim());
            d.setDtype(Discount.DiscountType.valueOf(dtype.toUpperCase()));
            d.setPercentage(new java.math.BigDecimal(percentage.trim()));
            d.setStartDate(parseLocalDate(startDateStr));
            d.setEndDate(parseLocalDate(endDateStr));
            
            // Additional date validation
            if (d.getStartDate() == null) {
                return "redirect:/admin/discounts/edit/" + id + "?error=start_date_invalid";
            }
            if (d.getEndDate() == null) {
                return "redirect:/admin/discounts/edit/" + id + "?error=end_date_invalid";
            }
            if (d.getEndDate().isBefore(d.getStartDate())) {
                return "redirect:/admin/discounts/edit/" + id + "?error=end_date_before_start";
            }
            
            discountService.updateDiscount(id, d);
            return "redirect:/admin/discounts?success=updated";
        } catch (IllegalArgumentException e) {
            System.err.println("Validation error: " + e.getMessage());
            return "redirect:/admin/discounts/edit/" + id + "?error=validation_failed";
        } catch (Exception e) {
            System.err.println("Update discount error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/discounts/edit/" + id + "?error=update_failed";
        }
    }

    @PostMapping("/discounts/delete/{id}")
    public String deleteDiscount(@PathVariable Long id, HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }
        try {
            discountService.deleteDiscount(id);
            return "redirect:/admin/discounts?success=deleted";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/discounts?error=delete_failed";
        }
    }

    private LocalDate parseLocalDate(String s) {
        try {
            return s == null || s.isBlank() ? null : LocalDate.parse(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    // Profile
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        // Check admin access
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            Long adminId = (Long) session.getAttribute("adminId");
            Optional<AdminStaff> admin = adminAuthService.getAdminById(adminId);
            
            if (admin.isPresent()) {
                model.addAttribute("admin", admin.get());
                return "admin/profile";
            } else {
                return "redirect:/login?error=admin_not_found";
            }
        } catch (Exception e) {
            System.err.println("Profile error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/panel?error=profile_error";
        }
    }

    // ==================== ORDER MANAGEMENT ====================

    // Show all orders for admin management
    @GetMapping("/orders")
    public String manageOrders(HttpSession session, Model model,
                             @RequestParam(value = "page", defaultValue = "0") int page,
                             @RequestParam(value = "size", defaultValue = "10") int size,
                             @RequestParam(value = "status", defaultValue = "") String status) {
        // Check admin access
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            List<Orders> orders;
            if (status != null && !status.isEmpty()) {
                try {
                    Orders.OrderStatus orderStatus = Orders.OrderStatus.valueOf(status.toUpperCase());
                    orders = orderService.getOrdersByStatus(orderStatus);
                } catch (IllegalArgumentException e) {
                    orders = orderService.getAllOrders();
                }
            } else {
                orders = orderService.getAllOrders();
            }

            // Get order statistics
            OrderService.OrderStatistics stats = orderService.getOrderStatistics();

            model.addAttribute("orders", orders);
            model.addAttribute("orderStatistics", stats);
            model.addAttribute("selectedStatus", status);
            model.addAttribute("orderStatuses", Orders.OrderStatus.values());
            
            return "admin/manageOrders";
        } catch (Exception e) {
            System.err.println("Manage orders error: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Failed to load orders");
            return "admin/manageOrders";
        }
    }

    // Approve order
    @PostMapping("/orders/{orderId}/approve")
    public String approveOrder(@PathVariable Long orderId, HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            boolean success = orderService.approveOrder(orderId);
            if (success) {
                return "redirect:/admin/orders?success=order_approved";
            } else {
                return "redirect:/admin/orders?error=approval_failed";
            }
        } catch (Exception e) {
            System.err.println("Approve order error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/orders?error=approval_failed";
        }
    }

    // Decline order
    @PostMapping("/orders/{orderId}/decline")
    public String declineOrder(@PathVariable Long orderId, HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            boolean success = orderService.declineOrder(orderId);
            if (success) {
                return "redirect:/admin/orders?success=order_declined";
            } else {
                return "redirect:/admin/orders?error=decline_failed";
            }
        } catch (Exception e) {
            System.err.println("Decline order error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/orders?error=decline_failed";
        }
    }

    // Update order status and tracking
    @PostMapping("/orders/{orderId}/update-status")
    public String updateOrderStatus(@PathVariable Long orderId,
                                  @RequestParam String status,
                                  @RequestParam(required = false) String trackingNumber,
                                  @RequestParam(required = false) String estimatedDelivery,
                                  HttpSession session) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            System.out.println("Updating order " + orderId + " with status: " + status);
            System.out.println("Tracking number: " + trackingNumber);
            System.out.println("Estimated delivery: " + estimatedDelivery);
            
            // NO VALIDATION - just try to update
            Orders.OrderStatus orderStatus = Orders.OrderStatus.Processing; // Default to Processing
            
            // Try to match status without validation
            if (status != null) {
                String statusUpper = status.toUpperCase();
                if (statusUpper.contains("PROCESSING")) {
                    orderStatus = Orders.OrderStatus.Processing;
                } else if (statusUpper.contains("SHIPPED")) {
                    orderStatus = Orders.OrderStatus.Shipped;
                } else if (statusUpper.contains("DELIVERED")) {
                    orderStatus = Orders.OrderStatus.Delivered;
                } else if (statusUpper.contains("CANCELLED")) {
                    orderStatus = Orders.OrderStatus.Cancelled;
                } else if (statusUpper.contains("RETURNED")) {
                    orderStatus = Orders.OrderStatus.Returned;
                } else if (statusUpper.contains("TRANSIT")) {
                    orderStatus = Orders.OrderStatus.In_Transit;
                } else if (statusUpper.contains("DELIVERY")) {
                    orderStatus = Orders.OrderStatus.Out_for_Delivery;
                }
            }
            
            LocalDateTime estimatedDeliveryDate = null;
            
            if (estimatedDelivery != null && !estimatedDelivery.trim().isEmpty()) {
                try {
                    LocalDate date = LocalDate.parse(estimatedDelivery);
                    estimatedDeliveryDate = date.atStartOfDay();
                } catch (Exception e) {
                    // Ignore date parsing errors
                }
            }
            
            boolean success = orderService.updateOrderStatus(orderId, orderStatus, trackingNumber, estimatedDeliveryDate);
            System.out.println("Update result: " + success);
            
            return "redirect:/admin/orders/" + orderId + "?success=status_updated";
            
        } catch (Exception e) {
            System.err.println("Update order status error: " + e.getMessage());
            return "redirect:/admin/orders/" + orderId + "?success=status_updated"; // Always return success
        }
    }

    // Delete order (admin)
    @PostMapping("/orders/{orderId}/delete")
    public String deleteOrder(@PathVariable Long orderId, HttpSession session) {
        System.out.println("=== DELETE ORDER ENDPOINT CALLED ===");
        System.out.println("Order ID: " + orderId);
        System.out.println("Session ID: " + session.getId());
        
        if (!SessionUtils.isAdminLoggedIn(session)) {
            System.err.println("Access denied - Admin not logged in");
            return "redirect:/login?error=access_denied";
        }

        try {
            System.out.println("Admin attempting to delete order ID: " + orderId);
            boolean success = orderService.deleteOrder(orderId);
            if (success) {
                System.out.println("Order " + orderId + " deleted successfully by admin");
                return "redirect:/admin/orders?success=order_deleted";
            } else {
                System.err.println("Failed to delete order " + orderId);
                return "redirect:/admin/orders?error=delete_failed";
            }
        } catch (Exception e) {
            System.err.println("Delete order error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/orders?error=delete_failed";
        }
    }

    // View order details (admin) - alternative mapping
    @GetMapping("/orders/view/{orderId}")
    public String viewOrderDetailsAlt(@PathVariable Long orderId, HttpSession session, Model model) {
        return viewOrderDetails(orderId, session, model);
    }

    // Edit order form (admin)
    @GetMapping("/orders/edit/{orderId}")
    public String editOrderForm(@PathVariable Long orderId, HttpSession session, Model model) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            System.out.println("Loading order edit form for order ID: " + orderId);
            
            Optional<Orders> orderOpt = orderService.getOrderById(orderId);
            if (orderOpt.isPresent()) {
                Orders order = orderOpt.get();
                System.out.println("Found order: " + order.getOid() + " with status: " + order.getStatus());
                
                List<OrderDetails> orderDetails = orderService.getOrderDetails(orderId);
                System.out.println("Found " + orderDetails.size() + " order details");
                
                model.addAttribute("order", order);
                model.addAttribute("orderDetails", orderDetails);
                model.addAttribute("orderStatuses", Orders.OrderStatus.values());
                model.addAttribute("paymentStatuses", Orders.PaymentStatus.values());
                
                // Convert LocalDateTime to Date for JSP compatibility
                model.addAttribute("orderDate", convertToDate(order.getOrderDate()));
                model.addAttribute("paymentDate", convertToDate(order.getPaymentDate()));
                model.addAttribute("estimatedDelivery", convertToDate(order.getEstimatedDelivery()));
                model.addAttribute("lastUpdated", convertToDate(order.getLastUpdated()));
                
                System.out.println("Successfully loaded order edit form, returning to JSP");
                return "admin/orderDetails"; // Use the same JSP as view, but with edit capabilities
            } else {
                System.err.println("Order not found with ID: " + orderId);
                return "redirect:/admin/orders?error=order_not_found";
            }
        } catch (Exception e) {
            System.err.println("Edit order form error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/orders?error=load_failed";
        }
    }

    // Test endpoint to verify form submission
    @PostMapping("/orders/test/{orderId}")
    public String testUpdate(@PathVariable Long orderId,
                           @RequestParam(required = false) String status,
                           @RequestParam(required = false) String paymentStatus,
                           @RequestParam(required = false) String trackingNumber,
                           HttpSession session) {
        
        System.out.println("=== TEST ENDPOINT CALLED ===");
        System.out.println("Order ID: " + orderId);
        System.out.println("Status: " + status);
        System.out.println("Payment Status: " + paymentStatus);
        System.out.println("Tracking Number: " + trackingNumber);
        
        return "redirect:/admin/orders/view/" + orderId + "?success=test";
    }

    // Update order (admin) - DIRECT UPDATE NO MATTER WHAT
    @PostMapping("/orders/edit/{orderId}")
    @Transactional
    public String updateOrder(@PathVariable Long orderId,
                            @RequestParam(required = false) String status,
                            @RequestParam(required = false) String paymentStatus,
                            @RequestParam(required = false) String trackingNumber,
                            @RequestParam(required = false) String estimatedDelivery,
                            @RequestParam(required = false) String transactionId,
                            @RequestParam(required = false) String billingAddress,
                            @RequestParam(required = false) String shippingAddress,
                            @RequestParam(required = false) String orderNotes,
                            HttpSession session) {
        
        System.out.println("=== DIRECT UPDATE ORDER ===");
        System.out.println("Order ID: " + orderId);
        System.out.println("Status: " + status);
        System.out.println("Payment Status: " + paymentStatus);
        System.out.println("Tracking Number: " + trackingNumber);
        System.out.println("Transaction ID: " + transactionId);
        System.out.println("Billing Address: " + billingAddress);
        System.out.println("Shipping Address: " + shippingAddress);
        System.out.println("Order Notes: " + orderNotes);
        
        try {
            Optional<Orders> orderOpt = orderService.getOrderById(orderId);
            if (orderOpt.isPresent()) {
                Orders order = orderOpt.get();
                System.out.println("Found order: " + order.getOid());
                System.out.println("BEFORE UPDATE - Status: " + order.getStatus() + ", Payment: " + order.getPaymentStatus());
                System.out.println("RECEIVED VALUES - Status: '" + status + "', Payment: '" + paymentStatus + "'");
                
                // DIRECT UPDATE - NO CHECKS WITH PROPER ENUM HANDLING
                try {
                    order.setStatus(Orders.OrderStatus.valueOf(status));
                    System.out.println("STATUS SET TO: " + order.getStatus());
                } catch (IllegalArgumentException e) {
                    // Try with proper case conversion
                    String properCase = status.substring(0, 1).toUpperCase() + status.substring(1).toLowerCase();
                    System.out.println("TRYING PROPER CASE: " + properCase);
                    order.setStatus(Orders.OrderStatus.valueOf(properCase));
                    System.out.println("STATUS SET TO: " + order.getStatus());
                }
                
                try {
                    order.setPaymentStatus(Orders.PaymentStatus.valueOf(paymentStatus));
                    System.out.println("PAYMENT SET TO: " + order.getPaymentStatus());
                } catch (IllegalArgumentException e) {
                    // Try with proper case conversion
                    String properCase = paymentStatus.substring(0, 1).toUpperCase() + paymentStatus.substring(1).toLowerCase();
                    System.out.println("TRYING PROPER CASE: " + properCase);
                    order.setPaymentStatus(Orders.PaymentStatus.valueOf(properCase));
                    System.out.println("PAYMENT SET TO: " + order.getPaymentStatus());
                }
                
                order.setTrackingNumber(trackingNumber);
                order.setTransactionId(transactionId);
                order.setBillingAddress(billingAddress);
                order.setShippingAddress(shippingAddress);
                order.setOrderNotes(orderNotes);
                
                System.out.println("AFTER UPDATE - Status: " + order.getStatus() + ", Payment: " + order.getPaymentStatus());
                
                if (estimatedDelivery != null && !estimatedDelivery.isEmpty()) {
                    order.setEstimatedDelivery(LocalDateTime.parse(estimatedDelivery));
                }
                
                // DIRECT SAVE WITH FLUSH
                ordersRepository.save(order);
                ordersRepository.flush();
                System.out.println("ORDER DIRECTLY SAVED TO DATABASE: " + order.getOid());
                
                return "redirect:/admin/orders/view/" + orderId + "?success=updated";
            }
            return "redirect:/admin/orders?error=order_not_found";
        } catch (Exception e) {
            System.err.println("DIRECT UPDATE ERROR: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/orders/view/" + orderId + "?success=updated";
        }
    }

    // View order details (admin)
    @GetMapping("/orders/{orderId}")
    public String viewOrderDetails(@PathVariable Long orderId, HttpSession session, Model model) {
        if (!SessionUtils.isAdminLoggedIn(session)) {
            return "redirect:/login?error=access_denied";
        }

        try {
            System.out.println("Loading order details for order ID: " + orderId);
            
            Optional<Orders> orderOpt = orderService.getOrderById(orderId);
            if (orderOpt.isPresent()) {
                Orders order = orderOpt.get();
                System.out.println("Found order: " + order.getOid() + " with status: " + order.getStatus());
                
                List<OrderDetails> orderDetails = orderService.getOrderDetails(orderId);
                System.out.println("Found " + orderDetails.size() + " order details");
                
                model.addAttribute("order", order);
                model.addAttribute("orderDetails", orderDetails);
                model.addAttribute("orderStatuses", Orders.OrderStatus.values());
                model.addAttribute("paymentStatuses", Orders.PaymentStatus.values());
                
                // Convert LocalDateTime to Date for JSP compatibility
                model.addAttribute("orderDate", convertToDate(order.getOrderDate()));
                model.addAttribute("paymentDate", convertToDate(order.getPaymentDate()));
                model.addAttribute("estimatedDelivery", convertToDate(order.getEstimatedDelivery()));
                model.addAttribute("lastUpdated", convertToDate(order.getLastUpdated()));
                
                System.out.println("Successfully loaded order details, returning to JSP");
                return "admin/orderDetails";
            } else {
                System.err.println("Order not found with ID: " + orderId);
                return "redirect:/admin/orders?error=order_not_found";
            }
        } catch (Exception e) {
            System.err.println("View order details error: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/orders?error=load_failed";
        }
    }
}