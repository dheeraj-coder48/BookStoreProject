package com.bookhaven.dao;

import com.bookhaven.models.Order;
import com.bookhaven.models.OrderItem;
import com.bookhaven.models.Book;
import com.bookhaven.utils.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    
    public boolean createOrder(Order order, List<OrderItem> orderItems) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Insert order
            String orderSql = "INSERT INTO orders (user_id, total_amount, shipping_address, payment_method) VALUES (?, ?, ?, ?)";
            PreparedStatement orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, order.getUserId());
            orderStmt.setDouble(2, order.getTotalAmount());
            orderStmt.setString(3, order.getShippingAddress());
            orderStmt.setString(4, order.getPaymentMethod());
            
            int orderRows = orderStmt.executeUpdate();
            if (orderRows == 0) {
                conn.rollback();
                return false;
            }
            
            // Get generated order ID
            ResultSet generatedKeys = orderStmt.getGeneratedKeys();
            int orderId = 0;
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            }
            
            // Insert order items
            String itemSql = "INSERT INTO order_items (order_id, book_id, quantity, price) VALUES (?, ?, ?, ?)";
            PreparedStatement itemStmt = conn.prepareStatement(itemSql);
            
            for (OrderItem item : orderItems) {
                itemStmt.setInt(1, orderId);
                itemStmt.setInt(2, item.getBookId());
                itemStmt.setInt(3, item.getQuantity());
                itemStmt.setDouble(4, item.getPrice());
                itemStmt.addBatch();
            }
            
            int[] itemResults = itemStmt.executeBatch();
            
            // Update book stock
            String updateStockSql = "UPDATE books SET stock_quantity = stock_quantity - ? WHERE book_id = ?";
            PreparedStatement stockStmt = conn.prepareStatement(updateStockSql);
            
            for (OrderItem item : orderItems) {
                stockStmt.setInt(1, item.getQuantity());
                stockStmt.setInt(2, item.getBookId());
                stockStmt.addBatch();
            }
            
            stockStmt.executeBatch();
            
            conn.commit(); // Commit transaction
            return true;
            
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.out.println("Error creating order: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public List<Order> getOrdersByUserId(int userId) {
    List<Order> orders = new ArrayList<>();
    String sql = "SELECT o.*, u.username FROM orders o JOIN users u ON o.user_id = u.user_id WHERE o.user_id = ? ORDER BY o.order_date DESC";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            Order order = new Order();
            order.setOrderId(rs.getInt("order_id"));
            order.setUserId(rs.getInt("user_id"));
            order.setOrderDate(rs.getTimestamp("order_date"));
            order.setTotalAmount(rs.getDouble("total_amount"));
            order.setStatus(rs.getString("status"));
            order.setShippingAddress(rs.getString("shipping_address"));
            order.setPaymentMethod(rs.getString("payment_method"));
            order.setUsername(rs.getString("username"));
            
            // Get order items - THIS IS CRITICAL
            List<OrderItem> orderItems = getOrderItemsByOrderId(order.getOrderId());
            order.setOrderItems(orderItems);
            
            orders.add(order);
        }
        
        System.out.println("Loaded " + orders.size() + " orders for user " + userId);
        
    } catch (SQLException e) {
        System.out.println("Error retrieving orders: " + e.getMessage());
        e.printStackTrace();
    }
    return orders;
}
    
    public List<Order> getAllOrders() {
    List<Order> orders = new ArrayList<>();
    String sql = "SELECT o.*, u.username FROM orders o JOIN users u ON o.user_id = u.user_id ORDER BY o.order_date DESC";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {
        
        while (rs.next()) {
            Order order = new Order();
            order.setOrderId(rs.getInt("order_id"));
            order.setUserId(rs.getInt("user_id"));
            order.setOrderDate(rs.getTimestamp("order_date"));
            order.setTotalAmount(rs.getDouble("total_amount"));
            order.setStatus(rs.getString("status"));
            order.setShippingAddress(rs.getString("shipping_address"));
            order.setPaymentMethod(rs.getString("payment_method"));
            order.setUsername(rs.getString("username"));
            
            // Get order items - THIS IS CRITICAL
            List<OrderItem> orderItems = getOrderItemsByOrderId(order.getOrderId());
            order.setOrderItems(orderItems);
            
            orders.add(order);
        }
        
        System.out.println("Loaded " + orders.size() + " orders with items");
        
    } catch (SQLException e) {
        System.out.println("Error retrieving all orders: " + e.getMessage());
        e.printStackTrace();
    }
    return orders;
}
    
    private List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, b.title, b.author, b.image_url FROM order_items oi JOIN books b ON oi.book_id = b.book_id WHERE oi.order_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("order_item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setBookId(rs.getInt("book_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                
                // Create book object for display
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setImageUrl(rs.getString("image_url"));
                item.setBook(book);
                
                items.add(item);
            }
            
        } catch (SQLException e) {
            System.out.println("Error retrieving order items: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }
    
    public boolean updateOrderStatus(int orderId, String status) {
    // Validate status
    if (!java.util.Arrays.asList("pending", "confirmed", "shipped", "delivered", "cancelled").contains(status)) {
        return false;
    }
    
    String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, status);
        stmt.setInt(2, orderId);
        
        int rowsAffected = stmt.executeUpdate();
        System.out.println("Updated order " + orderId + " status to: " + status);
        return rowsAffected > 0;
        
    } catch (SQLException e) {
        System.out.println("Error updating order status: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
}