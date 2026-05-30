<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${not empty discount}">Edit Discount</c:when><c:otherwise>Add Discount</c:otherwise></c:choose> - BookNest Admin</title>
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
        
        .form-container {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
        }
        
        .form-group {
            margin-bottom: 20px;
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
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            background: white;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #1a7f5a;
            box-shadow: 0 0 0 3px rgba(26, 127, 90, 0.1);
        }
        
        .form-control select {
            background: white;
            cursor: pointer;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }
        
        .btn-save {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(26,127,90,0.3);
        }
        
        .btn-cancel {
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
        
        .btn-cancel:hover {
            background: #5a6268;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
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
        
        .required {
            color: #e74c3c;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
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
            <h1 class="page-title">
                <c:choose>
                    <c:when test="${not empty discount}">Edit Discount</c:when>
                    <c:otherwise>Add New Discount</c:otherwise>
                </c:choose>
            </h1>
            <p class="page-subtitle">
                <c:choose>
                    <c:when test="${not empty discount}">Update discount information</c:when>
                    <c:otherwise>Create a new discount code</c:otherwise>
                </c:choose>
            </p>
        </div>
    </div>

    <div class="main-content">
        <!-- Success/Error Messages -->
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
                <a href="<c:url value='/admin/discounts'/>" class="breadcrumb-item">Manage Discounts</a>
                <span class="breadcrumb-separator">›</span>
                <span class="breadcrumb-item active">
                    <c:choose>
                        <c:when test="${not empty discount}">Edit Discount</c:when>
                        <c:otherwise>Add Discount</c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="action-buttons">
                <a href="<c:url value='/admin/discounts'/>" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Back to Discounts
                </a>
            </div>
        </div>

        <!-- Discount Form -->
        <div class="form-container">
            <form action="<c:choose><c:when test='${not empty discount}'><c:url value='/admin/discounts/update/${discount.disId}'/></c:when><c:otherwise><c:url value='/admin/discounts/create'/></c:otherwise></c:choose>" method="post">
                <div class="form-group">
                    <label for="dname" class="form-label">
                        Discount Name <span class="required">*</span>
                    </label>
                    <input type="text" id="dname" name="dname" class="form-control" 
                           value="${discount.dname}" 
                           placeholder="Enter discount name" required>
                </div>

                <div class="form-group">
                    <label for="dtype" class="form-label">
                        Discount Type <span class="required">*</span>
                    </label>
                    <select id="dtype" name="dtype" class="form-control" required>
                        <option value="">Select discount type</option>
                        <c:forEach var="type" items="${discountTypes}">
                            <option value="${type}" ${discount.dtype == type ? 'selected' : ''}>${type}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="percentage" class="form-label">
                        Percentage <span class="required">*</span>
                    </label>
                    <input type="number" id="percentage" name="percentage" class="form-control" 
                           value="${discount.percentage}" 
                           placeholder="Enter percentage (e.g., 10 for 10%)" 
                           min="0" max="100" step="0.01" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="start_date" class="form-label">
                            Start Date <span class="required">*</span>
                        </label>
                        <input type="date" id="start_date" name="start_date" class="form-control" 
                               value="<fmt:formatDate value='${discount.startDateAsDate}' pattern='yyyy-MM-dd' />" 
                               required>
                    </div>

                    <div class="form-group">
                        <label for="end_date" class="form-label">
                            End Date <span class="required">*</span>
                        </label>
                        <input type="date" id="end_date" name="end_date" class="form-control" 
                               value="<fmt:formatDate value='${discount.endDateAsDate}' pattern='yyyy-MM-dd' />" 
                               required>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-save">
                        <i class="fas fa-save"></i> 
                        <c:choose>
                            <c:when test="${not empty discount}">Update Discount</c:when>
                            <c:otherwise>Create Discount</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="<c:url value='/admin/discounts'/>" class="btn-cancel">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
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
            const startDate = new Date(document.getElementById('start_date').value);
            const endDate = new Date(document.getElementById('end_date').value);
            
            if (endDate <= startDate) {
                e.preventDefault();
                alert('End date must be after start date.');
                return false;
            }
            
            const percentage = parseFloat(document.getElementById('percentage').value);
            if (percentage < 0 || percentage > 100) {
                e.preventDefault();
                alert('Percentage must be between 0 and 100.');
                return false;
            }
        });
    </script>
</body>
</html>
