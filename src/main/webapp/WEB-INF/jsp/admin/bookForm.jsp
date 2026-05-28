<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book.bid == null ? 'Add' : 'Edit'} Book - BookNest Admin</title>
    <jsp:include page="../fragments/common-styles.jsp" />
    <style>
        .admin-page {
            background: #f8f9fa;
            min-height: auto;
        }
        
        .page-header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 40px 0;
            text-align: center;
            margin-bottom: 20px;
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
        
        .form-container {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
        }
        
        .form-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 2px solid #1a7f5a;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
            background: white;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #1a7f5a;
            box-shadow: 0 0 0 3px rgba(26, 127, 90, 0.1);
        }
        
        .form-control.is-invalid {
            border-color: #e74c3c;
        }
        
        .invalid-feedback {
            color: #e74c3c;
            font-size: 14px;
            margin-top: 5px;
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(26,127,90,0.3);
        }
        
        .btn-cancel {
            background: #6c757d;
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-left: 15px;
        }
        
        .btn-cancel:hover {
            background: #5a6268;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .form-actions {
            display: flex;
            align-items: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }
        
        .nav-breadcrumb {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .breadcrumb-item {
            color: #666;
            text-decoration: none;
            margin-right: 10px;
        }
        
        .breadcrumb-item:hover {
            color: #1a7f5a;
            text-decoration: none;
        }
        
        .breadcrumb-item.active {
            color: #1a1a1a;
            font-weight: 600;
        }
        
        .breadcrumb-separator {
            margin: 0 10px;
            color: #ccc;
        }
        
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
            padding: 15px 20px;
            border: none;
            font-size: 14px;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
        }
        
        .required {
            color: #e74c3c;
        }
        
        .form-help {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }
            
            .btn-cancel {
                margin-left: 0;
                margin-top: 10px;
            }
        }
    </style>
</head>
<body class="admin-page">
    <jsp:include page="../fragments/header.jsp" />

    <!-- Page Header -->
    <div class="page-header">
        <div class="main-content">
            <h1 class="page-title">${book.bid == null ? 'Add New Book' : 'Edit Book'}</h1>
            <p class="page-subtitle">${book.bid == null ? 'Create a new book entry' : 'Update book information'}</p>
        </div>
    </div>

    <div class="main-content">
        <!-- Error Messages -->
        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                ❌ Error: ${param.error}
            </div>
        </c:if>

        <!-- Navigation -->
        <div class="nav-breadcrumb">
            <a href="<c:url value='/admin/panel'/>" class="breadcrumb-item">Admin Panel</a>
            <span class="breadcrumb-separator">›</span>
            <a href="<c:url value='/admin/books'/>" class="breadcrumb-item">Manage Books</a>
            <span class="breadcrumb-separator">›</span>
            <span class="breadcrumb-item active">${book.bid == null ? 'Add Book' : 'Edit Book'}</span>
        </div>

        <!-- Book Form -->
        <div class="form-container">
            <h2 class="form-title">${book.bid == null ? 'Book Information' : 'Edit Book Information'}</h2>
            
            <form:form modelAttribute="book" method="post" action="${book.bid == null ? '/admin/books/add' : '/admin/books/edit/'}${book.bid}">
                <div class="form-row">
                    <div class="form-group">
                        <label for="title" class="form-label">Title <span class="required">*</span></label>
                        <form:input path="title" class="form-control" placeholder="Enter book title" required="true" />
                        <form:errors path="title" cssClass="invalid-feedback" />
                    </div>
                    
                    <div class="form-group">
                        <label for="author" class="form-label">Author <span class="required">*</span></label>
                        <form:input path="author" class="form-control" placeholder="Enter author name" required="true" />
                        <form:errors path="author" cssClass="invalid-feedback" />
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="genre" class="form-label">Genre</label>
                        <form:select path="genre" class="form-control">
                            <form:option value="" label="Select Genre" />
                            <form:option value="Fiction" label="Fiction" />
                            <form:option value="Non-Fiction" label="Non-Fiction" />
                            <form:option value="Mystery" label="Mystery" />
                            <form:option value="Romance" label="Romance" />
                            <form:option value="Science Fiction" label="Science Fiction" />
                            <form:option value="Fantasy" label="Fantasy" />
                            <form:option value="Thriller" label="Thriller" />
                            <form:option value="Biography" label="Biography" />
                            <form:option value="History" label="History" />
                            <form:option value="Self-Help" label="Self-Help" />
                            <form:option value="Business" label="Business" />
                            <form:option value="Technology" label="Technology" />
                            <form:option value="Health" label="Health" />
                            <form:option value="Travel" label="Travel" />
                            <form:option value="Cooking" label="Cooking" />
                            <form:option value="Art" label="Art" />
                            <form:option value="Music" label="Music" />
                            <form:option value="Sports" label="Sports" />
                            <form:option value="Education" label="Education" />
                            <form:option value="Children" label="Children" />
                            <form:option value="Young Adult" label="Young Adult" />
                            <form:option value="Other" label="Other" />
                        </form:select>
                        <form:errors path="genre" cssClass="invalid-feedback" />
                    </div>
                    
                    <div class="form-group">
                        <label for="isbn" class="form-label">ISBN</label>
                        <form:input path="isbn" class="form-control" placeholder="Enter ISBN (optional)" />
                        <form:errors path="isbn" cssClass="invalid-feedback" />
                        <div class="form-help">International Standard Book Number</div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="price" class="form-label">Price <span class="required">*</span></label>
                        <form:input path="price" type="number" step="0.01" min="0" class="form-control" placeholder="0.00" required="true" />
                        <form:errors path="price" cssClass="invalid-feedback" />
                        <div class="form-help">Enter price in dollars</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="stock" class="form-label">Stock Quantity <span class="required">*</span></label>
                        <form:input path="stock" type="number" min="0" class="form-control" placeholder="0" required="true" />
                        <form:errors path="stock" cssClass="invalid-feedback" />
                        <div class="form-help">Number of copies available</div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="imageUrl" class="form-label">Image URL</label>
                    <form:input path="imageUrl" class="form-control" placeholder="https://example.com/book-image.jpg" />
                    <form:errors path="imageUrl" cssClass="invalid-feedback" />
                    <div class="form-help">URL to book cover image (optional)</div>
                </div>
                
                <div class="form-group">
                    <label for="publicationDate" class="form-label">Publication Date</label>
                    <form:input path="publicationDate" type="date" class="form-control" />
                    <form:errors path="publicationDate" cssClass="invalid-feedback" />
                </div>
                
                <div class="form-group">
                    <label for="description" class="form-label">Description</label>
                    <form:textarea path="description" class="form-control" placeholder="Enter book description..." rows="5" />
                    <form:errors path="description" cssClass="invalid-feedback" />
                    <div class="form-help">Brief description of the book</div>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i>
                        ${book.bid == null ? 'Create Book' : 'Update Book'}
                    </button>
                    <a href="<c:url value='/admin/books'/>" class="btn-cancel">
                        <i class="fas fa-times"></i>
                        Cancel
                    </a>
                </div>
            </form:form>
        </div>
    </div>

    <jsp:include page="../fragments/footer.jsp" />

    <script>
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const title = document.querySelector('input[name="title"]').value.trim();
            const author = document.querySelector('input[name="author"]').value.trim();
            const price = document.querySelector('input[name="price"]').value;
            const stock = document.querySelector('input[name="stock"]').value;
            
            if (!title || !author || !price || !stock) {
                e.preventDefault();
                alert('Please fill in all required fields.');
                return false;
            }
            
            if (parseFloat(price) < 0) {
                e.preventDefault();
                alert('Price must be a positive number.');
                return false;
            }
            
            if (parseInt(stock) < 0) {
                e.preventDefault();
                alert('Stock must be a non-negative number.');
                return false;
            }
        });
    </script>
</body>
</html>