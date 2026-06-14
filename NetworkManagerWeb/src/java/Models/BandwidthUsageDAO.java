
package Models;

import Utils.DbUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 *
 * @author nvtv0
 */
public class BandwidthUsageDAO implements IDAO<BandwidthUsageDTO, Integer> {

    // ResultSet → BandwidthUsageDTO
    private BandwidthUsageDTO mapRow(ResultSet rs) throws SQLException {
        return new BandwidthUsageDTO(
                rs.getInt("usageId"),
                rs.getDouble("uploadSpeed"),
                rs.getDouble("downloadSpeed"),
                rs.getTimestamp("recordTime"),
                rs.getInt("deviceId")
        );
    }
    
    @Override
    public boolean insert(BandwidthUsageDTO t) {
        String sql = "INSERT INTO BandwidthUsage (uploadSpeed, downloadSpeed, recordTime, deviceId) "
                   + "VALUES (?, ?, GETDATE(), ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, t.getUploadSpeed());
            ps.setDouble(2, t.getDownloadSpeed());
            ps.setInt(3, t.getDeviceId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean remove(BandwidthUsageDTO t) {
        String sql = "DELETE FROM BandwidthUsage WHERE usageId = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, t.getUsageId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(BandwidthUsageDTO t) {
        String sql = "UPDATE BandwidthUsage SET uploadSpeed=?, downloadSpeed=?, deviceId=? "
                   + "WHERE usageId=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, t.getUploadSpeed());
            ps.setDouble(2, t.getDownloadSpeed());
            ps.setInt(3, t.getDeviceId());
            ps.setInt(4, t.getUsageId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    @Override
    public ArrayList<BandwidthUsageDTO> ListAll() {
        ArrayList<BandwidthUsageDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM BandwidthUsage ORDER BY recordTime DESC";
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
    public BandwidthUsageDTO searchById(Integer id) {
        String sql = "SELECT * FROM BandwidthUsage WHERE usageId = ?";
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

    /** Tìm tất cả bản ghi theo deviceId */
    public ArrayList<BandwidthUsageDTO> findByDevice(int deviceId) {
        ArrayList<BandwidthUsageDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM BandwidthUsage WHERE deviceId = ? ORDER BY recordTime DESC";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public ArrayList<BandwidthUsageDTO> findByDate(String date) {
        ArrayList<BandwidthUsageDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM BandwidthUsage WHERE CAST(recordTime AS DATE) = ? ORDER BY recordTime DESC";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<BandwidthUsageDTO> findTopUsage(int topN) {
        ArrayList<BandwidthUsageDTO> list = new ArrayList<>();
        String sql = "SELECT TOP (?) deviceId, "
                   + "SUM(uploadSpeed) AS uploadSpeed, "
                   + "SUM(downloadSpeed) AS downloadSpeed, "
                   + "MAX(recordTime) AS recordTime "
                   + "FROM BandwidthUsage "
                   + "GROUP BY deviceId "
                   + "ORDER BY (SUM(uploadSpeed) + SUM(downloadSpeed)) DESC";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, topN);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BandwidthUsageDTO dto = new BandwidthUsageDTO();
                dto.setDeviceId(rs.getInt("deviceId"));
                dto.setUploadSpeed(rs.getDouble("uploadSpeed"));
                dto.setDownloadSpeed(rs.getDouble("downloadSpeed"));
                dto.setRecordTime(rs.getTimestamp("recordTime"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<BandwidthUsageDTO> generateReport(String fromDate, String toDate) {
        ArrayList<BandwidthUsageDTO> list = new ArrayList<>();
        String sql = "SELECT 0 AS usageId, 0 AS deviceId, "
                   + "SUM(uploadSpeed) AS uploadSpeed, "
                   + "SUM(downloadSpeed) AS downloadSpeed, "
                   + "CAST(recordTime AS DATE) AS recordTime "
                   + "FROM BandwidthUsage "
                   + "WHERE CAST(recordTime AS DATE) BETWEEN ? AND ? "
                   + "GROUP BY CAST(recordTime AS DATE) "
                   + "ORDER BY CAST(recordTime AS DATE)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fromDate);
            ps.setString(2, toDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BandwidthUsageDTO dto = new BandwidthUsageDTO();
                dto.setUploadSpeed(rs.getDouble("uploadSpeed"));
                dto.setDownloadSpeed(rs.getDouble("downloadSpeed"));
                dto.setRecordTime(rs.getTimestamp("recordTime"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

