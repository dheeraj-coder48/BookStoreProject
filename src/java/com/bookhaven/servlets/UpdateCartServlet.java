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

@WebServlet("/update-cart")
public class UpdateCartServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        if (cart == null) {
            response.sendRedirect("cart");
            return;
        }
        
        String action = request.getParameter("action");
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        
        System.out.println("UpdateCart: Action=" + action + ", BookId=" + bookId);
        
        if ("update".equals(action)) {
            int newQuantity = Integer.parseInt(request.getParameter("quantity"));
            System.out.println("UpdateCart: New quantity=" + newQuantity);
            
            for (CartItem item : cart) {
                if (item.getBook().getBookId() == bookId) {
                    if (newQuantity > 0) {
                        item.setQuantity(newQuantity);
                        System.out.println("Updated quantity for: " + item.getBook().getTitle());
                    } else {
                        cart.remove(item);
                        System.out.println("Removed item: " + item.getBook().getTitle());
                    }
                    break;
                }
            }
        } else if ("remove".equals(action)) {
            cart.removeIf(item -> item.getBook().getBookId() == bookId);
            System.out.println("Removed item with ID: " + bookId);
        }
        
        // Update cart count
        int totalItems = 0;
        for (CartItem item : cart) {
            totalItems += item.getQuantity();
        }
        session.setAttribute("cartItemCount", totalItems);
        
        session.setAttribute("success", "Cart updated successfully!");
        response.sendRedirect("cart");
    }
}