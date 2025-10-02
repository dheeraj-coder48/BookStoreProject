<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.bookhaven.models.Order, com.bookhaven.models.OrderItem, java.util.List"%>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    Boolean isAdmin = (Boolean) request.getAttribute("isAdmin");
    
    System.out.println("=== ORDERS JSP START ===");
    System.out.println("Orders from request: " + (orders != null ? orders.size() : "NULL"));
    System.out.println("isAdmin from request: " + isAdmin);
    
    if (orders == null) {
        System.out.println("Orders is null - creating empty list");
        orders = new java.util.ArrayList<>();
    }
    
    String orderSuccess = (String) session.getAttribute("orderSuccess");
    if (orderSuccess != null) {
        System.out.println("Order success message: " + orderSuccess);
        session.removeAttribute("orderSuccess");
    }
    
    // If isAdmin is still null, check session
    if (isAdmin == null) {
        String role = (String) session.getAttribute("role");
        isAdmin = "admin".equals(role);
        System.out.println("isAdmin from session role: " + isAdmin);
    }
    
    System.out.println("=== ORDERS JSP END ===");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isAdmin ? "All Orders" : "My Orders" %> - BookHaven</title>
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
            padding: 20px;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        
        .header {
            text-align: center;
            margin-bottom: 3rem;
            padding-top: 2rem;
        }
        
        .header h1 {
            font-family: 'Merriweather', serif;
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 1rem;
        }
        
        .back-home {
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            padding: 1rem 1.8rem;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            border: 2px solid rgba(212, 175, 55, 0.3);
            transition: all 0.3s ease;
            margin-bottom: 2rem;
        }
        
        .back-home:hover {
            background: white;
            transform: translateX(-5px);
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(139, 69, 19, 0.1);
        }
        
        .empty-state i {
            font-size: 4rem;
            color: var(--secondary);
            margin-bottom: 1.5rem;
            opacity: 0.7;
        }
        
        .empty-state h2 {
            font-family: 'Merriweather', serif;
            font-size: 2rem;
            color: var(--primary-dark);
            margin-bottom: 1rem;
        }
        
        .btn {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        .order-card {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 5px 15px rgba(139, 69, 19, 0.1);
            border-left: 4px solid var(--secondary);
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .order-id {
            font-family: 'Merriweather', serif;
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--primary-dark);
        }
        
        .order-total {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--primary);
        }
        
        .order-status {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .status-pending { background: #fef3c7; color: #92400e; }
        .status-confirmed { background: #dbeafe; color: #1e40af; }
        .status-shipped { background: #f0f9ff; color: #0c4a6e; }
        .status-delivered { background: #d1fae5; color: #065f46; }
        
        .order-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 0;
            border-bottom: 1px solid rgba(139, 69, 19, 0.05);
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .item-image {
            width: 60px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
        }
        
        .item-details {
            flex: 1;
        }
        
        .item-title {
            font-weight: 600;
            color: var(--primary-dark);
            margin-bottom: 0.3rem;
        }
        
        .item-author {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }
        
        .item-meta {
            display: flex;
            gap: 1rem;
            font-size: 0.85rem;
            color: var(--text-light);
        }
        
        .no-items {
            text-align: center;
            padding: 2rem;
            color: var(--text-light);
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="home" class="back-home">
            <i class="fas fa-arrow-left"></i>
            <span>Back to Home</span>
        </a>

        <div class="header">
            <h1>
                <i class="fas fa-shopping-bag"></i>
                <%= isAdmin ? "All Orders" : "My Orders" %>
            </h1>
            <p style="color: var(--text-light);">
                <%= isAdmin ? "Manage all customer orders" : "Track your order history" %>
            </p>
        </div>
        
        <% if (orderSuccess != null) { %>
            <div style="background: #d1fae5; color: #065f46; padding: 1rem; border-radius: 8px; margin-bottom: 2rem; border-left: 4px solid #10b981;">
                <i class="fas fa-check-circle"></i> <%= orderSuccess %>
            </div>
        <% } %>
        
        <% if (orders.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-box-open"></i>
                <h2>No Orders Found</h2>
                <p style="color: var(--text-light); margin-bottom: 2rem;">
                    <%= isAdmin ? "No orders have been placed yet." : "You haven't placed any orders yet." %>
                </p>
                <a href="home" class="btn">
                    <i class="fas fa-book-open"></i> 
                    <%= isAdmin ? "View Store" : "Start Shopping" %>
                </a>
            </div>
        <% } else { %>
            <div>
                <% for (Order order : orders) { %>
                <div class="order-card">
                    <div class="order-header">
                        <div>
                            <div class="order-id">Order #<%= order.getOrderId() %></div>
                            <div style="color: var(--text-light); font-size: 0.9rem; margin-top: 0.5rem;">
                                Placed on <%= order.getOrderDate() %>
                                <% if (isAdmin && order.getUsername() != null) { %>
                                    • Customer: <%= order.getUsername() %>
                                <% } %>
                            </div>
                        </div>
                        <div style="text-align: right;">
                            <div class="order-total">₹<%= String.format("%.2f", order.getTotalAmount()) %></div>
                            <div class="order-status status-<%= order.getStatus() %>">
                                <%= order.getStatus().toUpperCase() %>
                            </div>
                        </div>
                    </div>
                    
                    <div>
                        <% 
                            // SAFE CHECK: Handle null order items
                            List<OrderItem> orderItems = order.getOrderItems();
                            if (orderItems != null && !orderItems.isEmpty()) {
                                for (OrderItem item : orderItems) { 
                        %>
                        <div class="order-item">
                            <img src="<%= item.getBook().getImageUrl() != null ? item.getBook().getImageUrl() : "https://via.placeholder.com/60x80/8B4513/FFFFFF?text=📚" %>" 
                                 alt="<%= item.getBook().getTitle() != null ? item.getBook().getTitle() : "Unknown Book" %>" 
                                 class="item-image">
                            <div class="item-details">
                                <div class="item-title"><%= item.getBook().getTitle() != null ? item.getBook().getTitle() : "Unknown Book" %></div>
                                <div class="item-author">by <%= item.getBook().getAuthor() != null ? item.getBook().getAuthor() : "Unknown Author" %></div>
                                <div class="item-meta">
                                    <span>Qty: <%= item.getQuantity() %></span>
                                    <span>Price: $<%= String.format("%.2f", item.getPrice()) %></span>
                                    <span>Total: $<%= String.format("%.2f", item.getTotalPrice()) %></span>
                                </div>
                            </div>
                        </div>
                        <% 
                                } 
                            } else { 
                        %>
                            <div class="no-items">
                                <i class="fas fa-exclamation-circle"></i>
                                No items found for this order
                            </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>