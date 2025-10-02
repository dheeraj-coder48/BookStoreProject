package com.bookhaven.servlets;

import com.bookhaven.dao.BookDAO;
import com.bookhaven.dao.CategoryDAO;
import com.bookhaven.utils.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

@WebServlet("/debug")
public class DebugServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><body>");
        out.println("<h1>Debug Information</h1>");
        
        try {
            // Test database connection
            out.println("<h2>Database Connection Test:</h2>");
            Connection conn = DatabaseConnection.getConnection();
            if (conn != null && !conn.isClosed()) {
                out.println("<p style='color: green;'>✅ Database connection SUCCESS</p>");
                conn.close();
            } else {
                out.println("<p style='color: red;'>❌ Database connection FAILED</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ Database connection ERROR: " + e.getMessage() + "</p>");
        }
        
        // Test BookDAO
        out.println("<h2>BookDAO Test:</h2>");
        try {
            BookDAO bookDAO = new BookDAO();
            int bookCount = bookDAO.getAllBooks().size();
            out.println("<p>Total books in database: " + bookCount + "</p>");
            
            int featuredCount = bookDAO.getFeaturedBooks().size();
            out.println("<p>Featured books: " + featuredCount + "</p>");
            
            int newReleasesCount = bookDAO.getNewReleases().size();
            out.println("<p>New releases: " + newReleasesCount + "</p>");
        } catch (Exception e) {
            out.println("<p style='color: red;'>BookDAO Error: " + e.getMessage() + "</p>");
        }
        
        // Test CategoryDAO
        out.println("<h2>CategoryDAO Test:</h2>");
        try {
            CategoryDAO categoryDAO = new CategoryDAO();
            int categoryCount = categoryDAO.getAllCategories().size();
            out.println("<p>Total categories: " + categoryCount + "</p>");
        } catch (Exception e) {
            out.println("<p style='color: red;'>CategoryDAO Error: " + e.getMessage() + "</p>");
        }
        
        out.println("</body></html>");
    }
}