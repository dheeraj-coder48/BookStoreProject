<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.bookhaven.models.CartItem, java.util.List"%>
<%
    List<CartItem> cart = (List<CartItem>) request.getAttribute("cart");
    Double cartTotal = (Double) request.getAttribute("cartTotal");
    Integer itemCount = (Integer) request.getAttribute("itemCount");
    
    if (cart == null) cart = new java.util.ArrayList<>();
    if (cartTotal == null) cartTotal = 0.0;
    if (itemCount == null) itemCount = 0;
    
    System.out.println("cart.jsp: Cart size = " + cart.size());
    System.out.println("cart.jsp: Cart total = " + cartTotal);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - BookHaven</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #f8fafc; color: #333; }
        .container { max-width: 1200px; margin: 0 auto; padding: 0 20px; }
        
        .header { background: white; padding: 1rem 0; border-bottom: 1px solid #e5e7eb; }
        .header-content { display: flex; align-items: center; justify-content: space-between; }
        .logo { display: flex; align-items: center; gap: 10px; text-decoration: none; color: #1f2937; font-weight: 700; font-size: 1.5rem; }
        
        .page-header { margin: 2rem 0; }
        .page-title { font-size: 2.5rem; font-weight: 700; color: #1f2937; }
        
        .cart-layout { display: grid; grid-template-columns: 2fr 1fr; gap: 2rem; }
        
        .cart-items { background: white; border-radius: 12px; padding: 2rem; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .cart-item { display: flex; gap: 1.5rem; padding: 1.5rem 0; border-bottom: 1px solid #e5e7eb; }
        .cart-item:last-child { border-bottom: none; }
        .item-image { width: 100px; height: 140px; object-fit: cover; border-radius: 8px; }
        .item-details { flex: 1; }
        .item-title { font-size: 1.2rem; font-weight: 600; margin-bottom: 0.5rem; color: #1f2937; }
        .item-author { color: #6b7280; margin-bottom: 1rem; }
        .item-price { font-size: 1.3rem; font-weight: 700; color: #10b981; }
        .item-actions { display: flex; gap: 1rem; align-items: center; margin-top: 1rem; }
        .quantity-controls { display: flex; align-items: center; gap: 0.5rem; }
        .quantity-btn { width: 35px; height: 35px; border: 1px solid #d1d5db; background: white; border-radius: 6px; cursor: pointer; }
        .quantity-input { width: 60px; text-align: center; padding: 8px; border: 1px solid #d1d5db; border-radius: 6px; }
        .remove-btn { color: #ef4444; background: none; border: none; cursor: pointer; padding: 8px 12px; border-radius: 6px; }
        .remove-btn:hover { background: #fef2f2; }
        
        .cart-summary { background: white; border-radius: 12px; padding: 2rem; box-shadow: 0 4px 12px rgba(0,0,0,0.1); height: fit-content; }
        .summary-title { font-size: 1.5rem; font-weight: 600; margin-bottom: 1.5rem; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 1rem; padding-bottom: 1rem; border-bottom: 1px solid #e5e7eb; }
        .summary-total { font-size: 1.3rem; font-weight: 700; color: #1f2937; }
        .btn { padding: 12px 24px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s ease; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; width: 100%; justify-content: center; }
        .btn-primary { background: #3b82f6; color: white; }
        .btn-primary:hover { background: #2563eb; }
        .btn-secondary { background: #f3f4f6; color: #374151; margin-top: 1rem; }
        .btn-secondary:hover { background: #e5e7eb; }
        
        .empty-cart { text-align: center; padding: 4rem 2rem; background: white; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .empty-icon { font-size: 4rem; color: #d1d5db; margin-bottom: 1.5rem; }
        .empty-title { font-size: 1.8rem; font-weight: 600; margin-bottom: 1rem; color: #1f2937; }
        .empty-text { color: #6b7280; margin-bottom: 2rem; }
        
        .success-message { background: #d1fae5; color: #065f46; padding: 1rem; border-radius: 8px; margin-bottom: 2rem; border: 1px solid #a7f3d0; }
        .error-message { background: #fee2e2; color: #991b1b; padding: 1rem; border-radius: 8px; margin-bottom: 2rem; border: 1px solid #fecaca; }
    </style>
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="header-content">
                <a href="home" class="logo">
                    <i class="fas fa-book-open" style="color: #3b82f6;"></i>
                    BookHaven
                </a>
                <a href="home" class="btn-secondary" style="width: auto; padding: 8px 16px;">
                    <i class="fas fa-arrow-left"></i> Back to Home
                </a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="page-header">
            <h1 class="page-title">Shopping Cart</h1>
        </div>
        
        <% if (session.getAttribute("success") != null) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i> <%= session.getAttribute("success") %>
            </div>
            <% session.removeAttribute("success"); %>
        <% } %>
        
        <% if (session.getAttribute("error") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i> <%= session.getAttribute("error") %>
            </div>
            <% session.removeAttribute("error"); %>
        <% } %>
        
        <% if (cart.isEmpty()) { %>
            <div class="empty-cart">
                <div class="empty-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <h2 class="empty-title">Your cart is empty</h2>
                <p class="empty-text">Discover amazing books and add them to your cart!</p>
                <a href="home" class="btn btn-primary" style="width: auto; display: inline-flex;">
                    <i class="fas fa-book-open"></i> Continue Shopping
                </a>
            </div>
        <% } else { %>
            <div class="cart-layout">
                <div class="cart-items">
                    <% for (CartItem item : cart) { %>
                    <div class="cart-item">
                        <img src="<%= item.getBook().getImageUrl() %>" 
                             alt="<%= item.getBook().getTitle() %>" 
                             class="item-image">
                        
                        <div class="item-details">
                            <h3 class="item-title"><%= item.getBook().getTitle() %></h3>
                            <p class="item-author">by <%= item.getBook().getAuthor() %></p>
                            <div class="item-price">$<%= String.format("%.2f", item.getBook().getPrice()) %></div>
                            
                            <div class="item-actions">
                                <div class="quantity-controls" style="margin-bottom: 8px;">
    <button type="button" class="quantity-btn quantity-down">-</button>
    <input type="number" name="quantity" value="1" min="1" max="10" 
           class="quantity-input" readonly>
    <button type="button" class="quantity-btn quantity-up">+</button>
</div>
<form action="add-to-cart" method="post" style="display: block;">
    <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
    <input type="hidden" name="quantity" value="1" class="quantity-submit">
    <button type="submit" class="action-btn btn-cart" style="width: 100%;">
        <i class="fas fa-cart-plus"></i> Add to Cart
    </button>
</form>
                            </div>
                        </div>
                        
                        <div style="text-align: right;">
                            <div style="font-size: 1.2rem; font-weight: 600; color: #1f2937;">
                                $<%= String.format("%.2f", item.getTotalPrice()) %>
                            </div>
                            <div style="color: #6b7280; font-size: 0.9rem;">
                                Qty: <%= item.getQuantity() %>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                
                <div class="cart-summary">
                    <h3 class="summary-title">Order Summary</h3>
                    
                    <div class="summary-row">
                        <span>Items (<%= itemCount %>):</span>
                        <span>$<%= String.format("%.2f", cartTotal) %></span>
                    </div>
                    
                    <div class="summary-row">
                        <span>Shipping:</span>
                        <span>$5.00</span>
                    </div>
                    
                    <div class="summary-row" style="border-bottom: none;">
                        <span class="summary-total">Total:</span>
                        <span class="summary-total">$<%= String.format("%.2f", cartTotal + 5.00) %></span>
                    </div>
                    
                    <a href="checkout" class="btn btn-primary">
                        <i class="fas fa-lock"></i> Proceed to Checkout
                    </a>
                    
                    <a href="home" class="btn btn-secondary">
                        <i class="fas fa-shopping-bag"></i> Continue Shopping
                    </a>
                </div>
            </div>
        <% } %>
    </div>

<!--    <script>
        // Debug: Log cart information
        console.log("Cart page loaded");
        console.log("Cart items: <%= cart.size() %>");
        console.log("Cart total: $<%= cartTotal %>");
        
        // Quantity input validation
        document.querySelectorAll('.quantity-input').forEach(input => {
            input.addEventListener('change', function() {
                if (this.value < 1) this.value = 1;
                if (this.value > 10) this.value = 10;
            });
        });
    </script>-->
</body>
</html>