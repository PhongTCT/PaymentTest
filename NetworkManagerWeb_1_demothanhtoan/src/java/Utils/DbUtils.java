/*
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Computing Fundamental - HCM Campus
 */
public class DbUtils {

    private static final String DEFAULT_DB_URL      = "jdbc:postgresql://localhost:5432/network_simulation_db3";
    private static final String DEFAULT_DB_USER     = "postgres";
    private static final String DEFAULT_DB_PASSWORD = "postgres";

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection(getJdbcUrl(), getDbUser(), getDbPassword());
    }

    public static String getJdbcUrl() {
        return environment("DB_URL", DEFAULT_DB_URL);
    }

    public static String getDbUser() {
        return environment("DB_USER", DEFAULT_DB_USER);
    }

    public static String getDbPassword() {
        return environment("DB_PASSWORD", DEFAULT_DB_PASSWORD);
    }

    private static String environment(String name, String fallback) {
        String value = System.getenv(name);
        return value == null || value.trim().isEmpty() ? fallback : value.trim();
    }
    
    public static void main(String[] args) {
        try {
            System.out.println(getConnection());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DbUtils.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(DbUtils.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
