package Models;

import java.sql.Timestamp;

public class PremiumSubscriptionDTO {

    private int userId;
    private String planCode;
    private String status;
    private Timestamp startedAt;
    private Timestamp expiresAt;

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getPlanCode() {
        return planCode;
    }

    public void setPlanCode(String planCode) {
        this.planCode = planCode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(Timestamp startedAt) {
        this.startedAt = startedAt;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(status)
                && expiresAt != null
                && expiresAt.after(new Timestamp(System.currentTimeMillis()));
    }
}
