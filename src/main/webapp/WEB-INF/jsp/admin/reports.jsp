<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - BookNest Admin</title>
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
        
        .reports-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .report-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border: 1px solid #e0e0e0;
            transition: all 0.3s;
        }
        
        .report-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        
        .report-icon {
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
        
        .report-icon.sales { background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%); }
        .report-icon.customers { background: linear-gradient(135deg, #3498db 0%, #2980b9 100%); }
        .report-icon.books { background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%); }
        .report-icon.orders { background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%); }
        
        .report-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .report-description {
            color: #666;
            font-size: 14px;
            margin-bottom: 20px;
            line-height: 1.5;
        }
        
        .report-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: #1a7f5a;
        }
        
        .stat-label {
            color: #666;
            font-size: 12px;
        }
        
        .btn-generate {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            width: 100%;
            justify-content: center;
        }
        
        .btn-generate:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(26,127,90,0.3);
            color: white;
            text-decoration: none;
        }
        
        .chart-section {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
        }
        
        .chart-title {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #1a7f5a;
        }
        
        .chart-placeholder {
            height: 300px;
            background: #f8f9fa;
            border: 2px dashed #e0e0e0;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 16px;
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
        
        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
        }
        
        @media (max-width: 768px) {
            .reports-grid {
                grid-template-columns: 1fr;
            }
            
            .report-stats {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body class="admin-page">
    <jsp:include page="../fragments/header.jsp" />

    <!-- Page Header -->
    <div class="page-header">
        <div class="main-content">
            <h1 class="page-title">Reports & Analytics</h1>
            <p class="page-subtitle">View business insights and generate reports</p>
        </div>
    </div>

    <div class="main-content">
        <!-- Info Messages -->
        <c:if test="${param.info != null}">
            <div class="alert alert-info">
                ℹ️ ${param.info}
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
                <span class="breadcrumb-item active">Reports</span>
            </div>
            
            <div class="action-buttons">
                <a href="<c:url value='/admin/panel'/>" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Reports Grid -->
        <div class="reports-grid">
            <div class="report-card">
                <div class="report-icon sales">
                    <i class="fas fa-chart-line"></i>
                </div>
                <h3 class="report-title">Sales Report</h3>
                <p class="report-description">
                    Generate comprehensive sales reports including revenue, orders, and trends.
                </p>
                <div class="report-stats">
                    <div>
                        <div class="stat-value">$${totalRevenue != null ? totalRevenue : '0'}</div>
                        <div class="stat-label">Total Revenue</div>
                    </div>
                    <div>
                        <div class="stat-value">${totalOrders != null ? totalOrders : '0'}</div>
                        <div class="stat-label">Total Orders</div>
                    </div>
                </div>
                <a href="<c:url value='/admin/reports/sales'/>" class="btn-generate">
                    <i class="fas fa-download"></i> Generate Sales Report
                </a>
            </div>
            
            <div class="report-card">
                <div class="report-icon customers">
                    <i class="fas fa-users"></i>
                </div>
                <h3 class="report-title">Customer Report</h3>
                <p class="report-description">
                    Analyze customer data, registration trends, and customer behavior.
                </p>
                <div class="report-stats">
                    <div>
                        <div class="stat-value">${totalCustomers != null ? totalCustomers : '0'}</div>
                        <div class="stat-label">Total Customers</div>
                    </div>
                    <div>
                        <div class="stat-value">${newCustomers != null ? newCustomers : '0'}</div>
                        <div class="stat-label">New This Month</div>
                    </div>
                </div>
                <a href="<c:url value='/admin/reports/customers'/>" class="btn-generate">
                    <i class="fas fa-download"></i> Generate Customer Report
                </a>
            </div>
            
            <div class="report-card">
                <div class="report-icon books">
                    <i class="fas fa-book"></i>
                </div>
                <h3 class="report-title">Inventory Report</h3>
                <p class="report-description">
                    Track book inventory, bestsellers, and stock levels across categories.
                </p>
                <div class="report-stats">
                    <div>
                        <div class="stat-value">${totalBooks != null ? totalBooks : '0'}</div>
                        <div class="stat-label">Total Books</div>
                    </div>
                    <div>
                        <div class="stat-value">${lowStockBooks != null ? lowStockBooks : '0'}</div>
                        <div class="stat-label">Low Stock</div>
                    </div>
                </div>
                <a href="<c:url value='/admin/reports/inventory'/>" class="btn-generate">
                    <i class="fas fa-download"></i> Generate Inventory Report
                </a>
            </div>
            
            <div class="report-card">
                <div class="report-icon orders">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <h3 class="report-title">Order Report</h3>
                <p class="report-description">
                    Detailed order analysis including status, fulfillment, and shipping.
                </p>
                <div class="report-stats">
                    <div>
                        <div class="stat-value">${pendingOrders != null ? pendingOrders : '0'}</div>
                        <div class="stat-label">Pending Orders</div>
                    </div>
                    <div>
                        <div class="stat-value">${completedOrders != null ? completedOrders : '0'}</div>
                        <div class="stat-label">Completed</div>
                    </div>
                </div>
                <a href="<c:url value='/admin/reports/orders'/>" class="btn-generate">
                    <i class="fas fa-download"></i> Generate Order Report
                </a>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="chart-section">
            <h3 class="chart-title">Sales Trends</h3>
            <div class="chart-placeholder">
                <i class="fas fa-chart-area" style="font-size: 48px; margin-right: 15px;"></i>
                Sales trend chart will be displayed here
            </div>
        </div>
        
        <div class="chart-section">
            <h3 class="chart-title">Top Selling Books</h3>
            <div class="chart-placeholder">
                <i class="fas fa-chart-bar" style="font-size: 48px; margin-right: 15px;"></i>
                Top selling books chart will be displayed here
            </div>
        </div>
        
        <div class="chart-section">
            <h3 class="chart-title">Customer Demographics</h3>
            <div class="chart-placeholder">
                <i class="fas fa-chart-pie" style="font-size: 48px; margin-right: 15px;"></i>
                Customer demographics chart will be displayed here
            </div>
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