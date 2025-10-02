<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.bookhaven.models.CartItem, java.util.List"%>
<%
    List<CartItem> cart = (List<CartItem>) request.getAttribute("cart");
    Double cartTotal = (Double) request.getAttribute("cartTotal");
    Integer itemCount = (Integer) request.getAttribute("itemCount");
    
    if (cart == null) cart = new java.util.ArrayList<>();
    if (cartTotal == null) cartTotal = 0.0;
    if (itemCount == null) itemCount = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart - BookHaven</title>
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
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .header {
            text-align: center;
            margin-bottom: 3rem;
            position: relative;
        }
        
        .header h1 {
            font-family: 'Merriweather', serif;
            font-size: 3rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 0.5rem;
            text-shadow: 2px 2px 4px rgba(139, 69, 19, 0.1);
        }
        
        .header p {
            font-size: 1.2rem;
            color: var(--text-light);
            font-weight: 300;
        }
        
        .success-message {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 1.2rem 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.3);
            border-left: 4px solid white;
        }
        
        .success-message i {
            font-size: 1.5rem;
        }
        
        .empty-cart {
            text-align: center;
            padding: 4rem 2rem;
            background: linear-gradient(145deg, #FFFFFF, #FDF6E3);
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(139, 69, 19, 0.1);
            border: 2px solid rgba(212, 175, 55, 0.2);
        }
        
        .empty-cart-icon {
            font-size: 4rem;
            color: var(--secondary);
            margin-bottom: 1.5rem;
            opacity: 0.7;
        }
        
        .empty-cart h3 {
            font-family: 'Merriweather', serif;
            font-size: 2rem;
            color: var(--primary-dark);
            margin-bottom: 1rem;
        }
        
        .empty-cart p {
            color: var(--text-light);
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139, 69, 19, 0.4);
        }
        
        .cart-layout {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 2.5rem;
            align-items: start;
        }
        
        .cart-items {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 10px 40px rgba(139, 69, 19, 0.1);
            border: 1px solid rgba(212, 175, 55, 0.2);
        }
        
        .cart-item {
            display: grid;
            grid-template-columns: 100px 1fr auto;
            gap: 1.5rem;
            padding: 1.5rem;
            border-bottom: 1px solid rgba(139, 69, 19, 0.1);
            transition: all 0.3s ease;
            border-radius: 12px;
            margin-bottom: 1rem;
        }
        
        .cart-item:hover {
            background: linear-gradient(145deg, #FFFFFF, #FDF6E3);
            box-shadow: 0 8px 25px rgba(139, 69, 19, 0.1);
            transform: translateY(-2px);
        }
        
        .cart-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        
        .cart-item-image {
            width: 100px;
            height: 140px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        
        .cart-item-details {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .cart-item-title {
            font-family: 'Merriweather', serif;
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }
        
        .cart-item-author {
            color: var(--text-light);
            font-size: 1rem;
            margin-bottom: 1rem;
            font-style: italic;
        }
        
        .cart-item-price {
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--primary);
            margin-bottom: 1rem;
        }
        
        .quantity-controls {
    display: flex;
    align-items: center;
    justify-content: flex-start;
    gap: 0.5rem;
    background: rgba(139, 69, 19, 0.05);
    border-radius: 8px;
    padding: 0.5rem 1rem;
}
        
        .quantity-btn {
            width: 32px;
            height: 32px;
            border: none;
            background: var(--primary);
            color: white;
            border-radius: 6px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .quantity-btn:hover {
            background: var(--primary-dark);
            transform: scale(1.1);
        }
        
        .quantity-input {
    width: 45px;
    text-align: center;
    border: none;
    background: transparent;
    font-weight: 600;
    color: var(--primary-dark);
    font-size: 1rem;
}
        
        .remove-btn {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.3);
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .remove-btn:hover {
            background: rgba(239, 68, 68, 0.2);
            transform: translateY(-1px);
        }
        
        .cart-item-total {
            text-align: right;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: flex-end;
        }
        
        .item-total {
    margin-left: auto;  /* pushes total to the right */
    font-weight: 600;
    color: #8B4513;
    font-size: 1rem;
}
        
        .item-total-price {
            font-size: 1.6rem;
            font-weight: 800;
            color: var(--primary);
        }
        
        .order-summary {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 10px 40px rgba(139, 69, 19, 0.1);
            border: 1px solid rgba(212, 175, 55, 0.2);
            position: sticky;
            top: 2rem;
        }
        
        .summary-title {
            font-family: 'Merriweather', serif;
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--secondary);
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .summary-row:last-child {
            border-bottom: none;
        }
        
        .summary-label {
            color: var(--text-light);
            font-size: 1rem;
        }
        
        .summary-value {
            font-weight: 600;
            color: var(--primary-dark);
            font-size: 1rem;
        }
        
        .summary-total {
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--primary);
            border-top: 2px solid var(--primary);
            padding-top: 1rem;
        }
        
        .checkout-btn {
            width: 100%;
            background: linear-gradient(135deg, var(--secondary), #F39C12);
            color: var(--dark);
            padding: 15px;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 1.5rem;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.4);
        }
        
        .checkout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(212, 175, 55, 0.6);
        }
        
        .continue-shopping {
            width: 100%;
            background: rgba(139, 69, 19, 0.1);
            color: var(--primary);
            padding: 12px;
            border: 2px solid rgba(139, 69, 19, 0.3);
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            text-align: center;
            display: block;
            margin-top: 1rem;
            transition: all 0.3s ease;
        }
        
        .continue-shopping:hover {
            background: rgba(139, 69, 19, 0.2);
            transform: translateY(-1px);
        }
        
        @media (max-width: 968px) {
            .cart-layout {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
            
            .order-summary {
                position: static;
            }
            
            .cart-item {
                grid-template-columns: 80px 1fr;
                gap: 1rem;
            }
            
            .cart-item-total {
                grid-column: 1 / -1;
                flex-direction: row;
                justify-content: space-between;
                align-items: center;
                margin-top: 1rem;
                padding-top: 1rem;
                border-top: 1px solid rgba(139, 69, 19, 0.1);
            }
        }
        .quantity-controls-container {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 1rem;
    background: rgba(139, 69, 19, 0.05);
    border-radius: 8px;
    padding: 0.8rem 1.2rem;
}

.quantity-controls {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.quantity-btn {
    width: 32px;
    height: 32px;
    border: none;
    background: var(--primary);
    color: white;
    border-radius: 6px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    transition: all 0.3s ease;
}

.quantity-btn:hover {
    background: var(--primary-dark);
    transform: scale(1.1);
}

.quantity-input {
    width: 50px;
    text-align: center;
    border: none;
    background: transparent;
    font-weight: 600;
    color: var(--primary-dark);
    font-size: 1rem;
}

.item-total {
    font-size: 1.4rem;
    font-weight: 800;
    color: var(--primary);
    white-space: nowrap;
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
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-shopping-cart"></i> Shopping Cart</h1>
            <p>Review your items and proceed to checkout</p>
        </div>
        
        <% if (session.getAttribute("success") != null) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                <div>
                    <strong>Success!</strong> <%= session.getAttribute("success") %>
                </div>
            </div>
            <% session.removeAttribute("success"); %>
        <% } %>
        
        <% if (cart.isEmpty()) { %>
            <div class="empty-cart">
                <div class="empty-cart-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <h3>Your Cart is Empty</h3>
                <p>Discover amazing books and start building your reading collection</p>
                <a href="home" class="btn-primary">
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
         class="cart-item-image"
         onerror="this.src='https://via.placeholder.com/100x140/8B4513/FFFFFF?text=📚'">
    
    <div class="cart-item-details">
        <div>
            <h3 class="cart-item-title"><%= item.getBook().getTitle() %></h3>
            <p class="cart-item-author">by <%= item.getBook().getAuthor() %></p>
            <div class="cart-item-price">₹<%= String.format("%.2f", item.getBook().getPrice()) %> each</div>
        </div>
        
        <!-- Updated Quantity Controls with Price Calculation -->
        <div class="quantity-controls">
            <form action="update-cart" method="post" class="quantity-form">
                <input type="hidden" name="bookId" value="<%= item.getBook().getBookId() %>">
                <input type="hidden" name="action" value="update">
                
                <button type="button" class="quantity-btn quantity-down" 
                        onclick="updateQuantity(this, -1, <%= item.getBook().getPrice() %>)">-</button>
                
                <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" max="10" 
                       class="quantity-input" 
                       onchange="updateTotalPrice(this, <%= item.getBook().getPrice() %>)"
                       readonly>
                
                <button type="button" class="quantity-btn quantity-up"
                        onclick="updateQuantity(this, 1, <%= item.getBook().getPrice() %>)">+</button>
                
                <!-- Real-time price display -->
                <div class="item-total" style="margin-left: 15px; font-weight: 600; color: #8B4513;">
                    Total: ₹<span id="total-<%= item.getBook().getBookId() %>">
                        <%= String.format("%.2f", item.getTotalPrice()) %>
                    </span>
                </div>
            </form>
        </div>
        
        <form action="update-cart" method="post" style="display: inline;">
            <input type="hidden" name="bookId" value="<%= item.getBook().getBookId() %>">
            <input type="hidden" name="action" value="remove">
            <button type="submit" class="remove-btn">
                <i class="fas fa-trash"></i> Remove
            </button>
        </form>
    </div>
</div>
<% } %>
                </div>
                
                <div class="order-summary">
                    <h3 class="summary-title">Order Summary</h3>
                    
                    <div class="summary-row">
                        <span class="summary-label">Items (<%= itemCount %>)</span>
                        <span class="summary-value">₹<%= String.format("%.2f", cartTotal) %></span>
                    </div>
                    
                    <div class="summary-row">
                        <span class="summary-label">Shipping</span>
                        <span class="summary-value">₹5.00</span>
                    </div>
                    
                    <div class="summary-row">
                        <span class="summary-label">Tax</span>
                        <span class="summary-value">₹<%= String.format("%.2f", cartTotal * 0.1) %></span>
                    </div>
                    
                    <div class="summary-row summary-total">
                        <span>Total Amount</span>
                        <span>₹<%= String.format("%.2f", cartTotal + 5.00 + (cartTotal * 0.1)) %></span>
                    </div>
                    
                    <a href="checkout" class="checkout-btn">
                        <i class="fas fa-lock"></i> Proceed to Checkout
                    </a>
                    
                    <a href="home" class="continue-shopping">
                        <i class="fas fa-shopping-bag"></i> Continue Shopping
                    </a>
                </div>
            </div>
        <% } %>
    </div>
    
    <script>
// Update quantity and price in real-time
function updateQuantity(button, change, unitPrice) {
    const form = button.closest('.quantity-form');
    const input = form.querySelector('.quantity-input');
    const totalSpan = form.querySelector('.item-total span');
    
    let currentValue = parseInt(input.value);
    let newValue = currentValue + change;
    
    // Ensure value stays within bounds
    if (newValue < 1) newValue = 1;
    if (newValue > 10) newValue = 10;
    
    // Update input value
    input.value = newValue;
    
    // Calculate and update total price
    const totalPrice = (unitPrice * newValue).toFixed(2);
    totalSpan.textContent = totalPrice;
    
    // Submit form automatically
    setTimeout(() => {
        form.submit();
    }, 500);
    
    // Add visual feedback
    button.style.transform = 'scale(0.9)';
    setTimeout(() => {
        button.style.transform = 'scale(1)';
    }, 150);
}

// Update total price when quantity changes manually
function updateTotalPrice(input, unitPrice) {
    const form = input.closest('.quantity-form');
    const totalSpan = form.querySelector('.item-total span');
    const quantity = parseInt(input.value);
    
    if (quantity >= 1 && quantity <= 10) {
        const totalPrice = (unitPrice * quantity).toFixed(2);
        totalSpan.textContent = totalPrice;
        form.submit();
    }
}
</script>
</body>
</html>