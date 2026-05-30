<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${user.cid == null ? 'Add' : 'Edit'} User - BookNest Admin</title>
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
            padding-bottom: 10px;
            border-bottom: 2px solid #1a7f5a;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
            background: white;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #1a7f5a;
            box-shadow: 0 0 0 3px rgba(26, 127, 90, 0.1);
        }
        
        .form-control.is-invalid {
            border-color: #e74c3c;
        }
        
        .invalid-feedback {
            color: #e74c3c;
            font-size: 14px;
            margin-top: 5px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(26,127,90,0.3);
        }
        
        .btn-cancel {
            background: #6c757d;
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-left: 15px;
        }
        
        .btn-cancel:hover {
            background: #5a6268;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .form-actions {
            display: flex;
            align-items: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
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
        
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
            padding: 15px 20px;
            border: none;
            font-size: 14px;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
        }
        
        .required {
            color: #e74c3c;
        }
        
        .form-help {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }
            
            .btn-cancel {
                margin-left: 0;
                margin-top: 10px;
            }
        }
    </style>
</head>
<body class="admin-page">
    <jsp:include page="../fragments/header.jsp" />

    <!-- Page Header -->
    <div class="page-header">
        <div class="main-content">
            <h1 class="page-title">${user.cid == null ? 'Add New User' : 'Edit User'}</h1>
            <p class="page-subtitle">${user.cid == null ? 'Create a new user account' : 'Update user information'}</p>
        </div>
    </div>

    <div class="main-content">
        <!-- Error Messages -->
        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                ❌ Error: ${param.error}
            </div>
        </c:if>

        <!-- Navigation -->
        <div class="nav-breadcrumb">
            <a href="<c:url value='/admin/panel'/>" class="breadcrumb-item">Admin Panel</a>
            <span class="breadcrumb-separator">›</span>
            <a href="<c:url value='/admin/users'/>" class="breadcrumb-item">Manage Users</a>
            <span class="breadcrumb-separator">›</span>
            <span class="breadcrumb-item active">${user.cid == null ? 'Add User' : 'Edit User'}</span>
        </div>

        <!-- User Form -->
        <div class="form-container">
            <h2 class="form-title">${user.cid == null ? 'User Information' : 'Edit User Information'}</h2>
            
            <form:form modelAttribute="user" method="post" action="${user.cid == null ? '/admin/users/add' : '/admin/users/edit/'}${user.cid}">
                <div class="form-row">
                    <div class="form-group">
                        <label for="username" class="form-label">Username <span class="required">*</span></label>
                        <form:input path="username" class="form-control" placeholder="Enter username" required="true" />
                        <form:errors path="username" cssClass="invalid-feedback" />
                    </div>
                    
                    <div class="form-group">
                        <label for="email" class="form-label">Email <span class="required">*</span></label>
                        <form:input path="email" type="email" class="form-control" placeholder="Enter email address" required="true" />
                        <form:errors path="email" cssClass="invalid-feedback" />
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="password" class="form-label">Password <span class="required">*</span></label>
                        <form:input path="password" type="password" class="form-control" placeholder="Enter password" required="true" />
                        <form:errors path="password" cssClass="invalid-feedback" />
                        <div class="form-help">Minimum 6 characters</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone" class="form-label">Phone Number</label>
                        <form:input path="phone" class="form-control" placeholder="Enter phone number (optional)" />
                        <form:errors path="phone" cssClass="invalid-feedback" />
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="role" class="form-label">Role <span class="required">*</span></label>
                    <form:select path="role" class="form-control" required="true">
                        <form:option value="" label="Select Role" />
                        <form:option value="CUSTOMER" label="Customer" />
                        <form:option value="ADMIN" label="Admin" />
                    </form:select>
                    <form:errors path="role" cssClass="invalid-feedback" />
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i>
                        ${user.cid == null ? 'Create User' : 'Update User'}
                    </button>
                    <a href="<c:url value='/admin/users'/>" class="btn-cancel">
                        <i class="fas fa-times"></i>
                        Cancel
                    </a>
                </div>
            </form:form>
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
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const username = document.querySelector('input[name="username"]').value.trim();
            const email = document.querySelector('input[name="email"]').value.trim();
            const password = document.querySelector('input[name="password"]').value;
            const role = document.querySelector('select[name="role"]').value;
            
            if (!username || !email || !password || !role) {
                e.preventDefault();
                alert('Please fill in all required fields.');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long.');
                return false;
            }
        });
    </script>
</body>
</html>