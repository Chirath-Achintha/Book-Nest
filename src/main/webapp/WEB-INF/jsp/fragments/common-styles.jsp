<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        background-color: #f8f9fa;
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

        /* Main Content */
        .main-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
            min-height: auto;
        }

    /* Form Styles */
    .form-container {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        max-width: 500px;
        margin: 0 auto;
    }

    .form-title {
        font-size: 28px;
        font-weight: 700;
        color: #1a1a1a;
        margin-bottom: 30px;
        text-align: center;
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
        min-height: 100px;
    }

    /* Button Styles */
    .btn {
        display: inline-block;
        padding: 12px 24px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        text-decoration: none;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s;
        text-align: center;
    }

    .btn-primary {
        background: #1a7f5a;
        color: white;
    }

    .btn-primary:hover {
        background: #156847;
        color: white;
        text-decoration: none;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(26,127,90,0.3);
    }

    .btn-secondary {
        background: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background: #5a6268;
        color: white;
        text-decoration: none;
    }

    .btn-outline-primary {
        background: transparent;
        color: #1a7f5a;
        border: 2px solid #1a7f5a;
    }

    .btn-outline-primary:hover {
        background: #1a7f5a;
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

    .btn-danger {
        background: #dc3545;
        color: white;
    }

    .btn-danger:hover {
        background: #c82333;
        color: white;
        text-decoration: none;
    }

    .btn-success {
        background: #28a745;
        color: white;
    }

    .btn-success:hover {
        background: #218838;
        color: white;
        text-decoration: none;
    }

    .btn-warning {
        background: #ffc107;
        color: #212529;
    }

    .btn-warning:hover {
        background: #e0a800;
        color: #212529;
        text-decoration: none;
    }

    .btn-sm {
        padding: 8px 16px;
        font-size: 12px;
    }

    .btn-lg {
        padding: 16px 32px;
        font-size: 16px;
    }

    .btn-block {
        width: 100%;
        display: block;
    }

    /* Card Styles */
    .card {
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        overflow: hidden;
        transition: all 0.3s;
    }
    
    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0,0,0,0.12);
    }
    
    .card-header {
        background: #f8f9fa;
        padding: 15px;
        border-bottom: 1px solid #e0e0e0;
        font-weight: 600;
        color: #1a1a1a;
    }
    
    .card-body {
        padding: 15px;
    }
    
    .card-footer {
        background: #f8f9fa;
        padding: 10px 15px;
        border-top: 1px solid #e0e0e0;
    }

    /* Book Card Styles */
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
            line-clamp: 2;
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
        margin-bottom: 15px;
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

    .book-actions {
        display: flex;
        gap: 10px;
        margin-top: 15px;
    }

    /* Grid Styles */
    .book-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
        gap: 30px;
    }

    .grid-2 {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 30px;
    }

    .grid-3 {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 30px;
    }

    .grid-4 {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 30px;
    }

    /* Alert Styles */
    .alert {
        padding: 15px 20px;
        margin-bottom: 20px;
        border: 1px solid transparent;
        border-radius: 8px;
        position: relative;
    }

    .alert-success {
        color: #155724;
        background-color: #d4edda;
        border-color: #c3e6cb;
    }

    .alert-danger {
        color: #721c24;
        background-color: #f8d7da;
        border-color: #f5c6cb;
    }

    .alert-info {
        color: #0c5460;
        background-color: #d1ecf1;
        border-color: #bee5eb;
    }

    .alert-warning {
        color: #856404;
        background-color: #fff3cd;
        border-color: #ffeaa7;
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
        background: none;
        border: none;
        font-size: 20px;
        cursor: pointer;
        color: inherit;
    }

    /* Table Styles */
    .table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .table th,
    .table td {
        padding: 12px 15px;
        text-align: left;
        border-bottom: 1px solid #e0e0e0;
    }

    .table th {
        background: #f8f9fa;
        font-weight: 600;
        color: #1a1a1a;
    }

    .table tbody tr:hover {
        background: #f8f9fa;
    }

    .table tbody tr:last-child td {
        border-bottom: none;
    }

    /* Modal Styles */
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
        position: relative;
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

    /* Footer Styles */
    footer {
        background: #1a1a1a;
        color: #ccc;
        padding: 50px 20px 20px;
        margin-top: 60px;
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

    /* Utility Classes */
    .text-center { text-align: center; }
    .text-left { text-align: left; }
    .text-right { text-align: right; }
    
    .mb-0 { margin-bottom: 0; }
    .mb-1 { margin-bottom: 0.25rem; }
    .mb-2 { margin-bottom: 0.5rem; }
    .mb-3 { margin-bottom: 1rem; }
    .mb-4 { margin-bottom: 1.5rem; }
    .mb-5 { margin-bottom: 3rem; }
    
    .mt-0 { margin-top: 0; }
    .mt-1 { margin-top: 0.25rem; }
    .mt-2 { margin-top: 0.5rem; }
    .mt-3 { margin-top: 1rem; }
    .mt-4 { margin-top: 1.5rem; }
    .mt-5 { margin-top: 3rem; }
    
    .p-0 { padding: 0; }
    .p-1 { padding: 0.25rem; }
    .p-2 { padding: 0.5rem; }
    .p-3 { padding: 1rem; }
    .p-4 { padding: 1.5rem; }
    .p-5 { padding: 3rem; }
    
    .d-none { display: none; }
    .d-block { display: block; }
    .d-flex { display: flex; }
    .d-grid { display: grid; }
    
    .justify-content-center { justify-content: center; }
    .justify-content-between { justify-content: space-between; }
    .align-items-center { align-items: center; }
    
    .w-100 { width: 100%; }
    .h-100 { height: 100%; }

    /* Responsive Design */
    @media (max-width: 768px) {
        .nav-container {
            flex-direction: column;
            gap: 20px;
        }

        .search-bar {
            margin: 20px 0;
            order: 2;
        }

        .user-actions {
            order: 1;
        }

        .nav-menu {
            flex-direction: column;
            gap: 0;
        }

        .nav-menu li a {
            padding: 12px 0;
        }

        .main-content {
            padding: 20px 15px;
        }

        .form-container {
            padding: 30px 20px;
        }

        .book-grid {
            grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
            gap: 20px;
        }

        .grid-2,
        .grid-3,
        .grid-4 {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 480px) {
        .form-container {
            padding: 20px 15px;
        }

        .btn {
            padding: 10px 20px;
            font-size: 13px;
        }

        .book-actions {
            flex-direction: column;
            gap: 8px;
        }

        .book-actions .btn {
            width: 100%;
        }
    }
</style>
