package com.project.bookStore_backend.repository;

import com.project.bookStore_backend.model.Book;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookRepository extends JpaRepository<Book, Long> {

    // Search books by title (case-insensitive)
    List<Book> findByTitleContainingIgnoreCase(String title);

    // Find books by genre
    List<Book> findByGenreIgnoreCase(String genre);

    // Get books cheaper than a given price
    List<Book> findByPriceLessThan(Double price);

    // Get books in price range
    List<Book> findByPriceBetween(Double minPrice, Double maxPrice);

    // Search by author (case-insensitive)
    List<Book> findByAuthorContainingIgnoreCase(String author);

    // Find books in stock
    List<Book> findByStockGreaterThan(Integer stock);

    // Find books by multiple criteria
    @Query("SELECT b FROM Book b WHERE " +
           "(:title IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :title, '%'))) AND " +
           "(:author IS NULL OR LOWER(b.author) LIKE LOWER(CONCAT('%', :author, '%'))) AND " +
           "(:genre IS NULL OR LOWER(b.genre) = LOWER(:genre)) AND " +
           "(:minPrice IS NULL OR b.price >= :minPrice) AND " +
           "(:maxPrice IS NULL OR b.price <= :maxPrice) AND " +
           "(:inStock IS NULL OR (:inStock = true AND b.stock > 0) OR (:inStock = false))")
    Page<Book> findBooksWithFilters(@Param("title") String title,
                                   @Param("author") String author,
                                   @Param("genre") String genre,
                                   @Param("minPrice") Double minPrice,
                                   @Param("maxPrice") Double maxPrice,
                                   @Param("inStock") Boolean inStock,
                                   Pageable pageable);

    // Get all unique genres
    @Query("SELECT DISTINCT b.genre FROM Book b WHERE b.genre IS NOT NULL ORDER BY b.genre")
    List<String> findDistinctGenres();

    // Get books sorted by price (ascending)
    List<Book> findAllByOrderByPriceAsc();

    // Get books sorted by price (descending)
    List<Book> findAllByOrderByPriceDesc();

    // Get books sorted by rating (descending)
    List<Book> findAllByOrderByRatingDesc();

    // Get books sorted by creation date (newest first)
    List<Book> findAllByOrderByCreatedAtDesc();

    // Get books sorted by title (ascending)
    List<Book> findAllByOrderByTitleAsc();

    // Search books by title or author
    @Query("SELECT b FROM Book b WHERE " +
           "LOWER(b.title) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(b.author) LIKE LOWER(CONCAT('%', :searchTerm, '%'))")
    List<Book> findByTitleOrAuthorContainingIgnoreCase(@Param("searchTerm") String searchTerm);

    // Get books with pagination and sorting
    @Query("SELECT b FROM Book b WHERE " +
           "(:title IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :title, '%'))) AND " +
           "(:author IS NULL OR LOWER(b.author) LIKE LOWER(CONCAT('%', :author, '%'))) AND " +
           "(:genre IS NULL OR LOWER(b.genre) = LOWER(:genre)) AND " +
           "(:minPrice IS NULL OR b.price >= :minPrice) AND " +
           "(:maxPrice IS NULL OR b.price <= :maxPrice)")
    Page<Book> findBooksWithFiltersAndPagination(@Param("title") String title,
                                                @Param("author") String author,
                                                @Param("genre") String genre,
                                                @Param("minPrice") Double minPrice,
                                                @Param("maxPrice") Double maxPrice,
                                                Pageable pageable);

    // Find books with low stock
    List<Book> findByStockLessThanEqual(Integer stock);

    // Find book by ISBN (case-insensitive)
    List<Book> findByIsbnIgnoreCase(String isbn);
}
