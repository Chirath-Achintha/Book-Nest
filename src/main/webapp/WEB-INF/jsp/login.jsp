<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - BookNest</title>
    <jsp:include page="fragments/common-styles.jsp" />
    <style>
        body {
            background: linear-gradient(135deg, #c8dce8 0%, #b8d4e8 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .login-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 50px;
            width: 100%;
            max-width: 450px;
            position: relative;
            overflow: hidden;
        }
        
        .login-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #1a7f5a, #20c997);
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .login-title {
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .login-subtitle {
            color: #666;
            font-size: 16px;
            margin-bottom: 10px;
        }
        
        .form-group {
            margin-bottom: 25px;
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
            padding: 14px 18px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s;
            background: #fafafa;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #1a7f5a;
            background: white;
            box-shadow: 0 0 0 4px rgba(26,127,90,0.1);
        }
        
        .btn-login {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            border: none;
            border-radius: 10px;
            padding: 16px 30px;
            font-weight: 600;
            font-size: 16px;
            width: 100%;
            color: white;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }
        
        .btn-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        
        .btn-login:hover::before {
            left: 100%;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(26,127,90,0.3);
        }
        
        .login-footer {
            text-align: center;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid #e0e0e0;
        }
        
        .login-footer p {
            color: #666;
            margin-bottom: 15px;
        }
        
        .login-footer a {
            color: #1a7f5a;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }
        
        .login-footer a:hover {
            color: #156847;
        }
        
        .back-home-btn {
            background: transparent;
            border: 2px solid #e0e0e0;
            color: #666;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s;
            display: inline-block;
            margin-top: 10px;
        }
        
        .back-home-btn:hover {
            border-color: #1a7f5a;
            color: #1a7f5a;
            text-decoration: none;
        }
        
        .alert {
            border-radius: 10px;
            margin-bottom: 25px;
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
        
        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .alert-warning {
            background: #fff3cd;
            color: #856404;
        }
        
        @media (max-width: 480px) {
            .login-container {
                padding: 30px 25px;
                margin: 10px;
            }
            
            .login-title {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1 class="login-title">Welcome Back</h1>
            <p class="login-subtitle">Sign in to your BookNest account</p>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${param.registered != null}">
            <div class="alert alert-success">
                ✅ Registration successful! Please login.
            </div>
        </c:if>
        <c:if test="${param.error == 'invalid_credentials'}">
            <div class="alert alert-danger">
                ❌ Invalid email or password!
            </div>
        </c:if>
        <c:if test="${param.error == 'login_failed'}">
            <div class="alert alert-danger">
                ❌ Login failed. Please try again.
            </div>
        </c:if>
        <c:if test="${param.logout != null}">
            <div class="alert alert-info">
                ℹ️ You have been logged out successfully.
            </div>
        </c:if>
        <c:if test="${param.redirect == 'cart'}">
            <div class="alert alert-warning">
                🛒 Please login to add items to your cart.
            </div>
        </c:if>

        <form action="<c:url value='/login'/>" method="post">
            <!-- Preserve redirect parameter -->
            <c:if test="${not empty param.redirect}">
                <input type="hidden" name="redirect" value="${param.redirect}">
            </c:if>
            
            <div class="form-group">
                <label for="email" class="form-label">Email or Username</label>
                <input type="text" class="form-control" id="email" name="email" required 
                       placeholder="Enter your email or username" value="${param.email}">
            </div>
            
            <div class="form-group">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required 
                       placeholder="Enter your password">
            </div>
            
            <button type="submit" class="btn-login">
                Sign In
            </button>
        </form>
        
        <div class="login-footer">
            <p>Don't have an account? 
                <a href="<c:url value='/register'/>">Register here</a>
            </p>
            <a href="<c:url value='/'/>" class="back-home-btn">
                ← Back to Home
            </a>
        </div>
    </div>
</body>
</html>