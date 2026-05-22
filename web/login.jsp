<%--
    Login Page (View)

    CT Pillar: Abstraction
    - This JSP only handles display logic (showing the form and errors)
    - All business logic is in LoginServlet (Controller)
    - Database queries are in UserDAO (Model layer)

    Compatible with: JDK 8 + Tomcat 9 + JSTL 1.2
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Network Simulation System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="login-page">
    <div class="login-container">
        <!-- System Title -->
        <div class="login-header">
            <h1>Network Infrastructure</h1>
            <h2>Simulation Management System</h2>
        </div>

        <!-- Error Message Display -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                ${errorMessage}
            </div>
        </c:if>

        <!-- Login Form -->
        <form action="login" method="POST" class="login-form">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username"
                       value="${username}"
                       placeholder="Enter your username"
                       required autofocus>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                       placeholder="Enter your password"
                       required>
            </div>

            <button type="submit" class="btn btn-primary btn-block">Sign In</button>
        </form>

        <!-- Demo Accounts Info (remove in production) -->
        <div class="login-footer">
            <p class="demo-info">Demo Accounts:</p>
            <table class="demo-table">
                <tr>
                    <td><strong>admin</strong> / admin123</td>
                    <td>Full access</td>
                </tr>
                <tr>
                    <td><strong>engineer1</strong> / eng123</td>
                    <td>Can edit</td>
                </tr>
                <tr>
                    <td><strong>viewer1</strong> / view123</td>
                    <td>View only</td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>
