package com.bookhaven.servlets;

import com.bookhaven.dao.BookDAO;
import com.bookhaven.models.Book;
import com.bookhaven.models.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        if (username == null) {
            response.sendRedirect("login");
            return;
        }
        
        String referer = request.getHeader("Referer");
        String redirectUrl = referer != null ? referer : "home";
        
        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            Book book = bookDAO.getBookById(bookId);
            if (book == null) {
                session.setAttribute("error", "Book not found!");
                response.sendRedirect(redirectUrl);
                return;
            }
            
            // Get or create cart in session
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) {
                cart = new ArrayList<>();
                session.setAttribute("cart", cart);
            }
            
            // Check if book already in cart
            boolean found = false;
            for (CartItem item : cart) {
                if (item.getBook().getBookId() == bookId) {
                    item.setQuantity(item.getQuantity() + quantity);
                    found = true;
                    break;
                }
            }
            
            // If not found, add new item
            if (!found) {
                cart.add(new CartItem(book, quantity));
            }
            
            // Update cart count
            int totalItems = 0;
            for (CartItem item : cart) {
                totalItems += item.getQuantity();
            }
            session.setAttribute("cartItemCount", totalItems);
            
            // Set success message with book title
            session.setAttribute("success", "✅ '" + book.getTitle() + "' added to cart successfully!");
            
            System.out.println("Book added to cart: " + book.getTitle() + " (Qty: " + quantity + ")");
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid book or quantity!");
        }
        
        response.sendRedirect(redirectUrl);
    }
}