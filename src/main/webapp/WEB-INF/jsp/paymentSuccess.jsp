<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful - BookNest</title>
    <jsp:include page="fragments/common-styles.jsp" />
    <style>
        .success-page {
            background: #f8f9fa;
            min-height: 100vh;
        }
        
        .success-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 60px 0;
            text-align: center;
            margin-bottom: 40px;
        }
        
        .success-icon {
            font-size: 80px;
            margin-bottom: 20px;
            animation: bounce 2s infinite;
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }
        
        .success-title {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .success-subtitle {
            font-size: 20px;
            opacity: 0.9;
        }
        
        .order-details-card {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            border: 1px solid #e0e0e0;
        }
        
        .order-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            border-left: 4px solid #28a745;
        }
        
        .info-label {
            font-weight: 600;
            color: #666;
            font-size: 14px;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .info-value {
            font-size: 16px;
            font-weight: 600;
            color: #333;
        }
        
        .order-id {
            color: #28a745;
            font-size: 20px;
        }
        
        .total-amount {
            color: #28a745;
            font-size: 24px;
            font-weight: 700;
        }
        
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            padding: 16px 30px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 12px;
            color: white;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40,167,69,0.3);
            text-decoration: none;
            color: white;
        }
        
        .btn-secondary {
            background: transparent;
            color: #666;
            border: 2px solid #e0e0e0;
            padding: 16px 30px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-secondary:hover {
            border-color: #28a745;
            color: #28a745;
            text-decoration: none;
        }
        
        .next-steps {
            background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 100%);
            border-radius: 16px;
            padding: 30px;
            margin-top: 30px;
            border: 1px solid #e0e0e0;
        }
        
        .next-steps h3 {
            color: #1976d2;
            margin-bottom: 20px;
            font-size: 24px;
            font-weight: 700;
        }
        
        .steps-list {
            list-style: none;
            padding: 0;
        }
        
        .steps-list li {
            padding: 12px 0;
            border-bottom: 1px solid rgba(25,118,210,0.1);
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .steps-list li:last-child {
            border-bottom: none;
        }
        
        .step-icon {
            background: #1976d2;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
        }
        
        .step-text {
            color: #333;
            font-size: 16px;
        }
        
        @media (max-width: 768px) {
            .success-title {
                font-size: 36px;
            }
            
            .order-info {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body class="success-page">
    <jsp:include page="fragments/header.jsp" />

    <!-- Success Header -->
    <div class="success-header">
        <div class="main-content">
            <div class="success-icon">✅</div>
            <h1 class="success-title">Payment Successful!</h1>
            <p class="success-subtitle">Your order has been placed and payment confirmed</p>
        </div>
    </div>

    <div class="main-content">
        <c:if test="${not empty order}">
            <!-- Order Details Card -->
            <div class="order-details-card">
                <h2 style="color: #333; margin-bottom: 25px; font-size: 28px; font-weight: 700;">
                    📋 Order Details
                </h2>
                
                <div class="order-info">
                    <div class="info-item">
                        <div class="info-label">Order Number</div>
                        <div class="info-value order-id">#${order.oid}</div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">Order Date</div>
                        <div class="info-value">
                            <fmt:formatDate value="${order.orderDateAsDate}" pattern="MMM dd, yyyy 'at' HH:mm" />
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">Payment Method</div>
                        <div class="info-value">${order.paymentMethod}</div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">Transaction ID</div>
                        <div class="info-value">${order.transactionId}</div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">Total Amount</div>
                        <div class="info-value total-amount">
                            $<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" />
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-label">Order Status</div>
                        <div class="info-value" style="color: #28a745; font-weight: 700;">
                            ${order.statusDisplayName}
                        </div>
                    </div>
                </div>
                
                <c:if test="${not empty order.billingAddress}">
                    <div style="margin-top: 25px;">
                        <h4 style="color: #333; margin-bottom: 15px; font-size: 18px; font-weight: 600;">
                            📍 Billing Address
                        </h4>
                        <p style="color: #666; line-height: 1.6; background: #f8f9fa; padding: 15px; border-radius: 8px;">
                            ${order.billingAddress}
                        </p>
                    </div>
                </c:if>
                
                <c:if test="${not empty order.shippingAddress}">
                    <div style="margin-top: 20px;">
                        <h4 style="color: #333; margin-bottom: 15px; font-size: 18px; font-weight: 600;">
                            🚚 Shipping Address
                        </h4>
                        <p style="color: #666; line-height: 1.6; background: #f8f9fa; padding: 15px; border-radius: 8px;">
                            ${order.shippingAddress}
                        </p>
                    </div>
                </c:if>
                
                <c:if test="${not empty order.orderNotes}">
                    <div style="margin-top: 20px;">
                        <h4 style="color: #333; margin-bottom: 15px; font-size: 18px; font-weight: 600;">
                            📝 Order Notes
                        </h4>
                        <p style="color: #666; line-height: 1.6; background: #f8f9fa; padding: 15px; border-radius: 8px;">
                            ${order.orderNotes}
                        </p>
                    </div>
                </c:if>
            </div>
            
            <!-- Next Steps -->
            <div class="next-steps">
                <h3>🚀 What happens next?</h3>
                <ul class="steps-list">
                    <li>
                        <div class="step-icon">1</div>
                        <div class="step-text">We'll process your order and prepare it for shipment</div>
                    </li>
                    <li>
                        <div class="step-icon">2</div>
                        <div class="step-text">You'll receive a confirmation email with tracking details</div>
                    </li>
                    <li>
                        <div class="step-icon">3</div>
                        <div class="step-text">Your order will be shipped within 1-2 business days</div>
                    </li>
                    <li>
                        <div class="step-icon">4</div>
                        <div class="step-text">Track your package using the tracking number provided</div>
                    </li>
                </ul>
            </div>
            
            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/payment/${order.oid}/invoice" 
                   class="btn-primary" target="_blank">
                    📄 Download Invoice
                </a>
                <a href="${pageContext.request.contextPath}/orders" class="btn-secondary">
                    📦 View My Orders
                </a>
                <a href="${pageContext.request.contextPath}/" class="btn-secondary">
                    🏠 Continue Shopping
                </a>
            </div>
        </c:if>
        
        <c:if test="${empty order}">
            <div class="order-details-card">
                <h2 style="color: #dc3545; margin-bottom: 20px;">❌ Order Not Found</h2>
                <p style="color: #666; font-size: 16px;">
                    We couldn't find the order details. Please contact our support team if you continue to experience issues.
                </p>
                <div class="action-buttons" style="margin-top: 20px;">
                    <a href="${pageContext.request.contextPath}/orders" class="btn-primary">
                        📦 View My Orders
                    </a>
                    <a href="${pageContext.request.contextPath}/" class="btn-secondary">
                        🏠 Go Home
                    </a>
                </div>
            </div>
        </c:if>
    </div>

    <jsp:include page="fragments/footer.jsp" />

    <script>
        // Auto-scroll to top on page load
        window.scrollTo(0, 0);
        
        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function() {
            // Animate the success icon
            const successIcon = document.querySelector('.success-icon');
            if (successIcon) {
                setTimeout(() => {
                    successIcon.style.transform = 'scale(1.1)';
                    setTimeout(() => {
                        successIcon.style.transform = 'scale(1)';
                    }, 200);
                }, 500);
            }
            
            // Add hover effects to info items
            const infoItems = document.querySelectorAll('.info-item');
            infoItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                    this.style.boxShadow = '0 4px 15px rgba(0,0,0,0.1)';
                });
                
                item.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                    this.style.boxShadow = 'none';
                });
            });
        });
    </script>
</body>
</html>
