<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - BookNest</title>
    <jsp:include page="fragments/common-styles.jsp" />
    <style>
        .payment-page {
            background: #f8f9fa;
            min-height: 100vh;
        }
        
        .payment-header {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            padding: 40px 0;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .payment-title {
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .payment-subtitle {
            font-size: 18px;
            opacity: 0.9;
        }
        
        .payment-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .order-summary {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border: 1px solid #e0e0e0;
            height: fit-content;
        }
        
        .summary-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f8f9fa;
        }
        
        .order-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .order-item.total {
            border-top: 2px solid #1a7f5a;
            font-size: 18px;
            font-weight: 700;
            margin-top: 15px;
            padding-top: 15px;
        }
        
        .total-amount {
            color: #1a7f5a;
        }
        
        .payment-form {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border: 1px solid #e0e0e0;
        }
        
        .form-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f8f9fa;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #1a7f5a;
            box-shadow: 0 0 0 3px rgba(26,127,90,0.1);
        }
        
        .form-select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            background-color: white;
            transition: border-color 0.3s;
        }
        
        .form-select:focus {
            outline: none;
            border-color: #1a7f5a;
            box-shadow: 0 0 0 3px rgba(26,127,90,0.1);
        }
        
        .card-fields {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-top: 15px;
            border: 1px solid #e0e0e0;
        }
        
        .btn-pay {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            border: none;
            padding: 16px 30px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 10px;
            width: 100%;
            color: white;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }
        
        .btn-pay::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        
        .btn-pay:hover::before {
            left: 100%;
        }
        
        .btn-pay:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(26,127,90,0.3);
        }
        
        .btn-cancel {
            background: transparent;
            color: #666;
            border: 2px solid #e0e0e0;
            padding: 16px 30px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: block;
            text-align: center;
            width: 100%;
            margin-top: 15px;
        }
        
        .btn-cancel:hover {
            border-color: #1a7f5a;
            color: #1a7f5a;
            text-decoration: none;
        }
        
        .required {
            color: #dc3545;
        }
        
        .payment-method-info {
            background: #e3f2fd;
            border: 1px solid #bbdefb;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .payment-method-info h4 {
            color: #1976d2;
            margin-bottom: 10px;
            font-size: 16px;
            font-weight: 600;
        }
        
        .payment-method-info p {
            color: #666;
            font-size: 14px;
            margin: 0;
        }
        
        @media (max-width: 768px) {
            .payment-container {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .payment-title {
                font-size: 32px;
            }
            
            .order-summary,
            .payment-form {
                padding: 20px;
            }
        }
    </style>
</head>
<body class="payment-page">
    <jsp:include page="fragments/header.jsp" />

    <!-- Header -->
    <div class="payment-header">
        <div class="main-content">
            <h1 class="payment-title">Complete Payment</h1>
            <p class="payment-subtitle">Review your order and complete the payment process</p>
        </div>
    </div>

    <div class="payment-container">
        <!-- Order Summary -->
        <div class="order-summary">
            <h2 class="summary-title">📋 Order Summary</h2>
            
            <c:if test="${not empty order}">
                <div class="order-item">
                    <span><strong>Order Number:</strong></span>
                    <span>#${order.oid}</span>
                </div>
                
                <div class="order-item">
                    <span><strong>Order Date:</strong></span>
                    <span><fmt:formatDate value="${order.orderDateAsDate}" pattern="MMM dd, yyyy" /></span>
                </div>
                
                <div class="order-item">
                    <span><strong>Payment Method:</strong></span>
                    <span>${order.paymentMethod}</span>
                </div>
                
                <div class="order-item">
                    <span><strong>Items:</strong></span>
                    <span>Cart Items</span>
                </div>
                
                <div class="order-item total">
                    <span><strong>Total Amount:</strong></span>
                    <span class="total-amount">$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" /></span>
                </div>
                
                <c:if test="${not empty order.billingAddress}">
                    <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #f0f0f0;">
                        <h4 style="color: #333; margin-bottom: 10px; font-size: 16px; font-weight: 600;">
                            📍 Billing Address
                        </h4>
                        <p style="color: #666; font-size: 14px; line-height: 1.5;">
                            ${order.billingAddress}
                        </p>
                    </div>
                </c:if>
                
                <c:if test="${not empty order.shippingAddress}">
                    <div style="margin-top: 15px;">
                        <h4 style="color: #333; margin-bottom: 10px; font-size: 16px; font-weight: 600;">
                            🚚 Shipping Address
                        </h4>
                        <p style="color: #666; font-size: 14px; line-height: 1.5;">
                            ${order.shippingAddress}
                        </p>
                    </div>
                </c:if>
            </c:if>
        </div>

        <!-- Payment Form -->
        <div class="payment-form">
            <h2 class="form-title">💳 Payment Details</h2>
            
            <c:if test="${not empty order}">
                <c:choose>
                    <c:when test="${order.paymentMethod == 'CASH_ON_DELIVERY'}">
                        <div class="payment-method-info">
                            <h4>💰 Cash on Delivery</h4>
                            <p>You will pay for your order when it is delivered to your address. No payment is required now.</p>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/payment/${order.oid}/confirm" method="post">
                            <button type="submit" class="btn-pay">
                                ✅ Confirm Order (Cash on Delivery)
                            </button>
                        </form>
                    </c:when>
                    
                    <c:otherwise>
                        <div class="payment-method-info">
                            <h4>💳 Credit/Debit Card</h4>
                            <p>Enter your card details to complete the payment securely.</p>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/payment/${order.oid}/confirm" method="post">
                            <div class="form-group">
                                <label for="cardNumber" class="form-label">Card Number <span class="required">*</span></label>
                                <input type="text" id="cardNumber" name="cardNumber" class="form-control" 
                                       placeholder="1234 5678 9012 3456" maxlength="23" required />
                            </div>
                            
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                                <div class="form-group">
                                    <label for="cardExpiry" class="form-label">Expiry (MM/YY) <span class="required">*</span></label>
                                    <input type="text" id="cardExpiry" name="cardExpiry" class="form-control" 
                                           placeholder="MM/YY" maxlength="5" required />
                                </div>
                                <div class="form-group">
                                    <label for="cardCvv" class="form-label">CVV <span class="required">*</span></label>
                                    <input type="password" id="cardCvv" name="cardCvv" class="form-control" 
                                           placeholder="123" maxlength="4" required />
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="cardName" class="form-label">Cardholder Name <span class="required">*</span></label>
                                <input type="text" id="cardName" name="cardName" class="form-control" 
                                       placeholder="John Doe" required />
                            </div>
                            
                            <button type="submit" class="btn-pay">
                                💳 Pay $<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" />
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
                
                <a href="${pageContext.request.contextPath}/cart" class="btn-cancel">
                    ← Back to Cart
                </a>
            </c:if>
            
            <c:if test="${empty order}">
                <div style="text-align: center; padding: 40px 20px;">
                    <h3 style="color: #dc3545; margin-bottom: 15px;">❌ Order Not Found</h3>
                    <p style="color: #666; margin-bottom: 20px;">We couldn't find the order details.</p>
                    <a href="${pageContext.request.contextPath}/cart" class="btn-pay">
                        🛒 Go to Cart
                    </a>
                </div>
            </c:if>
        </div>
    </div>

    <jsp:include page="fragments/footer.jsp" />

    <script>
        // Form validation
        document.querySelector('form')?.addEventListener('submit', function(e) {
            const cardNumber = document.getElementById('cardNumber')?.value || '';
            const cardExpiry = document.getElementById('cardExpiry')?.value || '';
            const cardCvv = document.getElementById('cardCvv')?.value || '';
            const cardName = document.getElementById('cardName')?.value || '';
            
            if (cardNumber && cardExpiry && cardCvv && cardName) {
                const number = cardNumber.replace(/\s+/g,'');
                if (number.length < 12 || !/^\d{12,19}$/.test(number)) {
                    e.preventDefault(); 
                    alert('Enter a valid card number.'); 
                    return;
                }
                if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(cardExpiry)) {
                    e.preventDefault(); 
                    alert('Enter expiry in MM/YY format.'); 
                    return;
                }
                if (!/^\d{3,4}$/.test(cardCvv)) {
                    e.preventDefault(); 
                    alert('Enter a valid CVV.'); 
                    return;
                }
                if (cardName.trim().length < 2) {
                    e.preventDefault(); 
                    alert('Enter a valid cardholder name.'); 
                    return;
                }
            }
        });

        // Format card number
        const cardNumberInput = document.getElementById('cardNumber');
        if (cardNumberInput) {
            cardNumberInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
                let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
                if (formattedValue.length > 19) {
                    formattedValue = formattedValue.substr(0, 19);
                }
                e.target.value = formattedValue;
            });
        }

        // Format expiry date
        const cardExpiryInput = document.getElementById('cardExpiry');
        if (cardExpiryInput) {
            cardExpiryInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length >= 2) {
                    value = value.substring(0, 2) + '/' + value.substring(2, 4);
                }
                e.target.value = value;
            });
        }
    </script>
</body>
</html>
