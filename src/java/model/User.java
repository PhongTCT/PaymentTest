package model;

import java.io.Serializable;
import java.util.Date;

/**
 * User Model (Java Bean)
 *
 * CT Pillar: Abstraction
 * - Represents a real system user as a simple data object
 * - Maps directly to the 'users' table in the database
 * - Used to pass data between DAO, Servlet, and JSP layers
 *
 * Compatible with: JDK 8 + MySQL 8.0
 */
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    // Fields match database columns exactly
    private int userId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String role;       // ADMIN, ENGINEER, VIEWER
    private boolean isActive;
    private Date createdAt;
    private Date updatedAt;

    // Default constructor (required for Java Beans)
    public User() {
    }

    // Constructor with essential fields
    public User(int userId, String username, String fullName, String role) {
        this.userId = userId;
        this.username = username;
        this.fullName = fullName;
        this.role = role;
    }

    // ==================== GETTERS ====================

    public int getUserId() {
        return userId;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getFullName() {
        return fullName;
    }

    public String getEmail() {
        return email;
    }

    public String getRole() {
        return role;
    }

    public boolean getIsActive() {
        return isActive;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    // ==================== SETTERS ====================

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    // ==================== UTILITY METHODS ====================

    /**
     * Check if user has ADMIN role
     */
    public boolean isAdmin() {
        return "ADMIN".equals(this.role);
    }

    /**
     * Check if user has ENGINEER role
     */
    public boolean isEngineer() {
        return "ENGINEER".equals(this.role);
    }

    /**
     * Check if user can edit (ADMIN or ENGINEER)
     */
    public boolean canEdit() {
        return isAdmin() || isEngineer();
    }

    @Override
    public String toString() {
        return "User{userId=" + userId + ", username=" + username +
               ", fullName=" + fullName + ", role=" + role + "}";
    }
}
