package com.bookhaven.servlets;

import com.bookhaven.models.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        if (username == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Get cart from session
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        System.out.println("CartServlet: Cart size = " + (cart != null ? cart.size() : "null"));
        
        double cartTotal = 0.0;
        int itemCount = 0;
        
        if (cart != null && !cart.isEmpty()) {
            for (CartItem item : cart) {
                cartTotal += item.getTotalPrice();
                itemCount += item.getQuantity();
                System.out.println("Cart item: " + item.getBook().getTitle() + " x" + item.getQuantity());
            }
        } else {
            System.out.println("Cart is empty or null");
            cart = new java.util.ArrayList<>(); // Ensure cart is never null
        }
        
        // Set attributes for JSP
        request.setAttribute("cart", cart);
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("itemCount", itemCount);
        
        System.out.println("Cart total: " + cartTotal + ", Item count: " + itemCount);
        
        request.getRequestDispatcher("cart-sample.jsp").forward(request, response);
    }
}