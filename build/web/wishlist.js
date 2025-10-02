// Enhanced Wishlist functionality
class WishlistManager {
    constructor() {
        this.wishlistKey = 'bookhaven_wishlist';
        this.wishlist = this.loadWishlist();
        this.init();
    }
    
    init() {
        console.log('WishlistManager initialized');
        this.setupEventListeners();
        this.updateWishlistDisplay();
        this.updateWishlistBadge();
        this.updateHeartIcons();
    }
    
    setupEventListeners() {
        // Handle wishlist button clicks - BETTER EVENT DELEGATION
        document.addEventListener('click', (e) => {
            const wishlistBtn = e.target.closest('.wishlist-btn');
            if (wishlistBtn) {
                e.preventDefault();
                e.stopPropagation();
                this.handleWishlistClick(wishlistBtn);
            }
        });
        
        // Wishlist link in dropdown
        document.addEventListener('click', (e) => {
            if (e.target.closest('.wishlist-link')) {
                e.preventDefault();
                this.showWishlistSection();
            }
        });
    }
    
    handleWishlistClick(button) {
    console.log('Wishlist button clicked');
    
    // CHECK IF USER IS LOGGED IN
    const isLoggedIn = document.body.getAttribute('data-user-loggedin') === 'true';
    
    if (!isLoggedIn) {
        this.showNotification('Please login to use wishlist! 🔐', 'warning');
        // Redirect to login page after 2 seconds
        setTimeout(() => {
            window.location.href = 'login?redirect=' + encodeURIComponent(window.location.href);
        }, 2000);
        return;
    }
    
    // FIX: Get all data attributes with proper fallbacks
    const bookId = button.getAttribute('data-book-id');
    const bookTitle = button.getAttribute('data-book-title') || 'Unknown Title';
    const bookAuthor = button.getAttribute('data-book-author') || 'Unknown Author';
    const bookPrice = button.getAttribute('data-book-price') || '0';
    const bookImage = button.getAttribute('data-book-image') || 'https://via.placeholder.com/300x400/8B4513/FFFFFF?text=📚';
    const bookCategory = button.getAttribute('data-book-category') || 'Unknown Category';
    
    console.log('Book data from attributes:', { 
        bookId, 
        bookTitle, 
        bookAuthor, 
        bookPrice, 
        bookImage, 
        bookCategory 
    });
    
    // Validate required data
    if (!bookId) {
        console.error('Missing book ID');
        this.showNotification('Error: Missing book information', 'warning');
        return;
    }
    
    // FIX: Parse price safely
    const price = parseFloat(bookPrice);
    if (isNaN(price)) {
        console.warn('Invalid price detected, using 0 as default');
    }
    
    const bookData = {
        id: bookId,
        title: bookTitle,
        author: bookAuthor,
        price: isNaN(price) ? 0 : price,
        image: bookImage,
        category: bookCategory
    };
    
    console.log('Processed book data for storage:', bookData);
    
    if (this.isInWishlist(bookId)) {
        this.removeFromWishlist(bookId);
        this.showNotification(`"${bookTitle}" removed from wishlist`, 'info');
    } else {
        this.addToWishlist(bookData);
        this.showNotification(`"${bookTitle}" added to wishlist! ❤️`, 'success');
    }
    
    this.updateWishlistDisplay();
    this.updateWishlistBadge();
    this.updateHeartIcons();
    
    // Debug: Check what's actually stored
    this.debugWishlist();
}
    
    addToWishlist(bookData) {
        // Check if already exists
        if (!this.isInWishlist(bookData.id)) {
            this.wishlist.push(bookData);
            this.saveWishlist();
            console.log('Added to wishlist:', bookData);
        }
    }
    
    removeFromWishlist(bookId) {
        const initialLength = this.wishlist.length;
        this.wishlist = this.wishlist.filter(book => book.id !== bookId);
        if (this.wishlist.length !== initialLength) {
            this.saveWishlist();
            console.log('Removed from wishlist:', bookId);
        }
    }
    
    isInWishlist(bookId) {
        return this.wishlist.some(book => book.id === bookId);
    }
    
    loadWishlist() {
        try {
            const stored = localStorage.getItem(this.wishlistKey);
            const wishlist = stored ? JSON.parse(stored) : [];
            console.log('Loaded wishlist:', wishlist);
            return wishlist;
        } catch (e) {
            console.error('Error loading wishlist:', e);
            return [];
        }
    }
    
    saveWishlist() {
        try {
            localStorage.setItem(this.wishlistKey, JSON.stringify(this.wishlist));
            console.log('Saved wishlist:', this.wishlist);
        } catch (e) {
            console.error('Error saving wishlist:', e);
        }
    }
    
    updateWishlistDisplay() {
    const container = document.getElementById('wishlistContainer');
    if (!container) {
        console.log('Wishlist container not found');
        return;
    }
    
    console.log('Updating wishlist display with', this.wishlist.length, 'items');
    
    if (this.wishlist.length === 0) {
        container.innerHTML = `
            <div class="wishlist-empty" style="grid-column: 1 / -1;">
                <div class="wishlist-empty-icon">
                    <i class="fas fa-heart"></i>
                </div>
                <h3 style="color: #8B4513; margin-bottom: 1rem;">Your wishlist is empty</h3>
                <p style="color: #8D6E63; margin-bottom: 2rem;">
                    Start building your reading collection by clicking the heart icon on any book!
                </p>
                <div style="font-size: 3rem; opacity: 0.3; margin-top: 2rem;">
                    ❤️
                </div>
            </div>
        `;
    } else {
        container.innerHTML = this.wishlist.map(book => {
            // FIX: Safely handle price - ensure it's a number and has a default value
            const price = typeof book.price === 'number' ? book.price : 0;
            const formattedPrice = price.toFixed(2);
            
            // FIX: Safely handle other properties with defaults
            const title = book.title || 'Unknown Title';
            const author = book.author || 'Unknown Author';
            const image = book.image || 'https://via.placeholder.com/300x400/8B4513/FFFFFF?text=📚';
            const category = book.category || 'Unknown Category';
            const id = book.id || '';
            
            return `
                <div class="book-card">
                    <div class="book-image-container">
                        <img src="${image}" alt="${title}" class="book-image"
                             onerror="this.src='https://via.placeholder.com/300x400/8B4513/FFFFFF?text=📚'">
                        <div class="book-overlay">
                            <div class="quick-actions">
                                <a href="book-detail?id=${id}" class="quick-btn">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <button class="quick-btn remove-wishlist" data-book-id="${id}">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="book-content">
                        <h3 class="book-title">${title}</h3>
                        <p class="book-author">by ${author}</p>
                        
                        <div class="book-meta">
                            <div class="book-price">₹${formattedPrice}</div>
                            <span class="book-category">${category}</span>
                        </div>
                        
                        <div class="book-actions">
                            <form action="add-to-cart" method="post" style="flex: 1;">
                                <input type="hidden" name="bookId" value="${id}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="action-btn btn-cart">
                                    <i class="fas fa-cart-plus"></i> Add to Cart
                                </button>
                            </form>
                            
                            <button class="action-btn btn-wishlist wishlist-btn active" 
                                    data-book-id="${id}"
                                    data-book-title="${title.replace(/"/g, '&quot;')}"
                                    data-book-author="${author.replace(/"/g, '&quot;')}"
                                    data-book-price="${price}"
                                    data-book-image="${image}"
                                    data-book-category="${category}">
                                <i class="fas fa-heart wishlist-heart active"></i> Saved
                            </button>
                        </div>
                    </div>
                </div>
            `;
        }).join('');
        
        // Add event listeners to remove buttons
        container.querySelectorAll('.remove-wishlist').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const bookId = btn.getAttribute('data-book-id');
                const bookTitle = this.wishlist.find(b => b.id === bookId)?.title || 'Book';
                this.removeFromWishlist(bookId);
                this.showNotification(`"${bookTitle}" removed from wishlist`, 'warning');
                this.updateWishlistDisplay();
                this.updateWishlistBadge();
                this.updateHeartIcons();
            });
        });
    }
}
    
    updateHeartIcons() {
        const wishlistButtons = document.querySelectorAll('.wishlist-btn');
        console.log('Updating', wishlistButtons.length, 'heart icons');
        
        wishlistButtons.forEach(btn => {
            const bookId = btn.getAttribute('data-book-id');
            const heartIcon = btn.querySelector('.wishlist-heart');
            const textSpan = btn.querySelector('.wishlist-text');
            
            if (this.isInWishlist(bookId)) {
                heartIcon.classList.add('active');
                // Update button text
                if (textSpan) {
                    textSpan.textContent = ' Saved';
                } else {
                    const newText = document.createElement('span');
                    newText.className = 'wishlist-text';
                    newText.textContent = ' Saved';
                    btn.appendChild(newText);
                }
            } else {
                heartIcon.classList.remove('active');
                // Update button text
                if (textSpan) {
                    textSpan.textContent = ' Wishlist';
                } else {
                    const newText = document.createElement('span');
                    newText.className = 'wishlist-text';
                    newText.textContent = ' Wishlist';
                    btn.appendChild(newText);
                }
            }
        });
    }
    
    showWishlistSection() {
        const wishlistSection = document.getElementById('wishlist-section');
        if (wishlistSection) {
            wishlistSection.style.display = 'block';
            wishlistSection.classList.remove('hidden');
            wishlistSection.classList.add('visible');
            
            // Update display first
            this.updateWishlistDisplay();
            
            // Smooth scroll to wishlist section
            setTimeout(() => {
                wishlistSection.scrollIntoView({ 
                    behavior: 'smooth',
                    block: 'start'
                });
            }, 100);
        }
    }
    
    updateWishlistBadge() {
        const dropdownCount = document.getElementById('dropdownWishlistCount');
        const countBadge = document.getElementById('wishlistCountBadge');
        const count = this.wishlist.length;
        
        console.log('Updating wishlist badge:', count, 'items');
        
        if (dropdownCount) {
            dropdownCount.textContent = count;
            dropdownCount.style.display = count > 0 ? 'inline-block' : 'none';
        }
        
        if (countBadge) {
            if (count > 0) {
                countBadge.textContent = count;
                countBadge.style.display = 'flex';
            } else {
                countBadge.style.display = 'none';
            }
        }
    }
    
    showNotification(message, type = 'success') {
        // Remove existing notifications
        document.querySelectorAll('.notification').forEach(n => n.remove());
        
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.innerHTML = `
            <i class="fas fa-${this.getNotificationIcon(type)}"></i>
            <span>${message}</span>
        `;
        
        document.body.appendChild(notification);
        
        // Animate in
        setTimeout(() => notification.classList.add('show'), 100);
        
        // Remove after delay
        setTimeout(() => {
            notification.classList.remove('show');
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.remove();
                }
            }, 400);
        }, 3000);
    }
    
    getNotificationIcon(type) {
        const icons = {
            success: 'heart',
            warning: 'exclamation-triangle',
            info: 'info-circle'
        };
        return icons[type] || 'info-circle';
    }
    // Add this method to debug the stored data
debugWishlist() {
    console.log('=== CURRENT WISHLIST STORAGE ===');
    console.log('Total items:', this.wishlist.length);
    
    this.wishlist.forEach((book, index) => {
        console.log(`Item ${index + 1}:`, {
            id: book.id,
            title: book.title,
            author: book.author,
            price: book.price,
            category: book.category,
            hasAuthor: !!book.author,
            hasPrice: typeof book.price === 'number',
            hasCategory: !!book.category
        });
    });
    
    // Also check localStorage directly
    const rawStorage = localStorage.getItem(this.wishlistKey);
    console.log('Raw localStorage data:', rawStorage);
    console.log('=== END DEBUG ===');
}


}

// Initialize wishlist when page loads
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded - initializing WishlistManager');
    window.wishlistManager = new WishlistManager();
});
// Temporary debug - add this to check button data
document.addEventListener('DOMContentLoaded', function() {
    const buttons = document.querySelectorAll('.wishlist-btn');
    console.log('Found', buttons.length, 'wishlist buttons');
    
    buttons.forEach((btn, index) => {
        console.log(`Button ${index + 1} data:`, {
            id: btn.getAttribute('data-book-id'),
            title: btn.getAttribute('data-book-title'),
            author: btn.getAttribute('data-book-author'),
            price: btn.getAttribute('data-book-price'),
            category: btn.getAttribute('data-book-category'),
            image: btn.getAttribute('data-book-image')
        });
    });
});