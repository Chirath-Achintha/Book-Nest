<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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