// Search functionality
class BookSearch {
    constructor() {
        this.searchInput = document.getElementById('searchInput');
        this.searchResults = document.getElementById('searchResults');
        this.allBooks = [];
        
        this.init();
    }
    
    init() {
        this.loadAllBooks();
        this.setupEventListeners();
    }
    
    setupEventListeners() {
        // Search on input with debounce
        this.searchInput.addEventListener('input', (e) => {
            this.handleSearch(e.target.value);
        });
        
        // Search on Enter key
        this.searchInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.performSearch(this.searchInput.value);
            }
        });
        
        // Close results when clicking outside
        document.addEventListener('click', (e) => {
            if (!e.target.closest('.search-bar')) {
                this.hideResults();
            }
        });
    }
    
    loadAllBooks() {
        // This would typically fetch from your search servlet
        // For now, we'll get books from the page
        this.allBooks = Array.from(document.querySelectorAll('.book-card')).map(card => {
            return {
                title: card.querySelector('.book-title').textContent,
                author: card.querySelector('.book-author').textContent.replace('by ', ''),
                category: card.querySelector('.book-category').textContent,
                price: card.querySelector('.book-price').textContent,
                image: card.querySelector('.book-image').src,
                url: card.querySelector('a[href*="book-detail"]').href
            };
        });
    }
    
    handleSearch(query) {
        clearTimeout(this.searchTimeout);
        
        if (query.length < 2) {
            this.hideResults();
            return;
        }
        
        this.searchTimeout = setTimeout(() => {
            this.performSearch(query);
        }, 300);
    }
    
    performSearch(query) {
        const lowerQuery = query.toLowerCase();
        const results = this.allBooks.filter(book => 
            book.title.toLowerCase().includes(lowerQuery) ||
            book.author.toLowerCase().includes(lowerQuery) ||
            book.category.toLowerCase().includes(lowerQuery)
        ).slice(0, 6);
        
        this.displayResults(results, query);
    }
    
    displayResults(results, query) {
        if (results.length === 0) {
            this.searchResults.innerHTML = `
                <div class="search-result-item">
                    <div style="text-align: center; width: 100%; padding: 30px 20px; color: #8D6E63;">
                        <i class="fas fa-search" style="font-size: 2.5rem; margin-bottom: 15px; opacity: 0.5;"></i>
                        <p style="font-size: 1.1rem; margin-bottom: 10px;">No books found for</p>
                        <p style="font-weight: 600; color: #8B4513;">"${query}"</p>
                        <p style="font-size: 0.9rem; margin-top: 10px; opacity: 0.7;">Try different keywords</p>
                    </div>
                </div>
            `;
        } else {
            this.searchResults.innerHTML = results.map(book => `
                <a href="${book.url}" class="search-result-item">
                    <img src="${book.image}" alt="${book.title}">
                    <div class="search-result-info">
                        <div class="search-result-title">${book.title}</div>
                        <div class="search-result-author">by ${book.author}</div>
                        <div class="search-result-meta">
                            <span class="search-result-price">${book.price}</span>
                            <span class="search-result-category">${book.category}</span>
                        </div>
                    </div>
                </a>
            `).join('');
        }
        
        this.showResults();
    }
    
    showResults() {
        this.searchResults.style.display = 'block';
    }
    
    hideResults() {
        this.searchResults.style.display = 'none';
    }
    
    handleAddToCart(form) {
    console.log("handleAddToCart called with form:", form);
    
    const formData = new FormData(form);
    const bookId = formData.get('bookId');
    const quantity = parseInt(formData.get('quantity')) || 1;
    
    console.log("Book ID:", bookId, "Quantity:", quantity);
    
    // Get book details from the page
    const bookCard = form.closest('.book-card');
    const bookData = this.getBookData(bookCard, bookId);
    
    if (!bookData) {
        console.error('Could not find book data');
        this.showNotification("Error: Could not add to cart", "warning");
        return;
    }
    
    // Create flying animation
    this.createFlyingAnimation(bookCard, bookData.image);
    
    // Update cart count with animation
    this.updateCartCount(this.cartCount + quantity);
    
    // Add to cart items
    this.addToCartItems(bookData, quantity);
    
    // Show success notification
    this.showNotification(`"${bookData.title}" added to cart! 🛒`, 'success');
    
    // Update cart preview
    this.updateCartPreview();
    
    // DON'T prevent default - let the form submit normally
    // The animation will still show, but the page will navigate to cart
    // If you want to stay on the same page, uncomment the timeout below:
    
    /*
    // Submit the form after animation (stays on same page)
    setTimeout(() => {
        console.log("Submitting form...");
        form.submit();
    }, 1000);
    */
}
}

// Initialize search when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    new BookSearch();
});