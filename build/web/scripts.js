    // Theme toggle
    function toggleTheme() {
        document.body.style.backgroundColor = document.body.style.backgroundColor === 'black' ? 'white' : 'black';
        document.body.style.color = document.body.style.color === 'white' ? 'black' : 'white';
    }
    
    // Add to wishlist with proper notification
    function addToWishlist(bookId, bookTitle) {
        <% if (username == null) { %>
            alert('Please login to add items to wishlist');
            window.location.href = 'login';
            return;
        <% } %>
        
        // Get existing wishlist or create new one
        let wishlist = JSON.parse(localStorage.getItem('wishlist') || '[]');
        
        // Check if book already in wishlist
        if (wishlist.some(item => item.bookId === bookId)) {
            showNotification('"' + bookTitle + '" is already in your wishlist!', 'warning');
            return;
        }
        
        // Add to wishlist
        const book = {
            bookId: bookId,
            title: bookTitle,
            // You can add more properties if needed
        };
        
        wishlist.push(book);
        localStorage.setItem('wishlist', JSON.stringify(wishlist));
        showNotification('"' + bookTitle + '" added to wishlist!', 'success');
        updateWishlistCount();
    }
    
    // Notification system
    function showNotification(message, type = 'info') {
        // Remove existing notifications
        const existingNotifications = document.querySelectorAll('.notification');
        existingNotifications.forEach(notif => notif.remove());
        
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.innerHTML = `
            <i class="fas fa-${getNotificationIcon(type)}"></i>
            ${message}
        `;
        
        // Add styles if not already added
        if (!document.querySelector('#notification-styles')) {
            const styles = document.createElement('style');
            styles.id = 'notification-styles';
            styles.textContent = `
                .notification {
                    position: fixed;
                    top: 100px;
                    right: 20px;
                    background: white;
                    padding: 15px 20px;
                    border-radius: 8px;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    z-index: 10000;
                    transform: translateX(400px);
                    transition: transform 0.3s ease;
                    border-left: 4px solid #3b82f6;
                }
                .notification.show {
                    transform: translateX(0);
                }
                .notification-success {
                    border-left-color: #10b981;
                    color: #10b981;
                }
                .notification-warning {
                    border-left-color: #f59e0b;
                    color: #f59e0b;
                }
                .notification-error {
                    border-left-color: #ef4444;
                    color: #ef4444;
                }
            `;
            document.head.appendChild(styles);
        }
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.classList.add('show');
        }, 100);
        
        setTimeout(() => {
            notification.classList.remove('show');
            setTimeout(() => {
                if (notification.parentNode) {
                    document.body.removeChild(notification);
                }
            }, 300);
        }, 3000);
    }
    
    function getNotificationIcon(type) {
        const icons = {
            success: 'check-circle',
            error: 'exclamation-circle',
            warning: 'exclamation-triangle',
            info: 'info-circle'
        };
        return icons[type] || 'info-circle';
    }
    
    function updateWishlistCount() {
        const wishlist = JSON.parse(localStorage.getItem('wishlist') || '[]');
        console.log('Wishlist updated. Total items:', wishlist.length);
    }
    
    // Initialize wishlist count on page load
    document.addEventListener('DOMContentLoaded', function() {
        updateWishlistCount();
    });
