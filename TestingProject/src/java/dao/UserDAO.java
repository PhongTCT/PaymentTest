package dao;

import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * User Data Access Object (DAO)
 *
 * CT Pillar: Pattern Recognition
 * - All database operations for 'users' table follow the same pattern:
 *   1. Get connection
 *   2. Prepare SQL statement
 *   3. Set parameters
 *   4. Execute query
 *   5. Process results
 *   6. Close resources
 * - This same pattern will be reused for DeviceDAO, MaintenanceDAO, etc.
 *
 * Compatible with: JDK 8 + MySQL 8.0
 */
public class UserDAO {

    private DBConnection dbConn;

    public UserDAO() {
        this.dbConn = DBConnection.getInstance();
    }

    /**
     * Authenticate user by username and password
     * CT Pillar: Algorithm Design
     *   Step 1: Connect to database
     *   Step 2: Query for matching username + password
     *   Step 3: If found, create User object
     *   Step 4: If not found, return null
     *
     * @param username The username to check
     * @param password The password to check
     * @return User object if authenticated, null otherwise
     */
    public User authenticate(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = '"+ username +"' AND password = '"+ password +"' AND is_active = 1";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConn.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapRowToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeQuietly(rs, stmt, conn);
        }

        return null;
    }

    /**
     * Find a user by their ID
     */
    public User findById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConn.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapRowToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeQuietly(rs, stmt, conn);
        }

        return null;
    }

    /**
     * Get all users
     */
    public List<User> findAll() {
        String sql = "SELECT * FROM users ORDER BY user_id";
        List<User> users = new ArrayList<User>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConn.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                users.add(mapRowToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeQuietly(rs, stmt, conn);
        }

        return users;
    }

    /**
     * Insert a new user
     */
    public boolean insert(User user) {
        String sql = "INSERT INTO users (username, password, full_name, email, role, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConn.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getRole());
            stmt.setBoolean(6, user.getIsActive());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeQuietly(null, stmt, conn);
        }
    }

    /**
     * Update an existing user
     */
    public boolean update(User user) {
        String sql = "UPDATE users SET username=?, password=?, full_name=?, email=?, role=?, is_active=? WHERE user_id=?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConn.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getRole());
            stmt.setBoolean(6, user.getIsActive());
            stmt.setInt(7, user.getUserId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeQuietly(null, stmt, conn);
        }
    }

    /**
     * Delete a user by ID
     */
    public boolean delete(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConn.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeQuietly(null, stmt, conn);
        }
    }

    // ==================== HELPER METHODS ====================

    /**
     * Map a database row to a User object
     * CT Pillar: Abstraction - converts raw database data into meaningful object
     */
    private User mapRowToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getString("role"));
        user.setIsActive(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }

    /**
     * Safely close database resources
     * Always close in reverse order: ResultSet → Statement → Connection
     */
    private void closeQuietly(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
        try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
        DBConnection.closeConnection(conn);
    }
}
