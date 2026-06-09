package Models;

import java.sql.Timestamp;

public class SystemLogDTO {

    private int logId;
    private String action;
    private Timestamp createdAt;
    private String details;
    private Integer performedBy;

    public SystemLogDTO() {
    }

    public SystemLogDTO(String action, String details, Integer performedBy) {
        this.action = action;
        this.details = details;
        this.performedBy = performedBy;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public Integer getPerformedBy() {
        return performedBy;
    }

    public void setPerformedBy(Integer performedBy) {
        this.performedBy = performedBy;
    }

}
