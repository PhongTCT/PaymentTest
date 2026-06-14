/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import Utils.DbUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;

/**
 *
 * @author nvtv0
 */
public class NetworkAlertDAO implements IDAO<NetworkAlertDTO, Integer>{
    private NetworkAlertDTO mapRow(ResultSet rs) throws SQLException {
        int alertId       = rs.getInt("alertId");
        String alertType  = rs.getString("alertType");
        String message    = rs.getString("message");
        String severity   = rs.getString("severity");
        Timestamp created = rs.getTimestamp("createdAt");

        // Đọc nullable FK
        Integer routerId = (Integer) rs.getObject("routerId");
        Integer apId     = (Integer) rs.getObject("apId");
        Integer switchId = (Integer) rs.getObject("switchId");

        return new NetworkAlertDTO(alertId, alertType, message, severity, created, routerId, apId, switchId);
    }

    @Override
    public boolean insert(NetworkAlertDTO t) {
        String sql = "INSERT INTO NetworkAlert (alertType, message, severity, createdAt, routerId, apId, switchId) "
                   + "VALUES (?, ?, ?, GETDATE(), ?, ?, ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getAlertType());
            ps.setString(2, t.getMessage());
            ps.setString(3, t.getSeverity() != null ? t.getSeverity() : "INFO");
            // Nullable FKs
            if (t.getRouterId() != null) ps.setInt(4, t.getRouterId()); else ps.setNull(4, Types.INTEGER);
            if (t.getApId()     != null) ps.setInt(5, t.getApId());     else ps.setNull(5, Types.INTEGER);
            if (t.getSwitchId() != null) ps.setInt(6, t.getSwitchId()); else ps.setNull(6, Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean remove(NetworkAlertDTO t) {
        String sql = "DELETE FROM NetworkAlert WHERE alertId = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, t.getAlertId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(NetworkAlertDTO t) {
        String sql = "UPDATE NetworkAlert SET alertType=?, message=?, severity=?, routerId=?, apId=?, switchId=? "
                   + "WHERE alertId=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getAlertType());
            ps.setString(2, t.getMessage());
            ps.setString(3, t.getSeverity());
            if (t.getRouterId() != null) ps.setInt(4, t.getRouterId()); else ps.setNull(4, Types.INTEGER);
            if (t.getApId()     != null) ps.setInt(5, t.getApId());     else ps.setNull(5, Types.INTEGER);
            if (t.getSwitchId() != null) ps.setInt(6, t.getSwitchId()); else ps.setNull(6, Types.INTEGER);
            ps.setInt(7, t.getAlertId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public ArrayList<NetworkAlertDTO> ListAll() {
        ArrayList<NetworkAlertDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM NetworkAlert ORDER BY createdAt DESC";
        try (Connection conn = DbUtils.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public NetworkAlertDTO searchById(Integer id) {
        String sql = "SELECT * FROM NetworkAlert WHERE alertId = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Tìm alerts theo thiết bị — truyền đúng tham số, hai cái còn lại null.
     * Ví dụ: findByDevice(5, null, null) → tìm alert của Router 5
     */
    public ArrayList<NetworkAlertDTO> findByDevice(Integer routerId, Integer apId, Integer switchId) {
        ArrayList<NetworkAlertDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM NetworkAlert WHERE 1=1");
        if (routerId != null) sql.append(" AND routerId = ?");
        if (apId     != null) sql.append(" AND apId = ?");
        if (switchId != null) sql.append(" AND switchId = ?");
        sql.append(" ORDER BY createdAt DESC");

        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (routerId != null) ps.setInt(idx++, routerId);
            if (apId     != null) ps.setInt(idx++, apId);
            if (switchId != null) ps.setInt(idx++, switchId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Tìm alerts theo mức độ nghiêm trọng: INFO | WARNING | CRITICAL */
    public ArrayList<NetworkAlertDTO> findBySeverity(String severity) {
        ArrayList<NetworkAlertDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM NetworkAlert WHERE severity = ? ORDER BY createdAt DESC";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, severity);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đánh dấu alert đã được giải quyết (xóa khỏi hệ thống).
     * Nếu muốn chỉ "đánh dấu resolved" thay vì xóa, cần thêm cột isResolved vào DB.
     */
    public boolean resolveAlert(int alertId) {
        String sql = "DELETE FROM NetworkAlert WHERE alertId = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, alertId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
