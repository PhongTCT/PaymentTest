
package Models;

import java.sql.Timestamp;

/**
 *
 * @author nvtv0
 */
public class BandwidthUsageDTO {

    private int usageId;
    private double uploadSpeed;
    private double downloadSpeed;
    private Timestamp recordTime;
    private int deviceId; 

    public BandwidthUsageDTO() {
    }

    public BandwidthUsageDTO(int usageId, double uploadSpeed, double downloadSpeed,
            Timestamp recordTime, int deviceId) {
        this.usageId = usageId;
        this.uploadSpeed = uploadSpeed;
        this.downloadSpeed = downloadSpeed;
        this.recordTime = recordTime;
        this.deviceId = deviceId;
    }

    public int getUsageId() {
        return usageId;
    }

    public void setUsageId(int usageId) {
        this.usageId = usageId;
    }

    public double getUploadSpeed() {
        return uploadSpeed;
    }

    public void setUploadSpeed(double uploadSpeed) {
        this.uploadSpeed = uploadSpeed;
    }

    public double getDownloadSpeed() {
        return downloadSpeed;
    }

    public void setDownloadSpeed(double downloadSpeed) {
        this.downloadSpeed = downloadSpeed;
    }

    public Timestamp getRecordTime() {
        return recordTime;
    }

    public void setRecordTime(Timestamp recordTime) {
        this.recordTime = recordTime;
    }

    public int getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(int deviceId) {
        this.deviceId = deviceId;
    }


}

