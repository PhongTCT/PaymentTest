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
public class MaintenanceSwitchDAO {

    public boolean addSwitch(int maintenanceId, int switchId) {
        String sql = "INSERT INTO MaintenanceSwitch (maintenanceId, switchId) VALUES (?, ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            ps.setInt(2, switchId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeSwitch(int maintenanceId, int switchId) {
        String sql = "DELETE FROM MaintenanceSwitch WHERE maintenanceId = ? AND switchId = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            ps.setInt(2, switchId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public ArrayList<Integer> findSwitchesByMaintenance(int maintenanceId) {
        ArrayList<Integer> list = new ArrayList<>();
        String sql = "SELECT switchId FROM MaintenanceSwitch WHERE maintenanceId = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("switchId"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public ArrayList<Integer> findMaintenancesBySwitch(int switchId) {
        ArrayList<Integer> list = new ArrayList<>();
        String sql = "SELECT maintenanceId FROM MaintenanceSwitch WHERE switchId = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, switchId);
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
