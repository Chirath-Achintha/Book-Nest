<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - BookNest</title>
    <jsp:include page="fragments/common-styles.jsp" />
    <style>
        .profile-page {
            background: #f8f9fa;
            min-height: auto;
        }
        
        .profile-header {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            padding: 40px 0;
            margin-bottom: 20px;
        }
        
        .profile-title {
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .profile-subtitle {
            font-size: 18px;
            opacity: 0.9;
        }
        
        .profile-nav {
            background: white;
            border-radius: 12px;
            padding: 0;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
            overflow: hidden;
        }
        
        .nav-tabs {
            border: none;
            display: flex;
        }
        
        .nav-tabs .nav-link {
            flex: 1;
            border: none;
            color: #666;
            font-weight: 600;
            padding: 20px;
            text-align: center;
            transition: all 0.3s;
            background: transparent;
        }
        
        .nav-tabs .nav-link:hover {
            background: #f8f9fa;
            color: #1a7f5a;
        }
        
        .nav-tabs .nav-link.active {
            background: #1a7f5a;
            color: white;
        }
        
        .profile-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
        }
        
        .card-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .card-subtitle {
            color: #666;
            font-size: 16px;
            margin-bottom: 30px;
        }
        
        .order-card {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            margin-bottom: 20px;
            transition: all 0.3s;
            overflow: hidden;
        }
        
        .order-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
            border-color: #1a7f5a;
        }
        
        .order-header {
            background: #f8f9fa;
            padding: 20px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .order-body {
            padding: 25px;
        }
        
        .order-id {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 5px;
        }
        
        .order-date {
            color: #666;
            font-size: 14px;
        }
        
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-processing {
            background: #cce5ff;
            color: #004085;
        }
        
        .status-shipped {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-delivered {
            background: #d4edda;
            color: #155724;
        }
        
        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }
        
        .payment-paid {
            background: #d4edda;
            color: #155724;
        }
        
        .payment-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .payment-failed {
            background: #f8d7da;
            color: #721c24;
        }
        
        .order-total {
            font-size: 20px;
            font-weight: 700;
            color: #1a7f5a;
        }
        
        .order-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .btn-order {
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .btn-view {
            background: #1a7f5a;
            color: white;
            border: none;
        }
        
        .btn-view:hover {
            background: #156847;
            color: white;
            text-decoration: none;
        }
        
        .btn-track {
            background: #20c997;
            color: white;
            border: none;
        }
        
        .btn-track:hover {
            background: #1ba085;
            color: white;
            text-decoration: none;
        }
        
        .info-section {
            margin-bottom: 20px;
        }
        
        .info-title {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .info-content {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }
        
        .account-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #1a7f5a;
        }
        
        .info-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
            font-size: 14px;
        }
        
        .info-value {
            color: #1a1a1a;
            font-size: 16px;
        }
        
        .account-actions {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .btn-account {
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .btn-edit {
            background: #1a7f5a;
            color: white;
            border: none;
        }
        
        .btn-edit:hover {
            background: #156847;
            color: white;
            text-decoration: none;
        }
        
        .btn-password {
            background: transparent;
            color: #666;
            border: 2px solid #e0e0e0;
        }
        
        .btn-password:hover {
            border-color: #1a7f5a;
            color: #1a7f5a;
            text-decoration: none;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        
        .empty-icon {
            font-size: 60px;
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
        
        .start-shopping-btn {
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
        
        .start-shopping-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(26,127,90,0.3);
            color: white;
            text-decoration: none;
        }
        
        @media (max-width: 768px) {
            .profile-title {
                font-size: 32px;
            }
            
            .nav-tabs {
                flex-direction: column;
            }
            
            .order-actions {
                flex-direction: column;
            }
            
            .account-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body class="profile-page">
    <jsp:include page="fragments/header.jsp" />

    <!-- Profile Header -->
    <div class="profile-header">
        <div class="main-content">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h1 class="profile-title">My Profile</h1>
                    <p class="profile-subtitle">Welcome back! Manage your account and view your order history.</p>
                </div>
                <div style="display: flex; gap: 15px;">
                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-light">
                        🛒 Cart
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light">
                        Logout
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="main-content">
        <!-- Navigation Tabs -->
        <div class="profile-nav">
            <div class="nav-tabs" id="profileTabs" role="tablist">
                <button class="nav-link active" id="orders-tab" onclick="showTab('orders')" type="button">
                    📦 My Orders
                </button>
                <button class="nav-link" id="account-tab" onclick="showTab('account')" type="button">
                    ⚙️ Account Settings
                </button>
            </div>
        </div>

        <!-- Orders Tab -->
        <div id="orders-content" class="tab-content">
            <div class="profile-card">
                <h3 class="card-title">Order History</h3>
                <p class="card-subtitle">Track your orders and view order details</p>
                
                <c:choose>
                    <c:when test="${not empty orders}">
                        <c:forEach var="order" items="${orders}">
                            <div class="order-card">
                                <div class="order-header">
                                    <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
                                        <div>
                                            <div class="order-id">Order #${order.oid}</div>
                                            <div class="order-date">
                                                <fmt:formatDate value="${order.orderDateAsDate}" pattern="MMM dd, yyyy 'at' HH:mm"/>
                                            </div>
                                        </div>
                                        <div style="display: flex; gap: 10px; align-items: center;">
                                            <span class="status-badge status-${order.status.name().toLowerCase()}">
                                                ${order.statusDisplayName}
                                            </span>
                                            <span class="status-badge payment-${order.paymentStatus.name().toLowerCase()}">
                                                ${order.paymentStatusDisplayName}
                                            </span>
                                        </div>
                                        <div class="order-total">$${order.totalAmount}</div>
                                    </div>
                                </div>
                                <div class="order-body">
                                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
                                        <div class="info-section">
                                            <div class="info-title">Order Info</div>
                                            <div class="info-content">
                                                <div><strong>Total:</strong> $${order.totalAmount}</div>
                                                <c:if test="${not empty order.trackingNumber}">
                                                    <div><strong>Tracking:</strong> ${order.trackingNumber}</div>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="info-section">
                                            <div class="info-title">Shipping Address</div>
                                            <div class="info-content">${order.shippingAddress}</div>
                                        </div>
                                    </div>
                                    <div class="order-actions" style="margin-top: 20px;">
                                        <a href="${pageContext.request.contextPath}/orders/details/${order.oid}" class="btn-order btn-view">
                                            View Details
                                        </a>
                                        <c:if test="${not empty order.trackingNumber}">
                                            <a href="${pageContext.request.contextPath}/orders/tracking/${order.oid}" class="btn-order btn-track">
                                                Track Order
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-icon">📦</div>
                            <h3 class="empty-title">No Orders Yet</h3>
                            <p class="empty-subtitle">You haven't placed any orders yet. Start shopping to see your order history here.</p>
                            <a href="${pageContext.request.contextPath}/" class="start-shopping-btn">
                                Start Shopping
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Account Tab -->
        <div id="account-content" class="tab-content" style="display: none;">
            <div class="profile-card">
                <h3 class="card-title">Account Information</h3>
                <p class="card-subtitle">Manage your account settings and personal information</p>
                
                <div class="account-info">
                    <div class="info-item">
                        <div class="info-label">Username</div>
                        <div class="info-value">${user.username}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Customer ID</div>
                        <div class="info-value">#${user.cid}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Email</div>
                        <div class="info-value">${user.email}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Phone</div>
                        <div class="info-value">${user.phone}</div>
                    </div>
                </div>
                
                <div class="info-item" style="margin-bottom: 30px;">
                    <div class="info-label">Address</div>
                    <div class="info-value">${user.address}</div>
                </div>
                
                <div class="account-actions">
                    <a href="${pageContext.request.contextPath}/profile/edit" class="btn-account btn-edit">
                        Edit Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/profile/change-password" class="btn-account btn-password">
                        Change Password
                    </a>
                </div>
                
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success" style="margin-top: 20px;">
                        ✅ ${param.success}
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <jsp:include page="fragments/footer.jsp" />

    <script>
        function showTab(tabName) {
            // Hide all tab contents
            document.querySelectorAll('.tab-content').forEach(content => {
                content.style.display = 'none';
            });
            
            // Remove active class from all nav links
            document.querySelectorAll('.nav-link').forEach(link => {
                link.classList.remove('active');
            });
            
            // Show selected tab content
            document.getElementById(tabName + '-content').style.display = 'block';
            
            // Add active class to clicked nav link
            document.getElementById(tabName + '-tab').classList.add('active');
        }
        
        // Add hover effects to order cards
        document.addEventListener('DOMContentLoaded', function() {
            const orderCards = document.querySelectorAll('.order-card');
            orderCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
        });
    </script>
</body>
</html>