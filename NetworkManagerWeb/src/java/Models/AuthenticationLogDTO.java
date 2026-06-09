
package Models;

import java.sql.Timestamp;


public class AuthenticationLogDTO {
    
    public static final String STATUS_SUCCESS = "SUCCESS";
    public static final String STATUS_FAILED  = "FAILED";
    
    private int logId;
    private String userName;
    private String loginStatus;
    private String ipAddress;
    private Timestamp loginTime;
    private Integer userId;

    public AuthenticationLogDTO(String userName, String loginStatus, String ipAddress, Integer user_id) {
        this.userName = userName;
        this.loginStatus = loginStatus;
        this.ipAddress = ipAddress;
        this.userId = user_id;
    }

    public AuthenticationLogDTO() {
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getLoginStatus() {
        return loginStatus;
    }

    public void setLoginStatus(String loginStatus) {
        this.loginStatus = loginStatus;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public Timestamp getLoginTime() {
        return loginTime;
    }

    public void setLoginTime(Timestamp loginTime) {
        this.loginTime = loginTime;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer user_id) {
        this.userId = user_id;
    }
    
    public boolean isSuccess(){
        return STATUS_SUCCESS.equalsIgnoreCase(loginStatus);
    }
}
