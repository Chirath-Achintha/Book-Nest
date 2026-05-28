<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - BookNest</title>
    <jsp:include page="fragments/common-styles.jsp" />
    <style>
        .cart-page {
            background: #f8f9fa;
            min-height: auto;
        }
        
        .cart-header {
            background: white;
            padding: 20px 0;
            border-bottom: 1px solid #e0e0e0;
            margin-bottom: 20px;
        }
        
        .cart-title {
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .cart-subtitle {
            color: #666;
            font-size: 16px;
        }
        
        .cart-item {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: all 0.3s;
            border: 1px solid #e0e0e0;
        }
        
        .cart-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        
        .book-image {
            width: 100px;
            height: 140px;
            object-fit: cover;
            border-radius: 8px;
            background: #f0f0f0;
        }
        
        .book-image-placeholder {
            width: 100px;
            height: 140px;
            background: linear-gradient(135deg, #1a7f5a, #20c997);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
        }
        
        .book-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 5px;
        }
        
        .book-author {
            color: #666;
            font-size: 14px;
            margin-bottom: 8px;
        }
        
        .stock-info {
            color: #1a7f5a;
            font-size: 12px;
            font-weight: 500;
        }
        
        .book-price {
            font-size: 20px;
            font-weight: 700;
            color: #1a7f5a;
        }
        
        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quantity-input {
            width: 80px;
            text-align: center;
            padding: 8px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-weight: 600;
        }
        
        .quantity-input:focus {
            outline: none;
            border-color: #1a7f5a;
        }
        
        .update-btn {
            background: #1a7f5a;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .update-btn:hover {
            background: #156847;
        }
        
        .item-total {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
        }
        
        .remove-btn {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            transition: background 0.3s;
        }
        
        .remove-btn:hover {
            background: #c82333;
        }
        
        .cart-summary {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            position: sticky;
            top: 20px;
            border: 1px solid #e0e0e0;
        }
        
        .summary-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 20px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .summary-total {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            border-bottom: 2px solid #1a7f5a;
            padding-bottom: 15px;
        }
        
        .checkout-btn {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 16px 30px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 16px;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 15px;
        }
        
        .checkout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(26,127,90,0.3);
        }
        
        .continue-shopping-btn {
            background: transparent;
            color: #666;
            border: 2px solid #e0e0e0;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: block;
            text-align: center;
        }
        
        .continue-shopping-btn:hover {
            border-color: #1a7f5a;
            color: #1a7f5a;
            text-decoration: none;
        }
        
        .empty-cart {
            text-align: center;
            padding: 40px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        
        .empty-cart-icon {
            font-size: 60px;
            color: #ccc;
            margin-bottom: 20px;
        }
        
        .empty-cart-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .empty-cart-subtitle {
            color: #666;
            font-size: 16px;
            margin-bottom: 20px;
        }
        
        .browse-books-btn {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 16px 40px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .browse-books-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(26,127,90,0.3);
            color: white;
            text-decoration: none;
        }
        
        .clear-cart-btn {
            background: #dc3545;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .clear-cart-btn:hover {
            background: #c82333;
        }
        
        @media (max-width: 768px) {
            .cart-item {
                padding: 20px;
            }
            
            .book-image,
            .book-image-placeholder {
                width: 80px;
                height: 110px;
            }
            
            .cart-summary {
                margin-top: 30px;
                position: static;
            }
        }
    </style>
</head>
<body class="cart-page">
    <jsp:include page="fragments/header.jsp" />

    <div class="cart-header">
        <div class="main-content">
            <h1 class="cart-title">Shopping Cart</h1>
            <p class="cart-subtitle">Review your selected books</p>
        </div>
    </div>

    <div class="main-content">
        <!-- Flash Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                ✅ ${successMessage}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                ❌ ${errorMessage}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${isEmpty}">
                <!-- Empty Cart -->
                <div class="empty-cart">
                    <div class="empty-cart-icon">🛒</div>
                    <h2 class="empty-cart-title">Your cart is empty</h2>
                    <p class="empty-cart-subtitle">Add some amazing books to get started!</p>
                    <a href="${pageContext.request.contextPath}/books" class="browse-books-btn">
                        Browse Books
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid-2">
                    <!-- Cart Items -->
                    <div>
                        <c:forEach var="item" items="${cartItems}">
                            <div class="cart-item">
                                <div style="display: flex; gap: 20px; align-items: flex-start;">
                                    <div>
                                        <c:choose>
                                            <c:when test="${not empty item.book.imageUrl}">
                                                <img src="${item.book.imageUrl}" alt="${item.book.title}" class="book-image">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="book-image-placeholder">
                                                    📚
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div style="flex: 1;">
                                        <h3 class="book-title">${item.book.title}</h3>
                                        <p class="book-author">by ${item.book.author}</p>
                                        <p class="stock-info">✓ In Stock (${item.book.stock} available)</p>
                                        
                                        <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px;">
                                            <div>
                                                <div class="book-price">
                                                    <fmt:formatNumber value="${item.book.price}" type="currency" currencySymbol="$"/>
                                                </div>
                                            </div>
                                            
                                            <div class="quantity-controls">
                                                <form action="${pageContext.request.contextPath}/cart/update" method="post" style="display: flex; align-items: center; gap: 10px;">
                                                    <input type="hidden" name="bookId" value="${item.book.bid}">
                                                    <input type="number" name="quantity" value="${item.quantity}" 
                                                           min="1" max="${item.book.stock}" class="quantity-input">
                                                    <button type="submit" class="update-btn">
                                                        Update
                                                    </button>
                                                </form>
                                            </div>
                                            
                                            <div style="text-align: right;">
                                                <div class="item-total">
                                                    <fmt:formatNumber value="${item.book.price * item.quantity}" type="currency" currencySymbol="$"/>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/cart/remove" method="post" style="margin-top: 10px;">
                                                    <input type="hidden" name="bookId" value="${item.book.bid}">
                                                    <button type="submit" class="remove-btn" 
                                                            onclick="return confirm('Remove this item from cart?')">
                                                        Remove
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Clear Cart Button -->
                        <div style="text-align: right; margin-bottom: 30px;">
                            <form action="${pageContext.request.contextPath}/cart/clear" method="post" style="display: inline;">
                                <button type="submit" class="clear-cart-btn" 
                                        onclick="return confirm('Clear entire cart? This action cannot be undone.')">
                                    Clear Cart
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- Cart Summary -->
                    <div>
                        <div class="cart-summary">
                            <h3 class="summary-title">Cart Summary</h3>
                            
                            <div class="summary-row">
                                <span>Items (${itemCount}):</span>
                                <span><fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="$"/></span>
                            </div>
                            
                            <div class="summary-row">
                                <span>Shipping:</span>
                                <span style="color: #1a7f5a; font-weight: 600;">Free</span>
                            </div>
                            
                            <div class="summary-row summary-total">
                                <span>Total:</span>
                                <span><fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="$"/></span>
                            </div>
                            
                            <button onclick="window.location.href='${pageContext.request.contextPath}/checkout'" class="checkout-btn">
                                Proceed to Checkout
                            </button>
                            
                            <a href="${pageContext.request.contextPath}/books" class="continue-shopping-btn">
                                Continue Shopping
                            </a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <jsp:include page="fragments/footer.jsp" />
</body>
</html>