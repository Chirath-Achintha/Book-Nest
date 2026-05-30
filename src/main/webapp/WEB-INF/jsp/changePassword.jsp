<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - BookNest</title>
    <jsp:include page="fragments/common-styles.jsp" />
    <style>
        .change-password-page {
            background: #f8f9fa;
            min-height: 100vh;
        }
        
        .change-password-header {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            padding: 40px 0;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .change-password-title {
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .change-password-subtitle {
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
        
        .password-strength {
            margin-top: 8px;
            font-size: 12px;
        }
        
        .strength-weak {
            color: #dc3545;
        }
        
        .strength-medium {
            color: #ffc107;
        }
        
        .strength-strong {
            color: #28a745;
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
        
        .password-requirements {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-top: 20px;
            border: 1px solid #e0e0e0;
        }
        
        .password-requirements h4 {
            color: #333;
            margin-bottom: 10px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .password-requirements ul {
            margin: 0;
            padding-left: 20px;
            color: #666;
            font-size: 13px;
        }
        
        .password-requirements li {
            margin-bottom: 5px;
        }
        
        @media (max-width: 768px) {
            .change-password-title {
                font-size: 32px;
            }
            
            .form-container {
                padding: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body class="change-password-page">
    <jsp:include page="fragments/header.jsp" />

    <!-- Header -->
    <div class="change-password-header">
        <div class="main-content">
            <h1 class="change-password-title">Change Password</h1>
            <p class="change-password-subtitle">Update your account password for better security</p>
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
            <h2 class="form-title">Password Change</h2>
            
            <form action="${pageContext.request.contextPath}/profile/change-password" method="post" id="changePasswordForm">
                <div class="form-group">
                    <label for="oldPassword" class="form-label">Current Password <span class="required">*</span></label>
                    <input type="password" id="oldPassword" name="oldPassword" class="form-control" 
                           required placeholder="Enter your current password" />
                </div>
                
                <div class="form-group">
                    <label for="newPassword" class="form-label">New Password <span class="required">*</span></label>
                    <input type="password" id="newPassword" name="newPassword" class="form-control" 
                           required placeholder="Enter your new password" />
                    <div id="passwordStrength" class="password-strength"></div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm New Password <span class="required">*</span></label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                           required placeholder="Confirm your new password" />
                </div>
                
                <div class="password-requirements">
                    <h4>Password Requirements:</h4>
                    <ul>
                        <li>At least 8 characters long</li>
                        <li>Contains at least one uppercase letter</li>
                        <li>Contains at least one lowercase letter</li>
                        <li>Contains at least one number</li>
                        <li>Contains at least one special character</li>
                    </ul>
                </div>
                
                <div class="action-buttons">
                    <button type="submit" class="btn-save">
                        🔒 Change Password
                    </button>
                    <a href="${pageContext.request.contextPath}/profile" class="btn-cancel">
                        ← Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="fragments/footer.jsp" />

    <script>
        // Password strength checker
        function checkPasswordStrength(password) {
            const strengthDiv = document.getElementById('passwordStrength');
            let strength = 0;
            let message = '';
            
            if (password.length >= 8) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            
            if (strength < 2) {
                message = 'Weak password';
                strengthDiv.className = 'password-strength strength-weak';
            } else if (strength < 4) {
                message = 'Medium strength password';
                strengthDiv.className = 'password-strength strength-medium';
            } else {
                message = 'Strong password';
                strengthDiv.className = 'password-strength strength-strong';
            }
            
            strengthDiv.textContent = message;
        }
        
        // Form validation
        document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
            const oldPassword = document.getElementById('oldPassword').value.trim();
            const newPassword = document.getElementById('newPassword').value.trim();
            const confirmPassword = document.getElementById('confirmPassword').value.trim();
            
            if (!oldPassword || !newPassword || !confirmPassword) {
                e.preventDefault();
                alert('Please fill in all fields.');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('New password and confirm password do not match.');
                return;
            }
            
            if (oldPassword === newPassword) {
                e.preventDefault();
                alert('New password must be different from current password.');
                return;
            }
            
            // Password strength validation
            if (newPassword.length < 8) {
                e.preventDefault();
                alert('Password must be at least 8 characters long.');
                return;
            }
        });
        
        // Real-time password strength checking
        document.getElementById('newPassword').addEventListener('input', function(e) {
            checkPasswordStrength(e.target.value);
        });
        
        // Confirm password matching
        document.getElementById('confirmPassword').addEventListener('input', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = e.target.value;
            
            if (confirmPassword && newPassword !== confirmPassword) {
                e.target.style.borderColor = '#dc3545';
            } else {
                e.target.style.borderColor = '#e0e0e0';
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
