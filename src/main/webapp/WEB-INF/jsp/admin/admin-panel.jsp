<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel - BookNest</title>
    <jsp:include page="../fragments/common-styles.jsp" />
    <style>
        .admin-page {
            background: #f8f9fa;
            min-height: auto;
        }
        
        .admin-header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 40px 0;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .admin-title {
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .admin-subtitle {
            font-size: 18px;
            opacity: 0.9;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border: 1px solid #e0e0e0;
            transition: all 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            margin-bottom: 15px;
        }
        
        .stat-icon.books { background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%); }
        .stat-icon.customers { background: linear-gradient(135deg, #3498db 0%, #2980b9 100%); }
        .stat-icon.admins { background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%); }
        .stat-icon.orders { background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%); }
        
        .stat-number {
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
            font-weight: 500;
        }
        
        .content-section {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
        }
        
        .section-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #1a7f5a;
        }
        
        .recent-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            margin-bottom: 10px;
            transition: all 0.3s;
        }
        
        .recent-item:hover {
            background: #f8f9fa;
            border-color: #1a7f5a;
        }
        
        .recent-item:last-child {
            margin-bottom: 0;
        }
        
        .recent-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            color: white;
            margin-right: 15px;
        }
        
        .recent-content {
            flex: 1;
        }
        
        .recent-title {
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 5px;
        }
        
        .recent-subtitle {
            color: #666;
            font-size: 14px;
        }
        
        .admin-nav {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
        }
        
        .nav-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .nav-item {
            display: block;
            padding: 15px 20px;
            background: #f8f9fa;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            text-decoration: none;
            color: #1a1a1a;
            font-weight: 500;
            transition: all 0.3s;
            text-align: center;
        }
        
        .nav-item:hover {
            background: #1a7f5a;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .nav-item i {
            display: block;
            font-size: 20px;
            margin-bottom: 8px;
        }
        
        .logout-btn {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s;
            display: inline-block;
        }
        
        .logout-btn:hover {
            background: #c0392b;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #666;
        }
        
        .empty-icon {
            font-size: 48px;
            color: #ccc;
            margin-bottom: 15px;
        }
        
        .empty-text {
            font-size: 16px;
        }
    </style>
</head>
<body class="admin-page">
    <jsp:include page="../fragments/header.jsp" />

    <!-- Admin Header -->
    <div class="admin-header">
        <div class="main-content">
            <h1 class="admin-title">Admin Dashboard</h1>
            <p class="admin-subtitle">Welcome back, ${adminName != null ? adminName : 'Administrator'}!</p>
        </div>
    </div>

    <div class="main-content">
        <!-- Success Messages -->
        <c:if test="${param.login == 'success'}">
            <div class="alert alert-success">
                ✅ Login successful! Welcome to the admin panel.
            </div>
        </c:if>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon books">
                    <i class="fas fa-book"></i>
                </div>
                <div class="stat-number">${totalBooks}</div>
                <div class="stat-label">Total Books</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon customers">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-number">${totalCustomers}</div>
                <div class="stat-label">Total Customers</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon admins">
                    <i class="fas fa-user-shield"></i>
                </div>
                <div class="stat-number">${totalAdmins}</div>
                <div class="stat-label">Active Admins</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon orders">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <div class="stat-number">0</div>
                <div class="stat-label">Total Orders</div>
            </div>
        </div>

        <!-- Quick Navigation -->
        <div class="admin-nav">
            <h3 class="section-title">Quick Actions</h3>
            <div class="nav-grid">
                <a href="<c:url value='/admin/books'/>" class="nav-item">
                    <i class="fas fa-book"></i>
                    Manage Books
                </a>
                <a href="<c:url value='/admin/users'/>" class="nav-item">
                    <i class="fas fa-users"></i>
                    Manage Users
                </a>
                <a href="<c:url value='/admin/orders'/>" class="nav-item">
                    <i class="fas fa-shopping-cart"></i>
                    Manage Orders
                </a>
                <a href="<c:url value='/admin/feedback'/>" class="nav-item">
                    <i class="fas fa-comments"></i>
                    View Feedback
                </a>
                <a href="<c:url value='/admin/discounts'/>" class="nav-item">
                    <i class="fas fa-percent"></i>
                    Manage Discounts
                </a>
                <a href="<c:url value='/admin/reports'/>" class="nav-item">
                    <i class="fas fa-chart-bar"></i>
                    Reports
                </a>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="row">
            <div class="col-md-6">
                <div class="content-section">
                    <h3 class="section-title">Recent Books</h3>
                    <c:choose>
                        <c:when test="${not empty recentBooks}">
                            <c:forEach var="book" items="${recentBooks}">
                                <div class="recent-item">
                                    <div class="recent-icon books">
                                        <i class="fas fa-book"></i>
                                    </div>
                                    <div class="recent-content">
                                        <div class="recent-title">${book.title}</div>
                                        <div class="recent-subtitle">by ${book.author} - $${book.price}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-book"></i>
                                </div>
                                <div class="empty-text">No recent books</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="content-section">
                    <h3 class="section-title">Recent Customers</h3>
                    <c:choose>
                        <c:when test="${not empty recentCustomers}">
                            <c:forEach var="customer" items="${recentCustomers}">
                                <div class="recent-item">
                                    <div class="recent-icon customers">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div class="recent-content">
                                        <div class="recent-title">${customer.username}</div>
                                        <div class="recent-subtitle">${customer.email}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="empty-text">No recent customers</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Logout Button -->
        <div class="text-center" style="margin-top: 30px;">
            <a href="<c:url value='/admin/logout'/>" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
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
    </script>
</body>
</html>