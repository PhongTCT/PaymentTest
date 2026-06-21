package Models_DAO;

import Models.PremiumSubscriptionDTO;
import Utils.DbUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PremiumSubscriptionDAO {

    private static final Logger LOGGER = Logger.getLogger(PremiumSubscriptionDAO.class.getName());

    public PremiumSubscriptionDTO findByUserId(int userId) {
        String sql = "SELECT user_id, plan_code, status, started_at, expires_at "
                + "FROM PremiumSubscription WHERE user_id = ?";
        try (Connection connection = DbUtils.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) {
                    return null;
                }
                PremiumSubscriptionDTO subscription = new PremiumSubscriptionDTO();
                subscription.setUserId(result.getInt("user_id"));
                subscription.setPlanCode(result.getString("plan_code"));
                subscription.setStatus(result.getString("status"));
                subscription.setStartedAt(result.getTimestamp("started_at"));
                subscription.setExpiresAt(result.getTimestamp("expires_at"));
                return subscription;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            LOGGER.log(Level.WARNING, "Cannot load Premium subscription. Run vnpay_migration.sql first.", ex);
            return null;
        }
    }
}
