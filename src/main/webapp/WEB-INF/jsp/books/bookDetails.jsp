<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book.title} - BookNest</title>
    <jsp:include page="../fragments/common-styles.jsp" />
    <style>
        .book-details-page {
            background: #f8f9fa;
            min-height: auto;
        }
        
        .book-details-container {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }
        
        .book-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 12px;
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
        }
        
        .book-image-placeholder {
            width: 100%;
            height: 400px;
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
            padding: 40px;
        }
        
        .book-title {
            font-size: 36px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 15px;
            line-height: 1.3;
        }
        
        .book-author {
            font-size: 20px;
            color: #666;
            margin-bottom: 20px;
        }
        
        .book-genre {
            color: #1a7f5a;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 20px;
            padding: 6px 12px;
            background: #d4edda;
            border-radius: 20px;
            display: inline-block;
        }
        
        .book-price {
            font-size: 32px;
            font-weight: 700;
            color: #1a7f5a;
            margin-bottom: 20px;
        }
        
        .book-stock {
            font-size: 16px;
            margin-bottom: 25px;
        }
        
        .stock-in {
            color: #1a7f5a;
            font-weight: 600;
        }
        
        .stock-low {
            color: #ffc107;
            font-weight: 600;
        }
        
        .stock-out {
            color: #dc3545;
            font-weight: 600;
        }
        
        .rating-section {
            margin-bottom: 25px;
        }
        
        .rating-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        
        .rating-display {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .rating-stars {
            color: #ffc107;
            font-size: 20px;
        }
        
        .rating-number {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
        }
        
        .rating-count {
            color: #666;
            font-size: 14px;
        }
        
        .book-description {
            font-size: 16px;
            line-height: 1.6;
            color: #555;
            margin-bottom: 30px;
        }
        
        .book-actions {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .btn-add-cart {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-add-cart:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(26,127,90,0.3);
            color: white;
            text-decoration: none;
        }
        
        .btn-add-cart:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        .btn-back {
            background: transparent;
            color: #666;
            border: 2px solid #e0e0e0;
            padding: 15px 30px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-back:hover {
            border-color: #1a7f5a;
            color: #1a7f5a;
            text-decoration: none;
        }
        
        .reviews-section {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }
        
        .reviews-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 25px;
        }
        
        .feedback-card {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            border-left: 4px solid #1a7f5a;
            transition: all 0.3s;
        }
        
        .feedback-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        
        .feedback-author {
            font-weight: 600;
            color: #1a1a1a;
            font-size: 16px;
        }
        
        .feedback-date {
            color: #666;
            font-size: 14px;
        }
        
        .feedback-rating {
            color: #ffc107;
            font-size: 16px;
            margin-bottom: 10px;
        }
        
        .feedback-comment {
            color: #555;
            font-size: 15px;
            line-height: 1.6;
        }
        
        .feedback-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .btn-edit {
            background: #1a7f5a;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .btn-edit:hover {
            background: #156847;
        }
        
        .btn-delete {
            background: #dc3545;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .btn-delete:hover {
            background: #c82333;
        }
        
        .review-form-section {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }
        
        .review-form-title {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .form-select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            background-color: white;
            transition: border-color 0.3s;
        }
        
        .form-select:focus {
            outline: none;
            border-color: #1a7f5a;
            box-shadow: 0 0 0 3px rgba(26,127,90,0.1);
        }
        
        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #1a7f5a;
            box-shadow: 0 0 0 3px rgba(26,127,90,0.1);
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(26,127,90,0.3);
        }
        
        .login-prompt {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            text-align: center;
        }
        
        .login-icon {
            font-size: 40px;
            color: #ccc;
            margin-bottom: 15px;
        }
        
        .login-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
        }
        
        .login-subtitle {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
        }
        
        .btn-login {
            background: #1a7f5a;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-login:hover {
            background: #156847;
            color: white;
            text-decoration: none;
        }
        
        .no-reviews {
            text-align: center;
            padding: 20px;
            color: #666;
        }
        
        .no-reviews-icon {
            font-size: 40px;
            color: #ccc;
            margin-bottom: 15px;
        }
        
        .no-reviews-text {
            font-size: 14px;
        }
        
        .modal-content {
            border-radius: 12px;
            border: none;
        }
        
        .modal-header {
            border-bottom: 1px solid #e0e0e0;
            padding: 20px;
        }
        
        .modal-title {
            font-weight: 700;
            color: #1a1a1a;
        }
        
        .modal-body {
            padding: 20px;
        }
        
        .modal-footer {
            border-top: 1px solid #e0e0e0;
            padding: 20px;
        }
        
        @media (max-width: 768px) {
            .book-details-container {
                padding: 20px;
            }
            
            .book-title {
                font-size: 28px;
            }
            
            .book-image,
            .book-image-placeholder {
                height: 300px;
            }
            
            .book-actions {
                flex-direction: column;
            }
            
            .btn-add-cart,
            .btn-back {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body class="book-details-page">
    <jsp:include page="../fragments/header.jsp" />

    <div class="main-content">
        <!-- Success Messages -->
        <c:if test="${param.success == 'true'}">
            <div class="alert alert-success">
                ✅ Your review has been submitted successfully!
            </div>
        </c:if>
        
        <c:if test="${not empty book}">
            <div class="book-details-container">
                <div class="grid-2">
                    <div>
                        <c:choose>
                            <c:when test="${not empty book.imageUrl}">
                                <img src="${book.imageUrl}" alt="${book.title}" class="book-image">
                            </c:when>
                            <c:otherwise>
                                <div class="book-image-placeholder">
                                    <div>
                                        <h3 style="font-size: 24px; margin-bottom: 10px;">${book.title}</h3>
                                        <p style="font-size: 16px; opacity: 0.9;">${book.author}</p>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div>
                        <div class="book-genre">${book.genre}</div>
                        <h1 class="book-title">${book.title}</h1>
                        <p class="book-author">By ${book.author}</p>
                        <div class="book-price">$<fmt:formatNumber value="${book.price}" pattern="#,##0.00"/></div>
                        
                        <div class="book-stock">
                            <c:choose>
                                <c:when test="${book.stock > 5}">
                                    <span class="stock-in">✓ In Stock (${book.stock} available)</span>
                                </c:when>
                                <c:when test="${book.stock > 0}">
                                    <span class="stock-low">⚠ Low Stock (${book.stock} available)</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="stock-out">✗ Out of Stock</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Rating Display -->
                        <div class="rating-section">
                            <div class="rating-label">Customer Rating</div>
                            <div class="rating-display">
                                <c:choose>
                                    <c:when test="${not empty averageRating and averageRating > 0}">
                                        <div class="rating-stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= averageRating}">★</c:when>
                                                    <c:otherwise>☆</c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                        <span class="rating-number"><fmt:formatNumber value="${averageRating}" pattern="#.#"/></span>
                                        <span class="rating-count">(${feedbackCount} reviews)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #666;">No ratings yet</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <c:if test="${not empty book.description}">
                            <div class="book-description">
                                <strong>Description:</strong><br>
                                ${book.description}
                            </div>
                        </c:if>
                        
                        <div class="book-actions">
                            <c:choose>
                                <c:when test="${book.isInStock()}">
                                    <form action="${pageContext.request.contextPath}/cart/add" method="post" style="margin:0;">
                                        <input type="hidden" name="bookId" value="${book.bid}" />
                                        <button type="submit" class="btn-add-cart">
                                            Add to Cart
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn-add-cart" disabled>
                                        Out of Stock
                                    </button>
                                </c:otherwise>
                            </c:choose>
                            <a href="${pageContext.request.contextPath}/books" class="btn-back">
                                ← Back to Books
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Reviews Section -->
            <div class="reviews-section">
                <h3 class="reviews-title">Customer Reviews</h3>
                
                <c:choose>
                    <c:when test="${not empty bookFeedback}">
                        <c:forEach var="feedback" items="${bookFeedback}">
                            <div class="feedback-card">
                                <div class="feedback-header">
                                    <div>
                                        <div class="feedback-author">${feedback.customerName}</div>
                                        <div class="feedback-rating">
                                            <c:forEach begin="1" end="5" var="star">
                                                <c:choose>
                                                    <c:when test="${star <= feedback.rating}">★</c:when>
                                                    <c:otherwise>☆</c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div>
                                        <div class="feedback-date">
                                            <c:out value="${feedback.createdAtFormatted}"/>
                                        </div>
                                        <!-- Show Edit/Delete buttons only for the current user's feedback -->
                                        <c:if test="${currentCustomerId != null && currentCustomerId == feedback.customerId}">
                                            <div class="feedback-actions">
                                                <button type="button" class="btn-edit" 
                                                        data-feedback-id="${feedback.feedbackId}"
                                                        data-rating="${feedback.rating}"
                                                        data-comment="${feedback.comment}"
                                                        onclick="editFeedback(this)">
                                                    Edit
                                                </button>
                                                <button type="button" class="btn-delete" 
                                                        onclick="deleteFeedback(${feedback.feedbackId})">
                                                    Delete
                                                </button>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                <c:if test="${not empty feedback.comment}">
                                    <div class="feedback-comment">${feedback.comment}</div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-reviews">
                            <div class="no-reviews-icon">💬</div>
                            <div class="no-reviews-text">No reviews yet. Be the first to review this book!</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Review Form -->
            <c:if test="${not empty sessionScope.user}">
                <div class="review-form-section">
                    <h4 class="review-form-title">Write a Review</h4>
                    <c:choose>
                        <c:when test="${hasLeftFeedback}">
                            <div class="alert alert-info">
                                ℹ️ You have already reviewed this book.
                                <c:if test="${not empty existingFeedback}">
                                    <br><strong>Your rating:</strong>
                                    <div style="color: #ffc107; margin: 5px 0;">
                                        <c:forEach begin="1" end="5" var="star">
                                            <c:choose>
                                                <c:when test="${star <= existingFeedback.rating}">★</c:when>
                                                <c:otherwise>☆</c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                    <c:if test="${not empty existingFeedback.comment}">
                                        <br><strong>Your comment:</strong> ${existingFeedback.comment}
                                    </c:if>
                                </c:if>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/books/${book.bid}/feedback" method="post">
                                <div class="form-group">
                                    <label for="rating" class="form-label">Rating *</label>
                                    <select class="form-select" id="rating" name="rating" required>
                                        <option value="">Select rating</option>
                                        <option value="5">5 - Excellent</option>
                                        <option value="4">4 - Very Good</option>
                                        <option value="3">3 - Good</option>
                                        <option value="2">2 - Fair</option>
                                        <option value="1">1 - Poor</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="comment" class="form-label">Comment (Optional)</label>
                                    <textarea class="form-control" id="comment" name="comment" rows="4" 
                                              placeholder="Share your thoughts about this book..."></textarea>
                                </div>
                                <button type="submit" class="btn-submit">
                                    Submit Review
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
            
            <c:if test="${empty sessionScope.user}">
                <div class="login-prompt">
                    <div class="login-icon">🔐</div>
                    <h4 class="login-title">Login to Review</h4>
                    <p class="login-subtitle">Please log in to write a review for this book.</p>
                    <a href="${pageContext.request.contextPath}/login" class="btn-login">Login</a>
                </div>
            </c:if>
        </c:if>
        
        <c:if test="${empty book}">
            <div class="alert alert-danger">
                ❌ Book not found
            </div>
        </c:if>
    </div>

    <!-- Edit Feedback Modal -->
    <div class="modal" id="editFeedbackModal">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Your Review</h5>
                <button type="button" class="btn-close" onclick="closeModal('editFeedbackModal')">&times;</button>
            </div>
            <form id="editFeedbackForm" method="post">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="editRating" class="form-label">Rating *</label>
                        <select class="form-select" id="editRating" name="rating" required>
                            <option value="">Select Rating</option>
                            <option value="1">1 Star - Poor</option>
                            <option value="2">2 Stars - Fair</option>
                            <option value="3">3 Stars - Good</option>
                            <option value="4">4 Stars - Very Good</option>
                            <option value="5">5 Stars - Excellent</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="editComment" class="form-label">Comment</label>
                        <textarea class="form-control" id="editComment" name="comment" rows="4" 
                                  placeholder="Share your thoughts about this book..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('editFeedbackModal')">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Review</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal" id="deleteFeedbackModal">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Delete Review</h5>
                <button type="button" class="btn-close" onclick="closeModal('deleteFeedbackModal')">&times;</button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete your review? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('deleteFeedbackModal')">Cancel</button>
                <form id="deleteFeedbackForm" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-danger">Delete Review</button>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="../fragments/footer.jsp" />

    <script>
        let currentFeedbackId = null;

        function editFeedback(button) {
            const feedbackId = button.getAttribute('data-feedback-id');
            const rating = button.getAttribute('data-rating');
            const comment = button.getAttribute('data-comment') || '';
            
            currentFeedbackId = feedbackId;
            document.getElementById('editRating').value = rating;
            document.getElementById('editComment').value = comment;
            // Get current book ID from the URL or page context
            const bookId = window.location.pathname.split('/').pop();
            document.getElementById('editFeedbackForm').action = '/feedback/edit/' + feedbackId + '?redirectTo=/books/' + bookId;
            
            document.getElementById('editFeedbackModal').style.display = 'block';
        }

        function deleteFeedback(feedbackId) {
            currentFeedbackId = feedbackId;
            // Get current book ID from the URL or page context
            const bookId = window.location.pathname.split('/').pop();
            document.getElementById('deleteFeedbackForm').action = '/feedback/delete/' + feedbackId + '?redirectTo=/books/' + bookId;
            
            document.getElementById('deleteFeedbackModal').style.display = 'block';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modals = document.querySelectorAll('.modal');
            modals.forEach(modal => {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });
        }

        // Show success message if redirected with success parameter
        window.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('success') === 'true') {
                console.log('Feedback operation completed successfully');
            }
        });
    </script>
</body>
</html>