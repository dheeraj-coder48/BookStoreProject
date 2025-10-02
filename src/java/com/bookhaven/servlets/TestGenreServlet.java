package com.bookhaven.servlets;

import com.bookhaven.dao.BookDAO;
import com.bookhaven.models.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/test-genre")
public class TestGenreServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><body>");
        out.println("<h1>Genre Test Page</h1>");
        
        String genre = request.getParameter("genre");
        if (genre == null) genre = "Indian Fiction";
        
        out.println("<h2>Testing Genre: " + genre + "</h2>");
        
        try {
            List<Book> books = bookDAO.getBooksByGenre(genre);
            out.println("<p>Found " + books.size() + " books</p>");
            
            for (Book book : books) {
                out.println("<div style='border:1px solid #ccc; padding:10px; margin:10px;'>");
                out.println("<h3>" + book.getTitle() + "</h3>");
                out.println("<p>Author: " + book.getAuthor() + "</p>");
                out.println("<p>Price: ₹" + book.getPrice() + "</p>");
                out.println("</div>");
            }
            
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("</body></html>");
    }
}