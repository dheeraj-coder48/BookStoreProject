package com.bookhaven.dao;

import com.bookhaven.models.Category;
import com.bookhaven.utils.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setName(rs.getString("name"));
                category.setImageUrl(rs.getString("image_url"));
                categories.add(category);
            }
            System.out.println("Retrieved " + categories.size() + " categories from database");
            
        } catch (SQLException e) {
            System.out.println("Error retrieving categories from database");
            e.printStackTrace();
        }
        return categories;
    }
}