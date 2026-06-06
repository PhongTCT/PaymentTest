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
import java.util.ArrayList;

/**
 *
 * @author ADMIN
 */
public class UserRoleDAO implements IDAO<UserRoleDTO, Integer>{
    
    private UserRoleDTO mapRow(ResultSet rs) throws SQLException {
        return new UserRoleDTO(
                rs.getInt("role_id"),
                rs.getString("role_name"),
                rs.getString("description")
        );
    }

    @Override
    public boolean insert(UserRoleDTO t) {
        String sql = "INSERT INTO role "
                + "(role_id, role_name, decription) "
                + "VALUES (?, ?, ?)";
        try{
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setInt(1, t.getRoleId());
            ps.setString(2, t.getRoleName());
            ps.setString(3, t.getDescription());            
            return ps.executeUpdate() > 0;
        }catch(Exception e){
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(UserRoleDTO t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean remove(UserRoleDTO t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<UserRoleDTO> ListAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public UserRoleDTO searchById(Integer id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
}
