package com.bookhaven.servlets;

import com.bookhaven.dao.BookDAO;
import com.bookhaven.dao.CategoryDAO;
import com.bookhaven.models.Book;
import com.bookhaven.models.CartItem;
import com.bookhaven.models.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        categoryDAO = new CategoryDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== HomeServlet START ===");
        
        try {
            // Get data from database
            List<Book> featuredBooks = bookDAO.getFeaturedBooks();
            List<Category> categories = categoryDAO.getAllCategories();
            List<Book> newReleases = bookDAO.getNewReleases();
            
            System.out.println("Data retrieved:");
            System.out.println("- Featured: " + featuredBooks.size());
            System.out.println("- Categories: " + categories.size());
            System.out.println("- New Releases: " + newReleases.size());
            
            // Debug: Print categories
            for (Category category : categories) {
                System.out.println("Category: " + category.getName());
            }
            
            // Set data as request attributes
            request.setAttribute("featuredBooks", featuredBooks);
            request.setAttribute("categories", categories);
            request.setAttribute("newReleases", newReleases);
            
            // Session data
            HttpSession session = request.getSession();
            String username = (String) session.getAttribute("username");
            System.out.println("Username: " + username);
            
            // Cart count
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            int cartItemCount = 0;
            if (cart != null) {
                cartItemCount = cart.size();
            }
            session.setAttribute("cartItemCount", cartItemCount);
            
            // Forward to JSP
            System.out.println("Forwarding to index.jsp...");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("featuredBooks", new java.util.ArrayList<Book>());
            request.setAttribute("categories", new java.util.ArrayList<Category>());
            request.setAttribute("newReleases", new java.util.ArrayList<Book>());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
        
        System.out.println("=== HomeServlet END ===");
    }
}