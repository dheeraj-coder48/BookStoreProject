package com.bookhaven.servlets;

import com.bookhaven.dao.BookDAO;
import com.bookhaven.models.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/genre")
public class GenreServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        System.out.println("GenreServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("GenreServlet called");
        
        String genreName = request.getParameter("name");
        System.out.println("Requested genre: " + genreName);
        
        if (genreName == null || genreName.trim().isEmpty()) {
            System.out.println("No genre specified, redirecting to home");
            response.sendRedirect("home");
            return;
        }
        
        try {
            // Decode URL parameter
            genreName = java.net.URLDecoder.decode(genreName, "UTF-8");
            
            // Get books by genre
            List<Book> genreBooks = bookDAO.getBooksByGenre(genreName);
            System.out.println("Found " + genreBooks.size() + " books for genre: " + genreName);
            
            request.setAttribute("genreBooks", genreBooks);
            request.setAttribute("genreName", genreName);
            
            // Debug: Print book titles
            for (Book book : genreBooks) {
                System.out.println("Book: " + book.getTitle() + " by " + book.getAuthor() + " | ID: " + book.getBookId());
            }
            
        } catch (Exception e) {
            System.out.println("Error in GenreServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("genreBooks", new java.util.ArrayList<Book>());
            request.setAttribute("error", "Error loading books: " + e.getMessage());
        }
        
        request.getRequestDispatcher("genre-books.jsp").forward(request, response);
    }
}