<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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