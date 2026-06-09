
package Models;

import java.sql.Timestamp;


public class UserRoleDTO {
    private int userId;
    private int roleId;
    private Timestamp assigedAt;

    public UserRoleDTO(int userId, int roleId) {
        this.userId = userId;
        this.roleId = roleId;
    }

    public UserRoleDTO() {
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public Timestamp getAssigedAt() {
        return assigedAt;
    }

    public void setAssigedAt(Timestamp assigedAt) {
        this.assigedAt = assigedAt;
    }

    
    
    
}
