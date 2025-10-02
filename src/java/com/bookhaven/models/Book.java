package com.bookhaven.models;

public class Book {
    private int bookId;
    private String title;
    private String author;
    private String category;
    private double price;
    private String imageUrl;
    private String description; // Add this field
    private int stockQuantity;  // Add this field
    
    // Constructors
    public Book() {}
    
    public Book(int bookId, String title, String author, String category, 
                double price, String imageUrl, String description, int stockQuantity) {
        this.bookId = bookId;
        this.title = title;
        this.author = author;
        this.category = category;
        this.price = price;
        this.imageUrl = imageUrl;
        this.description = description;
        this.stockQuantity = stockQuantity;
    }
    
    // Getters and Setters
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    // Add these new getters and setters
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }
}