package com.bookhaven.servlets;

import com.bookhaven.dao.OrderDAO;
import com.bookhaven.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/orders")
public class OrdersServlet extends HttpServlet {
    
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }
    
    // In your existing OrdersServlet, update the doGet method:
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    HttpSession session = request.getSession();
    String username = (String) session.getAttribute("username");
    User user = (User) session.getAttribute("user");
    
    if (username == null || user == null) {
        response.sendRedirect("login");
        return;
    }
    
    // Set flag for admin view
    request.setAttribute("isAdmin", user.isAdmin());
    
    if (user.isAdmin()) {
        // Admin sees all orders with management options
        request.setAttribute("orders", orderDAO.getAllOrders());
        request.setAttribute("pageTitle", "All Orders - Admin");
    } else {
        // Regular user sees only their orders
        request.setAttribute("orders", orderDAO.getOrdersByUserId(user.getUserId()));
        request.setAttribute("pageTitle", "My Orders");
    }
    
    request.getRequestDispatcher("orders.jsp").forward(request, response);
}
}