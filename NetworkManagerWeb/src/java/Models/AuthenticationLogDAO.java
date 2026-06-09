package Models;

import Utils.DbUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;

public class AuthenticationLogDAO {

    //SQL Statements
    private static String SQL_INSERT = "INSERT INTO AuthenticationLog "
            + "(username, login_status, ip_address, user_id) VALUES (?,?,?,?)";
    private static String SQL_FIND_ALL = "SELECT log_id, username, login_status, ip_address, login_time, user_id "
            + "FROM AuthenticationLog "
            + "ORDER BY login_time DESC";
    private static String SQL_FIND_BY_USER = "SELECT log_id, username, login_status, ip_address, login_time, user_id "
            + "FROM AuthenticationLog "
            + " WHERE user_id = ? "
            + " ORDER BY login_time DESC ";
    private static String SQL_FIND_FAILED = "SELECT log_id, username, login_status, ip_address, login_time, user_id "
            + "FROM AuthenticationLog "
            + "WHERE login_status = 'FAILED' "
            + "ORDER BY login_time DESC";

    //HELPER
    private AuthenticationLogDTO mapRow(ResultSet rs) throws SQLException {
        AuthenticationLogDTO log = new AuthenticationLogDTO();
        log.setLogId(rs.getInt("log_id"));
        log.setUserName(rs.getString("username"));
        log.setLoginStatus(rs.getString("login_status"));
        log.setIpAddress(rs.getString("ip_address"));
        log.setLoginTime(rs.getTimestamp("login_time"));

        // user_id is nullable — getInt() returns 0 for SQL NULL, so check wasNull()
        int uid = rs.getInt("user_id");
        log.setUserId(rs.wasNull() ? null : uid);

        return log;
    }

    //
    public boolean insert(AuthenticationLogDTO log) {
        try {
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareStatement(SQL_INSERT);

            ps.setString(1, log.getUserName());

            ps.setString(2, log.getLoginStatus());

            // ipAddress is nullable
            if (log.getIpAddress() != null) {
                ps.setString(3, log.getIpAddress());
            } else {
                ps.setNull(3, Types.VARCHAR);
            }

            // userId is nullable — null when login failed / username not found
            if (log.getUserId() != null) {
                ps.setInt(4, log.getUserId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    //
    public ArrayList<AuthenticationLogDTO> findAll() {
        ArrayList<AuthenticationLogDTO> list = new ArrayList<>();

        try {
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareStatement(SQL_FIND_ALL);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    //
    public ArrayList<AuthenticationLogDTO> findByUser(int userId){
        ArrayList<AuthenticationLogDTO> list = new ArrayList<>();

        try {
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareCall(SQL_FIND_BY_USER);
            
            ps.setInt(1, userId);
            
            try(ResultSet rs = ps.executeQuery()){
                while(rs.next()){
                    list.add(mapRow(rs));
                }
            }

            
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    //
    public ArrayList<AuthenticationLogDTO> findFailedAttempts() {
        ArrayList<AuthenticationLogDTO> list = new ArrayList<>();

        try {
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareCall(SQL_FIND_FAILED);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
