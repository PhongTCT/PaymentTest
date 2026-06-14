/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import Controller.*;
import java.sql.Date;

/**
 *
 * @author nvtv0
 */
public class WiFiAnalyticsDTO {

    private int analyticsId;
    private int totalUsers;
    private int peakUsers;
    private double avgSpeed;
    private Date analyticsDate;
    private int apId; 

    public WiFiAnalyticsDTO() {
    }

    public WiFiAnalyticsDTO(int analyticsId, int totalUsers, int peakUsers,
            double avgSpeed, Date analyticsDate, int apId) {
        this.analyticsId = analyticsId;
        this.totalUsers = totalUsers;
        this.peakUsers = peakUsers;
        this.avgSpeed = avgSpeed;
        this.analyticsDate = analyticsDate;
        this.apId = apId;
    }

    public int getAnalyticsId() {
        return analyticsId;
    }

    public void setAnalyticsId(int analyticsId) {
        this.analyticsId = analyticsId;
    }

    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getPeakUsers() {
        return peakUsers;
    }

    public void setPeakUsers(int peakUsers) {
        this.peakUsers = peakUsers;
    }

    public double getAvgSpeed() {
        return avgSpeed;
    }

    public void setAvgSpeed(double avgSpeed) {
        this.avgSpeed = avgSpeed;
    }

    public Date getAnalyticsDate() {
        return analyticsDate;
    }

    public void setAnalyticsDate(Date analyticsDate) {
        this.analyticsDate = analyticsDate;
    }

    public int getApId() {
        return apId;
    }

    public void setApId(int apId) {
        this.apId = apId;
    }


}
