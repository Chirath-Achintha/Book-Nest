<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookNest - Online Bookstore</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #1a1a1a;
            line-height: 1.6;
        }

        /* Header Styles */
        header {
            background: #ffffff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .top-bar {
            background: #f8f9fa;
            padding: 8px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .top-bar-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
            color: #555;
        }

        .contact-info {
            font-weight: 500;
        }

        .nav-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .logo {
            display: flex;
            align-items: center;
            font-size: 28px;
            font-weight: bold;
            color: #1a7f5a;
            text-decoration: none;
        }

        .logo::before {
            content: "📚";
            margin-right: 8px;
            font-size: 32px;
        }

        .search-bar {
            flex: 1;
            max-width: 500px;
            margin: 0 40px;
            position: relative;
        }

        .search-bar input {
            width: 100%;
            padding: 12px 120px 12px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 25px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .search-bar input:focus {
            outline: none;
            border-color: #1a7f5a;
            box-shadow: 0 2px 8px rgba(26,127,90,0.15);
        }

        .search-btn {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: #1a7f5a;
            color: white;
            border: none;
            padding: 8px 24px;
            border-radius: 20px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s;
        }

        .search-btn:hover {
            background: #156847;
        }

        .user-actions {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .user-actions a {
            color: #333;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.3s;
        }

        .user-actions a:hover {
            color: #1a7f5a;
        }

        nav {
            background: #fff;
            border-top: 1px solid #e0e0e0;
        }

        .nav-menu {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            gap: 35px;
            list-style: none;
        }

        .nav-menu li a {
            display: block;
            padding: 18px 0;
            color: #333;
            text-decoration: none;
            font-weight: 500;
            font-size: 15px;
            transition: color 0.3s;
            position: relative;
        }

        .nav-menu li a:hover {
            color: #1a7f5a;
        }

        .nav-menu li a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 3px;
            background: #1a7f5a;
            transition: width 0.3s;
        }

        .nav-menu li a:hover::after {
            width: 100%;
        }

        /* Cart count styling */
        .cart-count {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #1a7f5a;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
        }

        .cart-icon {
            position: relative;
        }

        /* Hero Section */
        .hero {
            background: linear-gradient(135deg, #c8dce8 0%, #b8d4e8 100%);
            padding: 80px 20px;
            position: relative;
            overflow: hidden;
        }

        .hero-content {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            z-index: 1;
        }

        .hero-text {
            flex: 1;
            max-width: 550px;
        }

        .hero-tag {
            color: #1a7f5a;
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 15px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .hero-title {
            font-size: 54px;
            font-weight: 800;
            color: #1a1a1a;
            line-height: 1.2;
            margin-bottom: 20px;
        }

        .hero-subtitle {
            font-size: 17px;
            color: #444;
            margin-bottom: 35px;
            font-weight: 500;
        }

        .discover-btn {
            display: inline-block;
            background: #1a7f5a;
            color: white;
            padding: 14px 35px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(26,127,90,0.3);
        }

        .discover-btn:hover {
            background: #156847;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(26,127,90,0.4);
            color: white;
            text-decoration: none;
        }

        .hero-books {
            flex: 1;
            display: flex;
            gap: 20px;
            justify-content: flex-end;
            align-items: center;
            position: relative;
        }

        .book-card-hero {
            background: white;
            border-radius: 12px;
            padding: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            transform: rotate(-5deg);
            transition: transform 0.3s;
        }

        .book-card-hero:nth-child(2) {
            transform: rotate(0deg) scale(1.1);
            z-index: 2;
        }

        .book-card-hero:nth-child(3) {
            transform: rotate(5deg);
        }

        .book-card-hero:hover {
            transform: rotate(0deg) scale(1.05);
        }

        .book-card-hero img {
            width: 140px;
            height: 200px;
            object-fit: cover;
            border-radius: 8px;
        }

        .discount-badge {
            position: absolute;
            top: -20px;
            left: 50%;
            transform: translateX(-50%);
            background: #ff8c00;
            color: white;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            box-shadow: 0 4px 15px rgba(255,140,0,0.4);
        }

        .discount-badge .percent {
            font-size: 28px;
        }

        .discount-badge .off {
            font-size: 16px;
        }

        /* Stats Bar */
        .stats-bar {
            background: #f8f9fa;
            padding: 25px 20px;
            border-top: 1px solid #e0e0e0;
            border-bottom: 1px solid #e0e0e0;
        }

        .stats-container {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 30px;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #333;
            font-weight: 600;
        }

        .stat-number {
            color: #1a7f5a;
            font-size: 22px;
            font-weight: 700;
        }

        /* Section Styles */
        .section {
            max-width: 1400px;
            margin: 60px auto;
            padding: 0 20px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 35px;
        }

        .section-title {
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
        }

        .browse-all {
            color: #1a7f5a;
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: gap 0.3s;
        }

        .browse-all:hover {
            gap: 12px;
            color: #1a7f5a;
            text-decoration: none;
        }

        /* Book Grid */
        .book-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 30px;
        }

        .book-card {
            background: white;
            border-radius: 12px;
            padding: 15px;
            transition: all 0.3s;
            border: 1px solid #e0e0e0;
            cursor: pointer;
        }

        .book-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.12);
            border-color: #1a7f5a;
        }

        .book-cover {
            width: 100%;
            height: 240px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 15px;
            background: #f0f0f0;
        }

        .book-title {
            font-size: 15px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 6px;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .book-author {
            font-size: 13px;
            color: #666;
            margin-bottom: 10px;
        }

        .book-price {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .current-price {
            font-size: 20px;
            font-weight: 700;
            color: #1a7f5a;
        }

        .original-price {
            font-size: 14px;
            color: #999;
            text-decoration: line-through;
        }

        /* Categories */
        .categories-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 25px;
        }

        .category-card {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            padding: 30px 20px;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
        }

        .category-card:hover {
            border-color: #1a7f5a;
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        }

        .category-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .category-name {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
        }

        /* Banner Sections */
        .banner-section {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            border-radius: 16px;
            padding: 60px 40px;
            color: white;
            text-align: center;
            position: relative;
            overflow: hidden;
            margin: 60px 20px;
        }

        .banner-section h2 {
            font-size: 38px;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .banner-section p {
            font-size: 17px;
            margin-bottom: 30px;
            opacity: 0.95;
        }

        .banner-btn {
            display: inline-block;
            background: white;
            color: #2c3e50;
            padding: 14px 35px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
        }

        .banner-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(255,255,255,0.3);
            color: #2c3e50;
            text-decoration: none;
        }

        /* Testimonials */
        .testimonials {
            background: #f8f9fa;
            padding: 60px 20px;
            margin: 60px 0;
        }

        .testimonials-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .testimonials-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 40px;
        }

        .testimonial-card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
        }

        .testimonial-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .testimonial-author {
            font-weight: 600;
            color: #1a1a1a;
            font-size: 15px;
        }

        .testimonial-date {
            color: #999;
            font-size: 13px;
        }

        .rating {
            color: #ffa500;
            margin-bottom: 12px;
        }

        .testimonial-title {
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 10px;
            font-size: 16px;
        }

        .testimonial-text {
            color: #555;
            font-size: 14px;
            line-height: 1.6;
        }

        /* Footer */
        footer {
            background: #1a1a1a;
            color: #ccc;
            padding: 50px 20px 20px;
        }

        .footer-content {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 40px;
            margin-bottom: 30px;
        }

        .footer-section h3 {
            color: white;
            margin-bottom: 20px;
            font-size: 18px;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 12px;
        }

        .footer-section a {
            color: #ccc;
            text-decoration: none;
            transition: color 0.3s;
            font-size: 14px;
        }

        .footer-section a:hover {
            color: #1a7f5a;
        }

        .footer-bottom {
            max-width: 1400px;
            margin: 30px auto 0;
            padding-top: 30px;
            border-top: 1px solid #333;
            text-align: center;
            color: #999;
            font-size: 14px;
        }

        .features-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            max-width: 1400px;
            margin: 60px auto;
            padding: 0 20px;
        }

        .feature-item {
            text-align: center;
            padding: 30px 20px;
        }

        .feature-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .feature-title {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
        }

        .feature-text {
            font-size: 14px;
            color: #666;
        }

        /* Success Messages */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
            max-width: 1400px;
            margin-left: auto;
            margin-right: auto;
        }

        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }

        .alert-info {
            color: #0c5460;
            background-color: #d1ecf1;
            border-color: #bee5eb;
        }

        .alert-dismissible {
            padding-right: 4rem;
        }

        .btn-close {
            position: absolute;
            top: 0;
            right: 0;
            z-index: 2;
            padding: 1.25rem 1rem;
        }

        /* Book action buttons */
        .book-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #1a7f5a;
            color: white;
        }

        .btn-primary:hover {
            background: #156847;
            color: white;
            text-decoration: none;
        }

        .btn-outline-secondary {
            background: transparent;
            color: #666;
            border: 1px solid #ddd;
        }

        .btn-outline-secondary:hover {
            background: #f8f9fa;
            color: #333;
            text-decoration: none;
        }

        /* Feedback form styles */
        .feedback-form {
            background: white;
            border: 2px solid #1a7f5a;
            border-radius: 12px;
            padding: 30px;
            margin-top: 30px;
        }

        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            display: block;
        }

        .form-select, .form-control {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-select:focus, .form-control:focus {
            outline: none;
            border-color: #1a7f5a;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }

        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 20px;
            border-radius: 12px;
            width: 90%;
            max-width: 500px;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #e0e0e0;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        @media (max-width: 768px) {
            .hero-content {
                flex-direction: column;
                text-align: center;
            }

            .hero-books {
                margin-top: 40px;
            }

            .hero-title {
                font-size: 36px;
            }

            .book-grid {
                grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
                gap: 20px;
            }

            .search-bar {
                margin: 20px 0;
            }

            .nav-container {
                flex-direction: column;
                gap: 20px;
            }

            .user-actions {
                order: -1;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="top-bar">
            <div class="top-bar-content">
                <span class="contact-info">Need help? Call Us: +94 (32)220 888 23</span>
                <div>
                    <a href="#" style="color: #555; text-decoration: none; margin-right: 15px;">Help</a>
                    <a href="#" style="color: #555; text-decoration: none;">USD $</a>
                </div>
            </div>
        </div>
        
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="logo">BookNest</a>
            
            <div class="search-bar">
                <input type="text" placeholder="Search products...">
                <button class="search-btn">🔍 Search</button>
            </div>
            
            <div class="user-actions">
                <c:choose>
                    <c:when test="${sessionScope.username != null}">
                        <a href="${pageContext.request.contextPath}/profile">${sessionScope.username}</a>
                        <a href="${pageContext.request.contextPath}/logout">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login">Sign In</a>
                        <a href="${pageContext.request.contextPath}/register">Register</a>
                    </c:otherwise>
                </c:choose>
                <a href="${pageContext.request.contextPath}/cart" class="cart-icon">🛒 Cart (<c:out value="${cartCount != null ? cartCount : 0}"/>)</a>
            </div>
        </div>

        <nav>
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/books">Shop</a></li>
                <li><a href="${pageContext.request.contextPath}/blog">Blogs</a></li>
                <li><a href="${pageContext.request.contextPath}/categories">Pages</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
            </ul>
        </nav>
    </header>

    <!-- Success Messages -->
    <c:if test="${param.login == 'success'}">
        <div class="alert alert-success alert-dismissible">
            ✅ Welcome back, <c:out value="${sessionScope.username}"/>! You have successfully logged in.
            <button type="button" class="btn-close" onclick="this.parentElement.style.display='none'">&times;</button>
        </div>
    </c:if>
    <c:if test="${param.success == 'true'}">
        <div class="alert alert-success alert-dismissible">
            ✅ Your feedback has been submitted successfully! Thank you for sharing your experience.
            <button type="button" class="btn-close" onclick="this.parentElement.style.display='none'">&times;</button>
        </div>
    </c:if>
    <c:if test="${param.logout == 'success'}">
        <div class="alert alert-info alert-dismissible">
            ℹ️ You have been logged out successfully.
            <button type="button" class="btn-close" onclick="this.parentElement.style.display='none'">&times;</button>
        </div>
    </c:if>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <div class="hero-text">
                <p class="hero-tag">A brand new series</p>
                <h1 class="hero-title">THE WORLD OF<br>YOUNG ADULT<br>BOOKS</h1>
                <p class="hero-subtitle">Save up to 15% on new releases.</p>
                <a href="${pageContext.request.contextPath}/books" class="discover-btn">Discover Now →</a>
            </div>
            
            <div class="hero-books">
                <div class="discount-badge">
                    <span class="percent">15%</span>
                    <span class="off">OFF</span>
                </div>
                <div class="book-card-hero">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='140' height='200'%3E%3Crect fill='%23667788' width='140' height='200'/%3E%3Ctext x='50%25' y='50%25' text-anchor='middle' fill='white' font-size='16'%3EBook 1%3C/text%3E%3C/svg%3E" alt="Book">
                </div>
                <div class="book-card-hero">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='140' height='200'%3E%3Crect fill='%2366b8aa' width='140' height='200'/%3E%3Ctext x='50%25' y='50%25' text-anchor='middle' fill='white' font-size='16'%3EBook 2%3C/text%3E%3C/svg%3E" alt="Book">
                </div>
                <div class="book-card-hero">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='140' height='200'%3E%3Crect fill='%23889966' width='140' height='200'/%3E%3Ctext x='50%25' y='50%25' text-anchor='middle' fill='white' font-size='16'%3EBook 3%3C/text%3E%3C/svg%3E" alt="Book">
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Bar -->
    <div class="stats-bar">
        <div class="stats-container">
            <div class="stat-item">
                <span class="stat-number">5,000+</span>
                <span>Total Books</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">1,258</span>
                <span>Authors</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">20,898</span>
                <span>Books Sold</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">97%</span>
                <span>Happy Customers</span>
            </div>
        </div>
    </div>

    <!-- This Week's Highlights -->
    <section class="section">
        <div class="section-header">
            <h2 class="section-title">This week's highlights</h2>
            <a href="${pageContext.request.contextPath}/books" class="browse-all">Browse All →</a>
        </div>
        
        <div class="book-grid">
            <c:choose>
                <c:when test="${not empty books}">
                    <c:forEach var="book" items="${books}" begin="0" end="5">
                        <div class="book-card">
                            <img class="book-cover" src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='180' height='240'%3E%3Crect fill='%234a5568' width='180' height='240'/%3E%3Ctext x='50%25' y='50%25' text-anchor='middle' fill='white'%3E<c:out value='${book.title}'/>%3C/text%3E%3C/svg%3E" alt="Book">
                            <h3 class="book-title"><c:out value="${book.title}"/></h3>
                            <p class="book-author"><c:out value="${book.author}"/></p>
                            <div class="book-price">
                                <span class="current-price">$<c:out value="${book.price}"/></span>
                            </div>
                            <div class="book-actions">
                                <c:url var="detailsUrl" value="${pageContext.request.contextPath}/books/${book.bid}"/>
                                <a href="${detailsUrl}" class="btn btn-primary">View</a>
                                <form action="${pageContext.request.contextPath}/cart/add" method="post" style="margin:0; display:inline;">
                                    <input type="hidden" name="bookId" value="${book.bid}" />
                                    <button type="submit" class="btn btn-outline-secondary">Add to cart</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="grid-column: 1 / -1; text-align: center; padding: 40px;">
                        <p>No books available right now. Please check back later.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- Top Categories -->
    <section class="section">
        <div class="section-header">
            <h2 class="section-title">Top categories</h2>
            <a href="${pageContext.request.contextPath}/categories" class="browse-all">Browse All →</a>
        </div>
        
        <div class="categories-grid">
            <div class="category-card">
                <div class="category-icon">📖</div>
                <div class="category-name">Biography</div>
            </div>
            <div class="category-card">
                <div class="category-icon">🧙</div>
                <div class="category-name">Fantasy</div>
            </div>
            <div class="category-card">
                <div class="category-icon">👻</div>
                <div class="category-name">Horror</div>
            </div>
            <div class="category-card">
                <div class="category-icon">👨‍👩‍👧</div>
                <div class="category-name">Family</div>
            </div>
            <div class="category-card">
                <div class="category-icon">✍️</div>
                <div class="category-name">Fiction</div>
            </div>
            <div class="category-card">
                <div class="category-icon">💕</div>
                <div class="category-name">Romance</div>
            </div>
            <div class="category-card">
                <div class="category-icon">👶</div>
                <div class="category-name">Kids</div>
            </div>
            <div class="category-card">
                <div class="category-icon">🏛️</div>
                <div class="category-name">History</div>
            </div>
        </div>
    </section>

    <!-- Current Bestselling Books -->
    <section class="section">
        <div class="section-header">
            <h2 class="section-title">Current bestselling books</h2>
            <a href="${pageContext.request.contextPath}/books" class="browse-all">Browse All →</a>
        </div>
        
        <div class="book-grid">
            <c:choose>
                <c:when test="${not empty books}">
                    <c:forEach var="book" items="${books}" begin="6" end="11">
                        <div class="book-card">
                            <img class="book-cover" src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='180' height='240'%3E%3Crect fill='%23c98547' width='180' height='240'/%3E%3Ctext x='50%25' y='50%25' text-anchor='middle' fill='white'%3E<c:out value='${book.title}'/>%3C/text%3E%3C/svg%3E" alt="Book">
                            <h3 class="book-title"><c:out value="${book.title}"/></h3>
                            <p class="book-author"><c:out value="${book.author}"/></p>
                            <div class="book-price">
                                <span class="current-price">$<c:out value="${book.price}"/></span>
                            </div>
                            <div class="book-actions">
                                <c:url var="detailsUrl" value="${pageContext.request.contextPath}/books/${book.bid}"/>
                                <a href="${detailsUrl}" class="btn btn-primary">View</a>
                                <form action="${pageContext.request.contextPath}/cart/add" method="post" style="margin:0; display:inline;">
                                    <input type="hidden" name="bookId" value="${book.bid}" />
                                    <button type="submit" class="btn btn-outline-secondary">Add to cart</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="grid-column: 1 / -1; text-align: center; padding: 40px;">
                        <p>No books available right now. Please check back later.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- Thriller Banner -->
    <div class="banner-section" style="background: linear-gradient(135deg, #1e3a5f 0%, #2c5282 100%); max-width: 1360px;">
        <h2>TOP FAVOURITE THRILLER STORIES</h2>
        <p>Find our tales on the best books of all time.</p>
        <a href="${pageContext.request.contextPath}/books" class="banner-btn">Discover Now →</a>
    </div>

    <!-- Half Price Books -->
    <section class="section">
        <div class="section-header">
            <h2 class="section-title">Half price books</h2>
            <a href="${pageContext.request.contextPath}/books" class="browse-all">Browse All →</a>
        </div>
        
        <div class="book-grid">
            <c:choose>
                <c:when test="${not empty books}">
                    <c:forEach var="book" items="${books}" begin="0" end="5">
                        <div class="book-card">
                            <img class="book-cover" src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='180' height='240'%3E%3Crect fill='%232d3748' width='180' height='240'/%3E%3Ctext x='50%25' y='50%25' text-anchor='middle' fill='white'%3E<c:out value='${book.title}'/>%3C/text%3E%3C/svg%3E" alt="Book">
                            <h3 class="book-title"><c:out value="${book.title}"/></h3>
                            <p class="book-author"><c:out value="${book.author}"/></p>
                            <div class="book-price">
                                <span class="current-price">$<c:out value="${book.price}"/></span>
                                <span class="original-price">$<c:out value="${book.price * 2}"/></span>
                            </div>
                            <div class="book-actions">
                                <c:url var="detailsUrl" value="${pageContext.request.contextPath}/books/${book.bid}"/>
                                <a href="${detailsUrl}" class="btn btn-primary">View</a>
                                <form action="${pageContext.request.contextPath}/cart/add" method="post" style="margin:0; display:inline;">
                                    <input type="hidden" name="bookId" value="${book.bid}" />
                                    <button type="submit" class="btn btn-outline-secondary">Add to cart</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="grid-column: 1 / -1; text-align: center; padding: 40px;">
                        <p>No books available right now. Please check back later.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- Additional Banners -->
    <div style="max-width: 1400px; margin: 60px auto; padding: 0 20px; display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 30px;">
        <div class="banner-section" style="background: linear-gradient(135deg, #1e3a5f 0%, #2c5282 100%); margin: 0; padding: 50px 30px;">
            <h2 style="font-size: 32px;">COLLECT SHOP</h2>
            <p>Discover limited editions and exclusive collections</p>
            <a href="${pageContext.request.contextPath}/books" class="banner-btn">Shop Now →</a>
        </div>
        
        <div class="banner-section" style="background: linear-gradient(135deg, #7c2d12 0%, #991b1b 100%); margin: 0; padding: 50px 30px;">
            <h2 style="font-size: 32px;">THE TRUTH LIES HERE</h2>
            <p>Uncover mysteries and thrilling narratives</p>
            <a href="${pageContext.request.contextPath}/books" class="banner-btn">Shop Now →</a>
        </div>
        
        <div class="banner-section" style="background: linear-gradient(135deg, #14532d 0%, #166534 100%); margin: 0; padding: 50px 30px;">
            <h2 style="font-size: 32px;">WOMAN IN THE WATER</h2>
            <p>Explore captivating stories and adventures</p>
            <a href="${pageContext.request.contextPath}/books" class="banner-btn">Shop Now →</a>
        </div>
    </div>

    <!-- Picks For You -->
    <section class="section">
        <div class="section-header">
            <h2 class="section-title">Picks for you</h2>
            <a href="${pageContext.request.contextPath}/books" class="browse-all">Browse All →</a>
        </div>
        
        <div class="book-grid">
            <c:choose>
                <c:when test="${not empty books}">
                    <c:forEach var="book" items="${books}" begin="0" end="5">
                        <div class="book-card">
                            <img class="book-cover" src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='180' height='240'%3E%3Crect fill='%23c53030' width='180' height='240'/%3E%3Ctext x='50%25' y='50%25' text-anchor='middle' fill='white'%3E<c:out value='${book.title}'/>%3C/text%3E%3C/svg%3E" alt="Book">
                            <h3 class="book-title"><c:out value="${book.title}"/></h3>
                            <p class="book-author"><c:out value="${book.author}"/></p>
                            <div class="book-price">
                                <span class="current-price">$<c:out value="${book.price}"/></span>
                            </div>
                            <div class="book-actions">
                                <c:url var="detailsUrl" value="${pageContext.request.contextPath}/books/${book.bid}"/>
                                <a href="${detailsUrl}" class="btn btn-primary">View</a>
                                <form action="${pageContext.request.contextPath}/cart/add" method="post" style="margin:0; display:inline;">
                                    <input type="hidden" name="bookId" value="${book.bid}" />
                                    <button type="submit" class="btn btn-outline-secondary">Add to cart</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="grid-column: 1 / -1; text-align: center; padding: 40px;">
                        <p>No books available right now. Please check back later.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- Testimonials -->
    <section class="testimonials">
        <div class="testimonials-container">
            <div style="text-align: center; margin-bottom: 20px;">
                <h2 class="section-title">What client says</h2>
                <div style="display: inline-flex; align-items: center; background: #1a7f5a; color: white; padding: 15px 30px; border-radius: 50px; margin-top: 20px;">
                    <span style="font-size: 32px; font-weight: bold; margin-right: 10px;">4.8</span>
                    <div style="text-align: left;">
                        <div style="color: #ffa500; margin-bottom: 4px;">★★★★★</div>
                        <div style="font-size: 12px; opacity: 0.95;">15,235 Reviews</div>
                    </div>
                </div>
            </div>
            
            <div class="testimonials-grid">
                <c:choose>
                    <c:when test="${not empty websiteFeedback}">
                        <c:forEach var="feedback" items="${websiteFeedback}" begin="0" end="3">
                            <div class="testimonial-card">
                                <div class="testimonial-header">
                                    <span class="testimonial-author"><c:out value="${feedback.customerName}"/></span>
                                    <span class="testimonial-date"><c:out value="${feedback.createdAtFormatted}"/></span>
                                </div>
                                <div class="rating">
                                    <c:forEach begin="1" end="5" var="star">
                                        <c:choose>
                                            <c:when test="${star <= feedback.rating}">★</c:when>
                                            <c:otherwise>☆</c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                                <h4 class="testimonial-title">Great Experience</h4>
                                <p class="testimonial-text"><c:out value="${feedback.comment}"/></p>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="testimonial-card">
                            <div class="testimonial-header">
                                <span class="testimonial-author">Cheryl R.</span>
                                <span class="testimonial-date">Oct 3, 2024</span>
                            </div>
                            <div class="rating">★★★★★</div>
                            <h4 class="testimonial-title">Excellent service</h4>
                            <p class="testimonial-text">The books were wrapped securely and arrived in pristine condition. I appreciated the care that was taken to talk about the author; they included a prompt reply.</p>
                        </div>
                        
                        <div class="testimonial-card">
                            <div class="testimonial-header">
                                <span class="testimonial-author">Margaret C.</span>
                                <span class="testimonial-date">Oct 5, 2024</span>
                            </div>
                            <div class="rating">★★★★★</div>
                            <h4 class="testimonial-title">Best Bookshop ever!</h4>
                            <p class="testimonial-text">I am so happy to find a site where I can shop for valued items. The phenomenal and my book arrived on time in perfect condition.</p>
                        </div>
                        
                        <div class="testimonial-card">
                            <div class="testimonial-header">
                                <span class="testimonial-author">Pearl Ruth</span>
                                <span class="testimonial-date">Oct 8, 2024</span>
                            </div>
                            <div class="rating">★★★★★</div>
                            <h4 class="testimonial-title">Great Books, Excellent Service</h4>
                            <p class="testimonial-text">Not only diverse books but also friendly and helpful staff. A memorable book shopping experience!</p>
                        </div>
                        
                        <div class="testimonial-card">
                            <div class="testimonial-header">
                                <span class="testimonial-author">Olivia P.</span>
                                <span class="testimonial-date">Oct 10, 2024</span>
                            </div>
                            <div class="rating">★★★★★</div>
                            <h4 class="testimonial-title">A Haven for Book Lovers</h4>
                            <p class="testimonial-text">Every visit is an immersion into a world of knowledge. Quality books and competitive customer service.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>

    <!-- Features Bar -->
    <div class="features-bar">
        <div class="feature-item">
            <div class="feature-icon">🚚</div>
            <h3 class="feature-title">FAST DELIVERY</h3>
            <p class="feature-text">Free standard delivery</p>
        </div>
        
        <div class="feature-item">
            <div class="feature-icon">💳</div>
            <h3 class="feature-title">BEST PRICES & OFFERS</h3>
            <p class="feature-text">Multiple gift options available</p>
        </div>
        
        <div class="feature-item">
            <div class="feature-icon">🎁</div>
            <h3 class="feature-title">GREAT DAILY DEAL</h3>
            <p class="feature-text">Orders $50 or more</p>
        </div>
        
        <div class="feature-item">
            <div class="feature-icon">📦</div>
            <h3 class="feature-title">QUICK & COLLECT</h3>
            <p class="feature-text">Check your local stores now</p>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="footer-content">
            <div class="footer-section">
                <h3>About BookNest</h3>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/about">Our Story</a></li>
                    <li><a href="${pageContext.request.contextPath}/careers">Careers</a></li>
                    <li><a href="${pageContext.request.contextPath}/press">Press</a></li>
                    <li><a href="${pageContext.request.contextPath}/affiliates">Affiliates</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h3>Customer Service</h3>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/help">Help Center</a></li>
                    <li><a href="${pageContext.request.contextPath}/track-order">Track Order</a></li>
                    <li><a href="${pageContext.request.contextPath}/returns">Returns</a></li>
                    <li><a href="${pageContext.request.contextPath}/shipping">Shipping Info</a></li>
                    <li><a href="${pageContext.request.contextPath}/gift-cards">Gift Cards</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h3>Quick Links</h3>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/books?filter=new">New Releases</a></li>
                    <li><a href="${pageContext.request.contextPath}/books?filter=bestseller">Bestsellers</a></li>
                    <li><a href="${pageContext.request.contextPath}/books?filter=sale">Sale</a></li>
                    <li><a href="${pageContext.request.contextPath}/blog">Blog</a></li>
                    <li><a href="${pageContext.request.contextPath}/events">Events</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h3>Connect With Us</h3>
                <ul>
                    <li><a href="#">Facebook</a></li>
                    <li><a href="#">Twitter</a></li>
                    <li><a href="#">Instagram</a></li>
                    <li><a href="#">YouTube</a></li>
                    <li><a href="${pageContext.request.contextPath}/newsletter">Newsletter</a></li>
                </ul>
            </div>
        </div>
        
        <div class="footer-bottom">
            <p>&copy; 2024 BookNest. All rights reserved. | Privacy Policy | Terms of Service</p>
        </div>
    </footer>

    <!-- Feedback Form for Logged-in Users -->
    <c:if test="${not empty sessionScope.user}">
        <div style="max-width: 1400px; margin: 60px auto; padding: 0 20px;">
            <div class="feedback-form">
                <h3 style="color: #1a7f5a; margin-bottom: 20px;">Share Your Experience</h3>
                <c:choose>
                    <c:when test="${hasLeftWebsiteFeedback}">
                        <div style="background: #d1ecf1; color: #0c5460; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                            Thank you for your feedback! You have already shared your experience with us.
                            <c:if test="${not empty existingWebsiteFeedback}">
                                <br><strong>Your rating:</strong>
                                <div style="color: #ffa500; margin: 5px 0;">
                                    <c:forEach begin="1" end="5" var="star">
                                        <c:choose>
                                            <c:when test="${star <= existingWebsiteFeedback.rating}">★</c:when>
                                            <c:otherwise>☆</c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                                <c:if test="${not empty existingWebsiteFeedback.comment}">
                                    <br><strong>Your comment:</strong> "${existingWebsiteFeedback.comment}"
                                </c:if>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <form action="${pageContext.request.contextPath}/feedback/website" method="post">
                            <div style="margin-bottom: 20px;">
                                <label for="rating" class="form-label">How would you rate your experience? *</label>
                                <select class="form-select" id="rating" name="rating" required>
                                    <option value="">Select rating</option>
                                    <option value="5">5 - Excellent</option>
                                    <option value="4">4 - Very Good</option>
                                    <option value="3">3 - Good</option>
                                    <option value="2">2 - Fair</option>
                                    <option value="1">1 - Poor</option>
                                </select>
                            </div>
                            <div style="margin-bottom: 20px;">
                                <label for="comment" class="form-label">Share your thoughts (Optional)</label>
                                <textarea class="form-control" id="comment" name="comment" rows="4" 
                                          placeholder="Tell us about your experience with BookNest..."></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                Submit Feedback
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>
    
    <c:if test="${empty sessionScope.user}">
        <div style="max-width: 1400px; margin: 60px auto; padding: 0 20px;">
            <div style="background: white; border: 1px solid #e0e0e0; border-radius: 12px; padding: 30px; text-align: center;">
                <h6>Want to share your experience?</h6>
                <p style="color: #666; margin: 15px 0;">Login to leave a testimonial about your BookNest experience.</p>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Login</a>
            </div>
        </div>
    </c:if>

    <script>
        // Add smooth scrolling
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            });
        });

        // Add hover effect to book cards
        document.querySelectorAll('.book-card').forEach(card => {
            card.addEventListener('click', function() {
                // Book details would open here in a real implementation
            });
        });

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
