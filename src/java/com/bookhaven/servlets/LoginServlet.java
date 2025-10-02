package com.bookhaven.servlets;

import com.bookhaven.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show login page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        System.out.println("Login attempt: " + username);
        
        if (userDAO.validateUser(username, password)) {
    // Login successful
    HttpSession session = request.getSession();
    com.bookhaven.models.User user = userDAO.getUserByUsername(username);
    session.setAttribute("user", user);
    session.setAttribute("username", username);
    session.setAttribute("role", user.getRole()); // Add role separately
    
    System.out.println("Login successful for: " + username + " Role: " + user.getRole());
    response.sendRedirect("home");
} else {
            // Login failed
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}