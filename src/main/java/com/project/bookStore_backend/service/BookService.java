package com.project.bookStore_backend.service;

import com.project.bookStore_backend.model.Book;
import com.project.bookStore_backend.repository.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class BookService {

    @Autowired
    private BookRepository bookRepository;

    // Get all books
    public List<Book> getAllBooks() {
        return bookRepository.findAll();
    }

    // Get all books with pagination
    public Page<Book> getAllBooks(int page, int size, String sortBy, String sortDir) {
        Sort sort = sortDir.equalsIgnoreCase("desc") ? 
                   Sort.by(sortBy).descending() : 
                   Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);
        return bookRepository.findAll(pageable);
    }

    // Get book by ID
    public Optional<Book> getBookById(Long id) {
        return bookRepository.findById(id);
    }

    // Search books by title or author
    public List<Book> searchBooks(String searchTerm) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return getAllBooks();
        }
        return bookRepository.findByTitleOrAuthorContainingIgnoreCase(searchTerm.trim());
    }

    // Search books with pagination
    public Page<Book> searchBooks(String searchTerm, int page, int size, String sortBy, String sortDir) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return getAllBooks(page, size, sortBy, sortDir);
        }
        
        Sort sort = sortDir.equalsIgnoreCase("desc") ? 
                   Sort.by(sortBy).descending() : 
                   Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);
        
        return bookRepository.findBooksWithFiltersAndPagination(
            searchTerm, null, null, null, null, pageable);
    }

    // Filter books by genre
    public List<Book> getBooksByGenre(String genre) {
        if (genre == null || genre.trim().isEmpty()) {
            return getAllBooks();
        }
        return bookRepository.findByGenreIgnoreCase(genre.trim());
    }

    // Filter books by price range
    public List<Book> getBooksByPriceRange(Double minPrice, Double maxPrice) {
        if (minPrice == null && maxPrice == null) {
            return getAllBooks();
        }
        if (minPrice == null) {
            return bookRepository.findByPriceLessThan(maxPrice);
        }
        if (maxPrice == null) {
            return bookRepository.findByPriceLessThan(minPrice);
        }
        return bookRepository.findByPriceBetween(minPrice, maxPrice);
    }

    // Get books in stock
    public List<Book> getBooksInStock() {
        return bookRepository.findByStockGreaterThan(0);
    }

    // Get all unique genres
    public List<String> getAllGenres() {
        return bookRepository.findDistinctGenres();
    }

    // Advanced search with multiple filters
    public Page<Book> searchBooksWithFilters(String title, String author, String genre, 
                                           Double minPrice, Double maxPrice, Boolean inStock,
                                           int page, int size, String sortBy, String sortDir) {
        Sort sort = sortDir.equalsIgnoreCase("desc") ? 
                   Sort.by(sortBy).descending() : 
                   Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);
        
        return bookRepository.findBooksWithFilters(
            title, author, genre, minPrice, maxPrice, inStock, pageable);
    }

    // Get books sorted by different criteria
    public List<Book> getBooksSortedBy(String sortBy) {
        switch (sortBy.toLowerCase()) {
            case "price_asc":
                return bookRepository.findAllByOrderByPriceAsc();
            case "price_desc":
                return bookRepository.findAllByOrderByPriceDesc();
            case "rating":
                return bookRepository.findAllByOrderByRatingDesc();
            case "newest":
                return bookRepository.findAllByOrderByCreatedAtDesc();
            case "title":
                return bookRepository.findAllByOrderByTitleAsc();
            default:
                return getAllBooks();
        }
    }

    // Get books with pagination and sorting
    public Page<Book> getBooksWithPaginationAndSorting(int page, int size, String sortBy, String sortDir) {
        Sort sort = sortDir.equalsIgnoreCase("desc") ? 
                   Sort.by(sortBy).descending() : 
                   Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);
        return bookRepository.findAll(pageable);
    }

    // Get featured books (for homepage)
    public List<Book> getFeaturedBooks(int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by("rating").descending());
        return bookRepository.findAll(pageable).getContent();
    }

    // Get new arrivals
    public List<Book> getNewArrivals(int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by("createdAt").descending());
        return bookRepository.findAll(pageable).getContent();
    }

    // Get bestsellers (high rating books)
    public List<Book> getBestsellers(int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by("rating").descending());
        return bookRepository.findAll(pageable).getContent();
    }

    // Check if book exists
    public boolean bookExists(Long id) {
        return bookRepository.existsById(id);
    }

    // Get total count of books
    public long getTotalBooksCount() {
        return bookRepository.count();
    }

    // Get books count by genre
    public long getBooksCountByGenre(String genre) {
        return bookRepository.findByGenreIgnoreCase(genre).size();
    }

    // Get low stock books (stock <= 5)
    public List<Book> getLowStockBooks() {
        return bookRepository.findByStockLessThanEqual(5);
    }

    // Add new book
    public Book addBook(Book book) {
        // Validate book before saving
        book.validate();
        
        // Check for duplicate ISBN if provided
        if (book.getIsbn() != null && !book.getIsbn().trim().isEmpty()) {
            List<Book> existingBooks = bookRepository.findByIsbnIgnoreCase(book.getIsbn().trim());
            if (!existingBooks.isEmpty()) {
                throw new IllegalArgumentException("A book with this ISBN already exists");
            }
        }
        
        // Set timestamps
        book.setCreatedAt(java.time.LocalDateTime.now());
        book.setUpdatedAt(java.time.LocalDateTime.now());
        
        return bookRepository.save(book);
    }

    // Update existing book
    public Book updateBook(Book book) {
        // Validate book before saving
        book.validate();
        
        // Check for duplicate ISBN if provided (excluding current book)
        if (book.getIsbn() != null && !book.getIsbn().trim().isEmpty()) {
            List<Book> existingBooks = bookRepository.findByIsbnIgnoreCase(book.getIsbn().trim());
            for (Book existingBook : existingBooks) {
                if (!existingBook.getBid().equals(book.getBid())) {
                    throw new IllegalArgumentException("A book with this ISBN already exists");
                }
            }
        }
        
        // Update timestamp
        book.setUpdatedAt(java.time.LocalDateTime.now());
        
        return bookRepository.save(book);
    }

    // Delete book by ID
    public void deleteBook(Long id) {
        if (bookRepository.existsById(id)) {
            bookRepository.deleteById(id);
        } else {
            throw new RuntimeException("Book not found with ID: " + id);
        }
    }
}
