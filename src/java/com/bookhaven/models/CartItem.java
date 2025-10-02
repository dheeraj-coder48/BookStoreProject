package com.bookhaven.models;

public class CartItem {
    private Book book;
    private int quantity;
    
    public CartItem() {}
    
    public CartItem(Book book, int quantity) {
        this.book = book;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public Book getBook() { return book; }
    public void setBook(Book book) { this.book = book; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    // Helper methods - FIXED to ensure proper calculation
    public double getTotalPrice() {
        if (book == null) return 0.0;
        return book.getPrice() * quantity;
    }
    
    public void incrementQuantity() {
        this.quantity++;
    }
    
    public void incrementQuantity(int amount) {
        this.quantity += amount;
    }
}