<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - BookNest Admin</title>
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
        
        .btn-edit {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
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
        
        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(52,152,219,0.3);
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
        
        .order-details {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .order-id {
            font-size: 28px;
            font-weight: 700;
            color: #1a7f5a;
        }
        
        .order-date {
            color: #666;
            font-size: 16px;
        }
        
        .order-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .info-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
        }
        
        .section-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #1a7f5a;
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #1a1a1a;
        }
        
        .info-value {
            color: #666;
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
        
        .order-items {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
        }
        
        .items-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .items-table th {
            background: #f8f9fa;
            color: #1a1a1a;
            font-weight: 600;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid #e0e0e0;
            font-size: 14px;
        }
        
        .items-table td {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            vertical-align: middle;
        }
        
        .items-table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .book-image {
            width: 60px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
        }
        
        .book-info h6 {
            margin: 0;
            font-weight: 600;
            color: #1a1a1a;
            font-size: 14px;
        }
        
        .book-info p {
            margin: 5px 0 0 0;
            color: #666;
            font-size: 12px;
        }
        
        .order-summary {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .summary-row:last-child {
            border-bottom: none;
            font-weight: 700;
            font-size: 18px;
            color: #1a1a1a;
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
        
        .edit-form {
            margin-top: 20px;
        }
        
        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            background: white;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #1a7f5a;
            box-shadow: 0 0 0 2px rgba(26, 127, 90, 0.2);
        }
        
        .form-control select {
            background: white;
        }
        
        .form-control textarea {
            resize: vertical;
            min-height: 60px;
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
        
        @media (max-width: 768px) {
            .order-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .order-info {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .items-table th,
            .items-table td {
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
            <h1 class="page-title">Order Details</h1>
            <p class="page-subtitle">View detailed order information</p>
        </div>
    </div>

    <div class="main-content">
        <!-- Success/Error Messages -->
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success">
                ✅ Order updated successfully!
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
                <a href="<c:url value='/admin/orders'/>" class="breadcrumb-item">Manage Orders</a>
                <span class="breadcrumb-separator">›</span>
                <span class="breadcrumb-item active">Order Details</span>
            </div>
            
            <div class="action-buttons">
                <a href="<c:url value='/admin/orders/edit/${order.oid}'/>" class="btn-edit">
                    <i class="fas fa-edit"></i> Edit Order
                </a>
                <a href="<c:url value='/admin/orders'/>" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Back to Orders
                </a>
            </div>
        </div>

        <!-- Order Details -->
        <c:if test="${not empty order}">
            <div class="order-details">
                <div class="order-header">
                    <div>
                        <div class="order-id">Order #${order.oid}</div>
                        <div class="order-date">
                            <fmt:formatDate value="${order.orderDateAsDate}" pattern="MMMM dd, yyyy 'at' HH:mm" />
                        </div>
                    </div>
                </div>
                
                <!-- Edit Form -->
                <form action="<c:url value='/admin/orders/edit/${order.oid}'/>" method="post" class="edit-form">
                    <div class="order-info">
                        <div class="info-section">
                            <h3 class="section-title">Customer Information</h3>
                            <div class="info-item">
                                <span class="info-label">Name:</span>
                                <span class="info-value">${order.customer.cname}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Customer ID:</span>
                                <span class="info-value">${order.customer.cid}</span>
                            </div>
                        </div>
                        
                        <div class="info-section">
                            <h3 class="section-title">Order Status</h3>
                            <div class="info-item">
                                <span class="info-label">Status:</span>
                                <span class="info-value">
                                    <select name="status" class="form-control">
                                        <c:forEach var="status" items="${orderStatuses}">
                                            <option value="${status}" ${order.status == status ? 'selected' : ''}>${status}</option>
                                        </c:forEach>
                                    </select>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Payment:</span>
                                <span class="info-value">
                                    <select name="paymentStatus" class="form-control">
                                        <c:forEach var="paymentStatus" items="${paymentStatuses}">
                                            <option value="${paymentStatus}" ${order.paymentStatus == paymentStatus ? 'selected' : ''}>${paymentStatus}</option>
                                        </c:forEach>
                                    </select>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Total Amount:</span>
                                <span class="info-value">$${order.totalAmount}</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="order-info">
                        <div class="info-section">
                            <h3 class="section-title">Tracking Information</h3>
                            <div class="info-item">
                                <span class="info-label">Tracking Number:</span>
                                <span class="info-value">
                                    <input type="text" name="trackingNumber" value="${order.trackingNumber}" class="form-control" placeholder="Enter tracking number">
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Estimated Delivery:</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty order.estimatedDeliveryAsDate}">
                                            <c:set var="estimatedDeliveryFormatted"><fmt:formatDate value='${order.estimatedDeliveryAsDate}' pattern='yyyy-MM-dd' />T<fmt:formatDate value='${order.estimatedDeliveryAsDate}' pattern='HH:mm' /></c:set>
                                            <input type="datetime-local" name="estimatedDelivery" 
                                                   value="${estimatedDeliveryFormatted}" 
                                                   class="form-control">
                                        </c:when>
                                        <c:otherwise>
                                            <input type="datetime-local" name="estimatedDelivery" 
                                                   value="" 
                                                   class="form-control">
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Transaction ID:</span>
                                <span class="info-value">
                                    <input type="text" name="transactionId" value="${order.transactionId}" class="form-control" placeholder="Enter transaction ID">
                                </span>
                            </div>
                        </div>
                        
                        <div class="info-section">
                            <h3 class="section-title">Order Details</h3>
                            <div class="info-item">
                                <span class="info-label">Billing Address:</span>
                                <span class="info-value">
                                    <textarea name="billingAddress" class="form-control" rows="3" placeholder="Enter billing address">${order.billingAddress}</textarea>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Shipping Address:</span>
                                <span class="info-value">
                                    <textarea name="shippingAddress" class="form-control" rows="3" placeholder="Enter shipping address">${order.shippingAddress}</textarea>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Order Notes:</span>
                                <span class="info-value">
                                    <textarea name="orderNotes" class="form-control" rows="3" placeholder="Enter order notes">${order.orderNotes}</textarea>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn-save">
                            <i class="fas fa-save"></i> Update Order
                        </button>
                        <a href="<c:url value='/admin/orders/view/${order.oid}'/>" class="btn-cancel">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
            
            <!-- Order Items -->
            <div class="order-items">
                <h3 class="section-title">Order Items</h3>
                <c:choose>
                    <c:when test="${not empty orderDetails}">
                        <table class="items-table">
                            <thead>
                                <tr>
                                    <th>Book</th>
                                    <th>Quantity</th>
                                    <th>Price</th>
                                    <th>Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${orderDetails}">
                                    <tr>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 15px;">
                                                <c:choose>
                                                    <c:when test="${not empty item.book.imageUrl}">
                                                        <img src="${item.book.imageUrl}" alt="${item.book.title}" class="book-image">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="book-image" style="background: #f8f9fa; display: flex; align-items: center; justify-content: center; color: #ccc;">
                                                            <i class="fas fa-book" style="font-size: 24px;"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="book-info">
                                                    <h6>${item.book.title}</h6>
                                                    <p>by ${item.book.author}</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td>${item.quantity}</td>
                                        <td>$${item.price}</td>
                                        <td>$${item.quantity * item.price}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        
                        <div class="order-summary">
                            <div class="summary-row">
                                <span>Subtotal:</span>
                                <span>$${order.totalAmount}</span>
                            </div>
                            <div class="summary-row">
                                <span>Shipping:</span>
                                <span>$0.00</span>
                            </div>
                            <div class="summary-row">
                                <span>Total:</span>
                                <span>$${order.totalAmount}</span>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align: center; padding: 40px; color: #666;">
                            <i class="fas fa-shopping-cart" style="font-size: 48px; margin-bottom: 15px;"></i>
                            <p>No items found for this order.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
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