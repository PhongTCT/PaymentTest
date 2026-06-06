package Models;

import Utils.DbUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
        String sql = "INSERT INTO router "
                + "(router_id, router_name, ip_address, mac_address, model,firmware,status,location,room_id) "
                + "VALUES (?,?,?,?,?,?,?,?,?)";
        try {
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setInt(1, t.getRouterId());
            ps.setString(2, t.getRouterName());
            ps.setString(3, t.getIpAddress());
            ps.setString(4, t.getMacAddress());
            ps.setString(5, t.getModel());
            ps.setString(6, t.getFirmware());
            ps.setString(7, t.getStatus());
            ps.setString(8, t.getLocation());
            ps.setInt(9, t.getRoomId());
            return ps.executeUpdate()>0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(RouterDTO t) {
        String sql = "UPDATE router SET "
                + " router_name = ?, ip_address =  ?, "
                + "mac_address = ?, model = ?, firmware = ? "
                +"status=?, location=?, room_id"
                + "WHERE router_id = ?";
        try {
            Connection connect= DbUtils.getConnection();
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setInt(1, t.getRouterId());
            ps.setString(2, t.getRouterName());
            ps.setString(3, t.getIpAddress());
            ps.setString(4, t.getMacAddress());
            ps.setString(5, t.getModel());
            ps.setString(6, t.getFirmware());
            ps.setString(7, t.getStatus());
            ps.setString(8, t.getLocation());
            ps.setInt(9, t.getRoomId());
            return ps.executeUpdate()>0;
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
       String sql = "SELECT*FROM router";
        try {
            Connection connect = DbUtils.getConnection();
            Statement st = connect.createStatement();
            ResultSet rs = st.executeQuery(sql);
            
            while(rs.next()){
                list.add(mapRow(rs));
                
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public RouterDTO searchById(Integer id) {
       String sql="SELECT * FROM router WHERE router_id=?";
        System.out.println(sql);
    }
    public boolean softDelete(int routerID) {
        String sql = "UPDATE router SET status = 0 WHERE router_id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, routerID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
