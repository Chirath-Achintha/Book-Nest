<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - BookNest</title>
    <jsp:include page="fragments/common-styles.jsp" />
    <style>
        .checkout-page {
            background: #f8f9fa;
            min-height: auto;
        }
        
        .checkout-header {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            padding: 40px 0;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .checkout-title {
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .checkout-subtitle {
            font-size: 18px;
            opacity: 0.9;
        }
        
        .form-section {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
        }
        
        .section-title {
            font-size: 20px;
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
        
        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }
        
        .card-fields {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-top: 15px;
            border: 1px solid #e0e0e0;
        }
        
        .cart-summary {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 15px;
            border: 1px solid #e0e0e0;
        }
        
        .cart-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .cart-item:last-child {
            border-bottom: none;
        }
        
        .cart-item.total {
            border-top: 2px solid #1a7f5a;
            font-size: 18px;
            font-weight: 700;
            margin-top: 15px;
            padding-top: 15px;
        }
        
        .total-amount {
            color: #1a7f5a;
        }
        
        .btn-checkout {
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
        
        .btn-checkout::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        
        .btn-checkout:hover::before {
            left: 100%;
        }
        
        .btn-checkout:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(26,127,90,0.3);
        }
        
        .btn-back {
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
        }
        
        .btn-back:hover {
            border-color: #1a7f5a;
            color: #1a7f5a;
            text-decoration: none;
        }
        
        .action-buttons {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-top: 20px;
        }
        
        .required {
            color: #dc3545;
        }
        
        @media (max-width: 768px) {
            .checkout-title {
                font-size: 32px;
            }
            
            .form-section {
                padding: 20px;
            }
            
            .action-buttons {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body class="checkout-page">
    <jsp:include page="fragments/header.jsp" />

    <!-- Header -->
    <div class="checkout-header">
        <div class="main-content">
            <h1 class="checkout-title">Checkout</h1>
            <p class="checkout-subtitle">Complete your order and proceed to payment</p>
        </div>
    </div>

    <div class="main-content">
        <!-- Error Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                ❌ ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/checkout" method="post">
            <div class="grid-2">
                <!-- Billing Information -->
                <div class="form-section">
                    <h3 class="section-title">💳 Billing Information</h3>
                    
                    <div class="form-group">
                        <label for="billingAddress" class="form-label">Billing Address <span class="required">*</span></label>
                        <textarea class="form-control" id="billingAddress" name="billingAddress" 
                                  rows="3" required placeholder="Enter your billing address"></textarea>
                    </div>

                    <div class="form-group">
                        <label for="paymentMethod" class="form-label">Payment Method <span class="required">*</span></label>
                        <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                            <option value="">Select Payment Method</option>
                            <option value="COD">Cash on Delivery</option>
                            <option value="CARD">Credit/Debit Card</option>
                        </select>
                    </div>
                    
                    <div id="cardFields" class="card-fields" style="display:none;">
                        <div class="form-group">
                            <label class="form-label">Card Number</label>
                            <input type="text" name="cardNumber" class="form-control" placeholder="1234 5678 9012 3456" maxlength="23" />
                        </div>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <div class="form-group">
                                <label class="form-label">Expiry (MM/YY)</label>
                                <input type="text" name="cardExpiry" class="form-control" placeholder="MM/YY" maxlength="5" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">CVV</label>
                                <input type="password" name="cardCvv" class="form-control" placeholder="123" maxlength="4" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Shipping Information -->
                <div class="form-section">
                    <h3 class="section-title">🚚 Shipping Information</h3>
                    
                    <div class="form-group">
                        <label for="shippingAddress" class="form-label">Shipping Address <span class="required">*</span></label>
                        <textarea class="form-control" id="shippingAddress" name="shippingAddress" 
                                  rows="3" required placeholder="Enter your shipping address"></textarea>
                    </div>

                    <div class="form-group">
                        <label for="orderNotes" class="form-label">Order Notes</label>
                        <textarea class="form-control" id="orderNotes" name="orderNotes" 
                                  rows="2" placeholder="Any special instructions for your order"></textarea>
                    </div>
                </div>
            </div>

            <!-- Cart Summary -->
            <div class="form-section">
                <h3 class="section-title">📋 Order Summary</h3>
                <div class="cart-summary">
                    <div class="cart-item">
                        <span><strong>Items in Cart:</strong></span>
                        <span>3 items</span>
                    </div>
                    <div class="cart-item">
                        <span><strong>Subtotal:</strong></span>
                        <span>$45.99</span>
                    </div>
                    <div class="cart-item">
                        <span><strong>Shipping:</strong></span>
                        <span style="color: #1a7f5a; font-weight: 600;">FREE</span>
                    </div>
                    <div class="cart-item total">
                        <span><strong>Total:</strong></span>
                        <span class="total-amount">$45.99</span>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/cart" class="btn-back">
                    ← Back to Cart
                </a>
                <button type="submit" class="btn-checkout">
                    Proceed to Payment
                </button>
            </div>
        </form>
    </div>

    <jsp:include page="fragments/footer.jsp" />

    <script>
        // Auto-fill shipping address with billing address
        document.getElementById('billingAddress').addEventListener('input', function() {
            const shippingAddress = document.getElementById('shippingAddress');
            if (shippingAddress.value === '') {
                shippingAddress.value = this.value;
            }
        });

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const billingAddress = document.getElementById('billingAddress').value.trim();
            const shippingAddress = document.getElementById('shippingAddress').value.trim();
            const paymentMethod = document.getElementById('paymentMethod').value;

            if (!billingAddress || !shippingAddress || !paymentMethod) {
                e.preventDefault();
                alert('Please fill in all required fields.');
                return;
            }

            if (paymentMethod === 'CARD') {
                const number = (document.querySelector('input[name="cardNumber"]').value || '').replace(/\s+/g,'');
                const expiry = document.querySelector('input[name="cardExpiry"]').value || '';
                const cvv = document.querySelector('input[name="cardCvv"]').value || '';
                
                if (number.length < 12 || !/^\d{12,19}$/.test(number)) {
                    e.preventDefault(); 
                    alert('Enter a valid card number.'); 
                    return;
                }
                if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiry)) {
                    e.preventDefault(); 
                    alert('Enter expiry in MM/YY format.'); 
                    return;
                }
                if (!/^\d{3,4}$/.test(cvv)) {
                    e.preventDefault(); 
                    alert('Enter a valid CVV.'); 
                    return;
                }
            }
        });

        // Toggle card fields
        document.getElementById('paymentMethod').addEventListener('change', function() {
            const showCard = this.value === 'CARD';
            document.getElementById('cardFields').style.display = showCard ? 'block' : 'none';
        });

        // Format card number
        document.querySelector('input[name="cardNumber"]').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
            let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
            if (formattedValue.length > 19) {
                formattedValue = formattedValue.substr(0, 19);
            }
            e.target.value = formattedValue;
        });

        // Format expiry date
        document.querySelector('input[name="cardExpiry"]').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length >= 2) {
                value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }
            e.target.value = value;
        });
    </script>
</body>
</html>