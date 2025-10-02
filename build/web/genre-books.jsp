<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.bookhaven.models.Book, java.util.List"%>
<%
    List<Book> genreBooks = (List<Book>) request.getAttribute("genreBooks");
    String genreName = (String) request.getAttribute("genreName");
    String error = (String) request.getAttribute("error");
    
    System.out.println("JSP: genreBooks = " + (genreBooks != null ? genreBooks.size() : "null"));
    System.out.println("JSP: genreName = " + genreName);
    System.out.println("JSP: error = " + error);
    
    if (genreBooks == null) {
        genreBooks = new java.util.ArrayList<>();
        System.out.println("JSP: genreBooks was null, created empty list");
    }
    if (genreName == null) {
        genreName = "Unknown Genre";
        System.out.println("JSP: genreName was null, set to default");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= genreName %> - BookHaven</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        /* Add your existing styles here */
        .back-home {
            position: absolute;
            top: 2rem;
            left: 2rem;
            z-index: 100;
        }
        
        .back-home a {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            color: #8B4513;
            text-decoration: none;
            font-weight: 600;
            padding: 1rem 1.8rem;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            backdrop-filter: blur(20px);
            border: 2px solid rgba(212, 175, 55, 0.3);
            transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            box-shadow: 0 8px 25px rgba(139, 69, 19, 0.15);
        }
        
        .back-home a:hover {
            background: white;
            transform: translateX(-8px);
            box-shadow: 0 12px 35px rgba(139, 69, 19, 0.25);
            border-color: #D4AF37;
        }
        
        .genre-header {
            text-align: center;
            padding: 4rem 2rem 2rem;
            background: linear-gradient(135deg, #8B4513, #654321);
            color: white;
            border-radius: 20px;
            margin: 2rem 0;
            position: relative;
            overflow: hidden;
        }
        
        .genre-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><path fill="%23D4AF37" opacity="0.1" d="M0,50 Q25,30 50,50 T100,50 L100,100 L0,100 Z"/></svg>');
        }
        
        .genre-title {
            font-family: 'Merriweather', serif;
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            position: relative;
        }
        
        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            padding: 2rem 0;
        }
        
        .book-card {
            background: linear-gradient(145deg, #FFFFFF, #FDF6E3);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(139, 69, 19, 0.1);
            transition: all 0.3s ease;
            border: 1px solid rgba(212, 175, 55, 0.2);
        }
        
        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(139, 69, 19, 0.2);
        }
        
        .book-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        
        .book-content {
            padding: 1.5rem;
        }
        
        .book-title {
            font-family: 'Merriweather', serif;
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: #654321;
        }
        
        .book-author {
            color: #8D6E63;
            margin-bottom: 1rem;
            font-style: italic;
        }
        
        .book-price {
            font-size: 1.5rem;
            font-weight: 800;
            color: #8B4513;
            margin-bottom: 1rem;
        }
        
        .book-actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .btn {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: #8B4513;
            color: white;
        }
        
        .btn-primary:hover {
            background: #654321;
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: rgba(139, 69, 19, 0.1);
            color: #8B4513;
            border: 1px solid rgba(139, 69, 19, 0.3);
        }
        
        .btn-secondary:hover {
            background: rgba(139, 69, 19, 0.2);
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #8D6E63;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
    </style>
</head>
<body>
    
    <div class="back-home">
        <a href="home">
            <i class="fas fa-arrow-left"></i>
            <span>Back to Home</span>
        </a>
    </div>

    <div class="container" style="max-width: 1200px; margin: 0 auto; padding: 2rem;">
        <div class="genre-header">
            <h1 class="genre-title"><i class="fas fa-book"></i> <%= genreName %></h1>
            <p style="font-size: 1.2rem; opacity: 0.9;">
                Discover <%= genreBooks.size() %> amazing books in this genre
            </p>
        </div>
        
        <% if (error != null) { %>
            <div style="background: #fee; color: #c00; padding: 1rem; border-radius: 8px; margin: 1rem 0; border-left: 4px solid #c00;">
                <i class="fas fa-exclamation-triangle"></i> <%= error %>
            </div>
        <% } %>
        
        <% if (genreBooks.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-book-open"></i>
                <h3>No Books Found</h3>
                <p>We couldn't find any books in the <%= genreName %> category.</p>
                <a href="home" class="btn btn-primary" style="display: inline-block; margin-top: 1rem;">
                    <i class="fas fa-arrow-left"></i> Browse Other Categories
                </a>
            </div>
        <% } else { %>
            <div class="books-grid">
                <% for (Book book : genreBooks) { %>
                <div class="book-card">
                    <img src="<%= book.getImageUrl() %>" 
                         alt="<%= book.getTitle() %>" 
                         class="book-image"
                         onerror="this.src='https://via.placeholder.com/300x200/8B4513/FFFFFF?text=📚'">
                    <div class="book-content">
                        <h3 class="book-title"><%= book.getTitle() %></h3>
                        <p class="book-author">by <%= book.getAuthor() %></p>
                        <div class="book-price">₹<%= String.format("%.2f", book.getPrice()) %></div>
                        <div class="book-actions">
                            <a href="book-detail?id=<%= book.getBookId() %>" class="btn btn-primary">
                                <i class="fas fa-eye"></i> View Details
                            </a>
                            <form action="add-to-cart" method="post" style="display: contents;">
                                <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn btn-secondary">
                                    <i class="fas fa-cart-plus"></i> Add to Cart
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>