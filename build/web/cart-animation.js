// Cart Animations - Fixed Version
console.log("Cart Animations script loaded!");

class CartAnimations {
    constructor() {
        console.log("CartAnimations constructor called");
        this.init();
    }
    
    init() {
        console.log("Initializing cart animations...");
        this.setupEventListeners();
        this.updateCartPreviewFromServer(); // Load from server session
    }
    
    setupEventListeners() {
        console.log("Setting up event listeners...");
        
        // Intercept Add to Cart form submissions
        document.addEventListener('submit', (e) => {
            console.log("Form submitted:", e.target);
            
            if (e.target.action && e.target.action.includes('add-to-cart')) {
                console.log("Add to Cart form detected!");
                // DON'T prevent default - let the form submit normally
                // The server will handle the cart update and redirect
            }
        });
    }
    
    // NEW METHOD: Load cart data from server session
    updateCartPreviewFromServer() {
        console.log("Loading cart data from server...");
        
        // Make AJAX call to get current cart data from server
        fetch('cart?action=preview')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.text();
            })
            .then(html => {
                // This would parse the cart data from server response
                // For now, we'll rely on the server-side session
                console.log("Cart data loaded from server");
                this.updateCartPreview();
            })
            .catch(error => {
                console.log("Could not load cart from server:", error);
                this.updateCartPreview();
            });
    }
    
    updateCartPreview() {
    console.log("Updating cart preview from actual session data...");
    
    const previewItems = document.getElementById('cartPreviewItems');
    const previewCount = document.getElementById('previewCartCount');
    const previewTotal = document.getElementById('previewCartTotal');
    
    // Get cart data from the page (set by JSP)
    const cartCountElement = document.getElementById('cartCount');
    if (cartCountElement && cartCountElement.textContent !== '0') {
        // Cart has items - show them in preview
        if (previewCount) {
            previewCount.textContent = cartCountElement.textContent + ' items';
        }
        // The actual items are rendered server-side in the JSP
    } else {
        // Cart is empty
        if (previewItems) {
            previewItems.innerHTML = `
                <div class="cart-preview-empty">
                    <i class="fas fa-shopping-cart"></i>
                    <p>Your cart is empty</p>
                </div>
            `;
        }
        if (previewCount) {
            previewCount.textContent = '0 items';
        }
        if (previewTotal) {
            previewTotal.textContent = '₹0.00';
        }
    }
}

// Add this method to sync with server cart data
syncWithServerCart() {
    // This would typically make an AJAX call to get current cart data
    // For now, we'll simulate it
    console.log("Syncing with server cart data...");
    
    // Simulate getting cart data from server
    fetch('cart?action=preview')
        .then(response => response.json())
        .then(cartData => {
            if (cartData && cartData.items) {
                this.cartItems = cartData.items;
                this.cartCount = cartData.totalItems || 0;
                this.updateCartPreview();
                this.updateCartCount(this.cartCount);
                console.log("Synced cart data:", cartData);
            }
        })
        .catch(error => {
            console.log("Could not sync with server, using local data");
            // Fallback to local data
            this.updateCartPreview();
        });
}
loadCartFromSession() {
    console.log("Loading cart from session...");
    
    // Try to get initial count from the page
    const initialCountElement = document.getElementById('cartCount');
    if (initialCountElement && initialCountElement.textContent) {
        this.cartCount = parseInt(initialCountElement.textContent) || 0;
        console.log("Initial cart count from page:", this.cartCount);
    }
    
    // If we have cart items in session, load them
    // This is a simulation - in real app, you'd get this from your backend
    if (this.cartCount > 0) {
        // Simulate some cart items for demo
        this.cartItems = [
            {
                id: '1',
                title: 'Sample Book',
                price: 12.99,
                image: 'https://via.placeholder.com/40x50/8B4513/FFFFFF?text=📚',
                author: 'Sample Author',
                quantity: 1
            }
        ];
        console.log("Loaded demo cart items:", this.cartItems);
    } else {
        this.cartItems = [];
    }
    
    // Update the preview immediately
    this.updateCartPreview();
}

// Add localStorage persistence for cart preview
saveCartToLocal() {
    localStorage.setItem('bookhaven_cart_preview', JSON.stringify({
        items: this.cartItems,
        count: this.cartCount
    }));
}

loadCartFromLocal() {
    try {
        const stored = localStorage.getItem('bookhaven_cart_preview');
        if (stored) {
            const data = JSON.parse(stored);
            this.cartItems = data.items || [];
            this.cartCount = data.count || 0;
            console.log("Loaded cart from localStorage:", data);
        }
    } catch (e) {
        console.error("Error loading cart from localStorage:", e);
    }
}

// Update your methods to save to localStorage:
addToCartItems(bookData, quantity) {
    // ... existing code ...
    this.saveCartToLocal(); // Add this line
}

removeFromCartItems(bookId) {
    // ... existing code ...
    this.saveCartToLocal(); // Add this line
}

// Update init to load from localStorage:
init() {
    console.log("Initializing cart animations...");
    this.loadCartFromLocal(); // Load from localStorage first
    this.loadCartFromSession();
    this.setupEventListeners();
    this.updateCartPreview();
}

// Call this in your init method:
init() {
    console.log("Initializing cart animations...");
    this.loadCartFromSession();
    this.setupEventListeners();
    this.syncWithServerCart(); // Add this line
    this.updateCartPreview();
}
}

// Initialize cart animations when page loads
document.addEventListener('DOMContentLoaded', function() {
    console.log("DOM loaded - initializing CartAnimations");
    window.cartAnimations = new CartAnimations();
    console.log("CartAnimations initialized:", window.cartAnimations);
});