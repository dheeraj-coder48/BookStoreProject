package com.bookhaven.servlets;

import com.bookhaven.dao.OrderDAO;
import com.bookhaven.models.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    
    private OrderDAO orderDAO;
    
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        User user = (User) session.getAttribute("user");
        
        if (username == null || user == null) {
            response.sendRedirect("login");
            return;
        }
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }
        
        // Calculate total
        double total = 0;
        for (CartItem item : cart) {
            total += item.getTotalPrice();
        }
        
        request.setAttribute("cartTotal", total);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        User user = (User) session.getAttribute("user");
        
        if (username == null || user == null) {
            response.sendRedirect("login");
            return;
        }
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }
        
        // Get form data
        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");
        
        // Calculate total
        double total = 0;
        for (CartItem item : cart) {
            total += item.getTotalPrice();
        }
        
        // Create order
        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setTotalAmount(total);
        order.setShippingAddress(shippingAddress);
        order.setPaymentMethod(paymentMethod);
        
        // Create order items from cart
        List<OrderItem> orderItems = new java.util.ArrayList<>();
        for (CartItem cartItem : cart) {
            OrderItem orderItem = new OrderItem();
            orderItem.setBookId(cartItem.getBook().getBookId());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setPrice(cartItem.getBook().getPrice());
            orderItems.add(orderItem);
        }
        
        // Save order to database
        if (orderDAO.createOrder(order, orderItems)) {
            // Clear cart
            session.removeAttribute("cart");
            session.setAttribute("orderSuccess", "Order placed successfully! Thank you for your purchase.");
            response.sendRedirect("orders");
        } else {
            session.setAttribute("orderError", "Failed to place order. Please try again.");
            response.sendRedirect("checkout");
        }
    }
}