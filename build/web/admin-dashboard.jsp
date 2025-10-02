<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.bookhaven.models.Order, com.bookhaven.models.Book, java.util.List"%>
<%
    List<Order> orders = (List<Order>) request.getAttribute("recentOrders");
    Integer totalBooks = (Integer) request.getAttribute("totalBooks");
    Integer totalOrders = (Integer) request.getAttribute("totalOrders");
    if (orders == null) orders = new java.util.ArrayList<>();
    if (totalBooks == null) totalBooks = 0;
    if (totalOrders == null) totalOrders = 0;
    
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    
    if (!"admin".equals(role)) {
        response.sendRedirect("home");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - BookHaven</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        primary: "#137fec",
                        secondary: "#1e40af",
                        success: "#10b981",
                        warning: "#f59e0b",
                        danger: "#ef4444",
                        "background-light": "#f6f7f8",
                        "background-dark": "#101922",
                    }
                }
            }
        }
    </script>
    <style>
        .sidebar {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .card-hover {
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .card-hover:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }
        .status-badge {
            padding: 0.35rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .status-pending { background: linear-gradient(135deg, #fef3c7, #f59e0b); color: #7c2d12; }
        .status-confirmed { background: linear-gradient(135deg, #dbeafe, #3b82f6); color: #1e3a8a; }
        .status-shipped { background: linear-gradient(135deg, #f0f9ff, #0369a1); color: #0c4a6e; }
        .status-delivered { background: linear-gradient(135deg, #d1fae5, #065f46); color: #064e3b; }
        .status-cancelled { background: linear-gradient(135deg, #fee2e2, #dc2626); color: #7f1d1d; }
        .glass-effect {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .dark .glass-effect {
            background: rgba(30, 30, 30, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in { animation: fadeInUp 0.6s ease-out; }
    </style>
</head>
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800 min-h-screen font-sans">
    <!-- Admin Layout -->
    <div class="flex min-h-screen">
        <!-- Sidebar -->
        <div class="sidebar w-80 bg-white/90 dark:bg-gray-900/90 shadow-2xl glass-effect">
            <div class="p-8 border-b border-gray-200/50 dark:border-gray-700/50">
                <div class="flex items-center gap-3">
                    <div class="w-12 h-12 bg-gradient-to-r from-primary to-secondary rounded-2xl flex items-center justify-center shadow-lg">
                        <i class="fas fa-book-open text-white text-xl"></i>
                    </div>
                    <div>
                        <h1 class="text-2xl font-bold text-gray-800 dark:text-white">BookHaven</h1>
                        <p class="text-sm text-gray-600 dark:text-gray-400">Admin Dashboard</p>
                    </div>
                </div>
            </div>
            
            <nav class="mt-8 space-y-2 px-4">
                <a href="admin" class="flex items-center gap-4 px-6 py-4 text-white bg-gradient-to-r from-primary to-secondary rounded-2xl shadow-lg transform hover:scale-105 transition-all duration-300">
                    <i class="fas fa-tachometer-alt text-lg"></i>
                    <span class="font-semibold">Dashboard</span>
                </a>
<!--                <a href="admin-books" class="flex items-center gap-4 px-6 py-4 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-2xl transition-all duration-300 group">
                    <i class="fas fa-book text-lg group-hover:text-primary"></i>
                    <span class="font-medium group-hover:text-primary">Manage Books</span>
                </a>-->
                <a href="orders" class="flex items-center gap-4 px-6 py-4 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-2xl transition-all duration-300 group">
                    <i class="fas fa-shopping-cart text-lg group-hover:text-primary"></i>
                    <span class="font-medium group-hover:text-primary">Manage Orders</span>
                </a>
<!--                <a href="admin-users" class="flex items-center gap-4 px-6 py-4 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-2xl transition-all duration-300 group">
                    <i class="fas fa-users text-lg group-hover:text-primary"></i>
                    <span class="font-medium group-hover:text-primary">Manage Users</span>
                </a>-->
                <a href="home" class="flex items-center gap-4 px-6 py-4 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-2xl transition-all duration-300 group">
                    <i class="fas fa-store text-lg group-hover:text-primary"></i>
                    <span class="font-medium group-hover:text-primary">View Store</span>
                </a>
                <a href="logout" class="flex items-center gap-4 px-6 py-4 text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-2xl transition-all duration-300 group mt-8">
                    <i class="fas fa-sign-out-alt text-lg"></i>
                    <span class="font-medium">Logout</span>
                </a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="flex-1 overflow-auto">
            <!-- Header -->
            <header class="bg-white/80 dark:bg-gray-900/80 backdrop-blur-lg border-b border-gray-200/50 dark:border-gray-700/50 sticky top-0 z-40">
                <div class="flex justify-between items-center px-8 py-6">
                    <div>
                        <h2 class="text-3xl font-bold text-gray-800 dark:text-white">Dashboard Overview</h2>
                        <p class="text-gray-600 dark:text-gray-400 mt-1">Welcome back, <span class="font-semibold text-primary"><%= username %></span>!</p>
                    </div>
                    <div class="flex items-center gap-6">
<!--                        <div class="relative group">
                            <div class="w-12 h-12 bg-gradient-to-r from-primary to-secondary rounded-2xl flex items-center justify-center cursor-pointer shadow-lg">
                                <i class="fas fa-bell text-white text-lg"></i>
                            </div>
                            <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-6 w-6 flex items-center justify-center font-bold shadow-lg">3</span>
                        </div>-->
                        <div class="flex items-center gap-3">
                            <div class="w-12 h-12 bg-gradient-to-r from-primary to-secondary rounded-2xl flex items-center justify-center shadow-lg">
                                <span class="text-white font-bold text-lg"><%= username.charAt(0) %></span>
                            </div>
                            <div class="hidden md:block">
                                <p class="font-semibold text-gray-800 dark:text-white"><%= username %></p>
                                <p class="text-sm text-gray-600 dark:text-gray-400">Administrator</p>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Stats Cards -->
            <div class="p-8 grid grid-cols-1 lg:grid-cols-3 gap-8">
                <!-- Total Books Card -->
                <div class="card-hover bg-white/90 dark:bg-gray-900/90 rounded-3xl shadow-xl p-8 glass-effect animate-fade-in">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-sm font-semibold text-gray-600 dark:text-gray-400 uppercase tracking-wide">Total Books</p>
                            <p class="text-5xl font-bold text-gray-800 dark:text-white mt-2"><%= totalBooks %></p>
                            <div class="flex items-center gap-2 mt-4">
                                <i class="fas fa-arrow-up text-success text-sm"></i>
                                <span class="text-sm font-medium text-success">+12% this month</span>
                            </div>
                        </div>
                        <div class="p-4 bg-blue-500/10 rounded-2xl">
                            <i class="fas fa-book text-3xl text-primary"></i>
                        </div>
                    </div>
                    <div class="mt-6 pt-6 border-t border-gray-200/50 dark:border-gray-700/50">
                        <div class="flex justify-between text-sm text-gray-600 dark:text-gray-400">
                            <span>Active Books</span>
                            <span class="font-semibold text-gray-800 dark:text-white"><%= totalBooks - 2 %></span>
                        </div>
                    </div>
                </div>

                <!-- Total Orders Card -->
                <div class="card-hover bg-white/90 dark:bg-gray-900/90 rounded-3xl shadow-xl p-8 glass-effect animate-fade-in" style="animation-delay: 0.1s;">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-sm font-semibold text-gray-600 dark:text-gray-400 uppercase tracking-wide">Total Orders</p>
                            <p class="text-5xl font-bold text-gray-800 dark:text-white mt-2"><%= totalOrders %></p>
                            <div class="flex items-center gap-2 mt-4">
                                <i class="fas fa-arrow-up text-success text-sm"></i>
                                <span class="text-sm font-medium text-success">+8% this week</span>
                            </div>
                        </div>
                        <div class="p-4 bg-green-500/10 rounded-2xl">
                            <i class="fas fa-shopping-cart text-3xl text-success"></i>
                        </div>
                    </div>
                    <div class="mt-6 pt-6 border-t border-gray-200/50 dark:border-gray-700/50">
                        <div class="flex justify-between text-sm text-gray-600 dark:text-gray-400">
                            <span>Pending Orders</span>
                            <span class="font-semibold text-warning"><%= orders.stream().filter(o -> "pending".equals(o.getStatus())).count() %></span>
                        </div>
                    </div>
                </div>

                <!-- Revenue Card -->
                <div class="card-hover bg-white/90 dark:bg-gray-900/90 rounded-3xl shadow-xl p-8 glass-effect animate-fade-in" style="animation-delay: 0.2s;">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-sm font-semibold text-gray-600 dark:text-gray-400 uppercase tracking-wide">Total Revenue</p>
                            <p class="text-5xl font-bold text-gray-800 dark:text-white mt-2">₹12,458</p>
                            <div class="flex items-center gap-2 mt-4">
                                <i class="fas fa-arrow-up text-success text-sm"></i>
                                <span class="text-sm font-medium text-success">+15% this month</span>
                            </div>
                        </div>
                        <div class="p-4 bg-yellow-500/10 rounded-2xl">
                            <i class="fas fa-dollar-sign text-3xl text-warning"></i>
                        </div>
                    </div>
                    <div class="mt-6 pt-6 border-t border-gray-200/50 dark:border-gray-700/50">
                        <div class="flex justify-between text-sm text-gray-600 dark:text-gray-400">
                            <span>Avg. Order Value</span>
                            <span class="font-semibold text-gray-800 dark:text-white">₹45.67</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Orders Section -->
            <div class="px-8 pb-8">
                <div class="bg-white/90 dark:bg-gray-900/90 rounded-3xl shadow-xl overflow-hidden glass-effect">
                    <div class="px-8 py-6 border-b border-gray-200/50 dark:border-gray-700/50">
                        <div class="flex justify-between items-center">
                            <div>
                                <h3 class="text-2xl font-bold text-gray-800 dark:text-white">Recent Orders</h3>
                                <p class="text-gray-600 dark:text-gray-400 mt-1">Latest customer orders that need attention</p>
                            </div>
                            <a href="orders" class="bg-gradient-to-r from-primary to-secondary text-white px-6 py-3 rounded-2xl font-semibold hover:shadow-lg transition-all duration-300 transform hover:scale-105">
                                View All Orders
                            </a>
                        </div>
                    </div>
                    
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50/50 dark:bg-gray-800/50">
                                <tr>
                                    <th class="px-8 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-400 uppercase tracking-wider">Order ID</th>
                                    <th class="px-8 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-400 uppercase tracking-wider">Customer</th>
                                    <th class="px-8 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-400 uppercase tracking-wider">Date</th>
                                    <th class="px-8 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-400 uppercase tracking-wider">Amount</th>
                                    <th class="px-8 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-400 uppercase tracking-wider">Status</th>
                                    <th class="px-8 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-400 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200/50 dark:divide-gray-700/50">
                                <% for (Order order : orders) { %>
                                <tr class="hover:bg-gray-50/50 dark:hover:bg-gray-800/50 transition-colors duration-300 group">
                                    <td class="px-8 py-6 whitespace-nowrap">
                                        <div class="flex items-center gap-3">
                                            <div class="w-10 h-10 bg-gradient-to-r from-primary to-secondary rounded-2xl flex items-center justify-center">
                                                <i class="fas fa-receipt text-white text-sm"></i>
                                            </div>
                                            <div>
                                                <span class="text-lg font-bold text-gray-800 dark:text-white">#<%= order.getOrderId() %></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6 whitespace-nowrap">
                                        <div class="text-lg font-medium text-gray-800 dark:text-white"><%= order.getUsername() %></div>
                                        <div class="text-sm text-gray-500 dark:text-gray-400 truncate max-w-xs"><%= order.getShippingAddress() %></div>
                                    </td>
                                    <td class="px-8 py-6 whitespace-nowrap">
                                        <div class="text-lg text-gray-800 dark:text-white"><%= order.getOrderDate().toString().substring(0, 10) %></div>
                                        <div class="text-sm text-gray-500 dark:text-gray-400">
                                            <%= order.getOrderDate().toString().substring(11, 16) %>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6 whitespace-nowrap">
                                        <div class="text-2xl font-bold text-gray-800 dark:text-white">
                                            ₹<%= String.format("%.2f", order.getTotalAmount()) %>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6 whitespace-nowrap">
                                        <span class="status-badge status-<%= order.getStatus() %> transform group-hover:scale-105 transition-transform">
                                            <i class="fas fa-<%= getStatusIcon(order.getStatus()) %> mr-2"></i>
                                            <%= order.getStatus().toUpperCase() %>
                                        </span>
                                    </td>
                                    <td class="px-8 py-6 whitespace-nowrap">
                                        <div class="flex items-center gap-3">
                                            <form action="admin" method="post" class="flex-1">
                                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                                <input type="hidden" name="action" value="updateOrderStatus">
                                                <select name="status" onchange="this.form.submit()" 
                                                        class="w-full bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-2xl px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all duration-300">
                                                    <option value="pending" <%= "pending".equals(order.getStatus()) ? "selected" : "" %>>Pending</option>
                                                    <option value="confirmed" <%= "confirmed".equals(order.getStatus()) ? "selected" : "" %>>Confirmed</option>
                                                    <option value="shipped" <%= "shipped".equals(order.getStatus()) ? "selected" : "" %>>Shipped</option>
                                                    <option value="delivered" <%= "delivered".equals(order.getStatus()) ? "selected" : "" %>>Delivered</option>
                                                    <option value="cancelled" <%= "cancelled".equals(order.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                                </select>
                                            </form>
<!--                                            <a href="order-detail?id=<%= order.getOrderId() %>" 
                                               class="w-10 h-10 bg-gray-100 dark:bg-gray-800 rounded-2xl flex items-center justify-center text-gray-600 dark:text-gray-400 hover:bg-primary hover:text-white transition-all duration-300 transform hover:scale-110">
                                                <i class="fas fa-eye"></i>
                                            </a>-->
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    
                    <% if (orders.isEmpty()) { %>
                    <div class="text-center py-16">
                        <div class="w-24 h-24 bg-gray-100 dark:bg-gray-800 rounded-3xl flex items-center justify-center mx-auto mb-6">
                            <i class="fas fa-inbox text-gray-400 text-3xl"></i>
                        </div>
                        <h4 class="text-xl font-semibold text-gray-600 dark:text-gray-400 mb-2">No recent orders</h4>
                        <p class="text-gray-500 dark:text-gray-500">New orders will appear here</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Theme Toggle
        class ThemeToggle {
            constructor() {
                this.init();
            this.applySavedTheme();
            this.setupAutoTheme();
            this.setupManualToggle();
            this.setupSystemThemeListener();
            this.updateThemeIndicator();
            this.setupSmoothTransitions();
        }

            init() {
                // Check for saved theme preference or system preference
                const savedTheme = localStorage.getItem('theme');
                const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
                
                if (savedTheme) {
                    document.documentElement.classList.toggle('dark', savedTheme === 'dark');
                } else {
                    document.documentElement.classList.toggle('dark', systemPrefersDark);
                }
                
                this.updateThemeIndicator();
            }

            applySavedTheme() {
                const theme = localStorage.getItem('theme') || 
                             (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
                document.documentElement.classList.toggle('dark', theme === 'dark');
            }

            setupAutoTheme() {
                // Auto-detect system theme changes
                window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
                    if (!localStorage.getItem('theme')) {
                        document.documentElement.classList.toggle('dark', e.matches);
                        this.updateThemeIndicator();
                    }
                });
            }

            setupManualToggle() {
                // Manual toggle button
                const toggleBtn = document.createElement('button');
                toggleBtn.innerHTML = '<i class="fas fa-moon"></i>';
                toggleBtn.className = 'fixed bottom-6 right-6 w-14 h-14 bg-gradient-to-r from-primary to-secondary text-white rounded-2xl shadow-2xl flex items-center justify-center hover:scale-110 transition-transform duration-300 z-50';
                toggleBtn.addEventListener('click', () => this.toggleTheme());
                document.body.appendChild(toggleBtn);
            }

            setupSystemThemeListener() {
                // Listen for system theme changes
                window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
                    if (!localStorage.getItem('theme')) {
                        this.applyTheme(e.matches ? 'dark' : 'light');
                    }
                });
            }

            toggleTheme() {
                const isDark = document.documentElement.classList.toggle('dark');
                this.applyTheme(isDark ? 'dark' : 'light');
                this.animateThemeTransition();
            }

            applyTheme(theme) {
                localStorage.setItem('theme', theme);
                this.updateThemeIndicator();
            }

            animateThemeTransition() {
                // Add transition animation
                document.documentElement.style.transition = 'all 0.5s cubic-bezier(0.4, 0, 0.2, 1)';
                setTimeout(() => {
                    document.documentElement.style.transition = '';
                }, 500);
            }

            updateThemeIndicator() {
                const isDark = document.documentElement.classList.contains('dark');
                const icon = document.querySelector('.fixed button i');
                if (icon) {
                    icon.className = isDark ? 'fas fa-sun' : 'fas fa-moon';
                }
            }

            setupSmoothTransitions() {
                // Smooth transitions for theme change
                const style = document.createElement('style');
                style.textContent = `
                    * {
                        transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease;
                    }
                `;
                document.head.appendChild(style);
            }
        }

        // Initialize theme toggle
        document.addEventListener('DOMContentLoaded', () => {
            new ThemeToggle();
            
            // Add animations to cards
            const cards = document.querySelectorAll('.card-hover');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
            });
        });

        // Status icons mapping
        function getStatusIcon(status) {
            const icons = {
                'pending': 'clock',
                'confirmed': 'check-circle',
                'shipped': 'shipping-fast',
                'delivered': 'box-open',
                'cancelled': 'times-circle'
            };
            return icons[status] || 'question-circle';
        }
    </script>
</body>
</html>

<%!
    // Helper method for status icons
    private String getStatusIcon(String status) {
        switch (status) {
            case "pending": return "clock";
            case "confirmed": return "check-circle";
            case "shipped": return "shipping-fast";
            case "delivered": return "box-open";
            case "cancelled": return "times-circle";
            default: return "question-circle";
        }
    }
%>