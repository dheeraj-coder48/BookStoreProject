package com.bookhaven.dao;

import com.bookhaven.models.Book;
import com.bookhaven.utils.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Book book = createBookFromResultSet(rs);
                books.add(book);
            }
            System.out.println("Retrieved " + books.size() + " books from database");
            
        } catch (SQLException e) {
            System.out.println("Error retrieving books from database");
            e.printStackTrace();
        }
        return books;
    }
    
    public List<Book> getFeaturedBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY RAND() LIMIT 5";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Book book = createBookFromResultSet(rs);
                books.add(book);
            }
            System.out.println("Retrieved " + books.size() + " featured books from database");
            
        } catch (SQLException e) {
            System.out.println("Error retrieving featured books from database");
            e.printStackTrace();
        }
        return books;
    }
    
    public List<Book> getNewReleases() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY created_at DESC LIMIT 4";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Book book = createBookFromResultSet(rs);
                books.add(book);
            }
            System.out.println("Retrieved " + books.size() + " new releases from database");
            
        } catch (SQLException e) {
            System.out.println("Error retrieving new releases from database");
            e.printStackTrace();
        }
        return books;
    }
    
    public Book getBookById(int bookId) {
        String sql = "SELECT * FROM books WHERE book_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createBookFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.out.println("Error retrieving book by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Helper method to create Book object from ResultSet
    private Book createBookFromResultSet(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookId(rs.getInt("book_id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setCategory(rs.getString("category"));
        book.setPrice(rs.getDouble("price"));
        book.setImageUrl(rs.getString("image_url"));
        book.setDescription(rs.getString("description"));
        book.setStockQuantity(rs.getInt("stock_quantity"));
        return book;
    }
    // Add this method to your BookDAO class
public List<Book> searchBooks(String query) {
    List<Book> books = new ArrayList<>();
    String sql = "SELECT * FROM books WHERE title LIKE ? OR author LIKE ? OR category LIKE ? ORDER BY title";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        String searchPattern = "%" + query + "%";
        stmt.setString(1, searchPattern);
        stmt.setString(2, searchPattern);
        stmt.setString(3, searchPattern);
        
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            Book book = createBookFromResultSet(rs);
            books.add(book);
        }
        
        System.out.println("Search found " + books.size() + " books for query: " + query);
        
    } catch (SQLException e) {
        System.out.println("Error searching books: " + e.getMessage());
        e.printStackTrace();
    }
    return books;
}
public boolean addBook(Book book) {
    String sql = "INSERT INTO books (title, author, category, price, stock_quantity, description, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, book.getTitle());
        stmt.setString(2, book.getAuthor());
        stmt.setString(3, book.getCategory());
        stmt.setDouble(4, book.getPrice());
        stmt.setInt(5, book.getStockQuantity());
        stmt.setString(6, book.getDescription());
        stmt.setString(7, book.getImageUrl());
        
        int rowsAffected = stmt.executeUpdate();
        return rowsAffected > 0;
        
    } catch (SQLException e) {
        System.out.println("Error adding book: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

public boolean updateBook(Book book) {
    String sql = "UPDATE books SET title = ?, author = ?, category = ?, price = ?, stock_quantity = ?, description = ?, image_url = ? WHERE book_id = ?";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, book.getTitle());
        stmt.setString(2, book.getAuthor());
        stmt.setString(3, book.getCategory());
        stmt.setDouble(4, book.getPrice());
        stmt.setInt(5, book.getStockQuantity());
        stmt.setString(6, book.getDescription());
        stmt.setString(7, book.getImageUrl());
        stmt.setInt(8, book.getBookId());
        
        int rowsAffected = stmt.executeUpdate();
        return rowsAffected > 0;
        
    } catch (SQLException e) {
        System.out.println("Error updating book: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

public boolean deleteBook(int bookId) {
    String sql = "DELETE FROM books WHERE book_id = ?";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, bookId);
        int rowsAffected = stmt.executeUpdate();
        return rowsAffected > 0;
        
    } catch (SQLException e) {
        System.out.println("Error deleting book: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}


    // Add this method to your BookDAO.java
public List<Book> getBooksByGenre(String genre) {
    List<Book> books = new ArrayList<>();
    String sql = "SELECT * FROM books WHERE category = ? ORDER BY title";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, genre);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            Book book = createBookFromResultSet(rs);
            books.add(book);
        }
        
        System.out.println("Retrieved " + books.size() + " books for genre: " + genre);
        
    } catch (SQLException e) {
        System.out.println("Error retrieving books by genre: " + e.getMessage());
        e.printStackTrace();
    }
    return books;
}
}