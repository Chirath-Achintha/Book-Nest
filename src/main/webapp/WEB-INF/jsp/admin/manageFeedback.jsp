<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Feedback - BookNest Admin</title>
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
        
        .admin-nav {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
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
        
        .btn-back {
            background: #6c757d;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-back:hover {
            background: #5a6268;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .feedback-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .feedback-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border: 1px solid #e0e0e0;
            transition: all 0.3s;
        }
        
        .feedback-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        
        .feedback-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .feedback-user {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 16px;
        }
        
        .user-info h6 {
            margin: 0;
            font-weight: 600;
            color: #1a1a1a;
            font-size: 14px;
        }
        
        .user-info p {
            margin: 0;
            color: #666;
            font-size: 12px;
        }
        
        .feedback-rating {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .stars {
            color: #ffc107;
            font-size: 16px;
        }
        
        .rating-number {
            font-weight: 600;
            color: #1a1a1a;
            font-size: 14px;
        }
        
        .feedback-content {
            margin-bottom: 15px;
        }
        
        .feedback-text {
            color: #1a1a1a;
            line-height: 1.5;
            margin-bottom: 10px;
        }
        
        .feedback-book {
            background: #f8f9fa;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 12px;
            color: #666;
        }
        
        .feedback-meta {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 12px;
            color: #666;
        }
        
        .feedback-date {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .feedback-type {
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 500;
        }
        
        .type-book {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .type-website {
            background: #d4edda;
            color: #155724;
        }
        
        .feedback-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn-edit {
            background: #3498db;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s;
            flex: 1;
            text-align: center;
        }
        
        .btn-edit:hover {
            background: #2980b9;
            color: white;
            text-decoration: none;
        }
        
        .btn-delete {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s;
            flex: 1;
            text-align: center;
        }
        
        .btn-delete:hover {
            background: #c0392b;
            color: white;
            text-decoration: none;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        
        .empty-icon {
            font-size: 64px;
            color: #ccc;
            margin-bottom: 20px;
        }
        
        .empty-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .empty-subtitle {
            color: #666;
            font-size: 16px;
            margin-bottom: 20px;
        }
        
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
            padding: 15px 20px;
            border: none;
            font-size: 14px;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
        }
        
        .pagination a {
            padding: 8px 12px;
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            color: #1a1a1a;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .pagination a:hover {
            background: #1a7f5a;
            color: white;
            border-color: #1a7f5a;
        }
        
        .pagination .current {
            background: #1a7f5a;
            color: white;
            border-color: #1a7f5a;
        }
        
        @media (max-width: 768px) {
            .feedback-grid {
                grid-template-columns: 1fr;
            }
            
            .feedback-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .feedback-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body class="admin-page">
    <jsp:include page="../fragments/header.jsp" />

    <!-- Page Header -->
    <div class="page-header">
        <div class="main-content">
            <h1 class="page-title">Manage Feedback</h1>
            <p class="page-subtitle">View and manage customer feedback</p>
        </div>
    </div>

    <div class="main-content">
        <!-- Success/Error Messages -->
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success">
                ✅ Feedback updated successfully!
            </div>
        </c:if>
        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-success">
                ✅ Feedback deleted successfully!
            </div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                ❌ Error: ${param.error}
            </div>
        </c:if>

        <!-- Navigation -->
        <div class="admin-nav">
            <div class="nav-breadcrumb">
                <a href="<c:url value='/admin/panel'/>" class="breadcrumb-item">Admin Panel</a>
                <span class="breadcrumb-separator">›</span>
                <span class="breadcrumb-item active">Manage Feedback</span>
            </div>
            
            <div class="action-buttons">
                <a href="<c:url value='/admin/panel'/>" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Feedback Grid -->
        <c:choose>
            <c:when test="${not empty feedbacks}">
                <div class="feedback-grid">
                    <c:forEach var="feedback" items="${feedbacks}">
                        <div class="feedback-card">
                            <div class="feedback-header">
                                <div class="feedback-user">
                                    <div class="user-avatar">
                                        ${feedback.customer.cname.charAt(0).toUpperCase()}
                                    </div>
                                    <div class="user-info">
                                        <h6>${feedback.customer.cname}</h6>
                                        <p>Customer ID: ${feedback.customer.cid}</p>
                                    </div>
                                </div>
                                <div class="feedback-rating">
                                    <div class="stars">
                                        <c:forEach begin="1" end="5" var="star">
                                            <c:choose>
                                                <c:when test="${star <= feedback.rating}">
                                                    <i class="fas fa-star"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="far fa-star"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                    <span class="rating-number">${feedback.rating}/5</span>
                                </div>
                            </div>
                            
                            <div class="feedback-content">
                                <div class="feedback-text">
                                    ${feedback.comment}
                                </div>
                                <c:if test="${feedback.book != null}">
                                    <div class="feedback-book">
                                        <i class="fas fa-book"></i> ${feedback.book.title}
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="feedback-meta">
                                <div class="feedback-date">
                                    <i class="fas fa-calendar"></i>
                                    <fmt:formatDate value="${feedback.createdAt}" pattern="MMM dd, yyyy" />
                                </div>
                                <span class="feedback-type type-${feedback.book != null ? 'book' : 'website'}">
                                    ${feedback.book != null ? 'Book Review' : 'Website Feedback'}
                                </span>
                            </div>
                            
                            <div class="feedback-actions">
                                <a href="<c:url value='/feedback/edit/${feedback.feedbackId}'/>" class="btn-edit">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                                <a href="<c:url value='/feedback/admin/delete/${feedback.feedbackId}'/>" 
                                   class="btn-delete"
                                   onclick="return confirm('Are you sure you want to delete this feedback?')">
                                    <i class="fas fa-trash"></i> Delete
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fas fa-comments"></i>
                    </div>
                    <h3 class="empty-title">No Feedback Found</h3>
                    <p class="empty-subtitle">No customer feedback has been submitted yet.</p>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:if test="${currentPage > 0}">
                    <a href="<c:url value='/feedback/admin/all?page=${currentPage - 1}'/>">
                        <i class="fas fa-chevron-left"></i> Previous
                    </a>
                </c:if>
                
                <c:forEach begin="0" end="${totalPages - 1}" var="page">
                    <c:choose>
                        <c:when test="${page == currentPage}">
                            <span class="current">${page + 1}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/feedback/admin/all?page=${page}'/>">${page + 1}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                <c:if test="${currentPage < totalPages - 1}">
                    <a href="<c:url value='/feedback/admin/all?page=${currentPage + 1}'/>">
                        Next <i class="fas fa-chevron-right"></i>
                    </a>
                </c:if>
            </div>
        </c:if>
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
    </script>
</body>
</html>