package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility (Singleton Pattern)
 *
 * CT Pillar: Abstraction
 * - Abstracts the complexity of database connection into a single reusable class
 * - All DAOs use this class instead of writing connection code repeatedly
 *
 * Compatible with: JDK 8 + MySQL 8.0 + Tomcat 9
 */
public class DBConnection {

    // Database configuration - CHANGE THESE TO MATCH YOUR MySQL SETUP
    private static final String DB_URL = "jdbc:mysql://localhost:3306/network_simulation?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";  // Enter your MySQL root password here
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    // Singleton instance
    private static DBConnection instance;

    // Load the JDBC driver once when class is loaded
    static {
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found!", e);
        }
    }

    // Private constructor - prevents creating multiple instances
    private DBConnection() {
    }

    /**
     * Get the singleton instance of DBConnection
     * CT Pillar: Pattern Recognition - same pattern used everywhere
     */
    public static synchronized DBConnection getInstance() {
        if (instance == null) {
            instance = new DBConnection();
        }
        return instance;
    }

    /**
     * Get a new database connection
     * Each DAO call gets a fresh connection (Tomcat manages the pool)
     */
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * Close connection safely (handles null check)
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
