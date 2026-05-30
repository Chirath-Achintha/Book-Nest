<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Discounts - BookNest Admin</title>
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
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .btn-add {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
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
        
        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(26,127,90,0.3);
            color: white;
            text-decoration: none;
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
        
        .discounts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .discount-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border: 1px solid #e0e0e0;
            transition: all 0.3s;
        }
        
        .discount-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        
        .discount-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .discount-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
            margin: 0;
        }
        
        .discount-code {
            background: #f8f9fa;
            padding: 4px 8px;
            border-radius: 4px;
            font-family: monospace;
            font-weight: 600;
            color: #1a7f5a;
            font-size: 12px;
        }
        
        .discount-details {
            margin-bottom: 15px;
        }
        
        .discount-value {
            font-size: 24px;
            font-weight: 700;
            color: #1a7f5a;
            margin-bottom: 10px;
        }
        
        .discount-type {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .discount-dates {
            display: flex;
            flex-direction: column;
            gap: 5px;
            font-size: 12px;
            color: #666;
        }
        
        .discount-status {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        
        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }
        
        .status-expired {
            background: #fff3cd;
            color: #856404;
        }
        
        .discount-usage {
            font-size: 12px;
            color: #666;
        }
        
        .discount-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn-edit {
            background: #3498db;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
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
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
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
            .discounts-grid {
                grid-template-columns: 1fr;
            }
            
            .discount-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .action-buttons {
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
            <h1 class="page-title">Manage Discounts</h1>
            <p class="page-subtitle">Create and manage discount codes</p>
        </div>
    </div>

    <div class="main-content">
        <!-- Success/Error Messages -->
        <c:if test="${param.success == 'created'}">
            <div class="alert alert-success">
                ✅ Discount created successfully!
            </div>
        </c:if>
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success">
                ✅ Discount updated successfully!
            </div>
        </c:if>
        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-success">
                ✅ Discount deleted successfully!
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
                <span class="breadcrumb-item active">Manage Discounts</span>
            </div>
            
            <div class="action-buttons">
                <a href="<c:url value='/admin/discounts/add'/>" class="btn-add">
                    <i class="fas fa-plus"></i> Add New Discount
                </a>
                <a href="<c:url value='/admin/panel'/>" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Discounts Grid -->
        <c:choose>
            <c:when test="${not empty discounts}">
                <div class="discounts-grid">
                    <c:forEach var="discount" items="${discounts}">
                        <div class="discount-card">
                            <div class="discount-header">
                                <h3 class="discount-title">${discount.dname}</h3>
                                <span class="discount-code">DIS${discount.disId}</span>
                            </div>
                            
                            <div class="discount-details">
                                <div class="discount-value">
                                    <c:choose>
                                        <c:when test="${discount.dtype == 'PERCENTAGE'}">
                                            ${discount.percentage}% OFF
                                        </c:when>
                                        <c:otherwise>
                                            Flat Discount
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="discount-type">
                                    ${discount.dtype} Discount
                                </div>
                                <div class="discount-dates">
                                    <div><strong>Start:</strong> <fmt:formatDate value="${discount.startDateAsDate}" pattern="MMM dd, yyyy" /></div>
                                    <div><strong>End:</strong> <fmt:formatDate value="${discount.endDateAsDate}" pattern="MMM dd, yyyy" /></div>
                                </div>
                            </div>
                            
                            <div class="discount-status">
                                <span class="status-badge status-${discount.status.name().toLowerCase()}">
                                    ${discount.status}
                                </span>
                                <div class="discount-usage">
                                    Usage: N/A
                                </div>
                            </div>
                            
                            <div class="discount-actions">
                                <a href="<c:url value='/admin/discounts/edit/${discount.disId}'/>" class="btn-edit">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                                <form action="<c:url value='/admin/discounts/delete/${discount.disId}'/>" method="post" style="display: inline-block;" onsubmit="return confirmDelete('${discount.dname}')">
                                    <button type="submit" class="btn-delete">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fas fa-percent"></i>
                    </div>
                    <h3 class="empty-title">No Discounts Found</h3>
                    <p class="empty-subtitle">Create your first discount code to start offering promotions.</p>
                    <a href="<c:url value='/admin/discounts/add'/>" class="btn-add">
                        <i class="fas fa-plus"></i> Create First Discount
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:if test="${currentPage > 0}">
                    <a href="<c:url value='/admin/discounts?page=${currentPage - 1}'/>">
                        <i class="fas fa-chevron-left"></i> Previous
                    </a>
                </c:if>
                
                <c:forEach begin="0" end="${totalPages - 1}" var="page">
                    <c:choose>
                        <c:when test="${page == currentPage}">
                            <span class="current">${page + 1}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/admin/discounts?page=${page}'/>">${page + 1}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                <c:if test="${currentPage < totalPages - 1}">
                    <a href="<c:url value='/admin/discounts?page=${currentPage + 1}'/>">
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
        
        // Confirm delete action
        function confirmDelete(discountName) {
            return confirm('Are you sure you want to delete the discount "' + discountName + '"?\n\nThis action cannot be undone.');
        }
    </script>
</body>
</html>