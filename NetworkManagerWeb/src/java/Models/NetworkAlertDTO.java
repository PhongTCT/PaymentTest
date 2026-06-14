/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.sql.Timestamp;

/**
 *
 * @author nvtv0
 */
public class NetworkAlertDTO {

    private int alertId;
    private String alertType;
    private String message;
    private String severity; 
    private Timestamp createdAt;
    private Integer routerId;  
    private Integer apId;      
    private Integer switchId; 

    public NetworkAlertDTO() {
    }

    public NetworkAlertDTO(int alertId, String alertType, String message, String severity,
            Timestamp createdAt, Integer routerId, Integer apId, Integer switchId) {
        this.alertId = alertId;
        this.alertType = alertType;
        this.message = message;
        this.severity = severity;
        this.createdAt = createdAt;
        this.routerId = routerId;
        this.apId = apId;
        this.switchId = switchId;
    }

    public int getAlertId() {
        return alertId;
    }

    public void setAlertId(int alertId) {
        this.alertId = alertId;
    }

    public String getAlertType() {
        return alertType;
    }

    public void setAlertType(String alertType) {
        this.alertType = alertType;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getRouterId() {
        return routerId;
    }

    public void setRouterId(Integer routerId) {
        this.routerId = routerId;
    }

    public Integer getApId() {
        return apId;
    }

    public void setApId(Integer apId) {
        this.apId = apId;
    }

    public Integer getSwitchId() {
        return switchId;
    }

    public void setSwitchId(Integer switchId) {
        this.switchId = switchId;
    }

}
