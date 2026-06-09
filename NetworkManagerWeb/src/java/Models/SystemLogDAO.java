
package Models;

import Utils.DbUtils;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;


public class SystemLogDAO {
    //HELPER
    private SystemLogDTO maprow(ResultSet rs) throws SQLException{
        SystemLogDTO log = new SystemLogDTO();
        log.setLogId(rs.getInt("log_id"));
        log.setAction(rs.getString("action"));
        log.setCreatedAt(rs.getTimestamp("created_at"));
        log.setDetails(rs.getString("details"));
 
        // performed_by is nullable — same wasNull() pattern as AuthenticationLogDAO
        int uid = rs.getInt("performed_by");
        log.setPerformedBy(rs.wasNull() ? null : uid);
 
        return log;
    }
    //SQL QUERIES:
    private static final String SQL_INSERT =
            "INSERT INTO SystemLog (action, details, performed_by) " +
            "VALUES (?, ?, ?)";
 
    private static final String SQL_FIND_ALL =
            "SELECT log_id, action, created_at, details, performed_by " +
            "FROM SystemLog " +
            "ORDER BY created_at DESC";
 
        // CAST(created_at AS DATE) strips the time part so we compare only the date
    private static final String SQL_FIND_BY_DATE =
            "SELECT log_id, action, created_at, details, performed_by " +
            "FROM SystemLog " +
            "WHERE CAST(created_at AS DATE) = ? " +
            "ORDER BY created_at DESC";
 
    private static final String SQL_FIND_BY_USER =
            "SELECT log_id, action, created_at, details, performed_by " +
            "FROM SystemLog " +
            "WHERE performed_by = ? " +
            "ORDER BY created_at DESC";
    
    
   //================== FUNCTIONS: ======================
    
    public boolean insert(SystemLogDTO log){
        try{
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareStatement(SQL_INSERT);
            
            ps.setString(1, log.getAction());
 
            // details is nullable
            if (log.getDetails() != null) {
                ps.setString(2, log.getDetails());
            } else {
                ps.setNull(2, Types.NVARCHAR);
            }
 
            // performedBy is nullable (e.g., automated system actions)
            if (log.getPerformedBy() != null) {
                ps.setInt(3, log.getPerformedBy());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
 
            return ps.executeUpdate() > 0;
            
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }
    
    // 
    public ArrayList<SystemLogDTO> findAll() {
        ArrayList<SystemLogDTO> list = new ArrayList<>();

        try {
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareStatement(SQL_FIND_ALL);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(maprow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    } 
    
    //
    public ArrayList<SystemLogDTO> findByUser(int userId){
        ArrayList<SystemLogDTO> list = new ArrayList<>();

        try {
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareStatement(SQL_FIND_BY_USER);
            
            ps.setInt(1, userId);
            
            try(ResultSet rs = ps.executeQuery()){
                while(rs.next()){
                    list.add(maprow(rs));
                }
            }

            
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    //
    public ArrayList<SystemLogDTO> findByDate(Date date){
        ArrayList<SystemLogDTO> list = new ArrayList<>();
        
        try{
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareStatement(SQL_FIND_BY_DATE);
            
            ps.setDate(1,date);
            try(ResultSet rs = ps.executeQuery()){
                while(rs.next()){
                    list.add(maprow(rs));
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }
}
