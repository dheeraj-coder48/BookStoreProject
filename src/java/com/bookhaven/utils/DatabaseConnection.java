package com.bookhaven.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/S118_DheerajSingh_Project";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "dheeraj9537d"; // Change to your MySQL password
    
    static {
        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver Registered!");
        } catch (ClassNotFoundException e) {
            System.out.println("Error: MySQL JDBC Driver not found");
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        System.out.println("Attempting to connect to database...");
        Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        System.out.println("Database connection established successfully!");
        return connection;
    }
    
    // Test method
    public static void testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("✅ Database connection test: SUCCESS");
        } catch (SQLException e) {
            System.out.println("❌ Database connection test: FAILED");
            e.printStackTrace();
        }
    }
}