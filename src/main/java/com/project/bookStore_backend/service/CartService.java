package com.project.bookStore_backend.service;

import com.project.bookStore_backend.model.CartItem;
import com.project.bookStore_backend.model.Customer;
import com.project.bookStore_backend.model.Book;
import com.project.bookStore_backend.repository.CartRepository;
import com.project.bookStore_backend.repository.CustomerRepository;
import com.project.bookStore_backend.repository.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private BookRepository bookRepository;

    /**
     * Add item to cart or update quantity if already exists
     */
    public boolean addToCart(Long customerId, Long bookId, Integer quantity) {
        try {
            // Input validation
            if (customerId == null || customerId <= 0) {
                throw new IllegalArgumentException("Invalid customer ID");
            }
            if (bookId == null || bookId <= 0) {
                throw new IllegalArgumentException("Invalid book ID");
            }
            if (quantity == null || quantity < 1) {
                throw new IllegalArgumentException("Quantity must be at least 1");
            }
            if (quantity > 99) {
                throw new IllegalArgumentException("Quantity cannot exceed 99");
            }

            // Validate customer and book exist
            Optional<Customer> customerOpt = customerRepository.findById(customerId);
            Optional<Book> bookOpt = bookRepository.findById(bookId);
            
            if (customerOpt.isEmpty()) {
                throw new IllegalArgumentException("Customer not found");
            }
            if (bookOpt.isEmpty()) {
                throw new IllegalArgumentException("Book not found");
            }

            Customer customer = customerOpt.get();
            Book book = bookOpt.get();

            // Check if book is in stock
            if (book.getStock() == null || book.getStock() < quantity) {
                throw new IllegalArgumentException("Insufficient stock available");
            }

            // Check if item already exists in cart
            Optional<CartItem> existingItemOpt = cartRepository.findByCustomerCidAndBookBid(customerId, bookId);
            
            if (existingItemOpt.isPresent()) {
                // Update quantity
                CartItem existingItem = existingItemOpt.get();
                int newQuantity = existingItem.getQuantity() + quantity;
                
                // Check stock availability for new total quantity
                if (book.getStock() < newQuantity) {
                    throw new IllegalArgumentException("Insufficient stock for total quantity");
                }
                if (newQuantity > 99) {
                    throw new IllegalArgumentException("Total quantity cannot exceed 99");
                }
                
                existingItem.setQuantity(newQuantity);
                // Validate cart item before saving
                existingItem.validate();
                cartRepository.save(existingItem);
            } else {
                // Create new cart item
                CartItem cartItem = new CartItem();
                cartItem.setCustomer(customer);
                cartItem.setBook(book);
                cartItem.setQuantity(quantity);
                // Validate cart item before saving
                cartItem.validate();
                cartRepository.save(cartItem);
            }
            
            return true;
        } catch (IllegalArgumentException e) {
            System.err.println("Validation error: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.err.println("Error adding to cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get all cart items for a customer
     */
    public List<CartItem> getCartItems(Long customerId) {
        return cartRepository.findByCustomerCid(customerId);
    }

    /**
     * Update quantity of a cart item
     */
    public boolean updateCartItemQuantity(Long customerId, Long bookId, Integer newQuantity) {
        try {
            // Input validation
            if (customerId == null || customerId <= 0) {
                throw new IllegalArgumentException("Invalid customer ID");
            }
            if (bookId == null || bookId <= 0) {
                throw new IllegalArgumentException("Invalid book ID");
            }
            if (newQuantity == null || newQuantity < 1) {
                throw new IllegalArgumentException("Quantity must be at least 1");
            }
            if (newQuantity > 99) {
                throw new IllegalArgumentException("Quantity cannot exceed 99");
            }

            if (newQuantity <= 0) {
                return removeFromCart(customerId, bookId);
            }

            Optional<CartItem> cartItemOpt = cartRepository.findByCustomerCidAndBookBid(customerId, bookId);
            if (cartItemOpt.isEmpty()) {
                throw new IllegalArgumentException("Cart item not found");
            }

            CartItem cartItem = cartItemOpt.get();
            Book book = cartItem.getBook();

            // Check stock availability
            if (book.getStock() < newQuantity) {
                throw new IllegalArgumentException("Insufficient stock available");
            }

            cartItem.setQuantity(newQuantity);
            // Validate cart item before saving
            cartItem.validate();
            cartRepository.save(cartItem);
            return true;
        } catch (IllegalArgumentException e) {
            System.err.println("Validation error: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.err.println("Error updating cart item quantity: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Remove item from cart
     */
    public boolean removeFromCart(Long customerId, Long bookId) {
        try {
            Optional<CartItem> cartItemOpt = cartRepository.findByCustomerCidAndBookBid(customerId, bookId);
            if (cartItemOpt.isPresent()) {
                cartRepository.delete(cartItemOpt.get());
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("Error removing from cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Clear entire cart for a customer
     */
    public boolean clearCart(Long customerId) {
        try {
            List<CartItem> cartItems = cartRepository.findByCustomerCid(customerId);
            cartRepository.deleteAll(cartItems);
            return true;
        } catch (Exception e) {
            System.err.println("Error clearing cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get cart total amount
     */
    public Double getCartTotal(Long customerId) {
        List<CartItem> cartItems = cartRepository.findByCustomerCid(customerId);
        return cartItems.stream()
                .mapToDouble(item -> item.getBook().getPrice() * item.getQuantity())
                .sum();
    }

    /**
     * Get cart item count
     */
    public Integer getCartItemCount(Long customerId) {
        List<CartItem> cartItems = cartRepository.findByCustomerCid(customerId);
        return cartItems.stream()
                .mapToInt(CartItem::getQuantity)
                .sum();
    }

    /**
     * Check if cart is empty
     */
    public boolean isCartEmpty(Long customerId) {
        List<CartItem> cartItems = cartRepository.findByCustomerCid(customerId);
        return cartItems.isEmpty();
    }
}
