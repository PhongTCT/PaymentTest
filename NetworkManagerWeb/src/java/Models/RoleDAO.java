
package Models;

import Utils.DbUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;


public class RoleDAO implements IDAO<RoleDTO, Integer>{
    
    private RoleDTO mapRow(ResultSet rs) throws SQLException {
        return new RoleDTO(
                rs.getInt("role_id"),
                rs.getString("role_name"),
                rs.getString("description")
        );
    }

    @Override
    public boolean insert(RoleDTO t) {
        String sql = "INSERT INTO Role "
                + "(role_name, decription) "
                + "VALUES (?, ?)";
        try{
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setString(1, t.getRoleName());
            ps.setString(2, t.getDescription());            
            return ps.executeUpdate() > 0;
        }catch(Exception e){
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(RoleDTO t) {
        String sql = "UPDATE Role SET "
                + "role_name = ?, decription = ? WHERE role_id = ?";
        try{
            Connection connect = DbUtils.getConnection();
            PreparedStatement ps = connect.prepareStatement(sql);
            ps.setString(1, t.getRoleName());
            ps.setString(2, t.getDescription());   
            ps.setInt(3, t.getRoleId());
            return ps.executeUpdate() > 0;
        }catch(Exception e){
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean remove(RoleDTO t) {
        return false; // 
    }

    @Override
    public ArrayList<RoleDTO> ListAll() {
        ArrayList<RoleDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM Role";
        try{
            Connection connect = DbUtils.getConnection();
            Statement st = connect.createStatement();
            ResultSet rs = st.executeQuery(sql); //lay du lieu tu Table [user]
            
            while(rs.next()){ //duyet qua tung dong trong table
                list.add(mapRow(rs)); //add thong tin tung dong vao list
                        //mapRow la chuyen doi du lieu tu table thanh Object
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public RoleDTO searchById(Integer id) {
        String sql = "SELECT * FROM Role WHERE role_id=?";
        System.out.println(sql);
        try {
            Connection conn = DbUtils.getConnection();
            //Statement st = conn.createStatement();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            // Da lay duoc du lieu tu Table User
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
}
