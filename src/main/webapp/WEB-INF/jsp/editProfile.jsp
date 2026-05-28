<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - BookNest</title>
    <jsp:include page="fragments/common-styles.jsp" />
    <style>
        .edit-profile-page {
            background: #f8f9fa;
            min-height: 100vh;
        }
        
        .edit-profile-header {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            padding: 40px 0;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .edit-profile-title {
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .edit-profile-subtitle {
            font-size: 18px;
            opacity: 0.9;
        }
        
        .form-container {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
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
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .btn-save {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            border: none;
            padding: 16px 30px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 10px;
            color: white;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }
        
        .btn-save::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        
        .btn-save:hover::before {
            left: 100%;
        }
        
        .btn-save:hover {
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
            display: inline-block;
            text-align: center;
        }
        
        .btn-cancel:hover {
            border-color: #1a7f5a;
            color: #1a7f5a;
            text-decoration: none;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .required {
            color: #dc3545;
        }
        
        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid transparent;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            border-color: #f5c6cb;
            color: #721c24;
        }
        
        .alert-success {
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }
        
        @media (max-width: 768px) {
            .edit-profile-title {
                font-size: 32px;
            }
            
            .form-container {
                padding: 20px;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body class="edit-profile-page">
    <jsp:include page="fragments/header.jsp" />

    <!-- Header -->
    <div class="edit-profile-header">
        <div class="main-content">
            <h1 class="edit-profile-title">Edit Profile</h1>
            <p class="edit-profile-subtitle">Update your personal information and account details</p>
        </div>
    </div>

    <div class="main-content">
        <!-- Error Messages -->
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger">
                ❌ ${param.error}
            </div>
        </c:if>

        <!-- Success Messages -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">
                ✅ ${param.success}
            </div>
        </c:if>

        <div class="form-container">
            <h2 class="form-title">Personal Information</h2>
            
            <c:if test="${not empty user}">
                <form action="${pageContext.request.contextPath}/profile/update" method="post">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="username" class="form-label">Username <span class="required">*</span></label>
                            <input type="text" id="username" name="username" class="form-control" 
                                   value="${user.username}" required placeholder="Enter your username" />
                        </div>
                        
                        <div class="form-group">
                            <label for="email" class="form-label">Email <span class="required">*</span></label>
                            <input type="email" id="email" name="email" class="form-control" 
                                   value="${user.email}" required placeholder="Enter your email address" />
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="phone" class="form-label">Phone Number</label>
                            <input type="tel" id="phone" name="phone" class="form-control" 
                                   value="${user.phone}" placeholder="Enter your phone number" />
                        </div>
                        
                        <div class="form-group">
                            <label for="address" class="form-label">Address</label>
                            <input type="text" id="address" name="address" class="form-control" 
                                   value="${user.address}" placeholder="Enter your address" />
                        </div>
                    </div>
                    
                    <div class="action-buttons">
                        <button type="submit" class="btn-save">
                            💾 Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/profile" class="btn-cancel">
                            ← Cancel
                        </a>
                    </div>
                </form>
            </c:if>
            
            <c:if test="${empty user}">
                <div style="text-align: center; padding: 40px 20px;">
                    <h3 style="color: #dc3545; margin-bottom: 15px;">❌ User Not Found</h3>
                    <p style="color: #666; margin-bottom: 20px;">We couldn't find your profile information.</p>
                    <a href="${pageContext.request.contextPath}/profile" class="btn-save">
                        🏠 Back to Profile
                    </a>
                </div>
            </c:if>
        </div>
    </div>

    <jsp:include page="fragments/footer.jsp" />

    <script>
        // Form validation
        document.querySelector('form')?.addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const email = document.getElementById('email').value.trim();
            
            if (!username || !email) {
                e.preventDefault();
                alert('Please fill in all required fields.');
                return;
            }
            
            // Basic email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert('Please enter a valid email address.');
                return;
            }
        });

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.opacity = '0';
                alert.style.transition = 'opacity 0.5s';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            });
        }, 5000);
    </script>
</body>
</html>
