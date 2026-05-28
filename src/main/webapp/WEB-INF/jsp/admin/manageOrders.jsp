<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders - BookNest Admin</title>
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
        
        .orders-table {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
            overflow-x: auto;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }
        
        .table th {
            background: #f8f9fa;
            color: #1a1a1a;
            font-weight: 600;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid #e0e0e0;
            font-size: 14px;
        }
        
        .table td {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            vertical-align: middle;
        }
        
        .table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .order-id {
            font-weight: 600;
            color: #1a7f5a;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-processing {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-shipped {
            background: #d4edda;
            color: #155724;
        }
        
        .status-delivered {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }
        
        .payment-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 500;
        }
        
        .payment-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .payment-paid {
            background: #d4edda;
            color: #155724;
        }
        
        .payment-failed {
            background: #f8d7da;
            color: #721c24;
        }
        
        .btn-view {
            background: #3498db;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .btn-view:hover {
            background: #2980b9;
            color: white;
            text-decoration: none;
        }
        
        .btn-update {
            background: #f39c12;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s;
            margin-right: 5px;
        }
        
        .btn-update:hover {
            background: #e67e22;
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
            margin-left: 5px;
        }
        
        .btn-delete:hover {
            background: #c0392b;
            color: white;
            text-decoration: none;
        }
        
        .btn-delete:disabled {
            background: #bdc3c7;
            color: #7f8c8d;
            cursor: not-allowed;
            opacity: 0.6;
        }
        
        .btn-delete:disabled:hover {
            background: #bdc3c7;
            color: #7f8c8d;
            transform: none;
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
            .orders-table {
                padding: 15px;
            }
            
            .table th,
            .table td {
                padding: 10px 8px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body class="admin-page">
    <jsp:include page="../fragments/header.jsp" />

    <!-- Page Header -->
    <div class="page-header">
        <div class="main-content">
            <h1 class="page-title">Manage Orders</h1>
            <p class="page-subtitle">View and manage customer orders</p>
        </div>
    </div>

    <div class="main-content">
        <!-- Success/Error Messages -->
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success">
                ✅ Order updated successfully!
            </div>
        </c:if>
        <c:if test="${param.success == 'order_deleted'}">
            <div class="alert alert-success">
                ✅ Order deleted successfully!
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
                <span class="breadcrumb-item active">Manage Orders</span>
            </div>
            
            <div class="action-buttons">
                <a href="<c:url value='/admin/panel'/>" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Orders Table -->
        <c:choose>
            <c:when test="${not empty orders}">
                <div class="orders-table">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Order Date</th>
                                <th>Total Amount</th>
                                <th>Status</th>
                                <th>Payment</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>
                                        <span class="order-id">#${order.oid}</span>
                                    </td>
                                    <td>
                                        <div>
                                            <strong>${order.customer.cname}</strong><br>
                                            <small class="text-muted">Customer ID: ${order.customer.cid}</small>
                                        </div>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${order.orderDateAsDate}" pattern="MMM dd, yyyy" />
                                    </td>
                                    <td>
                                        <strong>$${order.totalAmount}</strong>
                                    </td>
                                    <td>
                                        <span class="status-badge status-${order.status.name().toLowerCase()}">
                                            ${order.status}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="payment-badge payment-${order.paymentStatus.name().toLowerCase()}">
                                            ${order.paymentStatus}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="<c:url value='/admin/orders/view/${order.oid}'/>" class="btn-view">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                        <a href="<c:url value='/admin/orders/edit/${order.oid}'/>" class="btn-update">
                                            <i class="fas fa-edit"></i> Update
                                        </a>
                                         <c:choose>
                                             <c:when test="true">
                                                 <form action="<c:url value='/admin/orders/${order.oid}/delete'/>" method="post" style="display: inline-block;" onsubmit="return confirmDelete('${order.oid}')">
                                                     <button type="submit" class="btn-delete">
                                                         <i class="fas fa-trash"></i> Delete
                                                     </button>
                                                 </form>
                                             </c:when>
                                             <c:otherwise>
                                                 <button type="button" class="btn-delete" disabled title="Only PENDING, CANCELLED or DELIVERED orders can be deleted">
                                                     <i class="fas fa-trash"></i> Delete
                                                 </button>
                                             </c:otherwise>
                                         </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <h3 class="empty-title">No Orders Found</h3>
                    <p class="empty-subtitle">No orders have been placed yet.</p>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:if test="${currentPage > 0}">
                    <a href="<c:url value='/admin/orders?page=${currentPage - 1}'/>">
                        <i class="fas fa-chevron-left"></i> Previous
                    </a>
                </c:if>
                
                <c:forEach begin="0" end="${totalPages - 1}" var="page">
                    <c:choose>
                        <c:when test="${page == currentPage}">
                            <span class="current">${page + 1}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/admin/orders?page=${page}'/>">${page + 1}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                <c:if test="${currentPage < totalPages - 1}">
                    <a href="<c:url value='/admin/orders?page=${currentPage + 1}'/>">
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
        function confirmDelete(orderId) {
            console.log('Delete button clicked for order ID: ' + orderId);
            var result = confirm('Are you sure you want to delete Order #' + orderId + '?\n\nThis action cannot be undone and will permanently remove the order from the system.');
            console.log('User confirmation result: ' + result);
            return result;
        }
    </script>
</body>
</html>