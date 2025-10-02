package com.bookhaven.servlets;

import com.bookhaven.dao.BookDAO;
import com.bookhaven.dao.OrderDAO;
import com.bookhaven.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        orderDAO = new OrderDAO();
        System.out.println("AdminServlet initialized successfully");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String username = (String) session.getAttribute("username");
        
        // Enhanced admin access check with detailed logging
        System.out.println("=== ADMIN ACCESS CHECK ===");
        System.out.println("Session ID: " + session.getId());
        System.out.println("Username in session: " + username);
        System.out.println("User object in session: " + (user != null ? "Present" : "NULL"));
        
        if (user != null) {
            System.out.println("User role: " + user.getRole());
            System.out.println("Is admin: " + user.isAdmin());
        }
        
        // Comprehensive admin check
        boolean isAdmin = false;
        if (user != null) {
            isAdmin = user.isAdmin();
        }
        
        // Additional check for role attribute
        String roleAttr = (String) session.getAttribute("role");
        if (roleAttr != null && "admin".equals(roleAttr)) {
            isAdmin = true;
            System.out.println("Admin role confirmed via role attribute");
        }
        
        if (!isAdmin) {
            System.out.println("❌ ACCESS DENIED: User is not admin. Redirecting to home.");
            session.setAttribute("errorMessage", "Access denied. Administrator privileges required.");
            response.sendRedirect("home");
            return;
        }
        
        System.out.println("✅ ADMIN ACCESS GRANTED for user: " + username);
        
        try {
            // Get statistics for admin dashboard
            int totalBooks = bookDAO.getAllBooks().size();
            int totalOrders = orderDAO.getAllOrders().size();
            
            System.out.println("Loading admin data - Books: " + totalBooks + ", Orders: " + totalOrders);
            
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("totalOrders", totalOrders);
            
            // Get recent orders (last 5)
            java.util.List<com.bookhaven.models.Order> allOrders = orderDAO.getAllOrders();
            int recentCount = Math.min(5, allOrders.size());
            java.util.List<com.bookhaven.models.Order> recentOrders = allOrders.subList(0, recentCount);
            
            request.setAttribute("recentOrders", recentOrders);
            System.out.println("Loaded " + recentOrders.size() + " recent orders");
            
            // Set admin-specific attributes
            request.setAttribute("adminUsername", username);
            request.setAttribute("pageTitle", "Admin Dashboard");
            
        } catch (Exception e) {
            System.out.println("❌ Error loading admin data: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading dashboard data: " + e.getMessage());
        }
        
        // Forward to admin dashboard
        System.out.println("Forwarding to admin-dashboard.jsp");
        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Admin check for POST requests too
        if (user == null || !user.isAdmin()) {
            response.sendRedirect("home");
            return;
        }
        
        String action = request.getParameter("action");
        System.out.println("Admin POST action: " + action);
        
        if ("updateOrderStatus".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("status");
                
                System.out.println("Updating order " + orderId + " to status: " + status);
                
                if (orderDAO.updateOrderStatus(orderId, status)) {
                    session.setAttribute("adminMessage", "✅ Order status updated successfully!");
                    System.out.println("Order status updated successfully");
                } else {
                    session.setAttribute("adminError", "❌ Failed to update order status.");
                    System.out.println("Failed to update order status");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("adminError", "❌ Invalid order ID.");
                System.out.println("Invalid order ID format");
            } catch (Exception e) {
                session.setAttribute("adminError", "❌ Error updating order: " + e.getMessage());
                System.out.println("Error updating order: " + e.getMessage());
            }
        } else {
            session.setAttribute("adminError", "❌ Unknown action requested.");
            System.out.println("Unknown action: " + action);
        }
        
        response.sendRedirect("admin");
    }
    
    @Override
    public void destroy() {
        System.out.println("AdminServlet destroyed");
        super.destroy();
    }
}