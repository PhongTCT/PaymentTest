package controller;

import dao.UserDAO;
import model.User;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Login Controller Servlet
 *
 * CT Pillar: Algorithm Design
 * Login Flow:
 *   1. GET /login  → Show login form (login.jsp)
 *   2. POST /login → Validate credentials
 *      a. Query database for matching user
 *      b. If found → create session, redirect to dashboard
 *      c. If not found → redirect to login with error message
 *   3. GET /logout → Invalidate session, redirect to login
 *
 * This is the MVC Controller pattern:
 *   Request → Servlet (processes) → JSP (displays)
 *
 * Compatible with: JDK 8 + Tomcat 9 + javax.servlet
 */
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        // Initialize DAO once when servlet is created
        this.userDAO = new UserDAO();
    }

    /**
     * GET /login → Display the login form
     * GET /logout → Log user out and redirect to login
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Handle logout
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login");
            return;
        }

        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            response.sendRedirect("dashboard");
            return;
        }

        // Show login form
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    /**
     * POST /login → Process login form submission
     *
     * CT Pillar: Algorithm Design
     * Step 1: Get username and password from form
     * Step 2: Validate input (not empty)
     * Step 3: Query database via UserDAO
     * Step 4: If valid → create session, redirect to dashboard
     * Step 5: If invalid → redirect back with error message
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Step 1: Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Step 2: Basic validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Step 3: Authenticate against database
        User user = userDAO.authenticate(username.trim(), password.trim());

        // Step 4: Handle result
        if (user != null) {
            // Success - create session
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            // Redirect to dashboard
            response.sendRedirect("dashboard");
        } else {
            // Failed - show error
            request.setAttribute("errorMessage", "Invalid username or password.");
            request.setAttribute("username", username); // preserve entered username
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
