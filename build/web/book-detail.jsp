<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.bookhaven.models.Book"%>
<%
    Book book = (Book) request.getAttribute("book");
    if (book == null) {
        response.sendRedirect("home");
        return;
    }
    
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= book.getTitle() %> - BookHaven</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #8B4513;
            --primary-dark: #654321;
            --secondary: #D4AF37;
            --light: #FDF6E3;
            --dark: #2C1810;
            --text: #3E2723;
            --text-light: #8D6E63;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #FDF6E3 0%, #F5E6D3 100%);
            color: var(--text);
            line-height: 1.6;
            min-height: 100vh;
        }
        
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
            color: var(--primary);
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
            border-color: var(--secondary);
        }
        
        .back-home a i {
            transition: transform 0.3s ease;
        }
        
        .back-home a:hover i {
            transform: translateX(-3px);
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .book-hero {
            background: linear-gradient(135deg, rgba(139, 69, 19, 0.05), rgba(212, 175, 55, 0.05));
            border-radius: 20px;
            padding: 3rem;
            margin-top: 1rem;
            position: relative;
            overflow: hidden;
        }
        
        .book-hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
        }
        
        .book-layout {
            display: grid;
            grid-template-columns: 380px 1fr;
            gap: 4rem;
            align-items: start;
        }
        
        .book-image-container {
            position: relative;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            transform: perspective(1000px) rotateY(-5deg);
            transition: all 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }
        
        .book-image-container:hover {
            transform: perspective(1000px) rotateY(0deg) scale(1.02);
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.4);
        }
        
        .book-image {
            width: 100%;
            height: 600px;
            object-fit: cover;
            display: block;
        }
        
        .book-info {
            padding: 1rem 0;
        }
        
        .book-title {
            font-family: 'Merriweather', serif;
            font-size: 3.2rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 1rem;
            line-height: 1.1;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .book-author {
            font-size: 1.4rem;
            color: var(--text-light);
            margin-bottom: 2rem;
            font-style: italic;
            position: relative;
            padding-left: 2rem;
        }
        
        .book-author::before {
            content: 'by';
            position: absolute;
            left: 0;
            color: var(--secondary);
            font-weight: 600;
        }
        
        .book-price {
            font-size: 3rem;
            font-weight: 800;
            color: var(--primary);
            margin-bottom: 2rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .book-meta {
            display: flex;
            gap: 1.5rem;
            margin-bottom: 3rem;
            flex-wrap: wrap;
        }
        
        .book-category {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: #8B4513;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 1rem;
            box-shadow: 0 6px 20px rgba(139, 69, 19, 0.3);
        }
        
        .book-stock {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            padding: 10px 20px;
            background: rgba(16, 185, 129, 0.1);
            color: #059669;
            border-radius: 25px;
            font-weight: 600;
            border: 2px solid rgba(16, 185, 129, 0.2);
        }
        
        .book-description {
            background: rgba(255, 255, 255, 0.7);
            padding: 2.5rem;
            border-radius: 16px;
            margin-bottom: 3rem;
            border-left: 4px solid var(--secondary);
            box-shadow: 0 10px 30px rgba(139, 69, 19, 0.1);
        }
        
        .book-description h3 {
            font-family: 'Merriweather', serif;
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 1.5rem;
            position: relative;
        }
        
        .book-description h3::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 60px;
            height: 3px;
            background: var(--secondary);
            border-radius: 2px;
        }
        
        .book-description p {
            font-size: 1.1rem;
            line-height: 1.8;
            color: var(--text);
        }
        
        .action-buttons {
            display: flex;
            gap: 1.5rem;
            margin-top: 3rem;
        }
        
        .btn {
            padding: 1.2rem 2.5rem;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            position: relative;
            overflow: hidden;
        }
        
        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            transition: left 0.5s ease;
        }
        
        .btn:hover::before {
            left: 100%;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            box-shadow: 0 8px 25px rgba(139, 69, 19, 0.4);
            flex: 1;
        }
        
        .btn-primary:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 12px 35px rgba(139, 69, 19, 0.6);
        }
        
        .btn-secondary {
            background: rgba(139, 69, 19, 0.1);
            color: var(--primary);
            border: 2px solid rgba(139, 69, 19, 0.3);
            flex: 1;
        }
        
        .btn-secondary:hover {
            background: rgba(139, 69, 19, 0.2);
            border-color: var(--primary);
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 8px 25px rgba(139, 69, 19, 0.2);
        }
        
        .wishlist-btn.active {
            background: linear-gradient(135deg, #FF69B4, #FF1493);
            color: white;
            border-color: transparent;
        }
        
        .feature-badges {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            flex-wrap: wrap;
        }
        
        .feature-badge {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            padding: 0.8rem 1.2rem;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            font-size: 0.9rem;
            color: var(--text);
            border: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .feature-badge i {
            color: var(--secondary);
        }
        
        @media (max-width: 968px) {
            .book-layout {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
            
            .book-image-container {
                transform: none;
                max-width: 400px;
                margin: 0 auto;
            }
            
            .book-title {
                font-size: 2.5rem;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .back-home {
                top: 1rem;
                left: 1rem;
            }
        }
        
        @media (max-width: 480px) {
            .container {
                padding: 1rem;
            }
            
            .book-hero {
                padding: 2rem;
            }
            
            .book-title {
                font-size: 2rem;
            }
            
            .book-price {
                font-size: 2.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Success/Error Messages -->
<% 
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    
    if (success != null) { 
%>
    <div class="success-message" style="position: fixed; top: 100px; right: 20px; background: linear-gradient(135deg, #10b981, #059669); color: white; padding: 15px 25px; border-radius: 10px; box-shadow: 0 10px 30px rgba(16, 185, 129, 0.4); z-index: 10000; display: flex; align-items: center; gap: 12px; animation: slideIn 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55); border-left: 4px solid white;">
        <i class="fas fa-check-circle"></i>
        <div><%= success %></div>
    </div>
    
    <script>
        // Auto-hide success message after 3 seconds
        setTimeout(() => {
            const message = document.querySelector('.success-message');
            if (message) {
                message.style.animation = 'slideOut 0.4s ease';
                setTimeout(() => message.remove(), 400);
            }
        }, 3000);
    </script>
    
    <style>
        @keyframes slideIn {
            from { transform: translateX(400px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        @keyframes slideOut {
            from { transform: translateX(0); opacity: 1; }
            to { transform: translateX(400px); opacity: 0; }
        }
    </style>
<%
        session.removeAttribute("success");
    } 
    
    if (error != null) { 
%>
    <div class="error-message" style="position: fixed; top: 100px; right: 20px; background: linear-gradient(135deg, #ef4444, #dc2626); color: white; padding: 15px 25px; border-radius: 10px; box-shadow: 0 10px 30px rgba(239, 68, 68, 0.4); z-index: 10000; display: flex; align-items: center; gap: 12px; animation: slideIn 0.4s ease;">
        <i class="fas fa-exclamation-circle"></i>
        <div><%= error %></div>
    </div>
    
    <script>
        // Auto-hide error message after 3 seconds
        setTimeout(() => {
            const message = document.querySelector('.error-message');
            if (message) {
                message.style.animation = 'slideOut 0.4s ease';
                setTimeout(() => message.remove(), 400);
            }
        }, 3000);
    </script>
<%
        session.removeAttribute("error");
    } 
%>
    <div class="back-home">
        <a href="home">
            <i class="fas fa-arrow-left"></i>
            <span>Back to Home</span>
        </a>
    </div>

    <div class="container">
        <div class="book-hero">
            <div class="book-layout">
                <div class="book-image-container">
                    <img src="<%= book.getImageUrl() %>" alt="<%= book.getTitle() %>" class="book-image"
                         onerror="this.src='https://via.placeholder.com/380x500/8B4513/FFFFFF?text=📚'">
                </div>
                
                <div class="book-info">
                    <h1 class="book-title"><%= book.getTitle() %></h1>
                    <p class="book-author"><strong><%= book.getAuthor() %></strong></p>
                    
                    <div class="book-price">₹<%= String.format("%.2f", book.getPrice()) %></div>
                    
                    <div class="book-meta">
                        <span class="book-category"><%= book.getCategory() %></span>
                        <span class="book-stock">
                            <i class="fas fa-box"></i> 
                            <%= book.getStockQuantity() %> in stock
                        </span>
                    </div>
                    
                    <div class="book-description">
                        <h3>About this Book</h3>
                        <p><%= book.getDescription() != null ? book.getDescription() : "A wonderful addition to your collection. This book offers great value and engaging content that will keep you captivated from start to finish. Perfect for readers who appreciate quality literature and timeless storytelling." %></p>
                    </div>
                    
                    <div class="feature-badges">
<!--                        <div class="feature-badge">
                            <i class="fas fa-shipping-fast"></i>
                            <span>Free shipping over $50</span>
                        </div>-->
                        <div class="feature-badge">
                            <i class="fas fa-undo-alt"></i>
                            <span>30-day return policy</span>
                        </div>
                        <div class="feature-badge">
                            <i class="fas fa-shield-alt"></i>
                            <span>Secure checkout</span>
                        </div>
                    </div>
                    
                    <div class="action-buttons">
                        <form action="add-to-cart" method="post" style="display: contents;">
                            <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-cart-plus"></i> Add to Cart
                            </button>
                        </form>
                        
                        <button class="btn btn-secondary wishlist-btn"
                                data-book-id="<%= book.getBookId() %>"
                                data-book-title="<%= book.getTitle().replace("\"", "&quot;") %>"
                                data-book-author="<%= book.getAuthor().replace("\"", "&quot;") %>"
                                data-book-price="<%= book.getPrice() %>"
                                data-book-image="<%= book.getImageUrl() %>"
                                data-book-category="<%= book.getCategory() %>">
                            <i class="fas fa-heart"></i> Add to Wishlist
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const wishlistBtn = document.querySelector('.wishlist-btn');
            
            wishlistBtn.addEventListener('click', function() {
                <% if (username == null) { %>
                    alert('Please login to add to wishlist');
                    window.location.href = 'login';
                    return;
                <% } %>
                
                const bookId = this.getAttribute('data-book-id');
                const bookTitle = this.getAttribute('data-book-title');
                
                // Toggle active state
                this.classList.toggle('active');
                
                if (this.classList.contains('active')) {
                    this.innerHTML = '<i class="fas fa-heart"></i> Added to Wishlist';
                    // Add to wishlist logic here
                    let wishlist = JSON.parse(localStorage.getItem('bookhaven_wishlist') || '[]');
                    if (!wishlist.some(item => item.id === bookId)) {
                        wishlist.push({
                            id: bookId,
                            title: bookTitle
                        });
                        localStorage.setItem('bookhaven_wishlist', JSON.stringify(wishlist));
                    }
                } else {
                    this.innerHTML = '<i class="fas fa-heart"></i> Add to Wishlist';
                    // Remove from wishlist logic here
                    let wishlist = JSON.parse(localStorage.getItem('bookhaven_wishlist') || '[]');
                    wishlist = wishlist.filter(item => item.id !== bookId);
                    localStorage.setItem('bookhaven_wishlist', JSON.stringify(wishlist));
                }
            });
        });
    </script>
</body>
</html>