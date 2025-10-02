<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.bookhaven.models.CartItem, java.util.List"%>
<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    Double cartTotal = (Double) request.getAttribute("cartTotal");
    
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cart");
        return;
    }
    if (cartTotal == null) cartTotal = 0.0;
    
    double tax = cartTotal * 0.1;
    double shipping = 5.00;
    double finalTotal = cartTotal + tax + shipping;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - BookHaven</title>
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
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .checkout-header {
            text-align: center;
            margin-bottom: 3rem;
            position: relative;
        }
        
        .checkout-header h1 {
            font-family: 'Merriweather', serif;
            font-size: 3rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 1rem;
        }
        
        .checkout-header p {
            font-size: 1.2rem;
            color: var(--text-light);
        }
        
        .checkout-layout {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 3rem;
            align-items: start;
        }
        
        .checkout-form-section {
            background: linear-gradient(145deg, #FFFFFF, #FDF6E3);
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 20px 60px rgba(139, 69, 19, 0.1);
            border: 1px solid rgba(212, 175, 55, 0.3);
        }
        
        .section-title {
            font-family: 'Merriweather', serif;
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--secondary);
        }
        
        .form-group {
            margin-bottom: 2rem;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            color: var(--primary-dark);
            margin-bottom: 0.8rem;
            font-size: 1rem;
        }
        
        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 1.2rem 1.5rem;
            border: 2px solid rgba(139, 69, 19, 0.2);
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.8);
            font-size: 1rem;
            transition: all 0.3s ease;
            color: var(--text);
            font-family: 'Inter', sans-serif;
        }
        
        .form-textarea {
            resize: vertical;
            min-height: 120px;
        }
        
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
        }
        
        .order-summary-section {
            background: linear-gradient(145deg, #FFFFFF, #FDF6E3);
            border-radius: 20px;
            padding: 2.5rem;
            box-shadow: 0 20px 60px rgba(139, 69, 19, 0.1);
            border: 1px solid rgba(212, 175, 55, 0.3);
            position: sticky;
            top: 2rem;
        }
        
        .order-items {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 2rem;
            padding-right: 1rem;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 0;
            border-bottom: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .order-item-image {
            width: 60px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        
        .order-item-details {
            flex: 1;
        }
        
        .order-item-title {
            font-weight: 600;
            color: var(--primary-dark);
            margin-bottom: 0.3rem;
            font-size: 0.95rem;
        }
        
        .order-item-meta {
            display: flex;
            justify-content: space-between;
            font-size: 0.85rem;
            color: var(--text-light);
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
            padding-top: 1.5rem;
            margin-top: 1rem;
        }
        
        .place-order-btn {
            width: 100%;
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 1.5rem;
            border: none;
            border-radius: 12px;
            font-size: 1.2rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            margin-top: 2rem;
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.4);
            position: relative;
            overflow: hidden;
        }
        
        .place-order-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            transition: left 0.5s ease;
        }
        
        .place-order-btn:hover::before {
            left: 100%;
        }
        
        .place-order-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(16, 185, 129, 0.6);
        }
        
        .security-badges {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .security-badge {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-light);
            font-size: 0.9rem;
        }
        
        .security-badge i {
            color: var(--secondary);
        }
        
        @media (max-width: 968px) {
            .checkout-layout {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
            
            .order-summary-section {
                position: static;
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
            
            .checkout-form-section, .order-summary-section {
                padding: 2rem;
            }
            
            .checkout-header h1 {
                font-size: 2.2rem;
            }
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
        <div class="checkout-header">
            <h1><i class="fas fa-lock"></i> Secure Checkout</h1>
            <p>Complete your purchase with confidence</p>
        </div>
        
        <div class="checkout-layout">
            <div class="checkout-form-section">
                <h2 class="section-title">Shipping & Payment</h2>
                
                <form action="checkout" method="post">
                    <div class="form-group">
                        <label class="form-label" for="shippingAddress">
                            <i class="fas fa-map-marker-alt"></i> Shipping Address
                        </label>
                        <textarea name="shippingAddress" id="shippingAddress" required
                                  class="form-textarea" 
                                  placeholder="Enter your complete shipping address including street, city, state, and zip code"></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="paymentMethod">
                            <i class="fas fa-credit-card"></i> Payment Method
                        </label>
                        <select name="paymentMethod" id="paymentMethod" required
                                class="form-select">
                            <option value="">Select payment method</option>
                            <option value="Credit Card">💳 Credit Card</option>
                            <option value="Debit Card">💳 Debit Card</option>
                            <option value="PayPal">💰 PayPal</option>
                            <option value="Cash on Delivery">💵 Cash on Delivery</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="place-order-btn">
                        <i class="fas fa-shopping-bag"></i> Place Your Order
                    </button>
                </form>
                
                <div class="security-badges">
                    <div class="security-badge">
                        <i class="fas fa-shield-alt"></i>
                        <span>SSL Secure</span>
                    </div>
                    <div class="security-badge">
                        <i class="fas fa-lock"></i>
                        <span>Encrypted</span>
                    </div>
                    <div class="security-badge">
                        <i class="fas fa-user-shield"></i>
                        <span>Privacy Protected</span>
                    </div>
                </div>
            </div>
            
            <div class="order-summary-section">
                <h3 class="section-title">Order Summary</h3>
                
                <div class="order-items">
                    <% for (CartItem item : cart) { %>
                    <div class="order-item">
                        <img src="<%= item.getBook().getImageUrl() %>" 
                             alt="<%= item.getBook().getTitle() %>" 
                             class="order-item-image"
                             onerror="this.src='https://via.placeholder.com/60x80/8B4513/FFFFFF?text=📚'">
                        <div class="order-item-details">
                            <div class="order-item-title"><%= item.getBook().getTitle() %></div>
                            <div class="order-item-meta">
                                <span>Qty: <%= item.getQuantity() %></span>
                                <span>₹<%= String.format("%.2f", item.getTotalPrice()) %></span>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                
                <div class="summary-row">
                    <span class="summary-label">Subtotal</span>
                    <span class="summary-value">₹<%= String.format("%.2f", cartTotal) %></span>
                </div>
                
                <div class="summary-row">
                    <span class="summary-label">Shipping</span>
                    <span class="summary-value">₹<%= String.format("%.2f", shipping) %></span>
                </div>
                
                <div class="summary-row">
                    <span class="summary-label">Tax</span>
                    <span class="summary-value">₹<%= String.format("%.2f", tax) %></span>
                </div>
                
                <div class="summary-row summary-total">
                    <span>Total Amount</span>
                    <span>₹<%= String.format("%.2f", finalTotal) %></span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>