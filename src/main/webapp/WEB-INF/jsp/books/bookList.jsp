<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Catalog - BookNest</title>
    <jsp:include page="../fragments/common-styles.jsp" />
    <style>
        .books-page {
            background: #f8f9fa;
            min-height: auto;
        }
        
        .page-header {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            padding: 40px 0;
            text-align: center;
        }
        
        .page-title {
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .page-subtitle {
            font-size: 18px;
            opacity: 0.9;
        }
        
        .filter-section {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
        }
        
        .filter-title {
            font-size: 20px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 25px;
        }
        
        .filter-row {
            margin-bottom: 20px;
        }
        
        .filter-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            display: block;
            font-size: 14px;
        }
        
        .search-box {
            position: relative;
        }
        
        .search-box .form-control {
            padding-right: 45px;
        }
        
        .search-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
            font-size: 16px;
        }
        
        .book-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: all 0.3s;
            height: 100%;
            border: 1px solid #e0e0e0;
        }
        
        .book-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.15);
        }
        
        .book-cover {
            width: 100%;
            height: 280px;
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            position: relative;
            overflow: hidden;
        }
        
        .book-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .book-cover-placeholder {
            text-align: center;
            padding: 20px;
        }
        
        .book-cover-placeholder h4 {
            font-size: 18px;
            margin-bottom: 5px;
            font-weight: 600;
        }
        
        .book-cover-placeholder p {
            font-size: 12px;
            opacity: 0.9;
        }
        
        .book-info {
            padding: 25px;
        }
        
        .book-genre {
            color: #1a7f5a;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        
        .book-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .book-author {
            color: #666;
            font-size: 14px;
            margin-bottom: 12px;
        }
        
        .book-rating {
            color: #ffc107;
            font-size: 14px;
            margin-bottom: 12px;
        }
        
        .book-price {
            font-size: 22px;
            color: #1a7f5a;
            font-weight: 700;
            margin-bottom: 12px;
        }
        
        .stock-status {
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 20px;
            padding: 4px 8px;
            border-radius: 4px;
            display: inline-block;
        }
        
        .stock-status.in-stock {
            color: #1a7f5a;
            background: #d4edda;
        }
        
        .stock-status.low-stock {
            color: #856404;
            background: #fff3cd;
        }
        
        .stock-status.out-of-stock {
            color: #721c24;
            background: #f8d7da;
        }
        
        .book-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn-view {
            flex: 1;
            background: #1a7f5a;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
            text-decoration: none;
            text-align: center;
        }
        
        .btn-view:hover {
            background: #156847;
            color: white;
            text-decoration: none;
        }
        
        .btn-cart {
            flex: 1;
            background: #20c997;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .btn-cart:hover {
            background: #1ba085;
        }
        
        .btn-cart:disabled {
            background: #6c757d;
            cursor: not-allowed;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 40px;
            gap: 5px;
        }
        
        .page-link {
            padding: 10px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            color: #1a7f5a;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .page-link:hover {
            background: #1a7f5a;
            color: white;
            border-color: #1a7f5a;
            text-decoration: none;
        }
        
        .page-item.active .page-link {
            background: #1a7f5a;
            color: white;
            border-color: #1a7f5a;
        }
        
        .results-info {
            color: #666;
            font-size: 14px;
            font-weight: 500;
        }
        
        .no-books {
            text-align: center;
            padding: 40px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        
        .no-books-icon {
            font-size: 60px;
            color: #ccc;
            margin-bottom: 20px;
        }
        
        .no-books-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .no-books-subtitle {
            color: #666;
            font-size: 16px;
            margin-bottom: 20px;
        }
        
        .browse-all-btn {
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
        
        .browse-all-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(26,127,90,0.3);
            color: white;
            text-decoration: none;
        }
        
        @media (max-width: 768px) {
            .book-cover {
                height: 200px;
            }
            
            .filter-section {
                padding: 20px;
            }
            
            .book-actions {
                flex-direction: column;
            }
            
            .page-title {
                font-size: 32px;
            }
        }
    </style>
</head>
<body class="books-page">
    <jsp:include page="../fragments/header.jsp" />

    <!-- Page Header -->
    <div class="page-header">
        <div class="main-content">
            <h1 class="page-title">
                <c:choose>
                    <c:when test="${not empty pageTitle}">${pageTitle}</c:when>
                    <c:otherwise>Book Catalog</c:otherwise>
                </c:choose>
            </h1>
            <p class="page-subtitle">Discover your next favorite book from our extensive collection</p>
        </div>
    </div>

    <div class="main-content">
        <!-- Filters Section -->
        <div class="filter-section">
            <h3 class="filter-title">Filter & Search</h3>
            <form method="get" action="${pageContext.request.contextPath}/books" id="filterForm">
                <div class="grid-4">
                    <div class="filter-row">
                        <label class="filter-label">Search Books</label>
                        <div class="search-box">
                            <input type="text" class="form-control" name="search" 
                                   placeholder="Search books..." value="${search}">
                            <i class="fas fa-search search-icon"></i>
                        </div>
                    </div>
                    
                    <div class="filter-row">
                        <label class="filter-label">Genre</label>
                        <select class="form-select" name="genre">
                            <option value="">All Genres</option>
                            <c:forEach var="genre" items="${genres}">
                                <option value="${genre}" ${genre == param.genre ? 'selected' : ''}>${genre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="filter-row">
                        <label class="filter-label">Min Price</label>
                        <input type="number" class="form-control" name="minPrice" 
                               placeholder="0.00" step="0.01" value="${minPrice}">
                    </div>
                    
                    <div class="filter-row">
                        <label class="filter-label">Max Price</label>
                        <input type="number" class="form-control" name="maxPrice" 
                               placeholder="100.00" step="0.01" value="${maxPrice}">
                    </div>
                </div>
                
                <div class="grid-4" style="margin-top: 20px;">
                    <div class="filter-row">
                        <label class="filter-label">Stock Status</label>
                        <select class="form-select" name="inStock">
                            <option value="">All Books</option>
                            <option value="true" ${param.inStock == 'true' ? 'selected' : ''}>In Stock Only</option>
                        </select>
                    </div>
                    
                    <div class="filter-row">
                        <label class="filter-label">Sort By</label>
                        <select class="form-select" name="sortBy">
                            <option value="title" ${sortBy == 'title' ? 'selected' : ''}>Title</option>
                            <option value="price" ${sortBy == 'price' ? 'selected' : ''}>Price</option>
                            <option value="rating" ${sortBy == 'rating' ? 'selected' : ''}>Rating</option>
                            <option value="createdAt" ${sortBy == 'createdAt' ? 'selected' : ''}>Newest</option>
                        </select>
                    </div>
                    
                    <div class="filter-row">
                        <label class="filter-label">Order</label>
                        <select class="form-select" name="sortDir">
                            <option value="asc" ${sortDir == 'asc' ? 'selected' : ''}>Ascending</option>
                            <option value="desc" ${sortDir == 'desc' ? 'selected' : ''}>Descending</option>
                        </select>
                    </div>
                    
                    <div class="filter-row">
                        <label class="filter-label">Per Page</label>
                        <select class="form-select" name="size">
                            <option value="12" ${size == 12 ? 'selected' : ''}>12</option>
                            <option value="24" ${size == 24 ? 'selected' : ''}>24</option>
                            <option value="48" ${size == 48 ? 'selected' : ''}>48</option>
                        </select>
                    </div>
                </div>
                
                <div style="margin-top: 25px; display: flex; justify-content: space-between; align-items: center;">
                    <button type="submit" class="btn btn-primary">
                        Apply Filters
                    </button>
                    <div class="results-info">
                        Showing ${(currentPage * size) + 1} to 
                        ${(currentPage * size) + books.size()} of ${totalElements} books
                    </div>
                </div>
            </form>
        </div>
        
        <!-- Books Grid -->
        <div class="book-grid">
            <c:choose>
                <c:when test="${not empty books}">
                    <c:forEach var="book" items="${books}">
                        <div class="book-card">
                            <div class="book-cover">
                                <c:choose>
                                    <c:when test="${not empty book.imageUrl}">
                                        <img src="${book.imageUrl}" alt="${book.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="book-cover-placeholder">
                                            <h4>${book.title}</h4>
                                            <p>${book.author}</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="book-info">
                                <div class="book-genre">${book.genre}</div>
                                <h3 class="book-title">${book.title}</h3>
                                <p class="book-author">By ${book.author}</p>
                                
                                <c:if test="${book.rating > 0}">
                                    <div class="book-rating">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= book.rating}">★</c:when>
                                                <c:otherwise>☆</c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <span style="margin-left: 5px;">(${book.rating})</span>
                                    </div>
                                </c:if>
                                
                                <div class="book-price">$<fmt:formatNumber value="${book.price}" pattern="#,##0.00"/></div>
                                
                                <div class="stock-status ${book.stock > 5 ? 'in-stock' : (book.stock > 0 ? 'low-stock' : 'out-of-stock')}">
                                    ${book.stockStatus}
                                </div>
                                
                                <div class="book-actions">
                                    <c:url var="detailsUrl" value="${pageContext.request.contextPath}/books/${book.bid}"/>
                                    <a href="${detailsUrl}" class="btn-view">
                                        View Details
                                    </a>
                                    
                                    <c:choose>
                                        <c:when test="${book.isInStock()}">
                                            <form action="${pageContext.request.contextPath}/cart/add" method="post" style="margin:0; flex:1;">
                                                <input type="hidden" name="bookId" value="${book.bid}" />
                                                <button type="submit" class="btn-cart">
                                                    Add to Cart
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn-cart" disabled>
                                                Out of Stock
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-books">
                        <div class="no-books-icon">📚</div>
                        <h3 class="no-books-title">No books found</h3>
                        <p class="no-books-subtitle">Try adjusting your search criteria or browse all books.</p>
                        <a href="${pageContext.request.contextPath}/books" class="browse-all-btn">
                            Browse All Books
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Books pagination">
                <div class="pagination">
                    <c:if test="${currentPage > 0}">
                        <a class="page-link" href="?page=${currentPage - 1}&size=${size}&sortBy=${sortBy}&sortDir=${sortDir}&search=${search}&genre=${genre}&minPrice=${minPrice}&maxPrice=${maxPrice}&inStock=${inStock}">
                            ← Previous
                        </a>
                    </c:if>
                    
                    <c:forEach begin="0" end="${totalPages - 1}" var="i">
                        <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                            <a class="page-link ${i == currentPage ? 'active' : ''}" href="?page=${i}&size=${size}&sortBy=${sortBy}&sortDir=${sortDir}&search=${search}&genre=${genre}&minPrice=${minPrice}&maxPrice=${maxPrice}&inStock=${inStock}">
                                ${i + 1}
                            </a>
                        </c:if>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages - 1}">
                        <a class="page-link" href="?page=${currentPage + 1}&size=${size}&sortBy=${sortBy}&sortDir=${sortDir}&search=${search}&genre=${genre}&minPrice=${minPrice}&maxPrice=${maxPrice}&inStock=${inStock}">
                            Next →
                        </a>
                    </c:if>
                </div>
            </nav>
        </c:if>
    </div>

    <jsp:include page="../fragments/footer.jsp" />

    <script>
        // Auto-submit form when filters change
        document.querySelectorAll('#filterForm select, #filterForm input[type="number"]').forEach(element => {
            element.addEventListener('change', function() {
                document.getElementById('filterForm').submit();
            });
        });
        
        // Search with Enter key
        document.querySelector('input[name="search"]').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                document.getElementById('filterForm').submit();
            }
        });
    </script>
</body>
</html>