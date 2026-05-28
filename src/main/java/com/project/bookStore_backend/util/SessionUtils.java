package com.project.bookStore_backend.util;

import jakarta.servlet.http.HttpSession;

public class SessionUtils {
    
    // Customer session constants
    public static final String CUSTOMER_SESSION_KEY = "user";
    public static final String CUSTOMER_ID_KEY = "userId";
    public static final String CUSTOMER_USERNAME_KEY = "username";
    public static final String CUSTOMER_ROLE_KEY = "userRole";
    
    // Admin session constants
    public static final String ADMIN_SESSION_KEY = "admin";
    public static final String ADMIN_ID_KEY = "adminId";
    public static final String ADMIN_USERNAME_KEY = "adminUsername";
    public static final String ADMIN_ROLE_KEY = "adminRole";
    public static final String ADMIN_NAME_KEY = "adminName";
    
    // Role constants
    public static final String ROLE_CUSTOMER = "CUSTOMER";
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_SUPER_ADMIN = "SUPER_ADMIN";
    
    /**
     * Check if user is logged in as customer
     */
    public static boolean isCustomerLoggedIn(HttpSession session) {
        return session.getAttribute(CUSTOMER_ROLE_KEY) != null && 
               ROLE_CUSTOMER.equals(session.getAttribute(CUSTOMER_ROLE_KEY));
    }
    
    /**
     * Check if user is logged in as admin
     */
    public static boolean isAdminLoggedIn(HttpSession session) {
        return session.getAttribute(ADMIN_ROLE_KEY) != null && 
               (ROLE_ADMIN.equals(session.getAttribute(ADMIN_ROLE_KEY)) || 
                ROLE_SUPER_ADMIN.equals(session.getAttribute(ADMIN_ROLE_KEY)));
    }
    
    /**
     * Check if user is logged in as super admin
     */
    public static boolean isSuperAdminLoggedIn(HttpSession session) {
        return session.getAttribute(ADMIN_ROLE_KEY) != null && 
               ROLE_SUPER_ADMIN.equals(session.getAttribute(ADMIN_ROLE_KEY));
    }
    
    /**
     * Check if user is logged in (either customer or admin)
     */
    public static boolean isUserLoggedIn(HttpSession session) {
        return isCustomerLoggedIn(session) || isAdminLoggedIn(session);
    }
    
    /**
     * Get current user role
     */
    public static String getCurrentUserRole(HttpSession session) {
        if (isAdminLoggedIn(session)) {
            return (String) session.getAttribute(ADMIN_ROLE_KEY);
        } else if (isCustomerLoggedIn(session)) {
            return (String) session.getAttribute(CUSTOMER_ROLE_KEY);
        }
        return null;
    }
    
    /**
     * Get current user ID
     */
    public static Long getCurrentUserId(HttpSession session) {
        if (isAdminLoggedIn(session)) {
            return (Long) session.getAttribute(ADMIN_ID_KEY);
        } else if (isCustomerLoggedIn(session)) {
            return (Long) session.getAttribute(CUSTOMER_ID_KEY);
        }
        return null;
    }
    
    /**
     * Get current customer ID (alias for getCurrentUserId for customer context)
     */
    public static Long getCurrentCustomerId(HttpSession session) {
        if (isCustomerLoggedIn(session)) {
            return (Long) session.getAttribute(CUSTOMER_ID_KEY);
        }
        return null;
    }
    
    /**
     * Get current username
     */
    public static String getCurrentUsername(HttpSession session) {
        if (isAdminLoggedIn(session)) {
            return (String) session.getAttribute(ADMIN_USERNAME_KEY);
        } else if (isCustomerLoggedIn(session)) {
            return (String) session.getAttribute(CUSTOMER_USERNAME_KEY);
        }
        return null;
    }
    
    /**
     * Clear all session data
     */
    public static void clearSession(HttpSession session) {
        session.invalidate();
    }
    
    /**
     * Clear only customer session data
     */
    public static void clearCustomerSession(HttpSession session) {
        session.removeAttribute(CUSTOMER_SESSION_KEY);
        session.removeAttribute(CUSTOMER_ID_KEY);
        session.removeAttribute(CUSTOMER_USERNAME_KEY);
        session.removeAttribute(CUSTOMER_ROLE_KEY);
    }
    
    /**
     * Clear only admin session data
     */
    public static void clearAdminSession(HttpSession session) {
        session.removeAttribute(ADMIN_SESSION_KEY);
        session.removeAttribute(ADMIN_ID_KEY);
        session.removeAttribute(ADMIN_USERNAME_KEY);
        session.removeAttribute(ADMIN_ROLE_KEY);
        session.removeAttribute(ADMIN_NAME_KEY);
    }
    
    /**
     * Check if user has access to admin panel
     */
    public static boolean hasAdminAccess(HttpSession session) {
        return isAdminLoggedIn(session);
    }
    
    /**
     * Check if user has access to customer area
     */
    public static boolean hasCustomerAccess(HttpSession session) {
        return isCustomerLoggedIn(session);
    }
}
