<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - BookNest</title>
    <jsp:include page="fragments/common-styles.jsp" />
    <style>
        .error-page {
            background: #f8f9fa;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .error-container {
            background: white;
            border-radius: 16px;
            padding: 60px 40px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 600px;
            width: 100%;
            position: relative;
            overflow: hidden;
        }
        
        .error-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #dc3545, #c82333);
        }
        
        .error-icon {
            font-size: 80px;
            color: #dc3545;
            margin-bottom: 30px;
        }
        
        .error-title {
            font-size: 36px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 20px;
        }
        
        .error-subtitle {
            font-size: 18px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .error-details {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            border-left: 4px solid #dc3545;
        }
        
        .status-code {
            font-size: 16px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .status-code strong {
            color: #dc3545;
            font-weight: 700;
        }
        
        .error-message {
            font-size: 14px;
            color: #555;
            line-height: 1.5;
        }
        
        .error-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn-home {
            background: linear-gradient(135deg, #1a7f5a 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(26,127,90,0.3);
            color: white;
            text-decoration: none;
        }
        
        .btn-back {
            background: transparent;
            color: #666;
            border: 2px solid #e0e0e0;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-back:hover {
            border-color: #1a7f5a;
            color: #1a7f5a;
            text-decoration: none;
        }
        
        .help-text {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
            color: #666;
            font-size: 14px;
        }
        
        @media (max-width: 480px) {
            .error-container {
                padding: 40px 25px;
            }
            
            .error-title {
                font-size: 28px;
            }
            
            .error-actions {
                flex-direction: column;
            }
            
            .btn-home,
            .btn-back {
                width: 100%;
            }
        }
    </style>
    <meta http-equiv="Cache-Control" content="no-store" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <meta name="robots" content="noindex" />
</head>
<body class="error-page">
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h1 class="error-title">Something went wrong</h1>
        <p class="error-subtitle">We're sorry, but something unexpected happened. Please try again or contact support if the problem persists.</p>
        
        <div class="error-details">
            <div class="status-code">
                Status code: <strong><c:out value="${statusCode}"/></strong>
            </div>
            <div class="error-message">
                <c:out value="${message}"/>
            </div>
        </div>
        
        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/" class="btn-home">
                Go to Home
            </a>
            <a href="javascript:history.back()" class="btn-back">
                Go Back
            </a>
        </div>
        
        <div class="help-text">
            If you continue to experience issues, please contact our support team.
        </div>
    </div>
</body>
</html>