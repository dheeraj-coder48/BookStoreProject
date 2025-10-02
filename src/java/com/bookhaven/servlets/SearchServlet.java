package com.bookhaven.servlets;

import com.bookhaven.dao.BookDAO;
import com.bookhaven.models.Book;
import com.bookhaven.utils.JSONUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/search-servlet")
public class SearchServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }
    
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    String action = request.getParameter("action");
    String query = request.getParameter("query");
    
    PrintWriter out = response.getWriter();
    
    try {
        if ("getAllBooks".equals(action)) {
            // Return all books for client-side search
            List<Book> allBooks = bookDAO.getAllBooks();
            String booksJson = JSONUtil.booksToJson(allBooks);
            out.print(booksJson);
        } else if (query != null && !query.trim().isEmpty()) {
            // Server-side search
            List<Book> searchResults = bookDAO.searchBooks(query);
            String resultsJson = JSONUtil.booksToJson(searchResults);
            out.print(resultsJson);
        } else {
            out.print("[]");
        }
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print("{\"error\": \"Search failed: " + e.getMessage() + "\"}");
        e.printStackTrace();
    }
    
    out.flush();
}
}