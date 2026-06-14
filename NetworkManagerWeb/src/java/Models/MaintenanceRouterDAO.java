/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import Utils.DbUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

/**
 *
 * @author nvtv0
 */
public class MaintenanceRouterDAO {

    public boolean addRouter(int maintenanceId, int routerId) {
        String sql = "INSERT INTO MaintenanceRouter (maintenanceId, routerId) VALUES (?, ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            ps.setInt(2, routerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public boolean removeRouter(int maintenanceId, int routerId) {
        String sql = "DELETE FROM MaintenanceRouter WHERE maintenanceId = ? AND routerId = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            ps.setInt(2, routerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public ArrayList<Integer> findRoutersByMaintenance(int maintenanceId) {
        ArrayList<Integer> list = new ArrayList<>();
        String sql = "SELECT routerId FROM MaintenanceRouter WHERE maintenanceId = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("routerId"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public ArrayList<Integer> findMaintenancesByRouter(int routerId) {
        ArrayList<Integer> list = new ArrayList<>();
        String sql = "SELECT maintenanceId FROM MaintenanceRouter WHERE routerId = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, routerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("maintenanceId"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
