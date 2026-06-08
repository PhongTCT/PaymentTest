package Models;

public class AccessPointDTO {
    private int apId;
    private String apName;
    private String ssid;
    private String ipAddress;
    private int connectedUsers;
    private String status;
    private String location;

    public AccessPointDTO() {
    }

    public AccessPointDTO(int apId, String apName, String ssid, String ipAddress, int connectedUsers, String status, String location) {
        this.apId = apId;
        this.apName = apName;
        this.ssid = ssid;
        this.ipAddress = ipAddress;
        this.connectedUsers = connectedUsers;
        this.status = status;
        this.location = location;
    }

    public int getApId() {
        return apId;
    }

    public void setApId(int apId) {
        this.apId = apId;
    }

    public String getApName() {
        return apName;
    }

    public void setApName(String apName) {
        this.apName = apName;
    }

    public String getSsid() {
        return ssid;
    }

    public void setSsid(String ssid) {
        this.ssid = ssid;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public int getConnectedUsers() {
        return connectedUsers;
    }

    public void setConnectedUsers(int connectedUsers) {
        this.connectedUsers = connectedUsers;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }
}
