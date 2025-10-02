<%@page import="com.bookhaven.models.CartItem"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.bookhaven.models.Book, com.bookhaven.models.Category, java.util.List"%>
<%
    // Get data from servlet request attributes
    List<Book> featuredBooks = (List<Book>) request.getAttribute("featuredBooks");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<Book> newReleases = (List<Book>) request.getAttribute("newReleases");
    
    // Create empty lists if null to prevent errors
    if (featuredBooks == null) featuredBooks = new java.util.ArrayList<>();
    if (categories == null) categories = new java.util.ArrayList<>();
    if (newReleases == null) newReleases = new java.util.ArrayList<>();
    
    // Session data
    String username = (String) session.getAttribute("username");
    Integer cartItemCount = (Integer) session.getAttribute("cartItemCount");
    if (cartItemCount == null) cartItemCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>BookHaven - Where Stories Come Alive</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700;900&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
      <link rel="stylesheet" href="style.css">
</head>
<body>
    <!-- Temporary Test Links -->
<!--<div style="text-align: center; margin: 20px; padding: 20px; background: white; border-radius: 10px;">
    <h3>Quick Genre Test Links:</h3>
    <a href="genre?name=Indian Fiction" style="margin: 5px;">Indian Fiction</a> |
    <a href="genre?name=Indian History" style="margin: 5px;">Indian History</a> |
    <a href="genre?name=Indian Mythology" style="margin: 5px;">Indian Mythology</a>
</div>-->
    <body data-user-loggedin="<%= username != null %>">
    <!-- Premium Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <a href="home" class="logo">
                    <div class="logo-icon">
                        <i class="fas fa-book-open"></i>
                    </div>
                    BookHaven
                </a>

                <ul class="nav-links">
                    <li><a href="#featured"><i class="fas fa-star"></i> Featured</a></li>
                    <li><a href="#genres"><i class="fas fa-tags"></i> Genres</a></li>
                    <li><a href="#new-releases"><i class="fas fa-rocket"></i> New Releases</a></li>
                    <li><a href="#featured"><i class="fas fa-crown"></i> Bestsellers</a></li>
                </ul>

                <div class="header-actions">
                    <div class="search-bar">
    <input type="text" id="searchInput" placeholder="Discover your next read...">
    <i class="fas fa-search"></i>
    <div id="searchResults" class="search-results"></div>
</div>

                    <!-- Fixed Cart with Hover Preview -->
<!-- In your header section of index.jsp, replace the cart preview with this: -->
<div class="cart-container">
    <a href="cart" class="cart-icon">
        <i class="fas fa-shopping-cart"></i>
        <% if (cartItemCount > 0) { %>
            <span class="cart-count" id="cartCount"><%= cartItemCount %></span>
        <% } else { %>
            <span class="cart-count" id="cartCount" style="display: none;">0</span>
        <% } %>
    </a>
    
    <!-- Cart Preview Dropdown -->
    <div class="cart-preview">
        <div class="cart-preview-header">
            <span class="cart-preview-title">Your Cart</span>
            <span class="cart-preview-count" id="previewCartCount">
                <%= cartItemCount %> <%= cartItemCount == 1 ? "item" : "items" %>
            </span>
        </div>
        
        <div class="cart-preview-items" id="cartPreviewItems">
            <% 
                List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
                if (cart != null && !cart.isEmpty()) { 
                    for (int i = 0; i < Math.min(cart.size(), 3); i++) { 
                        CartItem item = cart.get(i);
            %>
                <div class="cart-preview-item">
                    <img src="<%= item.getBook().getImageUrl() %>" alt="<%= item.getBook().getTitle() %>"
                         onerror="this.src='https://via.placeholder.com/40x50/8B4513/FFFFFF?text=📚'">
                    <div class="cart-preview-info">
                        <div class="cart-preview-item-title"><%= item.getBook().getTitle() %></div>
                        <div class="cart-preview-item-meta">
                            <span>Qty: <%= item.getQuantity() %></span>
                            <span>₹<%= String.format("%.2f", item.getTotalPrice()) %></span>
                        </div>
                    </div>
                </div>
            <% 
                    } 
                } else { 
            %>
                <div class="cart-preview-empty">
                    <i class="fas fa-shopping-cart"></i>
                    <p>Your cart is empty</p>
                </div>
            <% } %>
        </div>
        
        <div class="cart-preview-total">
            <span>Total:</span>
            <span id="previewCartTotal">
                <% if (cart != null && !cart.isEmpty()) { 
                    double total = 0;
                    for (CartItem item : cart) {
                        total += item.getTotalPrice();
                    }
                %>
                    ₹<%= String.format("%.2f", total) %>
                <% } else { %>
                    ₹0.00
                <% } %>
            </span>
        </div>
        
        <div class="cart-preview-actions">
            <a href="cart" class="cart-preview-btn btn-view-cart">View Cart</a>
            <% if (cart != null && !cart.isEmpty()) { %>
                <a href="checkout" class="cart-preview-btn btn-checkout">Checkout</a>
            <% } %>
        </div>
    </div>
</div>

                    <!-- User Profile Dropdown -->
<% if (username != null) { %>
<div class="user-dropdown">
    <div class="user-icon dropdown-trigger">
        <i class="fas fa-user"></i>
        <span class="wishlist-badge" id="wishlistCountBadge" style="display: none;"></span>
    </div>
    
    <div class="dropdown-menu">
        <div class="dropdown-header">
            <div class="user-avatar">
                <i class="fas fa-user-circle"></i>
            </div>
            <div class="user-info">
                <div class="user-name"><%= username %></div>
                <div class="user-role">Book Lover</div>
            </div>
        </div>
        
        <div class="dropdown-divider"></div>
        
        <a href="#wishlist-section" class="dropdown-item wishlist-link">
            <i class="fas fa-heart"></i>
            My Wishlist
            <span class="wishlist-count" id="dropdownWishlistCount">0</span>
        </a>
        
        <a href="orders" class="dropdown-item">
            <i class="fas fa-shopping-bag"></i>
            My Orders
        </a>
        
        <div class="dropdown-divider"></div>
        
        <a href="logout" class="dropdown-item logout-btn">
            <i class="fas fa-sign-out-alt"></i>
            Logout
        </a>
    </div>
</div>
<% } else { %>
    <a href="login" class="btn btn-primary">
        <i class="fas fa-sign-in-alt"></i> Login
    </a>
<% } %>
                </div>
            </div>
        </div>
    </header>

    <!-- Welcome Banner -->
<!--    <div class="welcome-banner">
        <div class="container">
            <p style="font-size: 1.1rem; font-weight: 500;">
                <i class="fas fa-gem" style="color: var(--secondary);"></i>
                ✨ Premium Book Collection • <%= featuredBooks.size() %> Featured Books • <%= categories.size() %> Genres
                <i class="fas fa-gem" style="color: var(--secondary);"></i>
            </p>
        </div>
    </div>-->

    <!-- User Welcome -->
    <% if (username != null) { %>
    <div class="welcome-banner" style="background: linear-gradient(135deg, var(--secondary), #F39C12); margin-top: 0;">
        <div class="container">
            <p style="font-size: 1.2rem;">
                Welcome back, <strong style="color: var(--dark);"><%= username %></strong>! 
                Your next literary adventure awaits 📚
            </p>
        </div>
    </div>
    <% } %>

    <!-- Epic Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1 class="hero-title">Where Stories Come Alive</h1>
            <p class="hero-subtitle">
                Immerse yourself in worlds of wonder. Discover timeless classics and modern masterpieces 
                in our curated collection of literary treasures.
            </p>
            <div class="hero-buttons">
                <a href="#featured" class="btn btn-primary">
                    <i class="fas fa-gem"></i>
                    Explore Collection
                </a>
                <a href="#genres" class="btn btn-secondary">
                    <i class="fas fa-compass"></i>
                    Begin Journey
                </a>
            </div>
        </div>
    </section>

    <!-- Featured Books Section -->
    <section id="featured" class="section">
        <div class="container">
            <h2 class="section-title">Curated Masterpieces</h2>
            <p class="section-subtitle">
                Handpicked literary gems that promise to captivate, inspire, and transport you to extraordinary worlds
            </p>
            
            <div class="books-grid">
                <% for(Book book : featuredBooks) { %>
                <div class="book-card">
                    <div class="book-image-container">
                        <img src="<%= book.getImageUrl() %>" alt="<%= book.getTitle() %>" class="book-image">
                        <div class="book-overlay">
                            <div class="quick-actions">
                                <a href="book-detail?id=<%= book.getBookId() %>" class="quick-btn">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <form action="add-to-cart" method="post" style="display: inline;">
                                    <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="quick-btn" style="border: none; background: none; cursor: pointer;">
                                        <i class="fas fa-cart-plus"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <div class="book-content">
                        <h3 class="book-title"><%= book.getTitle() %></h3>
                        <p class="book-author">by <%= book.getAuthor() %></p>
                        
                        <div class="book-meta">
                            <div class="book-price">₹<%= String.format("%.2f", book.getPrice()) %></div>
                            <span class="book-category"><%= book.getCategory() %></span>
                        </div>
                        
                        <div class="book-actions">
    <div style="flex: 1;">
        <div class="quantity-controls" style="margin-bottom: 8px;">
            <button type="button" class="quantity-btn quantity-down" 
                    onclick="updateQuantity(this, -1)">-</button>
            <input type="number" name="quantity" value="1" min="1" max="10" 
                   class="quantity-input" id="quantity-<%= book.getBookId() %>" readonly>
            <button type="button" class="quantity-btn quantity-up"
                    onclick="updateQuantity(this, 1)">+</button>
        </div>
        <form action="add-to-cart" method="post" style="display: block;">
            <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
            <input type="hidden" name="quantity" value="1" id="hidden-quantity-<%= book.getBookId() %>">
            <button type="submit" class="action-btn btn-cart" style="width: 100%;">
                <i class="fas fa-cart-plus"></i> Add to Cart
            </button>
        </form>
    </div>
    
    <button class="action-btn btn-wishlist wishlist-btn" 
            data-book-id="<%= book.getBookId() %>"
            data-book-title="<%= book.getTitle().replace("\"", "&quot;") %>"
            data-book-author="<%= book.getAuthor().replace("\"", "&quot;") %>"
            data-book-price="<%= book.getPrice() %>"
            data-book-image="<%= book.getImageUrl() %>"
            data-book-category="<%= book.getCategory() %>">
        <i class="fas fa-heart wishlist-heart"></i>
    </button>
</div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </section>

    <!-- Categories Section -->
    <!-- Categories Section -->
<!-- Categories Section -->
<section id="genres" class="section" style="background: linear-gradient(135deg, #FDF6E3, #E8D5B5);">
    <div class="container">
        <h2 class="section-title">Literary Worlds</h2>
        <p class="section-subtitle">Journey through diverse genres and discover stories that resonate with your soul</p>
        
        <!-- Enhanced Genre Navigation Grid -->
        <div class="genre-quick-nav" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem; margin-top: 2rem;">
            <% for(Category category : categories) { %>
            <a href="genre?name=<%= java.net.URLEncoder.encode(category.getName(), "UTF-8") %>" class="genre-quick-card" 
               style="background: linear-gradient(145deg, #FFFFFF, #FDF6E3); border-radius: 16px; padding: 2.5rem 1.5rem; text-decoration: none; color: var(--text); text-align: center; transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94); border: 2px solid rgba(212, 175, 55, 0.2); box-shadow: 0 5px 20px rgba(139, 69, 19, 0.1); display: flex; flex-direction: column; align-items: center; justify-content: center;">
                <div class="genre-quick-icon" style="font-size: 2.5rem; color: var(--secondary); margin-bottom: 1rem; transition: all 0.3s ease;">
                    <i class="fas fa-book"></i>
                </div>
                <span style="font-weight: 600; font-size: 1.1rem; color: var(--primary-dark);"><%= category.getName() %></span>
            </a>
            <% } %>
        </div>

        <!-- Additional Popular Genres -->
        <div style="margin-top: 3rem; text-align: center;">
            <h3 style="color: var(--primary-dark); margin-bottom: 1.5rem; font-family: 'Merriweather', serif;">Popular Collections</h3>
            <div style="display: flex; flex-wrap: wrap; gap: 1rem; justify-content: center;">
                <a href="genre?name=Indian Fiction" class="genre-tag" 
                   style="background: linear-gradient(135deg, var(--primary), var(--accent)); color: white; padding: 0.8rem 1.5rem; border-radius: 25px; text-decoration: none; font-weight: 600; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(139, 69, 19, 0.3);">
                    <i class="fas fa-landmark"></i> Indian Fiction
                </a>
                <a href="genre?name=Indian History" class="genre-tag"
                   style="background: linear-gradient(135deg, #10b981, #059669); color: white; padding: 0.8rem 1.5rem; border-radius: 25px; text-decoration: none; font-weight: 600; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);">
                    <i class="fas fa-history"></i> Indian History
                </a>
                <a href="genre?name=Indian Mythology" class="genre-tag"
                   style="background: linear-gradient(135deg, #F59E0B, #D97706); color: white; padding: 0.8rem 1.5rem; border-radius: 25px; text-decoration: none; font-weight: 600; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(245, 158, 11, 0.3);">
                    <i class="fas fa-dragon"></i> Indian Mythology
                </a>
                <a href="genre?name=Hindi Literature" class="genre-tag"
                   style="background: linear-gradient(135deg, #8B5CF6, #7C3AED); color: white; padding: 0.8rem 1.5rem; border-radius: 25px; text-decoration: none; font-weight: 600; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(139, 92, 246, 0.3);">
                    <i class="fas fa-language"></i> Hindi Literature
                </a>
                <a href="genre?name=Indian Biographies" class="genre-tag"
                   style="background: linear-gradient(135deg, #EF4444, #DC2626); color: white; padding: 0.8rem 1.5rem; border-radius: 25px; text-decoration: none; font-weight: 600; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);">
                    <i class="fas fa-user-circle"></i> Indian Biographies
                </a>
            </div>
        </div>
    </div>
</section>


    <!-- New Releases Section -->
    <section id="new-releases" class="section">
        <div class="container">
            <h2 class="section-title">Fresh Chapters</h2>
            <p class="section-subtitle">Be the first to explore the latest literary arrivals and contemporary voices</p>
            
            <div class="books-grid">
                <% for(Book book : newReleases) { %>
                <div class="book-card">
                    <div class="book-image-container">
                        <img src="<%= book.getImageUrl() %>" alt="<%= book.getTitle() %>" class="book-image">
                        <div class="book-overlay">
                            <div class="quick-actions">
                                <a href="book-detail?id=<%= book.getBookId() %>" class="quick-btn">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <form action="add-to-cart" method="post" style="display: inline;">
                                    <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="quick-btn" style="border: none; background: none; cursor: pointer;">
                                        <i class="fas fa-cart-plus"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <div class="book-content">
                        <h3 class="book-title"><%= book.getTitle() %></h3>
                        <p class="book-author">by <%= book.getAuthor() %></p>
                        
                        <div class="book-meta">
                            <div class="book-price">₹<%= String.format("%.2f", book.getPrice()) %></div>
                            <span class="book-category"><%= book.getCategory() %></span>
                        </div>
                        
                        <div class="book-actions">
                            <form action="add-to-cart" method="post" style="flex: 1;">
                                <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="action-btn btn-cart">
                                    <i class="fas fa-cart-plus"></i> Add to Library
                                </button>
                            </form>
                            
                            <a href="book-detail?id=<%= book.getBookId() %>" class="action-btn btn-wishlist">
                                <i class="fas fa-eye"></i> Preview
                            </a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </section>
            
            
    <!-- Wishlist Section - Only show when user is logged in -->
<% if (username != null) { %>
<section id="wishlist-section" class="section" style="background: linear-gradient(135deg, #FFF0F5, #FFE4E1); display: none;">
    <div class="container">
        <h2 class="section-title">My Reading Wishlist</h2>
        <p class="section-subtitle">Books you're excited to read next</p>
        
        <div id="wishlistContainer" class="books-grid">
            <!-- Wishlist items will be loaded here by JavaScript -->
        </div>
    </div>
</section>
<% } %>    

    <!-- Luxury Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>BookHaven</h3>
                    <p>Where every page turns into an adventure. Your sanctuary for literary discovery and timeless stories.</p>
                </div>
                
                <div class="footer-section">
                    <h3>Explore</h3>
                    <ul class="footer-links">
                        <li><a href="#featured">Featured Collection</a></li>
                        <li><a href="#genres">Literary Genres</a></li>
                        <li><a href="#new-releases">New Arrivals</a></li>
                        <li><a href="#featured">Bestsellers</a></li>
                    </ul>
                </div>
                
<!--                <div class="footer-section">
                    <h3>Support</h3>
                    <ul class="footer-links">
                        <li><a href="#">Contact Curator</a></li>
                        <li><a href="#">Reading Guidance</a></li>
                        <li><a href="#">Membership</a></li>
                        <li><a href="#">Literary Events</a></li>
                    </ul>
                </div>-->
                
                <div class="footer-section">
    <h3>Connect</h3>
    <div class="social-links">
        <!-- Email -->
        <a href="mailto:singhdheerajcs242547@gmail.com" class="social-link"><i class="fas fa-envelope"></i></a>
        
        <!-- LinkedIn -->
        <a href="https://www.linkedin.com/in/dheeraj-singh-a25ba532a/" class="social-link" target="_blank"><i class="fab fa-linkedin-in"></i></a>
        
        <!-- GitHub -->
        <a href="https://github.com/dheeraj-coder48" class="social-link" target="_blank"><i class="fab fa-github"></i></a>
        
        <!-- Instagram -->
        <a href="https://www.instagram.com/ughdheeraj" class="social-link" target="_blank"><i class="fab fa-instagram"></i></a>
    </div>
</div>

            </div>
            
            <div class="footer-bottom">
                <p>&copy; 2025 BookHaven Literary Sanctuary. Crafted with passion for bibliophiles worldwide.</p>
            </div>
        </div>
    </footer>
    
    <script src="search.js"></script>
    <script src="wishlist.js"></script>
    <script src="cart-animation.js"></script>
    <script>
function updateQuantity(button, change) {
    const controls = button.closest('.quantity-controls');
    const input = controls.querySelector('.quantity-input');
    const hiddenInput = controls.closest('.book-actions').querySelector('input[type="hidden"][name="quantity"]');
    
    let currentValue = parseInt(input.value);
    let newValue = currentValue + change;
    
    // Ensure value stays within bounds
    if (newValue < 1) newValue = 1;
    if (newValue > 10) newValue = 10;
    
    // Update both visible and hidden inputs
    input.value = newValue;
    if (hiddenInput) {
        hiddenInput.value = newValue;
    }
    
    // Add visual feedback
    button.style.transform = 'scale(0.9)';
    setTimeout(() => {
        button.style.transform = 'scale(1)';
    }, 150);
}
// Add this debug script to check button data
document.addEventListener('DOMContentLoaded', function() {
    console.log('=== WISHLIST BUTTON DEBUG ===');
    
    // Check all wishlist buttons on the page
    const wishlistButtons = document.querySelectorAll('.wishlist-btn');
    console.log('Total wishlist buttons found:', wishlistButtons.length);
    
    wishlistButtons.forEach((button, index) => {
        const data = {
            id: button.getAttribute('data-book-id'),
            title: button.getAttribute('data-book-title'),
            author: button.getAttribute('data-book-author'),
            price: button.getAttribute('data-book-price'),
            category: button.getAttribute('data-book-category'),
            image: button.getAttribute('data-book-image')
        };
        
        console.log(`Button ${index + 1}:`, data);
        
        // Check if any data is missing
        const missingData = Object.entries(data)
            .filter(([key, value]) => !value)
            .map(([key]) => key);
            
        if (missingData.length > 0) {
            console.warn(`Button ${index + 1} missing data:`, missingData);
        }
    });
    
    console.log('=== END DEBUG ===');
});
</script>
    <!-- No JavaScript - Pure Premium Design -->
</body>
</html>