package Models;

import Utils.DbUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author User
 */
public class RouterDAO implements IDAO<RouterDTO, Integer> {

    private RouterDTO mapRow(ResultSet rs) throws SQLException {
        return new RouterDTO(
                rs.getInt("router_id"),
                rs.getString("router_name"),
                rs.getString("ip_address"),
                rs.getString("mac_address"),
                rs.getString("model"),
                rs.getString("firmware"),
                rs.getString("status"),
                rs.getString("location"),
                rs.getInt("room_id")
        );
    }

    @Override
    public boolean insert(RouterDTO t) {
        String sql = "INSERT INTO Router "
                + "(router_name, ip_address, mac_address, model, firmware, status, location, room_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection connect = DbUtils.getConnection()) {
            Integer inactiveRouterId = findInactiveRouterId(connect, t);
            if (inactiveRouterId != null) {
                return updateExistingRouter(connect, inactiveRouterId, t);
            }

            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setString(1, t.getRouterName());
            ps.setString(2, t.getIpAddress());
            ps.setString(3, t.getMacAddress());
            ps.setString(4, t.getModel());
            ps.setString(5, t.getFirmware());
            ps.setString(6, t.getStatus());
            ps.setString(7, t.getLocation());
            if (t.getRoomId() > 0) {
                ps.setInt(8, t.getRoomId());
            } else {
                ps.setNull(8, Types.INTEGER);
            }
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Integer findInactiveRouterId(Connection connect, RouterDTO router) throws SQLException {
        String sql = "SELECT TOP 1 router_id FROM Router "
                + "WHERE status = 'INACTIVE' AND (ip_address = ? OR mac_address = ?) "
                + "ORDER BY router_id";
        PreparedStatement ps = connect.prepareStatement(sql);
        ps.setString(1, router.getIpAddress());
        ps.setString(2, router.getMacAddress());
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt("router_id");
        }
        return null;
    }

    private boolean updateExistingRouter(Connection connect, int routerId, RouterDTO router) throws SQLException {
        String sql = "UPDATE Router SET "
                + "router_name = ?, ip_address = ?, mac_address = ?, "
                + "model = ?, firmware = ?, status = ?, location = ?, room_id = ? "
                + "WHERE router_id = ?";
        PreparedStatement ps = connect.prepareStatement(sql);
        ps.setString(1, router.getRouterName());
        ps.setString(2, router.getIpAddress());
        ps.setString(3, router.getMacAddress());
        ps.setString(4, router.getModel());
        ps.setString(5, router.getFirmware());
        ps.setString(6, router.getStatus());
        ps.setString(7, router.getLocation());
        if (router.getRoomId() > 0) {
            ps.setInt(8, router.getRoomId());
        } else {
            ps.setNull(8, Types.INTEGER);
        }
        ps.setInt(9, routerId);
        return ps.executeUpdate() > 0;
    }

    @Override
    public boolean update(RouterDTO t) {
        String sql = "UPDATE Router SET "
                + "router_name = ?, ip_address = ?, mac_address = ?, "
                + "model = ?, firmware = ?, status = ?, location = ?, room_id = ? "
                + "WHERE router_id = ?";
        try {
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setString(1, t.getRouterName());
            ps.setString(2, t.getIpAddress());
            ps.setString(3, t.getMacAddress());
            ps.setString(4, t.getModel());
            ps.setString(5, t.getFirmware());
            ps.setString(6, t.getStatus());
            ps.setString(7, t.getLocation());
            if (t.getRoomId() > 0) {
                ps.setInt(8, t.getRoomId());
            } else {
                ps.setNull(8, Types.INTEGER);
            }
            ps.setInt(9, t.getRouterId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean remove(RouterDTO t) {
        return softDelete(t.getRouterId());
    }

    @Override
    public ArrayList<RouterDTO> ListAll() {
        ArrayList<RouterDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM Router WHERE status <> 'INACTIVE'";
        try {
            Connection connect = DbUtils.getConnection();
            Statement st = connect.createStatement();
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                list.add(mapRow(rs));

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public RouterDTO searchById(Integer id) {
        String sql = "SELECT * FROM Router WHERE router_id = ?";
        System.out.println(sql);
        try {
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareStatement(sql);
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

    public boolean softDelete(int routerID) {
        String sql = "UPDATE Router SET status = 'INACTIVE' WHERE router_id = ?";
        try (
                 Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, routerID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int routerId, String status) {
        String sql = "UPDATE Router SET status = ? WHERE router_id = ?";

        try (
                 Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, routerId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean restartRouter(int routerId) {
        return updateStatus(routerId, "MAINTENANCE");
    }

}
