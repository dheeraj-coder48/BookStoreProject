package com.bookhaven.utils;

import com.bookhaven.models.Book;
import java.util.List;

public class JSONUtil {
    
    public static String booksToJson(List<Book> books) {
        if (books == null || books.isEmpty()) {
            return "[]";
        }
        
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < books.size(); i++) {
            Book book = books.get(i);
            json.append("{")
                .append("\"bookId\":").append(book.getBookId()).append(",")
                .append("\"title\":\"").append(escapeJson(book.getTitle())).append("\",")
                .append("\"author\":\"").append(escapeJson(book.getAuthor())).append("\",")
                .append("\"category\":\"").append(escapeJson(book.getCategory())).append("\",")
                .append("\"price\":").append(book.getPrice()).append(",")
                .append("\"imageUrl\":\"").append(escapeJson(book.getImageUrl())).append("\",")
                .append("\"stockQuantity\":").append(book.getStockQuantity())
                .append("}");
            
            if (i < books.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        
        return json.toString();
    }
    
    private static String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}