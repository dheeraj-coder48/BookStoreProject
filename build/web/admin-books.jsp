<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.bookhaven.models.Book, java.util.List"%>
<%
    List<Book> books = (List<Book>) request.getAttribute("books");
    Book editBook = (Book) request.getAttribute("book");
    Boolean isEdit = (Boolean) request.getAttribute("isEdit");
    String searchQuery = (String) request.getAttribute("searchQuery");
    if (books == null) books = new java.util.ArrayList<>();
    if (isEdit == null) isEdit = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Books - BookHaven Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .glass-effect {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }
        .book-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .book-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }
        .modal {
            transition: all 0.3s ease;
        }
        .modal-enter {
            opacity: 0;
            transform: scale(0.9);
        }
        .modal-enter-active {
            opacity: 1;
            transform: scale(1);
        }
    </style>
</head>
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen">
    <!-- Admin Layout -->
    <div class="flex">
        <!-- Sidebar (Same as admin-dashboard.jsp) -->
        <div class="sidebar w-64 bg-white shadow-xl glass-effect">
            <div class="p-6 border-b">
                <h1 class="text-2xl font-bold text-gray-800">
                    <i class="fas fa-book-open text-primary mr-2"></i>
                    BookHaven Admin
                </h1>
            </div>
            <!-- Navigation Header for Secondary Pages -->
<div class="bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-700">
    <div class="container mx-auto px-4 py-4">
        <div class="flex items-center gap-4">
            <a href="home" class="flex items-center gap-2 text-gray-600 dark:text-gray-400 hover:text-primary transition-colors group">
                <i class="fas fa-chevron-left group-hover:-translate-x-1 transition-transform"></i>
                <span>Back to Home</span>
            </a>
            <span class="text-gray-400">/</span>
            <span class="text-gray-900 dark:text-white font-semibold">Page Title</span>
        </div>
    </div>
</div>
            <nav class="mt-6">
                <a href="admin" class="flex items-center px-6 py-3 text-gray-600 hover:bg-gray-100 border-l-4 border-transparent">
                    <i class="fas fa-tachometer-alt mr-3"></i>
                    Dashboard
                </a>
                <a href="admin-books" class="flex items-center px-6 py-3 text-white bg-primary border-l-4 border-secondary">
                    <i class="fas fa-book mr-3"></i>
                    Manage Books
                </a>
                <a href="orders" class="flex items-center px-6 py-3 text-gray-600 hover:bg-gray-100 border-l-4 border-transparent">
                    <i class="fas fa-shopping-cart mr-3"></i>
                    Manage Orders
                </a>
                <a href="admin-users" class="flex items-center px-6 py-3 text-gray-600 hover:bg-gray-100 border-l-4 border-transparent">
                    <i class="fas fa-users mr-3"></i>
                    Manage Users
                </a>
                <a href="home" class="flex items-center px-6 py-3 text-gray-600 hover:bg-gray-100 border-l-4 border-transparent">
                    <i class="fas fa-store mr-3"></i>
                    View Store
                </a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="flex-1 p-6">
            <!-- Header -->
            <div class="glass-effect rounded-2xl p-6 mb-6 shadow-lg">
                <div class="flex justify-between items-center">
                    <div>
                        <h2 class="text-3xl font-bold text-gray-800">Book Management</h2>
                        <p class="text-gray-600">Add, edit, and manage your book collection</p>
                    </div>
                    <button onclick="openModal()" 
                            class="bg-gradient-to-r from-primary to-secondary text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transition-all duration-300 transform hover:scale-105">
                        <i class="fas fa-plus mr-2"></i>Add New Book
                    </button>
                </div>
                
                <!-- Search Bar -->
                <div class="mt-6">
                    <form action="admin-books" method="get" class="flex gap-4">
                        <div class="flex-1 relative">
                            <i class="fas fa-search absolute left-4 top-3 text-gray-400"></i>
                            <input type="text" name="search" value="<%= searchQuery != null ? searchQuery : "" %>" 
                                   placeholder="Search books by title, author, or category..."
                                   class="w-full pl-12 pr-4 py-3 rounded-xl border border-gray-300 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent">
                        </div>
                        <button type="submit" 
                                class="bg-primary text-white px-6 py-3 rounded-xl font-semibold hover:bg-secondary transition-colors">
                            Search
                        </button>
                        <% if (searchQuery != null) { %>
                        <a href="admin-books" 
                           class="bg-gray-500 text-white px-6 py-3 rounded-xl font-semibold hover:bg-gray-600 transition-colors">
                            Clear
                        </a>
                        <% } %>
                    </form>
                </div>
            </div>

            <!-- Books Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                <% for (Book book : books) { %>
                <div class="book-card bg-white rounded-2xl shadow-lg overflow-hidden group">
                    <div class="relative overflow-hidden">
                        <img src="<%= book.getImageUrl() %>" alt="<%= book.getTitle() %>" 
                             class="w-full h-48 object-cover group-hover:scale-110 transition-transform duration-500">
                        <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-20 transition-all duration-300"></div>
                        <div class="absolute top-4 right-4 flex gap-2">
                            <span class="status-badge <%= book.getStockQuantity() > 10 ? "bg-green-100 text-green-800" : book.getStockQuantity() > 0 ? "bg-yellow-100 text-yellow-800" : "bg-red-100 text-red-800" %>">
                                Stock: <%= book.getStockQuantity() %>
                            </span>
                        </div>
                    </div>
                    
                    <div class="p-4">
                        <h3 class="font-bold text-lg text-gray-800 mb-1 truncate"><%= book.getTitle() %></h3>
                        <p class="text-gray-600 text-sm mb-2">by <%= book.getAuthor() %></p>
                        <p class="text-primary font-bold text-lg mb-3">$<%= String.format("%.2f", book.getPrice()) %></p>
                        
                        <div class="flex justify-between items-center">
                            <span class="text-xs font-medium px-2 py-1 bg-blue-100 text-blue-800 rounded-full">
                                <%= book.getCategory() %>
                            </span>
                            <div class="flex gap-2">
                                <a href="admin-books?action=edit&id=<%= book.getBookId() %>" 
                                   class="text-blue-600 hover:text-blue-800 transition-colors"
                                   onclick="event.stopPropagation(); openEditModal(<%= book.getBookId() %>)">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="admin-books?action=delete&id=<%= book.getBookId() %>" 
                                   class="text-red-600 hover:text-red-800 transition-colors"
                                   onclick="return confirm('Are you sure you want to delete this book?')">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>

            <% if (books.isEmpty()) { %>
            <div class="text-center py-12 glass-effect rounded-2xl">
                <i class="fas fa-book-open text-gray-300 text-6xl mb-4"></i>
                <h3 class="text-xl font-semibold text-gray-600 mb-2">No books found</h3>
                <p class="text-gray-500 mb-4"><%= searchQuery != null ? "Try adjusting your search criteria" : "Get started by adding your first book" %></p>
                <% if (searchQuery == null) { %>
                <button onclick="openModal()" 
                        class="bg-gradient-to-r from-primary to-secondary text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transition-all">
                    <i class="fas fa-plus mr-2"></i>Add Your First Book
                </button>
                <% } %>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Add/Edit Book Modal -->
    <div id="bookModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50 p-4 modal">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
            <div class="p-6 border-b">
                <h3 class="text-2xl font-bold text-gray-800">
                    <%= isEdit ? "Edit Book" : "Add New Book" %>
                </h3>
            </div>
            
            <form action="admin-books" method="post" class="p-6 space-y-4">
                <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">
                <% if (isEdit && editBook != null) { %>
                <input type="hidden" name="bookId" value="<%= editBook.getBookId() %>">
                <% } %>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Book Title *</label>
                        <input type="text" name="title" required 
                               value="<%= isEdit && editBook != null ? editBook.getTitle() : "" %>"
                               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent">
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Author *</label>
                        <input type="text" name="author" required
                               value="<%= isEdit && editBook != null ? editBook.getAuthor() : "" %>"
                               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent">
                    </div>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Category *</label>
                        <select name="category" required
                                class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent">
                            <option value="">Select Category</option>
                            <option value="Fantasy" <%= isEdit && editBook != null && "Fantasy".equals(editBook.getCategory()) ? "selected" : "" %>>Fantasy</option>
                            <option value="Science Fiction" <%= isEdit && editBook != null && "Science Fiction".equals(editBook.getCategory()) ? "selected" : "" %>>Science Fiction</option>
                            <option value="Mystery" <%= isEdit && editBook != null && "Mystery".equals(editBook.getCategory()) ? "selected" : "" %>>Mystery</option>
                            <option value="Romance" <%= isEdit && editBook != null && "Romance".equals(editBook.getCategory()) ? "selected" : "" %>>Romance</option>
                            <option value="Thriller" <%= isEdit && editBook != null && "Thriller".equals(editBook.getCategory()) ? "selected" : "" %>>Thriller</option>
                            <option value="Historical Fiction" <%= isEdit && editBook != null && "Historical Fiction".equals(editBook.getCategory()) ? "selected" : "" %>>Historical Fiction</option>
                        </select>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Price *</label>
                        <input type="number" name="price" step="0.01" min="0" required
                               value="<%= isEdit && editBook != null ? editBook.getPrice() : "" %>"
                               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent">
                    </div>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Stock Quantity *</label>
                        <input type="number" name="stockQuantity" min="0" required
                               value="<%= isEdit && editBook != null ? editBook.getStockQuantity() : "0" %>"
                               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent">
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Image URL</label>
                        <input type="url" name="imageUrl"
                               value="<%= isEdit && editBook != null ? editBook.getImageUrl() : "" %>"
                               placeholder="https://example.com/image.jpg"
                               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent">
                    </div>
                </div>
                
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                    <textarea name="description" rows="4"
                              class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                              placeholder="Enter book description..."><%= isEdit && editBook != null ? editBook.getDescription() : "" %></textarea>
                </div>
                
                <div class="flex justify-end gap-4 pt-4 border-t">
                    <button type="button" onclick="closeModal()"
                            class="px-6 py-3 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-colors">
                        Cancel
                    </button>
                    <button type="submit"
                            class="bg-gradient-to-r from-primary to-secondary text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transition-all">
                        <%= isEdit ? "Update Book" : "Add Book" %>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Modal functions
        function openModal() {
            const modal = document.getElementById('bookModal');
            modal.classList.remove('hidden');
            modal.classList.add('flex');
            setTimeout(() => {
                modal.classList.add('modal-enter-active');
            }, 10);
        }
        
        function closeModal() {
            const modal = document.getElementById('bookModal');
            modal.classList.remove('modal-enter-active');
            setTimeout(() => {
                modal.classList.add('hidden');
                modal.classList.remove('flex');
            }, 300);
        }
        
        // Close modal when clicking outside
        document.getElementById('bookModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });
        
        // Real-time search preview (optional enhancement)
        const searchInput = document.querySelector('input[name="search"]');
        if (searchInput) {
            searchInput.addEventListener('input', function() {
                // You could add real-time search results here
                console.log('Searching for:', this.value);
            });
        }
    </script>
</body>
</html>