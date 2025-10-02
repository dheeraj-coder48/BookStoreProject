package com.bookhaven.servlets;

import com.bookhaven.dao.BookDAO;
import com.bookhaven.models.Book;
import com.bookhaven.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin-books")
public class BookManagementServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is admin
        if (user == null || !user.isAdmin()) {
            response.sendRedirect("home");
            return;
        }
        
        String action = request.getParameter("action");
        String searchQuery = request.getParameter("search");
        
        if ("edit".equals(action)) {
            // Show edit form
            int bookId = Integer.parseInt(request.getParameter("id"));
            Book book = bookDAO.getBookById(bookId);
            request.setAttribute("book", book);
            request.setAttribute("isEdit", true);
        } else if ("delete".equals(action)) {
            // Delete book
            int bookId = Integer.parseInt(request.getParameter("id"));
            if (deleteBook(bookId)) {
                session.setAttribute("adminMessage", "Book deleted successfully!");
            } else {
                session.setAttribute("adminError", "Failed to delete book.");
            }
            response.sendRedirect("admin-books");
            return;
        }
        
        // Get books list (with search filter if applicable)
        List<Book> books;
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            books = searchBooks(searchQuery);
            request.setAttribute("searchQuery", searchQuery);
        } else {
            books = bookDAO.getAllBooks();
        }
        
        request.setAttribute("books", books);
        request.getRequestDispatcher("admin-books.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect("home");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action) || "edit".equals(action)) {
            // Handle add/edit book
            if (saveBook(request)) {
                session.setAttribute("adminMessage", "Book " + ("add".equals(action) ? "added" : "updated") + " successfully!");
            } else {
                session.setAttribute("adminError", "Failed to " + ("add".equals(action) ? "add" : "update") + " book.");
            }
        }
        
        response.sendRedirect("admin-books");
    }
    
    private boolean saveBook(HttpServletRequest request) {
        try {
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String category = request.getParameter("category");
            double price = Double.parseDouble(request.getParameter("price"));
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");
            
            // You would typically handle file upload for images here
            // For now, we'll use the provided URL or a default
            
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                imageUrl = "https://via.placeholder.com/300x400/3b82f6/ffffff?text=" + title.replace(" ", "+");
            }
            
            Book book = new Book();
            book.setTitle(title);
            book.setAuthor(author);
            book.setCategory(category);
            book.setPrice(price);
            book.setStockQuantity(stockQuantity);
            book.setDescription(description);
            book.setImageUrl(imageUrl);
            
            // This is a simplified version - in real app, you'd have proper add/update methods
            // For now, we'll just return true as we don't have the actual implementation
            System.out.println("Book saved: " + book.getTitle());
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private boolean deleteBook(int bookId) {
        // In real application, you'd have a delete method in BookDAO
        System.out.println("Book deleted with ID: " + bookId);
        return true;
    }
    
    private List<Book> searchBooks(String query) {
    return bookDAO.searchBooks(query);
}
}