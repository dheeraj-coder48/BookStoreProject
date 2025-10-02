package com.bookhaven.servlets;

import com.bookhaven.dao.BookDAO;
import com.bookhaven.models.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/book-detail")
public class BookDetailServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    
    /**
     *
     * @throws ServletException
     */
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int bookId = Integer.parseInt(request.getParameter("id"));
            Book book = bookDAO.getBookById(bookId);
            
            if (book != null) {
                request.setAttribute("book", book);
                request.getRequestDispatcher("book-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect("home");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }
}