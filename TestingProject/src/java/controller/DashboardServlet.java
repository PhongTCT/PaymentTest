package controller;

import model.User;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Dashboard Controller Servlet
 *
 * CT Pillar: Algorithm Design
 * Dashboard Flow:
 *   1. Check if user is logged in (session check)
 *   2. If not logged in → redirect to login page
 *   3. If logged in → forward to dashboard.jsp
 *
 * This pattern (session check → forward) is used for ALL protected pages
 *
 * Compatible with: JDK 8 + Tomcat 9 + javax.servlet
 */
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * GET /dashboard → Display the dashboard page
     * Protected: requires valid session
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check - redirect to login if not authenticated
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login");
            return;
        }

        // User is logged in - get user info for the view
        User currentUser = (User) session.getAttribute("currentUser");
        request.setAttribute("currentUser", currentUser);

        // Forward to dashboard JSP
        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }

    /**
     * POST /dashboard → Same as GET (no form submissions on dashboard)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
